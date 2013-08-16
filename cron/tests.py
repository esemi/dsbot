#! /usr/bin/python
# -*- coding: utf-8 -*-

__author__ = 'esemi'

import unittest
from checker import Parser

class MessageParseCase(unittest.TestCase):

    _parser = None

    def setUp(self):
        self._parser = Parser()
        self._parser.setObservedSotsPattern(['MercenaryFirst','MercenarySecond', 'isset'])

    def test_parse_message(self):

        messages = [
            (
                u'02.03 22:28 - Армия 1.331.3 игрока Bionicl вступит в бой на соте isset (1.331.3) игрока unset через  8ч. 10м. 38с..',
                {'owner':u'Bionicl','army':u'1.331.3', 'sota':u'isset (1.331.3)','time':'8:10'}
            ),
            (
                u'31.08 09:18 - Армия 1-260-3 игрока kontra33 вступит в бой на соте MercenaryFirst (4.56.3) игрока ___L___ через  1ч. 40м. 35с..',
                {'owner':u'kontra33','army':u'1-260-3','sota':u'MercenaryFirst (4.56.3)','time':'1:40'}
            ),
            (
                u'31.08 09:18 - Армия asdfsf23 игрока kontra33 вступит в бой на соте MercenaryFirst (4.56.3) игрока ___L___ через  4ч. 28с..',
                {'owner':u'kontra33','army':u'asdfsf23','sota':u'MercenaryFirst (4.56.3)','time':'4:0'}
            ),
            (
                u'30.08 04:08 - Армия 234223 игрока kontra33 вступит в бой на соте MercenaryFirst (4.56.3) игрока ___L___ через  41м. 16с..',
                {'owner':u'kontra33','army':u'234223','sota':u'MercenaryFirst (4.56.3)','time':'0:41'}
            ),
            (
                u'30.08 04:08 - Армия 234223 игрока kontra33 вступит в бой на соте MercenaryFirst (4.56.3) игрока ___L___ через  10с..',
                {'owner':u'kontra33','army':u'234223','sota':u'MercenaryFirst (4.56.3)','time':'0:0'}
            ),
            (
                u'30.08 04:08 - Армия 234223 игрока kontra33 вступит в бой на соте MercenaryFirst (4.56.3) игрока ___L___ через  16м..',
                {'owner':u'kontra33','army':u'234223','sota':u'MercenaryFirst (4.56.3)','time':'0:16'}
            ),
            (
                u'30.08 04:08 - Армия 234223 игрока kontra33 вступит в бой на соте MercenaryFirst (4.56.3) игрока ___L___ через  1ч..',
                {'owner':u'kontra33','army':u'234223','sota':u'MercenaryFirst (4.56.3)','time':'1:0'}
            )
        ]
        for test, success in messages:
            res = self._parser.parse(test)
            self.assertEqual(res,success)

if __name__ == '__main__':
    unittest.main()
