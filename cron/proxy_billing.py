#! /usr/bin/python
# -*- coding: utf-8 -*-

#раз в сутки проверяет нет ли аккаунтов с неоплаченными проксями
#если такие нашлись - отвязывает от них проксю и оповещает об этом пользователя смской
#также оповещает за неделю до истечения даты проксей

__author__ = "esemi"

import logging

import config
import db_operations
from sender import Sender

if __name__ == "__main__":

    config.initLog('proxy_billing')
    db = db_operations.DB()

    #освобождение проксей
    accounts = db.getAccountsWithExpiredProxy()
    logging.info("found %d account with expired proxy" % len(accounts))

    sender = Sender(db)
    for account in accounts:
        logging.info("process account %s" % account)

        acc = db.getAccount(account['id'])
        if acc is None:
            logging.error('аккаунт не найден')
            continue

        #отвязали подсетку
        res = db.unsetProxyNetworkForAccount(acc['id'])
        logging.debug("unset proxy result %s" % res)

        #выключили мониторинг всех игроков на аккаунте
        res = db.disableMonitoringOnAccount(acc['id'])
        logging.debug("disable monitoring result %s" % res)

        message = "%s: proxy has expired, all checks stopped" % acc['login']
        res1 = sender.sendNotify(acc, message, 'Proxy expired notify', 'sms')
        res2 = sender.sendNotify(acc, message, 'Proxy expired notify', 'email')
        logging.debug('result sms - %s; email - %s' % (res1, res2))
        if res1 is not True or res2 is not True:
            logging.error(res1)
            logging.error(res2)
            continue
        logging.info('success notification of expired proxy')

    #оповещение о скором освобождении прокси
    accounts = db.getAccountsWithExpiredProxySoon()
    logging.info("found %d account with proxy expire soon" % len(accounts))

    for account in accounts:
        logging.info("process account %s" % account)

        acc = db.getAccount(account['id'])
        if acc is None:
            logging.error('аккаунт не найден')
            continue

        message = "%s: proxy expired %s" % (acc['login'], account['proxy_expired'])
        res1 = sender.sendNotify(acc, message, 'Proxy expired soon notify', 'sms')
        res2 = sender.sendNotify(acc, message, 'Proxy expired soon notify', 'email')
        logging.debug('result sms - %s; email - %s' % (res1, res2))
        if res1 is not True or res2 is not True:
            logging.error(res1)
            logging.error(res2)
            continue
        logging.info('success notification of proxy expired soon')




    db.close()
