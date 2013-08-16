#! /usr/bin/python
# -*- coding: utf-8 -*-

#Каждые 15 минут назначает новые задания для проверки игроков
#отталкивается от даты последней проверки и макс интервала между проверками

__author__ = "esemi"

import logging
import random
from datetime import datetime, timedelta

import config
import db_operations

def compute_next_check_date(hours, last_check):
    """
    Рассчёт времени для проверки соты
    отталкивается от максимального времени между проверками и даты последней проверки
    """
    maxdelta = timedelta(hours=hours)
    begin = datetime.now() + timedelta(minutes=1)
    if last_check is None or (datetime.now()-last_check['date']) > maxdelta :
        end = datetime.now() + timedelta(hours=config.SHEDULER_MIN_HOURS_CHECK)
    else:
        end = last_check['date'] + maxdelta
    logging.debug("исходное окно %s - %s" % (begin, end))

    segment = end - begin

    factor = random.betavariate(3, 1.2)
    result_data = begin + timedelta( seconds = factor * segment.seconds )
    logging.debug("окно от %s до %s; множитель %s; итоговый отступ %s" % (begin, end, factor, result_data) )
    
    return result_data

if __name__ == "__main__":
    config.initLog('sheduler')
    db = db_operations.DB()

    monitoring_players = db.getMonitoringPlayers()

    for player in monitoring_players:
        logging.info("взяли игрока %s" % player)

        if db.isRequireTaskByPlayer(player['player_id']):
            last_task = db.getLastTaskByPlayer(player['player_id'])
            logging.info("last checked %s, interval %d hours" % (last_task, player['check_interval']))

            check_date = compute_next_check_date(player['check_interval'], last_task)
            logging.info("next check date %s" % check_date)

            db.addNewTask(player['player_id'], check_date)
        else:
            logging.info('таск уже назначен')

    db.close()
