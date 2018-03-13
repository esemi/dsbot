#! /usr/bin/env python3
# -*- coding: utf-8 -*-

import os

from fabric.api import env, run, put
from fabric.contrib.files import exists

env.user = 'dsbot'

REMOTE_PATH = os.path.join('/home', env.user, env.user)
FOLDERS = ('www', 'app', 'cron')
LOCAL_PATH = os.path.dirname(__file__)


def tests():
    pass


def deploy():
    if not exists(REMOTE_PATH):
        run('mkdir -p %s' % REMOTE_PATH)

    for folder in FOLDERS:
        put(os.path.join(LOCAL_PATH, folder), REMOTE_PATH)
