# -*- coding: utf-8 -*-

__author__ = "esemi"

import MySQLdb as mdb
import sys
import logging
import config


class DB():
    _conn = None

    def __init__(self):

        self.connect()

    def conn(self):
        return self._conn

    def connect(self):
        try:
            self._conn = mdb.connect(config.DB_HOST, config.DB_USER, config.DB_PASS, config.DB_NAME, charset="utf8", use_unicode=True)
        except mdb.Error, e:
            logging.error("Error %d: %s" % (e.args[0], e.args[1]))
            sys.exit()

    def close(self):
        """Закрыть коннект к БД"""
        if self.conn():
            self.conn().close()

    def addMessage(self, acc_id, to, mess, result ):
        """Добавление нового сообщения в логи аккаунта"""
        cursor = self.conn().cursor()
        cursor.execute("""INSERT INTO `messages` (`acc_id`, `to`, `message`, `optional_data`, `date`)
                          VALUES (%s, %s, %s, %s, NOW())""", (acc_id, to, mess, result) )
        self.conn().commit()

    def addAgent(self, agent):
        """Добавление юзерагента в доступные"""
        cursor = self.conn().cursor()
        cursor.execute("INSERT INTO `agents` (`agent`) VALUES (%s)", agent)
        self.conn().commit()

    def getProxyNetworks(self):
        """Получение всех доступных подсетей проксей"""
        cursor = self.conn().cursor(mdb.cursors.DictCursor)
        cursor.execute("SELECT `id`, `network` FROM `proxy_networks`")
        rows = cursor.fetchall()
        cursor.close()
        return rows

    def addNetworks(self, networks):
        """Добавление новых подсеток проксей"""
        cursor = self.conn().cursor()
        for n in networks:
            cursor.execute("""INSERT INTO `proxy_networks` (`network`) VALUES (%s)""", n)
        self.conn().commit()

    def delNetwork(self,network):
        """Удаление одной старой подсети"""
        cursor = self.conn().cursor()
        cursor.execute("""DELETE FROM proxy_networks WHERE `network` = %s""", network)
        self.conn().commit()

    def incRankProxy(self, id):
        cursor = self.conn().cursor()
        cursor.execute("UPDATE `proxy_list` SET `rank` = `rank`+1 WHERE `id` = %s", id)
        self.conn().commit()

    def decRankProxy(self, id):
        cursor = self.conn().cursor()
        cursor.execute("UPDATE `proxy_list` SET `rank` = `rank`-10 WHERE `id` = %s", id)
        self.conn().commit()

    def getPlayerData(self, id_player):
        """Получаем данные по одному игроку
        :rtype : dict
        """
        cursor = self.conn().cursor(mdb.cursors.DictCursor)
        cursor.execute("""SELECT login, AES_DECRYPT(account.game_pass, %s) AS game_pass, url, pattern AS world_name, agent, enable_monitor, network_id
                            FROM `players`
                            LEFT JOIN account ON acc_id = account.id
                            LEFT JOIN worlds ON world_id = worlds.id
                            LEFT JOIN start_urls ON url_id = start_urls.id
                            LEFT JOIN agents ON agent_id = agents.id
                            WHERE (
                                players.`id` = %s
                            )
                            LIMIT 1 """, (config.GAME_PASS_KEY, id_player))
        row = cursor.fetchone()
        cursor.close()

        if row:
            row['observed_sots'] = self.getSots(id_player)

        return row
        
    def getSots(self, id_player):
        """Ищем все отслеживаемые соты игрока"""
        cursor = self.conn().cursor()
        cursor.execute("""SELECT name FROM `player_sots` WHERE player_id = %s""", id_player)
        rows = cursor.fetchall()
        cursor.close()

        return [row[0] for row in rows]

    def compareArmy(self, id_player, army):
        """Приводит армии в БД к соответсвию с только что найденными"""
        cnt = {'insert': 0, 'update': 0, 'delete': 0}

        cursor = self.conn().cursor()
        cursor.execute("UPDATE attacks SET `delete` = 1 WHERE `player_id` = %s", id_player)

        for data in army:
            res = cursor.execute("""INSERT INTO `attacks` (`player_id`, `army`, `owner`, `time`, `sota`, `date_find`, `notified`, `delete`)
                    VALUES (%s, %s, %s,  DATE_ADD( NOW( ) , INTERVAL %s HOUR_MINUTE ), %s, NOW(), 0, 0)
                    ON DUPLICATE KEY UPDATE
                        `time` = DATE_ADD( NOW( ) , INTERVAL %s HOUR_MINUTE ),
                        `sota` = %s,
                        `date_check` = NOW(),
                        `delete` = 0""",
                    (id_player, data['army'], data['owner'], data['time'], data['sota'], data['time'], data['sota']) )
            if res == 1:
                cnt['insert']+=1
            elif res == 2:
                cnt['update']+=1
                
        cnt['delete'] = cursor.execute("DELETE FROM attacks WHERE `delete` = 1 AND `player_id` = %s", id_player)
        self.conn().commit()

        return cnt

    def getAttackForNotification(self):
        """
        Получаем атаки для уведомления
        исходит из даты атаки и настроек мониторинга игрока
        !сортировка важна для программной группировки!
        """
        cursor = self.conn().cursor(mdb.cursors.DictCursor)
        cursor.execute("""
        SELECT `attacks`.id AS `attack_id`, player_id, acc_id, `time`, `owner`, `sota`, worlds.name AS world,
            account.login, notify_type
        FROM `attacks`
        LEFT JOIN players ON players.id = player_id
        LEFT JOIN worlds ON worlds.id = world_id
        LEFT JOIN account ON account.id = acc_id
        WHERE `notified` = 0 AND enable_notify = 1 AND `time` > NOW() AND `time` < DATE_ADD(NOW(), INTERVAL `notify_hours` HOUR)
        ORDER BY `player_id`, `sota`, `owner`""")
        rows = cursor.fetchall()
        cursor.close()

        return rows

    def getAccount(self, acc_id):
        """Получаем данные по аккаунту"""
        cursor = self.conn().cursor(mdb.cursors.DictCursor)
        cursor.execute("""SELECT * FROM `account` WHERE (`id` = %s) LIMIT 1""", acc_id)
        row = cursor.fetchone()
        cursor.close()
        return row

    def chargeBalance(self, acc_id, amount, type):
        """Списание денег с аккаунта"""
        cursor = self.conn().cursor()
        cursor.execute("UPDATE account SET `balance` = `balance` - %s WHERE `id` = %s", (amount, acc_id) )
        cursor.execute("""INSERT INTO balance_history (`acc_id`, `amount`, `type`, `date`)
                          VALUES (%s, %s, %s, NOW())""", (acc_id, amount, type) )
        self.conn().commit()

    def notifedAttack(self, ids):
        """отмечаем атаки как уведомленные"""
        search = ','.join(map(str,ids))
        cursor = self.conn().cursor()
        cursor.execute("UPDATE attacks SET `notified` = 1 WHERE `id` IN (%s)" % search )
        self.conn().commit()

    def getRelevantProxy(self, network_id):
        """Возвращает топ3 лучших проксей из подсети"""
        cursor = self.conn().cursor(mdb.cursors.DictCursor)
        cursor.execute("""SELECT CONCAT("http://",user,':',pass,'@',proxy) AS conf
                        FROM proxy_list
                        WHERE network_id = %s
                        ORDER BY `rank` DESC
                        LIMIT 3
                        """, network_id)
        rows = cursor.fetchall()
        cursor.close()
        return rows

    def setProxyNetworkUsed(self, network_id):
        """Обновляет дату последнего использования подсети"""
        cursor = self.conn().cursor()
        cursor.execute("UPDATE `proxy_networks` SET `date_last_used` = CURDATE() WHERE id = %s", network_id)
        self.conn().commit()

    def getProxy(self):
        """Получает все прокси в базе"""
        cursor = self.conn().cursor(mdb.cursors.DictCursor)
        cursor.execute("""SELECT `proxy`, `id`, `user`, `pass`, `network_id` FROM proxy_list""" )
        rows = cursor.fetchall()
        cursor.close()
        return rows

    def insertOrUpdProxy(self, user, passwd, proxy_conf, network_id):
        """Добавить или обновить новую проксю"""
        cursor = self.conn().cursor()
        res = cursor.execute("""INSERT INTO proxy_list (`user`, `pass`, `proxy`, `network_id`, `date_update`)
                                VALUES (%s,%s,%s,%s,CURRENT_DATE)
                                ON DUPLICATE KEY UPDATE `user`=%s, `pass`=%s, `proxy`=%s, `network_id` = %s, `date_update` = CURRENT_DATE""",
                                (user, passwd, proxy_conf, network_id, user, passwd, proxy_conf, network_id ) )
        self.conn().commit()
        return res

    def delProxy(self, proxy_conf):
        """Удаляет прокси по конфигурации (уникальна)"""
        cursor = self.conn().cursor()
        cursor.execute("""DELETE FROM proxy_list WHERE `proxy` = %s""", proxy_conf)
        self.conn().commit()

    def getMonitoringPlayers(self):
        """Игроки для мониторинга (для назначения тасков)"""
        cursor = self.conn().cursor(mdb.cursors.DictCursor)
        cursor.execute("""
            SELECT `Pl`.`id` AS `player_id`, `check_interval`
            FROM `players` as `Pl`
            LEFT JOIN `account` ON `account`.`id` = `acc_id`
            WHERE `enable_monitor` = 1 AND
            (SELECT COUNT(`name`) FROM `player_sots` WHERE `player_id` = `Pl`.`id`) > 0""")
        rows = cursor.fetchall()
        cursor.close()
        return rows

    def getAccountsForChangeNotify(self):
        """Возвращает все аккаунты с оповещением по смс и балансом меньше нуля"""
        cursor = self.conn().cursor(mdb.cursors.DictCursor)
        cursor.execute("""SELECT id FROM `account` WHERE `notify_type` = 'sms' AND `balance` < 0""")
        rows = cursor.fetchall()
        cursor.close()
        return rows

    def getAccountsWithExpiredProxy(self):
        """Найти все аккаунты со старой датой проксей"""
        cursor = self.conn().cursor(mdb.cursors.DictCursor)
        cursor.execute("""SELECT id FROM `account` WHERE `proxy_expired` < CURDATE() AND `network_id` IS NOT NULL""")
        rows = cursor.fetchall()
        cursor.close()
        return rows

    def getAccountsWithExpiredProxySoon(self):
        """Найти все аккаунты с датой проксей меньше недели вперёд"""
        cursor = self.conn().cursor(mdb.cursors.DictCursor)
        cursor.execute("""SELECT id, DATE_FORMAT(`proxy_expired`,'%%d.%%m.%%Y') AS `proxy_expired`
            FROM `account`
            WHERE `proxy_expired` < DATE_ADD(CURDATE(), INTERVAL %s DAY) AND
            `network_id` IS NOT NULL""", config.PROXY_EXPIRED_NOTIFY_DAYS)
        rows = cursor.fetchall()
        cursor.close()
        return rows

    def unsetProxyNetworkForAccount(self, acc_id):
        """Удалить подсетку проксей у аккаунта"""
        cursor = self.conn().cursor()
        res = cursor.execute("""UPDATE account SET `network_id` = NULL WHERE id = %s""", acc_id)
        self.conn().commit()

        return res

    def disableMonitoringOnAccount(self, acc_id):
        """Выключаем мониторинг на всех игроках аккаунта"""
        cursor = self.conn().cursor()
        res = cursor.execute("""UPDATE players SET `enable_monitor` = 0 WHERE acc_id = %s""", acc_id)
        self.conn().commit()

        return res

    def setAccountNotify(self, acc_id, type):
        """Изменяет тип нотификейшенов на аккаунте"""
        cursor = self.conn().cursor()
        res = cursor.execute("""UPDATE account SET `notify_type` = %s WHERE id = %s""", (type, acc_id))
        self.conn().commit()

        return res

    def isRequireTaskByPlayer(self, player_id):
        """Надо ли назначать новое задание (или уже назначено/есть работающее)"""
        cursor = self.conn().cursor(mdb.cursors.DictCursor)
        cursor.execute("""SELECT id FROM `check_tasks` WHERE
                        `player_id` = %s AND
                        `date` > NOW() AND
                        `status` = 'wait'
                       LIMIT 1""", player_id)
        row = cursor.fetchone()
        cursor.close()

        return row is None

    def getLastTaskByPlayer(self, player_id):
        """Получаем данные по последней задаче игрока"""
        cursor = self.conn().cursor(mdb.cursors.DictCursor)
        cursor.execute("""SELECT `date`, `status`
                        FROM `check_tasks`
                        WHERE `player_id` = %s AND `date` < NOW() AND `status` != 'wait'
                        ORDER BY `date` DESC
                        LIMIT 1""", player_id)
        row = cursor.fetchone()
        cursor.close()
        return row

    def addNewTask(self, player_id, date_check):
        """Добавление нового задания на проверку соты"""
        cursor = self.conn().cursor()
        cursor.execute("INSERT INTO `check_tasks` (`player_id`, `date`) VALUES (%s, %s)", (player_id, date_check) )
        self.conn().commit()

    def getCurrentTasks(self):
        """Получить задачи на текущую минуту"""
        cursor = self.conn().cursor(mdb.cursors.DictCursor)
        sql = "SELECT * FROM `check_tasks` WHERE DATE_FORMAT(`date`, '%Y-%m-%d %H:%i') = DATE_FORMAT(NOW(), '%Y-%m-%d %H:%i')"
        cursor.execute(sql)
        rows = cursor.fetchall()
        cursor.close()

        return rows

    def getTask(self, task_id):
        """Получить таск по id"""
        cursor = self.conn().cursor(mdb.cursors.DictCursor)
        cursor.execute("SELECT * FROM `check_tasks` WHERE id = %s", task_id)
        row = cursor.fetchone()
        cursor.close()
        return row

    def setTaskProcessed(self, task_id):
        """Отметить задачу по проверке соты как исполняемую"""
        cursor = self.conn().cursor()
        cursor.execute("UPDATE `check_tasks` SET `status` = 'processed' WHERE id = %s", task_id)
        self.conn().commit()

    def setTaskCompleted(self, task_id, result, try_count):
        """Отметить задачу по проверке соты как выполненную"""
        cursor = self.conn().cursor()
        cursor.execute("UPDATE `check_tasks` SET `status` = %s, `try_count` = %s WHERE id = %s", (result, try_count, task_id))
        self.conn().commit()


if __name__ == "__main__":
    obj = DB()
    print obj.getCurrentTasks()
