#! /usr/bin/python
# -*- coding: utf-8 -*-

#запускать каждые 10-20 минут
#Берёт все атаки на игроков, для которых включено и незаблочено оповещение
#формирует сообщения и отправляет (смс или почта)
#попутно снимает бабло за каждое смс (за почту не снимает)

__author__ = "esemi"

import json
import httplib
import logging
import socket
import sys
import time
import urllib
from datetime import datetime
from itertools import groupby
import smtplib
from email.header import Header
from email import MIMEMultipart as MM
from email import MIMEText as MT

import config
import db_operations
from notify_billing import changeNotifyTypeByBalance


class Sender():

    _db = None

    def __init__(self, db):
        self._db = db

    def sendNotify(self, account, message, subject, type=None):
        """Отправляет нотификейшн по смс или почте в зависимости от настроек аккаунта"""

        if type is None:
            type = account['notify_type']

        logging.debug('sending %s notify' % type)

        if type == 'sms':

            res, response = self._sendSms(account['phone'], message)
            if res is False:
                return 'socket error %s' % response

            parsed_response = json.loads(response)
            if 'cost' not in parsed_response:
                return 'decode error (%s) to (%s)' % (response, parsed_response)

            logging.debug('res %s; response %s' % (res, response))

            self._db.chargeBalance(account['id'], config.EQUITY + float(parsed_response['cost']), "%s (sms)" % subject )
            self._db.addMessage(account['id'], account['phone'], message, response)

        elif type == 'email':

            res, response = self._sendEmail(account['email'], message, subject)
            if res is False:
                return 'smtp error %s' % response

            logging.debug('res %s; response %s' % (res, response))

            self._db.addMessage(account['id'], account['email'], message, response)

        else:
            return 'undefined notify type'


        return True

    def _sendSms(self, phone, mess):
        """http://www.smsc.ru/api/http/#send"""

        logging.debug("длина сообщения %d" % len(mess))

        data = {
            'login': config.SMS_USER,
            'psw': config.SMS_PASS,
            'sender': config.SMS_SENDER,
            'phones': phone,
            'mes': mess,
            'translit': 1,
            'charset': 'utf-8',
            'cost': 1 if config.DEBUG else 2,
            'fmt': 3
        }

        try:
            conn = httplib.HTTPSConnection(config.SMS_HOST, port=config.SMS_PORT, timeout=config.SMS_TIMEOUT)
            conn.request("GET", config.SMS_ACTION + '?' + urllib.urlencode(data))
            response = conn.getresponse().read()
        except socket.gaierror as e:
            return False, e.message
        finally:
            if conn is not None:
                conn.close()

        return True, response

    def _sendEmail(self, to, mess, subject):
        """Отправка на мыло с яндексовой почты"""

        msg = MM.MIMEMultipart()
        msg['From'] = Header(config.SMTP_DEFAULT_FROM, config.SMTP_ENCODING)
        msg['To'] = Header(to, config.SMTP_ENCODING)
        msg['Subject'] = Header(subject, config.SMTP_ENCODING)
        msg.attach(MT.MIMEText(mess, 'plain', config.SMTP_ENCODING))

        text = msg.as_string()

        try:
            server = smtplib.SMTP(config.SMTP_SERVER, config.SMTP_PORT)
            server.ehlo()
            server.starttls()
            server.ehlo()
            server.login(config.SMTP_LOGIN,config.SMTP_PWD)
            res = server.sendmail(config.SMTP_DEFAULT_FROM, to, text)
        except smtplib.SMTPAuthenticationError as e:
            return False, e.smtp_error
        finally:
            if server is not None:
                server.quit()

        return res, text

def createMessage(data):
    """Создание сводного сообщения о нападении на игрока"""

    str = "%s(%s):" % (data[0]['login'], data[0]['world'])
    for k, v in groupby(data, lambda x: x['sota']):
        str += "\n%s " % (''.join(k.split()))
        tmp = list()
        for owner, d in groupby(list(v), lambda x: x['owner']):
            attack = list(d)
            t = min([a['time'] for a in attack]) - datetime.now()
            hours, remainder = divmod(t.seconds, 3600)
            minutes, seconds = divmod(remainder, 60)
            tmp.append("%d %s %d:%d" % (len(attack), owner, hours, minutes) )
        str += ', '.join(tmp)
    return str

def compactMessages(attack):
    """Группирует сообщения по игрокам"""
    
    result = []
    for k, v in groupby(attack, lambda x: x['player_id']):
        v = list(v)
        result.append({ 'acc':v[0]['acc_id'], 'ids':[a['attack_id'] for a in v], 'message':createMessage(v)})
    return result

def exit():
    global db
    logging.info("End %s" % time.strftime('%H:%M:%S %d.%m.%Y'))
    db.close()
    sys.exit()

if __name__ == "__main__":

    config.initLog('sender')

    db = db_operations.DB()

    #сменили тип оповещений на аккаунтах с отрицательным балансом
    res = changeNotifyTypeByBalance(db)
    logging.info("обработано %d аккаунтов" % res)

    #взяли атаки для оповещения
    attack = db.getAttackForNotification()
    logging.info('Найдено %d атак для уведомления' % len(attack))

    if len(attack) == 0:
        exit()

    #сжали до одного толстого сообщения по каждому игроку
    compact = compactMessages(attack)
    logging.info('Сжато до %d сообщений по игрокам' % len(compact))

    if len(compact) == 0:
        logging.error('ошибка при сжатии сообщений')
        exit()

    sender = Sender(db)
    for mess in compact:
        logging.info('аккаунт %d' % (mess['acc']) )

        #взяли инфу по аккаунту
        acc = db.getAccount(mess['acc'])
        if acc is None:
            logging.error('аккаунт не найден')
            continue

        #отправили
        res = sender.sendNotify(acc, mess['message'], 'Attack notification')
        logging.debug('result %s' % res)
        if res is not True:
            logging.error(res)
            continue

        db.notifedAttack(mess['ids'])
        logging.info('success notify')

