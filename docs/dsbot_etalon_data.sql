-- phpMyAdmin SQL Dump
-- version 3.4.5
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Feb 27, 2013 at 08:36 PM
-- Server version: 5.5.29
-- PHP Version: 5.3.10-1ubuntu3.5

SET FOREIGN_KEY_CHECKS=0;
SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT=0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `dsbot`
--

--
-- Dumping data for table `account`
--

INSERT INTO `account` (`id`, `network_id`, `agent_id`, `url_id`, `login`, `pass`, `approved`, `game_pass`, `balance`, `phone`, `email`, `proxy_expired`, `notify_type`) VALUES
(5, NULL, 37, 4, 'demo', 'ab65e99f17d56c71ccda865c33afc2f4e73e18f909aab156a5bd22ea5a5bf22a', 1, 0xa6096a84af89e0af9bb8dfb01147467c3ca0e80172ce5212c5ada3ac36aeecdf207cebc0cfe3239c77c9778c77956566, 117.6500, '89214567890', 'support@dsbot.ru', '2019-02-26', 'email');

--
-- Dumping data for table `agents`
--

INSERT INTO `agents` (`id`, `agent`) VALUES
(159, 'Mozilla/4.0 (compatible; MSIE 5.01; Windows NT)'),
(201, 'Mozilla/4.0 (compatible; MSIE 6.0; MSIE 5.5; Windows NT 5.1) Opera 7.01 [en]'),
(69, 'Mozilla/4.0 (compatible; MSIE 6.0; Windows 98; Win 9x 4.90)'),
(120, 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)'),
(109, 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; ru)'),
(236, 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1)'),
(142, 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 2.0.50727; .NET CLR 1.1.4322)'),
(39, 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 2.0.50727; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729; .NET4.0C; .NET4.0E)'),
(215, 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; InfoPath.1)'),
(100, 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; MRA 4.10 (build 01952); GTB6; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)'),
(107, 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; MRA 4.3 (build 01218); .NET CLR 2.0.50727; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729; AskTbPTV/5.11.3.15590)'),
(228, 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1)'),
(82, 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1;  SLCC1;  .NET CLR 1.1.4325;  .NET CLR 2.0.50727;  .NET CLR 3.0.30729)'),
(229, 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; .NET CLR 1.1.4322; .NET CLR 2.0.50727)'),
(237, 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)'),
(183, 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; MRA 5.10 (build 5339); .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.648; .NET CLR 3.5.21022; InfoPath.1)'),
(205, 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; Trident/4.0)'),
(122, 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; Trident/4.0; MathPlayer 2.20; .NET CLR 2.0.50727; .NET CLR 1.1.4322)'),
(94, 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; Trident/4.0; WebMoney Advisor; GTB7.4; TIOnline updater v Embedded Web Browser from: http://bsalsa.com/; InfoPath.1; .NET CLR 2.0.50727; .NET CLR 3.0.04506.648; .NET CLR 3.5.21022; WebMoney Advisor)'),
(114, 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.2; WOW64; Trident/4.0; .NET CLR 2.0.50727; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729; InfoPath.1; .NET4.0C)'),
(180, 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0; GTB6.4; SLCC1; .NET CLR 2.0.50727; Media Center PC 5.0; .NET CLR 3.5.30729; .NET CLR 3.0.30618)'),
(132, 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; Trident/5.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; OfficeLiveConnector.1.3; OfficeLivePatch.0.0; .NET4.0C; BRI/2)'),
(211, 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; Win64; x64; Trident/5.0; .NET CLR 2.0.50727; SLCC2; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; Tablet PC 2.0; MAAR; .NET4.0C; InfoPath.3; ms-office)'),
(89, 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.2; Trident/6.0; .NET4.0E; .NET4.0C; Media Center PC 6.0; InfoPath.3; .NET CLR 3.5.30729; .NET CLR 2.0.50727; .NET CLR 3.0.30729; WebMoney Advisor)'),
(37, 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0)'),
(219, 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; .NET CLR 1.0.3705; .NET CLR 1.1.4322; Media Center PC 4.0; InfoPath.1; .NET CLR 2.0.50727; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729; BRI/2)'),
(112, 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.30; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)'),
(225, 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.648; .NET CLR 3.5.21022; InfoPath.2)'),
(75, 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)'),
(63, 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729; .NET4.0C; .NET4.0E; AskTbALSV5/5.8.0.12217)'),
(172, 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729; InfoPath.1; WebMoney Advisor)'),
(93, 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; .NET CLR 1.1.4322; .NET CLR 2.0.50727; MAAU; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729; MAAU)'),
(169, 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; .NET CLR 2.0.50727; .NET CLR 3.0.04506.30; .NET CLR 1.1.4322; .NET CLR 3.0.04506.648; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)'),
(83, 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; .NET CLR 2.0.50727; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729; .NET4.0C; .NET4.0E)'),
(242, 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; .NET CLR 2.2.30729; .NET CLR 3.2.30729; .NET CLR 3.5.30729; .NET4.0C; .NET CLR 2.2.30729; .NET CLR 3.2.30729; .NET CLR 3.5.30729; .NET CLR 2.0.50727; .NET CLR 3.0.4506.2152; .NET4.0C)'),
(190, 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; GTB6; .NET CLR 2.0.50727; InfoPath.2; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)'),
(33, 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; GTB7.4; MRSPUTNIK 2, 4, 1, 74; .NET CLR 2.0.50727; WebMoney Advisor; BRI/2)'),
(72, 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1) )'),
(79, 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; MRA 5.6 (build 03278); .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729; .NET4.0C; .NET4.0E)'),
(38, 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; MRA 5.7 (build 03791); .NET CLR 2.0.50727)'),
(168, 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; MRSPUTNIK 2, 4, 0, 270; GTB7.4; .NET CLR 1.1.4322; .NET CLR 2.0.50727; AskTbPTV2/5.15.2.23037)'),
(153, 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; MRSPUTNIK 2, 4, 0, 504; .NET CLR 2.0.50727; .NET CLR 3.0.04506.30; InfoPath.2; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729; .NET CLR 1.1.4322)'),
(232, 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; MRSPUTNIK 2, 4, 0, 504; BTRS124869; GTB7.4; EasyBits GO v1.0; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)'),
(44, 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; MRSPUTNIK 2, 4, 1, 74; GTB7.4; .NET CLR 2.0.50727; WebMoney Advisor; BRI/2)'),
(139, 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.0; Trident/4.0)'),
(85, 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.0; Trident/4.0; SLCC1; .NET CLR 2.0.50727; Media Center PC 5.0; InfoPath.2; .NET CLR 3.5.30729; .NET CLR 3.0.30729; .NET4.0C)'),
(134, 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/4.0; MRSPUTNIK 2, 4, 0, 493; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0)'),
(223, 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/4.0; MRSPUTNIK 2, 4, 0, 508; GTB7.4; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET CLR 1.1.4322)'),
(128, 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; InfoPath.1)'),
(234, 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Win64; x64; Trident/4.0; .NET CLR 2.0.50727; SLCC2; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; InfoPath.3)'),
(116, 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; WOW64; Trident/4.0; MTI; BTRS21845; GTB7.4; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; .NET CLR 1.1.4322; .NET4.0C; .NET4.0E; MS-RTC LM 8; InfoPath.2; MTI)'),
(247, 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; WOW64; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; .NET4.0E)'),
(97, 'Mozilla/4.0 (Windows; U; Windows NT 5.1; lt; rv:1.9.0.14) Gecko/2009082707 Firefox/3.0.14 (.NET CLR 3.5.30729)'),
(52, 'Mozilla/4.0(compatible;MSIE 7.0;Windows NT 6.1;SV1;.NET CLR 1.0.3705;.NET CLR 3.0.30618)'),
(149, 'Mozilla/5.0 (compatible; DCPbot/1.2; +http://domains.checkparams.com/)'),
(124, 'Mozilla/5.0 (compatible; Exabot/3.0; +http://www.exabot.com/go/robot)'),
(165, 'Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.2; Trident/6.0)'),
(178, 'Mozilla/5.0 (compatible; MSIE 7.0; Windows NT 5.1)'),
(131, 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.0; Trident/5.0)'),
(171, 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)'),
(214, 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0)'),
(179, 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0; BOIE9;RURU)'),
(157, 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0; MAAU)'),
(35, 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0; NP06)'),
(161, 'Mozilla/5.0 (iPhone; CPU iPhone OS 5_1_1 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9B206 Safari/7534.48.3'),
(58, 'Mozilla/5.0 (Linux; U; Android 2.2; nl-nl; Desire_A8181 Build/FRF91) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1'),
(31, 'Mozilla/5.0 (Linux; U; Android 2.3.4; generic) AppleWebKit/536.8 (KHTML, like Gecko; Google Web Preview) Version/4.0 Mobile Safari/536.8'),
(193, 'Mozilla/5.0 (Linux; U; Android 2.3.6; ms-my; GT-S5360 Build/GINGERBREAD) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1'),
(177, 'Mozilla/5.0 (Linux; U; Android 4.0.4; ru-ru; GT-I9300 Build/IMM76D) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Mobile Safari/534.30'),
(199, 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/534.57.2 (KHTML, like Gecko) Version/5.1.7 Safari/534.57.2'),
(222, 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_4) AppleWebKit/536.25 (KHTML, like Gecko) Version/6.0 Safari/536.25'),
(103, 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_3; en-us) AppleWebKit/533.16 (KHTML, like Gecko) Version/5.0 Safari/533.16'),
(121, 'Mozilla/5.0 (Windows NT 5.1) AppleWebKit/535.1 (KHTML, like Gecko) Chrome/13.0.782.218 Safari/535.1'),
(99, 'Mozilla/5.0 (Windows NT 5.1) AppleWebKit/535.11 (KHTML, like Gecko) Chrome/17.0.963.46 Safari/535.11 MRCHROME'),
(88, 'Mozilla/5.0 (Windows NT 5.1) AppleWebKit/535.19 (KHTML, like Gecko) Chrome/18.0.1025.1634 Safari/535.19 YI'),
(45, 'Mozilla/5.0 (Windows NT 5.1) AppleWebKit/535.7 (KHTML, like Gecko) Chrome/16.0.912.63 Safari/535.7 MRCHROME'),
(81, 'Mozilla/5.0 (Windows NT 5.1) AppleWebKit/536.11 (KHTML, like Gecko) Chrome/20.0.1132.57 Safari/536.11'),
(175, 'Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1171.0 Safari/537.1'),
(138, 'Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.83 Safari/537.1'),
(184, 'Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.83 Safari/537.1 AvantBrowser/Tri-Core'),
(140, 'Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.89 Safari/537.1'),
(145, 'Mozilla/5.0 (Windows NT 5.1) Gecko/20100101 Firefox/4.0.1'),
(160, 'Mozilla/5.0 (Windows NT 5.1; rv:10.0.2) Gecko/20100101 Firefox/10.0.2'),
(207, 'Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20100101 Firefox/11.0'),
(108, 'Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20120330 Firefox/11.0'),
(243, 'Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20100101 Firefox/12.0'),
(135, 'Mozilla/5.0 (Windows NT 5.1; rv:13.0) Gecko/20100101 Firefox/13.0.1'),
(92, 'Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20100101 Firefox/14.0.1'),
(197, 'Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20100101 Firefox/15.0'),
(235, 'Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20100101 Firefox/15.0.1'),
(50, 'Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20100101 Firefox/15.0.1 FirePHP/0.7.1'),
(60, 'Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120909 Firefox/15.0.1 SeaMonkey/2.12.1'),
(141, 'Mozilla/5.0 (Windows NT 5.1; rv:5.0) Gecko/20100101 Firefox/5.0'),
(133, 'Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20100101 Firefox/7.0.1'),
(174, 'Mozilla/5.0 (Windows NT 5.1; rv:9.0.1) Gecko/20100101 Firefox/9.0.1'),
(143, 'Mozilla/5.0 (Windows NT 5.2) AppleWebKit/535.1 (KHTML, like Gecko) Chrome/13.0.772.0 Safari/535.1'),
(65, 'Mozilla/5.0 (Windows NT 5.2; rv:15.0) Gecko/20120909 Firefox/15.0.1 SeaMonkey/2.12.1'),
(55, 'Mozilla/5.0 (Windows NT 5.2; WOW64) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.89 Safari/537.1'),
(61, 'Mozilla/5.0 (Windows NT 6.0) AppleWebKit/534.24 (KHTML, like Gecko) Chrome/11.0.696.60 Safari/534.24'),
(136, 'Mozilla/5.0 (Windows NT 6.0) AppleWebKit/536.11 (KHTML, like Gecko) Chrome/20.0.1132.47 Safari/536.11'),
(67, 'Mozilla/5.0 (Windows NT 6.0) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.0 Safari/537.1'),
(196, 'Mozilla/5.0 (Windows NT 6.0) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.89 Safari/537.1'),
(156, 'Mozilla/5.0 (Windows NT 6.0; rv:13.0) Gecko/20100101 Firefox/13.0.1'),
(105, 'Mozilla/5.0 (Windows NT 6.0; rv:15.0) Gecko/20100101 Firefox/15.0.1'),
(202, 'Mozilla/5.0 (Windows NT 6.0; rv:15.0) Gecko/20120909 Firefox/15.0.1 SeaMonkey/2.12.1'),
(185, 'Mozilla/5.0 (Windows NT 6.0; WOW64) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.89 Safari/537.1'),
(248, 'Mozilla/5.0 (Windows NT 6.0; WOW64; rv:15.0) Gecko/20100101 Firefox/15.0.1'),
(167, 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/535.11 (KHTML, like Gecko) Chrome/17.0.963.46 Safari/535.11 MRCHROME'),
(129, 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/535.11 (KHTML, like Gecko) Chrome/17.0.963.47 Safari/535.11 MRCHROME'),
(224, 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/535.12 (KHTML, like Gecko) Maxthon/3.4.2.3000 Chrome/18.0.966.0 Safari/535.12'),
(46, 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/535.19 (KHTML, like Gecko) Chrome/18.0.1025.1634 Safari/535.19 YI'),
(217, 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/535.19 (KHTML, like Gecko) Chrome/18.0.1025.168 Safari/535.19'),
(155, 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/535.7 (KHTML, like Gecko) Chrome/16.0.912.77 Safari/535.7'),
(194, 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.83 Safari/537.1'),
(118, 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.89 Safari/537.1'),
(182, 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.3 (KHTML, like Gecko) Chrome/22.0.1223.0 Safari/537.3'),
(146, 'Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20100101 Firefox/11.0'),
(233, 'Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20100101 Firefox/12.0'),
(191, 'Mozilla/5.0 (Windows NT 6.1; rv:14.0) Gecko/20100101 Firefox/14.0'),
(84, 'Mozilla/5.0 (Windows NT 6.1; rv:14.0) Gecko/20100101 Firefox/14.0.1'),
(188, 'Mozilla/5.0 (Windows NT 6.1; rv:15.0) Gecko/20100101 Firefox/15.0'),
(78, 'Mozilla/5.0 (Windows NT 6.1; rv:15.0) Gecko/20100101 Firefox/15.0.1'),
(164, 'Mozilla/5.0 (Windows NT 6.1; rv:15.0) Gecko/20120819 Firefox/15.0 PaleMoon/15.0'),
(98, 'Mozilla/5.0 (Windows NT 6.1; rv:15.0) Gecko/20120911 Firefox/15.1 PaleMoon/15.1'),
(189, 'Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Firefox/17.0'),
(204, 'Mozilla/5.0 (Windows NT 6.1; rv:5.0.1) Gecko/20100101 Firefox/5.0.1'),
(187, 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/534.57.2 (KHTML, like Gecko) Version/5.1.7 Safari/534.57.2'),
(101, 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/535.1 (KHTML, like Gecko) Chrome/13.0.782.215 Safari/535.1'),
(54, 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/535.1 (KHTML, like Gecko) Chrome/14.0.835.186 Safari/535.1'),
(80, 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/535.19 (KHTML, like Gecko) Chrome/18.0.1025.1634 Safari/535.19 YI'),
(162, 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/535.19 (KHTML, like Gecko) Chrome/18.0.1025.168 Safari/535.19'),
(115, 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/536.11 (KHTML, like Gecko) Chrome/20.0.1132.47 Safari/536.11'),
(154, 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/536.11 (KHTML, like Gecko) Chrome/20.0.1132.57 Safari/536.11'),
(106, 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.89 Safari/537.1'),
(218, 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.10 (KHTML, like Gecko) Chrome/23.0.1262.0 Safari/537.10'),
(48, 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.2) Gecko/20100101 Firefox/10.0.2'),
(186, 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.4) Gecko/20100101 Firefox/10.0.4'),
(249, 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.7) Gecko/20100101 Firefox/10.0.7'),
(95, 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20100101 Firefox/14.0'),
(70, 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20100101 Firefox/14.0.1'),
(231, 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20100101 Firefox/15.0.1'),
(239, 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120909 Firefox/15.0.1 SeaMonkey/2.12.1'),
(111, 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20100101 Firefox/16.0'),
(71, 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:7.0.1) Gecko/20100101 Firefox/7.0.1'),
(66, 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0.1) Gecko/20100101 Firefox/9.0.1'),
(170, 'Mozilla/5.0 (Windows NT 6.2) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.89 Safari/537.1'),
(181, 'Mozilla/5.0 (Windows NT 6.2; WOW64; rv:15.0) Gecko/20100101 Firefox/15.0.1'),
(173, 'Mozilla/5.0 (Windows; I; Windows NT 5.1; ru; rv:1.9.2.13) Gecko/20100101 Firefox/4.0'),
(216, 'Mozilla/5.0 (Windows; U; Win98; en-US; rv:0.9.2) Gecko/20010726 Netscape6/6.1'),
(34, 'Mozilla/5.0 (Windows; U; Windows NT 5.1; Alexa Toolbar; MEGAUPLOAD 2.0; rv:1.8.1.7) Gecko/20070914 Firefox/2.0.0.7;MEGAUPLOAD 1.0'),
(57, 'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US) AppleWebKit/534.16 (KHTML, like Gecko) Chrome/10.0.648.204 Safari/534.16'),
(152, 'Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.0.1) Gecko/2008070208'),
(176, 'Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.1.3) Gecko/20090824 Firefox/3.5.3'),
(158, 'Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.1.6) Gecko/20091201 Firefox/3.5.6'),
(87, 'Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.2.12) Gecko/20101026 MRA 5.7 (build 03686) Firefox/3.6.12'),
(96, 'Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.2.15) Gecko/20110303 Firefox/13.0.1 ( ) WebMoney Advisor'),
(240, 'Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.2.27) Gecko/20120216 Firefox/3.6.27'),
(53, 'Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.2.3) Gecko/20100401 Firefox/3.6.3'),
(51, 'Mozilla/5.0 (Windows; U; Windows NT 5.1; uk; rv:1.9.2.23) Gecko/20110920 Firefox/3.6.23'),
(212, 'Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US) AppleWebKit/534.1 (KHTML, like Gecko) Chrome/6.0.427.0 Safari/534.1'),
(130, 'Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US) AppleWebKit/534.13 (KHTML, like Gecko) Chrome/9.0.597.84 Safari/534.13'),
(206, 'Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US) AppleWebKit/534.16 (KHTML, like Gecko) Chrome/10.0.648.133 Safari/534.16'),
(104, 'Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US) AppleWebKit/534.7 (KHTML, like Gecko) Chrome/7.0.517.8 Safari/534.7'),
(62, 'Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.7) Gecko/20100713 Firefox/3.6.7'),
(245, 'Mozilla/5.0 (Windows; U; Windows NT 6.1; ru; rv:1.9.1) Gecko/20090624 Firefox/3.5'),
(59, 'Mozilla/5.0 (Windows; U; Windows NT 6.1; ru; rv:1.9.1.15) Gecko/20101026 Firefox/3.5.15'),
(47, 'Mozilla/5.0 (Windows; U; Windows NT 6.1; ru; rv:1.9.2.3) Gecko/20100401 Firefox/3.6.3 WebMoney Advisor'),
(42, 'Mozilla/5.0 (X11; Linux i686) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.89 Safari/537.1'),
(203, 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/534.30 (KHTML, like Gecko) Ubuntu/11.04 Chromium/12.0.742.112 Chrome/12.0.742.112 Safari/534.30'),
(91, 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/536.8 (KHTML, like Gecko; Google Web Preview) Chrome/19.0.1084.36 Safari/536.8'),
(41, 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.89 Safari/537.1'),
(166, 'Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.11) Gecko/20101013 Ubuntu/10.04 (lucid) Firefox/3.6.11'),
(144, 'Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.3) Gecko/20100423 Ubuntu/10.04 (lucid) Firefox/3.6.3'),
(123, 'Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2a1pre) Gecko/20090428 Firefox/3.6a1pre'),
(126, 'Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:15.0) Gecko/20100101 Firefox/15.0'),
(238, 'Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:15.0) Gecko/20100101 Firefox/15.0.1'),
(49, 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:14.0) Gecko/20100101 Firefox/14.0.1'),
(110, 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:14.0) Gecko/20100101 Firefox/14.0.1 FirePHP/0.7.1'),
(200, 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:15.0) Gecko/20100101 Firefox/15.0'),
(68, 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:15.0) Gecko/20100101 Firefox/15.0.1'),
(102, 'Opera/10.00 (Windows NT 5.1; U; ru) Presto/2.2.0'),
(241, 'Opera/9.80 (Android 2.2.2; Linux; Opera Mobi/ADR-1207201819; U; ru) Presto/2.10.254 Version/12.00'),
(77, 'Opera/9.80 (Android; Opera Mini/7.0.29952/28.2555; U; ru) Presto/2.8.119 Version/11.10'),
(192, 'Opera/9.80 (J2ME/MIDP; Opera Mini/6.5.26955/28.2504; U; ru) Presto/2.8.119 Version/11.10'),
(137, 'Opera/9.80 (J2ME/MIDP; Opera Mini/6.5.26955/28.2555; U; ru) Presto/2.8.119 Version/11.10'),
(127, 'Opera/9.80 (Windows NT 5.1; U; Edition Yx; ru) Presto/2.10.289 Version/12.00'),
(244, 'Opera/9.80 (Windows NT 5.1; U; en-GB) Presto/2.10.289 Version/12.02'),
(221, 'Opera/9.80 (Windows NT 5.1; U; MRA 5.10 (build 5339); ru) Presto/2.10.229 Version/11.64'),
(64, 'Opera/9.80 (Windows NT 5.1; U; MRA 5.9 (build 4953); ru) Presto/2.10.289 Version/12.02'),
(43, 'Opera/9.80 (Windows NT 5.1; U; ru) Presto/2.10.229 Version/11.60'),
(40, 'Opera/9.80 (Windows NT 5.1; U; ru) Presto/2.10.229 Version/11.64'),
(76, 'Opera/9.80 (Windows NT 5.1; U; ru) Presto/2.10.289 Version/12.00'),
(56, 'Opera/9.80 (Windows NT 5.1; U; ru) Presto/2.10.289 Version/12.01'),
(74, 'Opera/9.80 (Windows NT 5.1; U; ru) Presto/2.10.289 Version/12.02'),
(150, 'Opera/9.80 (Windows NT 5.1; U; ru) Presto/2.2.15 Version/10.10'),
(251, 'Opera/9.80 (Windows NT 5.1; U; ru) Presto/2.5.24 Version/10.54'),
(163, 'Opera/9.80 (Windows NT 5.1; U; ru) Presto/2.6.30 Version/10.63'),
(226, 'Opera/9.80 (Windows NT 5.2; U; en) Presto/2.10.229 Version/11.64'),
(117, 'Opera/9.80 (Windows NT 5.2; WOW64; U; en) Presto/2.10.289 Version/12.02'),
(36, 'Opera/9.80 (Windows NT 6.0; U; ru) Presto/2.5.22 Version/10.51'),
(90, 'Opera/9.80 (Windows NT 6.0; U; ru) Presto/2.6.30 Version/10.63'),
(250, 'Opera/9.80 (Windows NT 6.1; U; Distribution 00; ru) Presto/2.10.289 Version/12.02'),
(73, 'Opera/9.80 (Windows NT 6.1; U; Edition Next; ru) Presto/2.10.289 Version/12.01'),
(209, 'Opera/9.80 (Windows NT 6.1; U; Edition Yx; ru) Presto/2.10.289 Version/12.00'),
(208, 'Opera/9.80 (Windows NT 6.1; U; MRA 5.10 (build 5339); ru) Presto/2.10.289 Version/12.02'),
(230, 'Opera/9.80 (Windows NT 6.1; U; MRA 5.7 (build 03796); ru) Presto/2.10.289 Version/12.02'),
(125, 'Opera/9.80 (Windows NT 6.1; U; MRA 6.0 (build 5970); ru) Presto/2.10.229 Version/11.62'),
(147, 'Opera/9.80 (Windows NT 6.1; U; MRA 6.0 (build 5970); ru) Presto/2.10.289 Version/12.01'),
(227, 'Opera/9.80 (Windows NT 6.1; U; MRA 6.0 (build 5970); ru) Presto/2.10.289 Version/12.02'),
(151, 'Opera/9.80 (Windows NT 6.1; U; ru) Presto/2.10.229 Version/11.60'),
(148, 'Opera/9.80 (Windows NT 6.1; U; ru) Presto/2.10.229 Version/11.64'),
(220, 'Opera/9.80 (Windows NT 6.1; U; ru) Presto/2.10.289 Version/12.02'),
(198, 'Opera/9.80 (Windows NT 6.1; U; ru) Presto/2.6.30 Version/10.63'),
(32, 'Opera/9.80 (Windows NT 6.1; U; ru) Presto/2.9.168 Version/11.52'),
(119, 'Opera/9.80 (Windows NT 6.1; WOW64; U; en) Presto/2.10.289 Version/12.02'),
(195, 'Opera/9.80 (Windows NT 6.1; WOW64; U; fr) Presto/2.10.289 Version/12.02'),
(86, 'Opera/9.80 (Windows NT 6.1; WOW64; U; MRA 6.0 (build 5970); ru) Presto/2.10.289 Version/12.02'),
(113, 'Opera/9.80 (Windows NT 6.1; WOW64; U; ru) Presto/2.10.229 Version/11.64'),
(246, 'Opera/9.80 (Windows NT 6.1; WOW64; U; ru) Presto/2.10.289 Version/12.00'),
(210, 'Opera/9.80 (Windows NT 6.1; WOW64; U; ru) Presto/2.10.289 Version/12.01'),
(213, 'Opera/9.80 (Windows NT 6.1; WOW64; U; ru) Presto/2.10.289 Version/12.02');

--
-- Dumping data for table `balance_history`
--

INSERT INTO `balance_history` (`acc_id`, `amount`, `type`, `date`) VALUES
(5, 0.6000, 'Proxy expired notify (sms)', '2013-02-27 20:08:49'),
(5, 0.6000, 'Proxy expired soon notify (sms)', '2013-02-27 20:08:50'),
(5, 0.6000, 'Proxy expired notify (sms)', '2013-02-27 20:09:10');

--
-- Dumping data for table `check_tasks`
--

INSERT INTO `check_tasks` (`id`, `player_id`, `date`, `status`, `try_count`) VALUES
(2, 8, '2013-02-27 19:49:09', 'success', 0),
(3, 9, '2013-02-27 19:42:42', 'success', 1),
(4, 8, '2013-02-27 23:19:31', 'success', 1),
(5, 9, '2013-02-27 20:39:49', 'fail', 4),
(6, 10, '2013-02-27 20:22:08', 'success', 2),
(7, 11, '2013-02-27 20:35:03', 'success', 3);

--
-- Dumping data for table `messages`
--

INSERT INTO `messages` (`acc_id`, `to`, `message`, `optional_data`, `date`) VALUES
(5, 'support@dsbot.ru', 'demo: proxy has expired, all checks stopped', 'Content-Type: multipart/mixed; boundary="===============3374031764004270448=="\nMIME-Version: 1.0\nFrom: =?utf-8?q?noreply=40dsbot=2Eru?=\nTo: support@dsbot.ru\nSubject: =?utf-8?q?Proxy_expired_notify?=\n\n--===============3374031764004270448==\nMIME-Version: 1.0\nContent-Type: text/plain; charset="utf-8"\nContent-Transfer-Encoding: base64\n\nZGVtbzogcHJveHkgaGFzIGV4cGlyZWQsIGFsbCBjaGVja3Mgc3RvcHBlZA==\n\n--===============3374031764004270448==--', '2013-02-27 20:05:21'),
(5, 'support@dsbot.ru', 'demo: proxy expired 26.02.2013', 'Content-Type: multipart/mixed; boundary="===============2963907752416589187=="\nMIME-Version: 1.0\nFrom: =?utf-8?q?noreply=40dsbot=2Eru?=\nTo: support@dsbot.ru\nSubject: =?utf-8?q?Proxy_expired_soon_notify?=\n\n--===============2963907752416589187==\nMIME-Version: 1.0\nContent-Type: text/plain; charset="utf-8"\nContent-Transfer-Encoding: base64\n\nZGVtbzogcHJveHkgZXhwaXJlZCAyNi4wMi4yMDEz\n\n--===============2963907752416589187==--', '2013-02-27 20:05:21'),
(5, '89214567890', 'demo: proxy has expired, all checks stopped', '{\n"cost": "0.4",\n"cnt": 1\n}', '2013-02-27 20:08:49'),
(5, 'support@dsbot.ru', 'demo: proxy has expired, all checks stopped', 'Content-Type: multipart/mixed; boundary="===============5751333375915868692=="\nMIME-Version: 1.0\nFrom: =?utf-8?q?noreply=40dsbot=2Eru?=\nTo: support@dsbot.ru\nSubject: =?utf-8?q?Proxy_expired_notify?=\n\n--===============5751333375915868692==\nMIME-Version: 1.0\nContent-Type: text/plain; charset="utf-8"\nContent-Transfer-Encoding: base64\n\nZGVtbzogcHJveHkgaGFzIGV4cGlyZWQsIGFsbCBjaGVja3Mgc3RvcHBlZA==\n\n--===============5751333375915868692==--', '2013-02-27 20:08:50'),
(5, '89214567890', 'demo: proxy expired 26.02.2013', '{\n"cost": "0.4",\n"cnt": 1\n}', '2013-02-27 20:08:50'),
(5, 'support@dsbot.ru', 'demo: proxy expired 26.02.2013', 'Content-Type: multipart/mixed; boundary="===============2272208240862670638=="\nMIME-Version: 1.0\nFrom: =?utf-8?q?noreply=40dsbot=2Eru?=\nTo: support@dsbot.ru\nSubject: =?utf-8?q?Proxy_expired_soon_notify?=\n\n--===============2272208240862670638==\nMIME-Version: 1.0\nContent-Type: text/plain; charset="utf-8"\nContent-Transfer-Encoding: base64\n\nZGVtbzogcHJveHkgZXhwaXJlZCAyNi4wMi4yMDEz\n\n--===============2272208240862670638==--', '2013-02-27 20:08:50'),
(5, '89214567890', 'demo: proxy has expired, all checks stopped', '{\n"cost": "0.4",\n"cnt": 1\n}', '2013-02-27 20:09:10'),
(5, 'support@dsbot.ru', 'demo: proxy has expired, all checks stopped', 'Content-Type: multipart/mixed; boundary="===============2156049786205330047=="\nMIME-Version: 1.0\nFrom: =?utf-8?q?noreply=40dsbot=2Eru?=\nTo: support@dsbot.ru\nSubject: =?utf-8?q?Proxy_expired_notify?=\n\n--===============2156049786205330047==\nMIME-Version: 1.0\nContent-Type: text/plain; charset="utf-8"\nContent-Transfer-Encoding: base64\n\nZGVtbzogcHJveHkgaGFzIGV4cGlyZWQsIGFsbCBjaGVja3Mgc3RvcHBlZA==\n\n--===============2156049786205330047==--', '2013-02-27 20:09:11');

--
-- Dumping data for table `player_sots`
--

INSERT INTO `player_sots` (`player_id`, `name`) VALUES
(8, 'second_colony'),
(8, 'sota1'),
(9, 'atat132'),
(10, '123456'),
(11, 'domik_v_derevne');

--
-- Dumping data for table `players`
--

INSERT INTO `players` (`id`, `acc_id`, `world_id`, `enable_monitor`, `enable_notify`, `check_interval`, `notify_hours`) VALUES
(8, 5, 8, 0, 0, 8, 3),
(9, 5, 12, 0, 1, 1, 12),
(10, 5, 9, 0, 1, 2, 4),
(11, 5, 1, 0, 0, 1, 1);

--
-- Dumping data for table `proxy_list`
--

INSERT INTO `proxy_list` (`id`, `user`, `pass`, `proxy`, `network_id`, `date_update`, `rank`) VALUES
(1127, 'RUSsyuTriYOpy', 'ARN0selUYG', '92.63.103.98:8080', 58, '2012-09-30', 154),
(1128, 'RUSsyuTriYOpy', 'ARN0selUYG', '92.63.103.102:8080', 58, '2012-09-30', 146),
(1129, 'RUSsyuTriYOpy', 'ARN0selUYG', '188.120.235.38:8080', 42, '2012-09-30', 152),
(1130, 'RUSsyuTriYOpy', 'ARN0selUYG', '92.63.103.249:8080', 58, '2012-09-30', 147),
(1131, 'RUSsyuTriYOpy', 'ARN0selUYG', '92.63.102.209:8080', 57, '2012-09-30', 147),
(1132, 'RUSsyuTriYOpy', 'ARN0selUYG', '188.120.237.121:8080', 41, '2012-09-30', 148),
(1133, 'RUSsyuTriYOpy', 'ARN0selUYG', '78.24.216.47:8080', 51, '2012-09-30', 152),
(1134, 'RUSsyuTriYOpy', 'ARN0selUYG', '149.154.69.130:8080', 49, '2012-09-30', 158),
(1135, 'RUSsyuTriYOpy', 'ARN0selUYG', '149.154.69.99:8080', 49, '2012-09-30', 160),
(1136, 'RUSsyuTriYOpy', 'ARN0selUYG', '92.63.103.173:8080', 58, '2012-09-30', 158),
(1137, 'RUSsyuTriYOpy', 'ARN0selUYG', '188.120.235.36:8080', 42, '2012-09-30', 155),
(1138, 'RUSsyuTriYOpy', 'ARN0selUYG', '188.120.235.39:8080', 42, '2012-09-30', 140),
(1139, 'RUSsyuTriYOpy', 'ARN0selUYG', '149.154.69.75:8080', 49, '2012-09-30', 160),
(1140, 'RUSsyuTriYOpy', 'ARN0selUYG', '188.120.229.106:8080', 54, '2012-09-30', 141),
(1141, 'RUSsyuTriYOpy', 'ARN0selUYG', '188.120.244.18:8080', 53, '2012-09-30', 153),
(1142, 'RUSsyuTriYOpy', 'ARN0selUYG', '188.120.227.220:8080', 43, '2012-09-30', 158),
(1143, 'RUSsyuTriYOpy', 'ARN0selUYG', '188.120.235.43:8080', 42, '2012-09-30', 159),
(1144, 'RUSsyuTriYOpy', 'ARN0selUYG', '92.63.105.80:8080', 62, '2012-09-30', 158),
(1145, 'RUSsyuTriYOpy', 'ARN0selUYG', '62.109.3.172:8080', 37, '2012-09-30', 160),
(1146, 'RUSsyuTriYOpy', 'ARN0selUYG', '92.63.100.8:8080', 59, '2012-09-30', 160),
(1147, 'RUSsyuTriYOpy', 'ARN0selUYG', '188.120.244.110:8080', 53, '2012-09-30', 149),
(1148, 'RUSsyuTriYOpy', 'ARN0selUYG', '149.154.69.106:8080', 49, '2012-09-30', 140),
(1149, 'RUSsyuTriYOpy', 'ARN0selUYG', '149.154.69.134:8080', 49, '2012-09-30', 153),
(1150, 'RUSsyuTriYOpy', 'ARN0selUYG', '78.24.220.6:8080', 34, '2012-09-30', 141),
(1151, 'RUSsyuTriYOpy', 'ARN0selUYG', '188.120.236.22:8080', 40, '2012-09-30', 153),
(1152, 'RUSsyuTriYOpy', 'ARN0selUYG', '92.63.107.192:8080', 61, '2012-09-30', 147),
(1153, 'RUSsyuTriYOpy', 'ARN0selUYG', '188.120.235.40:8080', 42, '2012-09-30', 159),
(1154, 'RUSsyuTriYOpy', 'ARN0selUYG', '82.146.40.20:8080', 55, '2012-09-30', 153),
(1155, 'RUSsyuTriYOpy', 'ARN0selUYG', '62.109.31.246:8080', 46, '2012-09-30', 159),
(1156, 'RUSsyuTriYOpy', 'ARN0selUYG', '188.120.236.2:8080', 40, '2012-09-30', 154),
(1157, 'RUSsyuTriYOpy', 'ARN0selUYG', '149.154.69.63:8080', 49, '2012-09-30', 147),
(1158, 'RUSsyuTriYOpy', 'ARN0selUYG', '92.63.105.12:8080', 62, '2012-09-30', 160),
(1159, 'RUSsyuTriYOpy', 'ARN0selUYG', '62.109.5.9:8080', 38, '2012-09-30', 153),
(1160, 'RUSsyuTriYOpy', 'ARN0selUYG', '62.109.27.253:8080', 48, '2012-09-30', 148),
(1161, 'RUSsyuTriYOpy', 'ARN0selUYG', '149.154.69.78:8080', 49, '2012-09-30', 154),
(1162, 'RUSsyuTriYOpy', 'ARN0selUYG', '188.120.231.243:8080', 39, '2012-09-30', 148),
(1163, 'RUSsyuTriYOpy', 'ARN0selUYG', '62.109.5.238:8080', 38, '2012-09-30', 160),
(1164, 'RUSsyuTriYOpy', 'ARN0selUYG', '92.63.103.143:8080', 58, '2012-09-30', 153),
(1165, 'RUSsyuTriYOpy', 'ARN0selUYG', '188.120.231.51:8080', 39, '2012-09-30', 154),
(1166, 'RUSsyuTriYOpy', 'ARN0selUYG', '149.154.69.69:8080', 49, '2012-09-30', 148),
(1167, 'RUSsyuTriYOpy', 'ARN0selUYG', '188.120.235.37:8080', 42, '2012-09-30', 160),
(1168, 'RUSsyuTriYOpy', 'ARN0selUYG', '149.154.69.143:8080', 49, '2012-09-30', 134),
(1169, 'RUSsyuTriYOpy', 'ARN0selUYG', '82.146.57.105:8080', 44, '2012-09-30', 158),
(1170, 'RUSsyuTriYOpy', 'ARN0selUYG', '82.146.56.89:8080', 45, '2012-09-30', 153),
(1171, 'RUSsyuTriYOpy', 'ARN0selUYG', '82.146.47.227:8080', 56, '2012-09-30', 160),
(1172, 'RUSsyuTriYOpy', 'ARN0selUYG', '149.154.69.94:8080', 49, '2012-09-30', 159),
(1173, 'RUSsyuTriYOpy', 'ARN0selUYG', '188.120.237.82:8080', 41, '2012-09-30', 161),
(1174, 'RUSsyuTriYOpy', 'ARN0selUYG', '62.109.10.22:8080', 63, '2012-09-30', 160),
(1175, 'RUSsyuTriYOpy', 'ARN0selUYG', '82.146.56.40:8080', 45, '2012-09-30', 153),
(1176, 'RUSsyuTriYOpy', 'ARN0selUYG', '62.109.19.1:8080', 60, '2012-09-30', 160),
(1177, 'RUSsyuTriYOpy', 'ARN0selUYG', '62.109.5.99:8080', 38, '2012-09-30', 142),
(1178, 'RUSsyuTriYOpy', 'ARN0selUYG', '188.120.235.42:8080', 42, '2012-09-30', 147),
(1179, 'RUSsyuTriYOpy', 'ARN0selUYG', '92.63.99.62:8080', 47, '2012-09-30', 153),
(1180, 'RUSsyuTriYOpy', 'ARN0selUYG', '62.109.31.228:8080', 46, '2012-09-30', 158),
(1181, 'RUSsyuTriYOpy', 'ARN0selUYG', '188.120.235.41:8080', 42, '2012-09-30', 158),
(1182, 'RUSsyuTriYOpy', 'ARN0selUYG', '149.154.69.113:8080', 49, '2012-09-30', 148),
(1183, 'RUSsyuTriYOpy', 'ARN0selUYG', '62.109.1.48:8080', 36, '2012-09-30', 158),
(1184, 'RUSsyuTriYOpy', 'ARN0selUYG', '188.120.229.117:8080', 54, '2012-09-30', 159),
(1185, 'RUSsyuTriYOpy', 'ARN0selUYG', '149.154.69.139:8080', 49, '2012-09-30', 158),
(1186, 'RUSsyuTriYOpy', 'ARN0selUYG', '62.109.5.119:8080', 38, '2012-09-30', 160),
(1187, 'RUSsyuTriYOpy', 'ARN0selUYG', '62.109.5.90:8080', 38, '2012-09-30', 160),
(1188, 'RUSsyuTriYOpy', 'ARN0selUYG', '62.109.20.45:8080', 50, '2012-09-30', 154),
(1189, 'RUSsyuTriYOpy', 'ARN0selUYG', '188.120.246.223:8080', 52, '2012-09-30', 149),
(1190, 'RUSsyuTriYOpy', 'ARN0selUYG', '149.154.69.52:8080', 49, '2012-09-30', 160),
(1191, 'RUSsyuTriYOpy', 'ARN0selUYG', '149.154.69.86:8080', 49, '2012-09-30', 159),
(1192, 'RUSsyuTriYOpy', 'ARN0selUYG', '188.120.229.105:8080', 54, '2012-09-30', 159),
(1193, 'RUSsyuTriYOpy', 'ARN0selUYG', '62.109.0.70:8080', 35, '2012-09-30', 158),
(1194, 'RUSsyuTriYOpy', 'ARN0selUYG', '188.120.231.22:8080', 39, '2012-09-30', 153),
(1195, 'RUSsyuTriYOpy', 'ARN0selUYG', '62.109.5.221:8080', 38, '2012-09-30', 154),
(1196, 'RUSsyuTriYOpy', 'ARN0selUYG', '82.146.56.143:8080', 45, '2012-09-30', 154);

--
-- Dumping data for table `proxy_networks`
--

INSERT INTO `proxy_networks` (`id`, `network`, `date_last_used`) VALUES
(34, '78.24.220', NULL),
(35, '62.109.0', NULL),
(36, '62.109.1', NULL),
(37, '62.109.3', NULL),
(38, '62.109.5', '2012-09-30'),
(39, '188.120.231', NULL),
(40, '188.120.236', NULL),
(41, '188.120.237', '2012-09-29'),
(42, '188.120.235', NULL),
(43, '188.120.227', NULL),
(44, '82.146.57', '2012-09-28'),
(45, '82.146.56', '2012-09-29'),
(46, '62.109.31', NULL),
(47, '92.63.99', NULL),
(48, '62.109.27', NULL),
(49, '149.154.69', NULL),
(50, '62.109.20', NULL),
(51, '78.24.216', NULL),
(52, '188.120.246', NULL),
(53, '188.120.244', NULL),
(54, '188.120.229', NULL),
(55, '82.146.40', NULL),
(56, '82.146.47', NULL),
(57, '92.63.102', NULL),
(58, '92.63.103', NULL),
(59, '92.63.100', NULL),
(60, '62.109.19', NULL),
(61, '92.63.107', NULL),
(62, '92.63.105', NULL),
(63, '62.109.10', NULL);

--
-- Dumping data for table `start_urls`
--

INSERT INTO `start_urls` (`id`, `url`) VALUES
(1, 'http://dsga.me'),
(2, 'http://www.dsga.me'),
(3, 'http://www.destinysphere.ru'),
(4, 'http://destinysphere.ru');

--
-- Dumping data for table `worlds`
--

INSERT INTO `worlds` (`id`, `pattern`, `name`) VALUES
(1, 'Сфера Водолея-Льва', 'VodaLev'),
(3, 'Сфера Ориона', 'Orion'),
(4, 'Сфера Стрельца', 'Strela'),
(7, 'Терра Нова', 'terra'),
(8, 'Сфера Волка', 'volk'),
(9, 'Сфера Гончих Псов', 'dogs'),
(10, 'Сфера Эридана', 'eridan'),
(11, 'Сфера Ворона-Феникса', 'voronfenix'),
(12, 'Сфера Змееносца', 'zmey');
SET FOREIGN_KEY_CHECKS=1;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
