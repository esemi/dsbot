#! /usr/bin/python
# -*- coding: utf-8 -*-

__author__ = "esemi"

import logging
import math
import random
import re
import sys
import time
import os
from optparse import OptionParser

import config
import db_operations
from PyQt4.QtCore import *
from PyQt4.QtGui import *
from PyQt4.QtNetwork import *
from PyQt4.QtWebKit import *

class Timeouts():
    """
    All timeouts for bot
    """

    def __init__(self):
        self.computeTimeouts()

    def computeTimeouts(self):
        self.start = random.randint(1, 40)              #несколько секунд перед началом
        self.startPageLoad = random.randint(15, 35)     #загрузка стартовой страницы
        self.login = random.randint(2, 10)              #логин на главной
        self.selectPageLoad = random.randint(15, 35)    #загрузка выбора мира
        self.enter = random.randint(4, 10)              #выбор мира и вход в игру
        self.limit = self.start + self.startPageLoad + self.login + self.selectPageLoad + self.enter + 20

    def getStart(self):
        """
        :rtype : int
        """
        return self.start * 1000

    def getStartPageLoad(self):
        return self.startPageLoad * 1000

    def getLogin(self):
        return self.login * 1000

    def getSelectPageLoad(self):
        return self.selectPageLoad * 1000

    def getSelect(self):
        return self.enter * 1000

    def getExitTime(self):
        return self.limit * 1000


class NetworkReply(QNetworkReply):
    def __init__(self, parent, reply):
        super(NetworkReply, self).__init__(parent)

        self.setOpenMode(QNetworkReply.ReadOnly | QNetworkReply.Unbuffered)
        self.reply = reply   # reply to proxy
        self.data = ''       # contains downloaded data
        self.buffer = ''     # contains buffer of data to read

        # connect signal from proxy reply
        self.reply.metaDataChanged.connect(self.applyMetaData)
        self.reply.readyRead.connect(self.readInternal)
        self.reply.finished.connect(self.finished)
        self.reply.uploadProgress.connect(self.uploadProgress)
        self.reply.downloadProgress.connect(self.downloadProgress)

    def __getattribute__(self, attr):
        """Send undefined methods straight through to proxied reply
        """
        # send these attributes through to proxy reply
        if attr in ('operation', 'request', 'url', 'abort', 'close'):#, 'isSequential'):
            value = self.reply.__getattribute__(attr)
        else:
            value = QNetworkReply.__getattribute__(self, attr)
        return value

    def abort(self):
        pass # qt requires that this be defined

    def isSequential(self):
        return True

    def applyMetaData(self):
        reply = self.sender()
        for header in reply.rawHeaderList():
            self.setRawHeader(header, reply.rawHeader(header))

        self.setHeader(QNetworkRequest.ContentTypeHeader, reply.header(QNetworkRequest.ContentTypeHeader))
        self.setHeader(QNetworkRequest.ContentLengthHeader, reply.header(QNetworkRequest.ContentLengthHeader))
        self.setHeader(QNetworkRequest.LocationHeader, reply.header(QNetworkRequest.LocationHeader))
        self.setHeader(QNetworkRequest.LastModifiedHeader, reply.header(QNetworkRequest.LastModifiedHeader))
        self.setHeader(QNetworkRequest.SetCookieHeader, reply.header(QNetworkRequest.SetCookieHeader))

        self.setAttribute(QNetworkRequest.HttpStatusCodeAttribute,
            reply.attribute(QNetworkRequest.HttpStatusCodeAttribute))
        self.setAttribute(QNetworkRequest.HttpReasonPhraseAttribute,
            reply.attribute(QNetworkRequest.HttpReasonPhraseAttribute))
        self.setAttribute(QNetworkRequest.RedirectionTargetAttribute,
            reply.attribute(QNetworkRequest.RedirectionTargetAttribute))
        self.setAttribute(QNetworkRequest.ConnectionEncryptedAttribute,
            reply.attribute(QNetworkRequest.ConnectionEncryptedAttribute))
        self.setAttribute(QNetworkRequest.CacheLoadControlAttribute,
            reply.attribute(QNetworkRequest.CacheLoadControlAttribute))
        self.setAttribute(QNetworkRequest.CacheSaveControlAttribute,
            reply.attribute(QNetworkRequest.CacheSaveControlAttribute))
        self.setAttribute(QNetworkRequest.SourceIsFromCacheAttribute,
            reply.attribute(QNetworkRequest.SourceIsFromCacheAttribute))
        # attribute is undefined
        #self.setAttribute(QNetworkRequest.DoNotBufferUploadDataAttribute, self.reply.attribute(QNetworkRequest.DoNotBufferUploadDataAttribute))
        self.metaDataChanged.emit()

    def bytesAvailable(self):
        """How many bytes in the buffer are available to be read
        """
        return len(self.buffer) + QNetworkReply.bytesAvailable(self)

    def readInternal(self):
        """New data available to read
        """
        s = self.reply.readAll()
        self.data += s
        self.buffer += s
        self.readyRead.emit()

    def readData(self, size):
        """Return up to size bytes from buffer
        """
        size = min(size, len(self.buffer))
        data, self.buffer = self.buffer[:size], self.buffer[size:]
        return str(data)


class CustomManager(QNetworkAccessManager):
    _red_button_url = '/ds/useraction.php?SIDIX='
    _finalAction = None


    def __init__(self, ):
        super(CustomManager, self).__init__()

        #cache = QNetworkDiskCache()
        #cache.setCacheDirectory('./cache')
        #cache.setMaximumCacheSize(10 * 1024 * 1024)
        #self.setCache(cache)

    def setFinalAction(self, func):
        self._finalAction = func

    def setClickCoord(self, coord):
        self._coord = coord

    def createRequest(self, operation, request, data):
        #request.setAttribute(QNetworkRequest.CacheLoadControlAttribute, QNetworkRequest.PreferCache)

        url = request.url().toString()

        #if data != None: print data.readAll()

        tmp = QNetworkAccessManager.createRequest(self, operation, request, data)

        #кастомный ответ для инфы красной кнопки
        if url.contains(self._red_button_url):
            reply = NetworkReply(self, tmp)
            reply.finished.connect(self.redButtonFind)
            return reply

        return tmp

    def redButtonFind(self):
        reply = self.sender()
        self._finalAction(reply)


class CustomPage(QWebPage):
    _agent = '' #user agent

    def __init__(self, parent=None):
        super(CustomPage, self).__init__(parent)

    def setAgent(self, agent):
        self._agent = agent

    def userAgentForUrl(self, url):
        return self._agent


class Browser(QWebView):
    def __init__(self, parent=None):
        super(Browser, self).__init__(parent)

        self.setPage(CustomPage())

        settings = self.settings()
        settings.setAttribute(QWebSettings.JavascriptEnabled, True)
        settings.setAttribute(QWebSettings.PluginsEnabled, True)


class Bot():
    _login_field = 'input[name=login].input_login_wnd'
    _pass_field = 'input[name=pass].input_login_wnd'
    _login_button = u'input[type="image"][alt="Войти в игру"]'
    _login_form = 'form[name=login_form]'

    _select_field = 'select[name="uiid"]'
    _select_world = 'option'
    _select_button = u'input[type="submit"][value="вход"].submit_yes'
    _select_form = 'form[name=start]'


    def __init__(self, start_url, world_name):
        self._url = start_url
        self._world = world_name
        self._try = 0

        self.timeouts = Timeouts()
        self.webView = Browser()

        self.manager = CustomManager()
        self.manager.setFinalAction(self.checkRedButton)
        self.webView.page().setNetworkAccessManager(self.manager)

        self.globalTimer = QTimer()
        self.globalTimer.setSingleShot(True)
        QObject.connect(self.globalTimer, SIGNAL("timeout()"), self.exitTimeout)

    def db(self):
        return self._db

    def setDB(self, db):
        self._db = db

    def playerId(self):
        return self._player_id

    def setPlayerId(self, id_player):
        self._player_id = id_player

    def parser(self):
        return self._parser

    def setParser(self, parser):
        self._parser = parser

    def setProxy(self, proxy):
        proxy_url = QUrl(proxy)
        QNetworkProxy.setApplicationProxy(
            QNetworkProxy(QNetworkProxy.HttpProxy,
                proxy_url.host(),
                proxy_url.port(),
                proxy_url.userName(),
                proxy_url.password()))

    def setAgent(self, agent):
        self.webView.page().setAgent(agent)

    def setCredentialy(self, login, password):
        self._login = login
        self._password = password

    def setSize(self, size):
        #TODO 
        pass

    def run(self):

        self.incTryCount()
        self.timeouts.computeTimeouts()
        logging.info("%d try check" % self.getCurrentTry())

        logging.info("global timeout %d seconds" % (self.timeouts.getExitTime() / 1000))
        self.globalTimer.start(self.timeouts.getExitTime())

        logging.info("start timeout %d seconds" % (self.timeouts.getStart() / 1000))
        QTimer.singleShot(self.timeouts.getStart(), self.go)

    def go(self):
        logging.info("start loading main page '%s'" % self._url)
        self.webView.load(QUrl(self._url))

        if config.DEBUG:
            self.webView.show()

        logging.info("load main page timeout %d seconds" % (self.timeouts.getStartPageLoad() / 1000))
        QTimer.singleShot(self.timeouts.getStartPageLoad(), self.login)

    def login(self):
        """Check exist login form on main page"""
        logging.info("login started")

        if not self.validateLoginForm():
            logging.error("login form not found or invalid")
            return self.exitOrRetry()

        logging.info("sleep %d seconds before login " % (self.timeouts.getLogin() / 1000))
        QTimer.singleShot(self.timeouts.getLogin(), self.doLogin)

    def doLogin(self):
        """Do login and shot entering to world"""

        document = self.webView.page().mainFrame().documentElement()

        button = document.findFirst(self._login_button)
        coord = self.getClickCoord(button.geometry())
        logging.info('click coord is x:%s y:%s' % coord)

        document.findFirst(self._login_field).setAttribute('value', self._login)
        document.findFirst(self._pass_field).setAttribute('value', self._password)
        document.findFirst(self._login_form).prependInside(self.getLoginHtml(coord))
        button.setAttribute('type', 'submit')
        button.evaluateJavaScript('this.click()')

        logging.info("load select page timeout %d seconds" % (self.timeouts.getSelectPageLoad() / 1000))
        QTimer.singleShot(self.timeouts.getSelectPageLoad(), self.enter)

    def enter(self):
        """Check exist select form and account world on page"""
        logging.info("select started")

        if not self.validateWorldForm():
            logging.error("select form not found or invalid")
            return self.exitOrRetry()

        logging.info("sleep %d seconds before enter " % (self.timeouts.getSelect() / 1000))
        QTimer.singleShot(self.timeouts.getSelect(), self.doEnter)

    def doEnter(self):
        """Do enter into world"""
        logging.info('enter started')

        document = self.webView.page().mainFrame().documentElement()
        options = document.findFirst(self._select_field).findAll(self._select_world)
        try:
            selected = [opt for opt in options if opt.toPlainText().trimmed().contains(self._world)][0]
        except IndexError:
            logging.error("world %s not found in select" % self._world)
            return self.exitOrRetry()

        for opt in options:
            opt.removeAttribute('selected')

        selected.setAttribute('selected', '1')
        document.findFirst(self._select_form).evaluateJavaScript('document.start.uiid.value="1"')
        document.findFirst(self._select_button).evaluateJavaScript('this.click()')

    def getLoginHtml(self, coord):
        return """
            <input type="text" name="x" value="%d">
            <input type="text" name="y" value="%d">
            """ % coord

    def getClickCoord(self, rect):
        """Рассчёт случайного места клика (нормальное распределение)"""
        (w, h) = rect.width(), rect.height()
        if w != 18 or h != 53:
            logging.error("login form button resize?")
            return self.exitOrRetry()
        return computeClickCoord(round(w)), computeClickCoord(round(h))

    def validateLoginForm(self):
        document = self.webView.page().mainFrame().documentElement()
        return (
            document.findAll(self._login_field).count() == 1
            and
            document.findAll(self._pass_field).count() == 1
            and
            document.findAll(self._login_button).count() == 1
            and
            document.findAll(self._login_form).count() == 1
            )

    def validateWorldForm(self):
        document = self.webView.page().mainFrame().documentElement()
        return (
            1 == document.findAll(self._select_form).count()
            and
            1 == document.findAll(self._select_button).count()
            and
            1 == document.findAll(self._select_field).count()
            )

    def checkRedButton(self, reply):
        """Запуск процессинга сообщений красной кнопки"""

        logging.info("source found")
        self.webView.stop()
        source = reply.data

        if not source.count():
            logging.error("source empty")
            return self.exitOrRetry()

        army = self.parser().process(source.data())
        cnt = self.db().compareArmy(self.playerId(), army)

        logging.info("Обработано %d найденных армий: доб %d / обн %d / удал %d" % (len(army), cnt['insert'], cnt['update'], cnt['delete']))
        exit(self.getCurrentTry(), 'success')

    def exitTimeout(self):
        logging.error('exit by global timeout')
        self.exitOrRetry()

    def exitOrRetry(self):
        if self.getCurrentTry() < config.TRY_COUNT:
            logging.info("retry check")
            self.run()
        else:
            exit(self.getCurrentTry())

    def getCurrentTry(self):
        return self._try

    def incTryCount(self):
        self._try += 1

class Parser():
    _pattern_sysmes = re.compile(u'sysmsg=<sysmsg>(.*?)</sysmsg>')
    _pattern_replace = re.compile(u'{(.*?)}')
    _pattern_redmes = re.compile(u'<w>(.*?)</w>')
    _pattern_sots = u'вступит в бой на соте ((%s) \(\d+\.\d+\.\d+\))'

    _pattern_army = re.compile(u'Армия ([\w\-\.]+) игрока', re.U)
    _pattern_owner = re.compile(u'игрока ([\wа-яё]+) вступит в бой', re.U | re.I)
    _pattern_time = re.compile(u'через[\s]+(([\d]{1,2}ч.)?(\s)?([\d]{1,2}м.)?(\s)?([\d]{1,2}с.)?).', re.U)
    _pattern_hour = re.compile(u'([\d]{1,2})ч.')
    _pattern_minute = re.compile(u'([\d]{1,2})м.')


    def setObservedSotsPattern(self, sots):
           self._pattern_sots = re.compile(self._pattern_sots % '|'.join(sots))

    def process(self, source):
        messages = self.extractMessages(source)
        logging.info("found %d messages" % len(messages))

        parced = []
        for m in messages:
            res = self.parse(m)
            if res:
                parced.append(res)

        logging.info("parced %d messages" % len(parced))

        return parced

    def extractMessages(self, source):
        """Извлекает сообщения из исходника"""

        try:
            str = self._pattern_sysmes.search(source.strip()).group(1)
            str = self._pattern_replace.sub('', str)
            return [unicode(m.group(1)) for m in self._pattern_redmes.finditer(str) if
                    self._pattern_sots.search(unicode(m.group(1)))]
        except AttributeError:
            return []

    def parse(self, m):
        """Парсит сообщение на дату/время и другие поля"""
        try:
            return {
                'army': self._pattern_army.search(m).group(1),
                'owner': self._pattern_owner.search(m).group(1),
                'time': self._parseTime(m),
                'sota': self._pattern_sots.search(m).group(1)
            }
        except AttributeError:
            logging.error("invalid message '%s'" % m)
            return None

    def _parseTime(self, m):
        time = self._pattern_time.search(m).group(1)

        try:
            hour = int(self._pattern_hour.search(time).group(1))
        except AttributeError:
            hour = 0
        try:
            minute = int(self._pattern_minute.search(time).group(1))
        except AttributeError:
            minute = 0

        return "%d:%d" % (hour, minute)

def computeClickCoord(len):
    m = len / 2
    s = math.sqrt(m)
    x = round(random.normalvariate(m, s))

    if x < 0: x = 0
    if x > len: x = len

    return x

def exit(try_count=0, task_result='fail'):
    global DB, TASK_ID
    logging.info("End %s" % time.strftime('%H:%M:%S %d.%m.%Y'))
    if DB is not None:
        DB.setTaskCompleted(TASK_ID,task_result,try_count)
        DB.close()
    QApplication.exit()
    sys.exit()

if __name__ == "__main__":
    config.initLog("checker")

    logging.info("Started %s" % time.strftime("%H:%M:%S %d.%m.%Y"))

    parser = OptionParser()
    parser.add_option("-t", '--task', type='int', dest='task_id', help='task id for check red button')
    (options, args) = parser.parse_args()

    if options.task_id is None:
        logging.error("task id not set")
        exit()

    DB = db_operations.DB()
    TASK_ID = options.task_id

    logging.info("task_id is %d" % TASK_ID)
    DB.setTaskProcessed(TASK_ID)

    if not config.DEBUG:
        os.environ['DISPLAY'] = ':%d' % config.DISPLAY

    task_data = DB.getTask(TASK_ID)
    acc_data = DB.getPlayerData(task_data['player_id'])

    if acc_data is None:
        logging.error('invalid account id %d' % task_data['player_id'])
        exit()

    if not len(acc_data['observed_sots']):
        logging.error('observed sots not found')
        exit()

    if not acc_data['enable_monitor']:
        logging.error('monitoring disabled')
        exit()

    if not config.DEBUG:
        if not acc_data['network_id']:
            logging.error('proxy disabled')
            exit()

        proxy = DB.getRelevantProxy(acc_data['network_id'])

        if not proxy:
            logging.error('not found relevant proxy')
            exit()

        DB.setProxyNetworkUsed(acc_data['network_id'])

    app = QApplication(sys.argv)
    app.setApplicationName("DSBot")
    app.setApplicationVersion("0.3(beta)")

    bot = Bot(
    start_url=acc_data['url'],
    world_name=acc_data['world_name']
    )
    bot.setDB(DB)
    bot.setPlayerId(task_data['player_id'])
    bot.setCredentialy(login=acc_data['login'], password=acc_data['game_pass'])
    bot.setAgent(acc_data['agent'])

    try:
        proxy = [i['conf'] for i in proxy]
        random.shuffle(proxy)
        bot.setProxy(proxy[0])
        logging.debug('proxy select %s' % proxy[0])
    except NameError:
        logging.warning('proxy not set')


    resultParser = Parser()
    resultParser.setObservedSotsPattern(acc_data['observed_sots'])
    bot.setParser(resultParser)

    bot.run()
    app.exec_()
    
