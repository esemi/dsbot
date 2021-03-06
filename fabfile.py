#! /usr/bin/env python3
# -*- coding: utf-8 -*-

import os

from fabric.api import env, run, put, cd
from fabric.contrib.files import exists

env.user = 'dsbot'

REMOTE_PATH = os.path.join('/home', env.user)
FOLDERS = ('www', 'app', 'cron', 'cache', 'logs', 'sessions')
LOCAL_PATH = os.path.dirname(__file__)
APP_PATH = os.path.join(REMOTE_PATH, env.user)
ZEND_PATH = os.path.join(REMOTE_PATH, 'Zend')


def tests():
    pass


def deploy():
    if not exists(ZEND_PATH):
        run('mkdir -p %s' % ZEND_PATH)
        put(os.path.join(LOCAL_PATH, 'docs', 'Zend.tar.gz'), ZEND_PATH)
        with cd(ZEND_PATH):
            run('tar -xzf Zend.tar.gz')

    if not exists(APP_PATH):
        run('mkdir -p %s' % APP_PATH)

    for folder in FOLDERS:
        put(os.path.join(LOCAL_PATH, folder), APP_PATH)

    run('chgrp www-data %s' % os.path.join(APP_PATH, 'logs'))
    run('chgrp www-data %s' % os.path.join(APP_PATH, 'cache'))
    run('chgrp www-data %s' % os.path.join(APP_PATH, 'sessions'))
