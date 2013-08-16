# -*- coding: utf-8 -*-

import logging
import sys
import os

DEBUG = False   #debug mode
EQUITY = 0.2   #маржа на смс
DISPLAY = 88   #номер дисплея для чекера
TRY_COUNT = 10   #количество попыток провести проверку
LOG_PATH = os.path.join(os.path.dirname(__file__), '..', '..', "logs", 'dsbot', 'cron')

PROXY_EXPIRED_NOTIFY_DAYS = 7

PROXY_USER = ""
PROXY_PASS = ""

DB_HOST = 'localhost'
DB_USER = ''
DB_PASS = ''
DB_NAME = 'dsbot'

GAME_PASS_KEY = ''

SHEDULER_MIN_HOURS_CHECK = 1 #минимальное время для назначения задания

SMS_HOST = "smsc.ru"
SMS_ACTION = "/sys/send.php"
SMS_PORT = 443
SMS_USER = ''
SMS_PASS = ''
SMS_SENDER = 'DSBot'
SMS_TIMEOUT = 30

SMTP_SERVER = "smtp.yandex.com"
SMTP_PORT = 25
SMTP_LOGIN = ""
SMTP_PWD = ""
SMTP_DEFAULT_FROM = "noreply@dsbot.ru"
SMTP_ENCODING = "UTF-8"


reload(sys)
sys.setdefaultencoding( "utf8" )

from config_secure import *

def initLog(name, notfile=False):

    logfile = None
    if DEBUG or notfile:

        logging.basicConfig(
            format='%(asctime)s %(levelname)s:%(message)s',
            level=logging.DEBUG)
    else:
        logfile = os.path.join(LOG_PATH, "%s.log" % name)
        logging.basicConfig(
            filename= logfile,
            format='%(asctime)s %(levelname)s:%(message)s',
            level=logging.DEBUG)
            
    return logfile




