#! /usr/bin/python
# -*- coding: utf-8 -*-

__author__ = "esemi"

import db_operations
import sys
import logging
import time
import config
import os

def filter_bot(x):

    bots = (
        'Googlebot',
        'Ezooms',
        'MJ12bot',
        'EmbeddedWB',
        'bingbot',
        'Crawler',
        'statdom.ru/Bot',
        'AhrefsBot',
        'crawler@nigma.ru',
        'Mail.RU/',
        'yandex.com/bots',
        'urllib',
        'FunWebProducts',
        'SeznamBot',
    )

    for bot in bots:
        if x.find(bot) != -1:
            return False
	
    if len(x) < 20 or len(x) > 250:
        return False

    return True

if __name__ == "__main__":
    config.initLog("agents_update", True)
    logging.info("Started %s" % time.strftime("%H:%M:%S %d.%m.%Y"))

    try:
        f = open(os.path.join(os.path.dirname(__file__), '..', 'docs', 'agents'), 'r')
    except IOError:
        logging.error('file not found')
        sys.exit()

    agents = set([i.strip() for i in f if filter_bot(i.strip())])
    logging.info("found %d unique agents" % len(agents))

    db = db_operations.DB()
    for agent in agents:
        try:
            db.addAgent(agent)
        except db_operations.mdb.IntegrityError:
            continue
        logging.info("agent added %s" % agent)
    db.close()

    
