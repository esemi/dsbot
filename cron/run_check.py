#! /usr/bin/python
# -*- coding: utf-8 -*-

#Каждую минуту проверяет наличие заданий на проверку игроков и запускает их при наличии
#TODO переписать на демона (?)

__author__ = "esemi"

import logging
import os
import subprocess

import config
import db_operations

if __name__ == "__main__":

    config.initLog('run_check')

    #получаем таски на эту минуту
    db = db_operations.DB()
    tasks = db.getCurrentTasks()
    logging.info('найдено %d тасков' % len(tasks))
    
    for task in tasks:
        if task['status'] != 'wait':
            logging.error("задача уже обработана?! Как, кем, билиать!? (%s)" % task)
            continue

        logging.info("запускаем проверку игрока %d (task id %d)" % (task['player_id'], task['id']) )
        subprocess.Popen(['python', os.path.join(os.path.dirname(__file__), 'checker.py'), '--task', str(task['id'])])

    db.close()
    
