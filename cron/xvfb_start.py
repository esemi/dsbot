#! /usr/bin/python
# -*- coding: utf-8 -*-

#Запускает виртуальный дисплей с номером из конфига
#запускается при старте системы
#Xvfb :88 -screen 0 1024x768x16 -nolisten tcp > /dev/null &
#прописать в rc.local python /home/esemi/dsBot/cron/xvfb_start.py >> /home/esemi/logs/dsBot/errorXvfb.log

__author__ = "esemi"

import subprocess
import sys

import config

reload(sys)
sys.setdefaultencoding("utf8")

if __name__ == "__main__":
    subprocess.Popen(['Xvfb', ':%d' % config.DISPLAY, '-screen', '0', '1366x768x24', '-nolisten', 'tcp'])

