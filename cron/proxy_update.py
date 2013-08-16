#! /usr/bin/python
# -*- coding: utf-8 -*-

__author__ = "esemi"

import urllib2
import db_operations
import sys
import logging
import time
import config
from collections import Counter


#каждую ночь обновляет прокси с сайта поставщика
#пишет ошибки, если удалили проксю, которую ктото использует (подсеть забиндена на аккаунт)

#Логин = RUSMVhBhIkG6k
#Пароль = LpkCuEI97O
#Тариф: 120 день(дней)
#1. Зайдите на страницу: http://www.billingproxy.net/usergui/index.php
#2. Пройдите в пункт меню Активировать аккаунт, введите логин и пароль полученный при покупке. 

def parseNetwork(proxy):
    return u'.'.join(proxy.split('.')[0:3])

if __name__ == "__main__":
    config.initLog("proxy_update")
    logging.info("Started %s" % time.strftime("%H:%M:%S %d.%m.%Y"))

    try:
        newProxy = set([unicode(i.strip()) for i in urllib2.urlopen("http://www.billingproxy.net/usergui/tmp/%s8080.txt" % config.PROXY_USER, timeout=20)])
    except urllib2.HTTPError:
        logging.error('http error')
        sys.exit()

    logging.info("found %d proxy" % len(newProxy))
    if len(newProxy) < 70 :
        logging.warning('short list?')
        sys.exit()

    db = db_operations.DB()

    #умное обновление подсетей
    oldNetworks = set([i['network'] for i in db.getProxyNetworks()])
    logging.info("found %d old unique networks" % len(oldNetworks))

    newNetworks = set([parseNetwork(i) for i in newProxy])
    logging.info("found %d new unique networks" % len(newNetworks))

    mustAdd = newNetworks - oldNetworks
    mustDel = oldNetworks - newNetworks

    if len(mustAdd) > 0:
        db.addNetworks(mustAdd)
        logging.info("%d networks added" % len(mustAdd))

    if len(mustDel) > 0:
        for n in mustDel:
            try:
                db.delNetwork(n)
                logging.info("%s network delete" % n)
            except:
                logging.error("%s network delete but used" % n)

    #обновление проксей
    networkIds = dict([ [i['network'],i['id']] for i in db.getProxyNetworks() ])
    
    cnt = Counter()
    for l in newProxy:
        networkId = networkIds[parseNetwork(l)]
        logging.debug("%s proxy, %s network id" % (l,networkId))

        res = db.insertOrUpdProxy(config.PROXY_USER, config.PROXY_PASS, l, networkId)
        logging.debug("%d result" % res)

        if res == 1:
            cnt['inserted'] += 1
        elif res == 2:
            cnt['updated'] += 1
        elif res == 0:
            cnt['relevant'] += 1
    
    oldProxy = set([i['proxy'] for i in db.getProxy()])
    delProxy = oldProxy - newProxy
    for d in delProxy:
        if parseNetwork(d) in mustDel: continue
        db.delProxy(d)
        logging.debug("%s proxy delete" % d)
        cnt['deleted'] += 1
	    
    logging.info("добавлено %d, обновлено %d, без изменений %d, удалено %d" %
                 (cnt['inserted'], cnt['updated'], cnt['relevant'], cnt['deleted']))

    db.close()


