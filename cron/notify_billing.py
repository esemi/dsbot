#! /usr/bin/python
# -*- coding: utf-8 -*-

#каждые 15 минут проверяет баланс пользователей
#если денег меньше нуля - принудительно переключает оповещения на мыло
#также оповещает об этом на смс и мыло

__author__ = "esemi"

import logging

import config
import db_operations


def changeNotifyTypeByBalance(db):
    """
    Принудительно изменяет тип оповещений с sms на емаил при балансе ниже нуля
    О каждом изменении оповещает пользователя на смс и мыло
    """

    from sender import Sender

    accounts = db.getAccountsForChangeNotify()
    logging.info("found %d account for change notify type" % len(accounts))

    sender = Sender(db)
    for account in accounts:
        logging.info("process account %s" % account)

        acc = db.getAccount(account['id'])
        if acc is None:
            logging.error('аккаунт не найден')
            continue

        #сменили тип нотификейшенов
        res = db.setAccountNotify(acc['id'], 'email')
        logging.debug("change type result %s" % res)

        message = "%s: balance < 0, notify type change to email" % acc['login']
        res1 = sender.sendNotify(acc, message, 'Notify type change by balance', 'sms')
        res2 = sender.sendNotify(acc, message, 'Notify type change by balance', 'email')
        logging.debug('result sms - %s; email - %s' % (res1, res2))
        if res1 is not True or res2 is not True:
            logging.error(res1)
            logging.error(res2)
            continue

        logging.info('success notification of change notify type')

    return len(accounts)

if __name__ == "__main__":

    config.initLog('notify_billing')
    db = db_operations.DB()

    res = changeNotifyTypeByBalance(db)
    logging.info("обработано %d аккаунтов" % res)

    db.close()
