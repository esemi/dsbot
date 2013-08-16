#! /usr/bin/python
# -*- coding: utf-8 -*-

__author__ = "esemi"

import urllib2
import db_operations
import logging
import time
import config
from random import shuffle

def get_proxy_opener(url, user, password):
    password_mgr = urllib2.HTTPPasswordMgrWithDefaultRealm()
    password_mgr.add_password(None, url, user, password)
    proxy_handler = urllib2.ProxyHandler({'http': url})
    proxy_auth_handler = urllib2.ProxyBasicAuthHandler(password_mgr)
    return urllib2.build_opener(proxy_handler, proxy_auth_handler)

def test_network(urls):
    try:
        for url in urls:
            urllib2.urlopen(url, timeout=10)
    except Exception, err:
        logging.error('network error %s' % str(err))
        return False
    return True

if __name__ == "__main__":
    config.initLog("proxy_check")
    logging.info("Started %s" % time.strftime("%H:%M:%S %d.%m.%Y"))


    db = db_operations.DB()
    proxyList = list(db.getProxy())
    logging.info("found %d proxy" % len(proxyList))

    shuffle(proxyList)

    for num, proxy in enumerate(proxyList):
        urls = ['http://ya.ru/','http://google.de/']
        if not test_network(urls): continue

        logging.info("%d - %s" % (num,proxy['proxy']))
        opener = get_proxy_opener(proxy['proxy'], proxy['user'], proxy['pass'])
        try:
            for url in urls:
                res = opener.open(url, timeout=5)
                if res.getcode() == 407:
                    raise Exception('Proxy auth request')
            db.incRankProxy(proxy['id'])
        except Exception, err:
            logging.error('fail %s' % str(err))
            db.decRankProxy(proxy['id'])

    db.close()

