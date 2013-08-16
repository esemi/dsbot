-- phpMyAdmin SQL Dump
-- version 3.4.5
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Feb 27, 2013 at 08:36 PM
-- Server version: 5.5.29
-- PHP Version: 5.3.10-1ubuntu3.5

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `dsbot`
--

-- --------------------------------------------------------

--
-- Table structure for table `account`
--

CREATE TABLE IF NOT EXISTS `account` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `network_id` int(10) unsigned DEFAULT NULL,
  `agent_id` int(10) unsigned NOT NULL,
  `url_id` int(10) unsigned NOT NULL,
  `login` varchar(250) NOT NULL,
  `pass` varchar(250) NOT NULL,
  `approved` tinyint(1) unsigned NOT NULL,
  `game_pass` mediumblob NOT NULL,
  `balance` decimal(20,4) NOT NULL DEFAULT '0.0000',
  `phone` varchar(20) NOT NULL,
  `email` varchar(255) NOT NULL,
  `proxy_expired` date NOT NULL,
  `notify_type` enum('sms','email') NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `proxy_id_2` (`network_id`),
  KEY `url_id` (`url_id`),
  KEY `agent_id_2` (`agent_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=8 ;

-- --------------------------------------------------------

--
-- Table structure for table `agents`
--

CREATE TABLE IF NOT EXISTS `agents` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `agent` varchar(250) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `agent` (`agent`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=252 ;

-- --------------------------------------------------------

--
-- Table structure for table `attacks`
--

CREATE TABLE IF NOT EXISTS `attacks` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `player_id` int(10) unsigned NOT NULL,
  `army` varchar(250) NOT NULL COMMENT 'имя армии',
  `owner` varchar(250) NOT NULL COMMENT 'ник нападающего',
  `time` datetime NOT NULL COMMENT 'время нападения, сведённое к локали сервера (из "через Хч. Ум."))',
  `sota` varchar(100) NOT NULL COMMENT 'имя соты, на которую летят',
  `date_find` datetime NOT NULL,
  `date_check` datetime DEFAULT NULL,
  `notified` tinyint(1) unsigned NOT NULL COMMENT 'было ли оповещение о данной армии',
  `delete` tinyint(1) unsigned NOT NULL COMMENT 'флажёк для чистки старых сообщений',
  PRIMARY KEY (`id`),
  UNIQUE KEY `player_id_2` (`player_id`,`army`,`owner`),
  KEY `player_id` (`player_id`),
  KEY `delete` (`delete`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `balance_history`
--

CREATE TABLE IF NOT EXISTS `balance_history` (
  `acc_id` int(10) unsigned NOT NULL,
  `amount` decimal(20,4) NOT NULL,
  `type` varchar(250) NOT NULL,
  `date` datetime NOT NULL,
  KEY `acc_id` (`acc_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `check_tasks`
--

CREATE TABLE IF NOT EXISTS `check_tasks` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `player_id` int(10) unsigned NOT NULL,
  `date` datetime NOT NULL,
  `status` enum('wait','processed','fail','success') NOT NULL DEFAULT 'wait' COMMENT 'wait - ждёт запуска, processed - в работе, fail - обломилась проверка, success - всё успешно проверилось',
  `try_count` tinyint(1) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `player_id` (`player_id`),
  KEY `date` (`date`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=8 ;

-- --------------------------------------------------------

--
-- Table structure for table `messages`
--

CREATE TABLE IF NOT EXISTS `messages` (
  `acc_id` int(10) unsigned NOT NULL,
  `to` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `optional_data` text NOT NULL,
  `date` datetime NOT NULL,
  KEY `acc_id` (`acc_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `player_sots`
--

CREATE TABLE IF NOT EXISTS `player_sots` (
  `player_id` int(10) unsigned NOT NULL,
  `name` varchar(250) NOT NULL,
  PRIMARY KEY (`player_id`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `players`
--

CREATE TABLE IF NOT EXISTS `players` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `acc_id` int(11) unsigned NOT NULL,
  `world_id` int(11) unsigned NOT NULL,
  `enable_monitor` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `enable_notify` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `check_interval` tinyint(2) unsigned NOT NULL COMMENT 'Максимальный интервал между проверками соты игрока',
  `notify_hours` tinyint(2) unsigned NOT NULL COMMENT 'Интервал времени оповещения до прилёта армии',
  PRIMARY KEY (`id`),
  UNIQUE KEY `acc_id_2` (`acc_id`,`world_id`),
  KEY `acc_id` (`acc_id`),
  KEY `world_id` (`world_id`),
  KEY `enabled` (`enable_notify`),
  KEY `enable_monitor` (`enable_monitor`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=12 ;

-- --------------------------------------------------------

--
-- Table structure for table `proxy_list`
--

CREATE TABLE IF NOT EXISTS `proxy_list` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user` varchar(250) NOT NULL,
  `pass` varchar(250) NOT NULL,
  `proxy` varchar(250) NOT NULL,
  `network_id` int(10) unsigned NOT NULL,
  `date_update` date NOT NULL,
  `rank` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `proxy` (`proxy`),
  KEY `network` (`network_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1197 ;

-- --------------------------------------------------------

--
-- Table structure for table `proxy_networks`
--

CREATE TABLE IF NOT EXISTS `proxy_networks` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `network` varchar(150) NOT NULL,
  `date_last_used` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `network` (`network`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=64 ;

-- --------------------------------------------------------

--
-- Table structure for table `start_urls`
--

CREATE TABLE IF NOT EXISTS `start_urls` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `url` varchar(250) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=5 ;

-- --------------------------------------------------------

--
-- Table structure for table `worlds`
--

CREATE TABLE IF NOT EXISTS `worlds` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `pattern` varchar(250) NOT NULL,
  `name` varchar(100) NOT NULL COMMENT 'имя для смс оповещения',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=13 ;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `account`
--
ALTER TABLE `account`
  ADD CONSTRAINT `account_ibfk_2` FOREIGN KEY (`agent_id`) REFERENCES `agents` (`id`),
  ADD CONSTRAINT `account_ibfk_3` FOREIGN KEY (`url_id`) REFERENCES `start_urls` (`id`),
  ADD CONSTRAINT `account_ibfk_4` FOREIGN KEY (`network_id`) REFERENCES `proxy_networks` (`id`);

--
-- Constraints for table `attacks`
--
ALTER TABLE `attacks`
  ADD CONSTRAINT `attacks_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `balance_history`
--
ALTER TABLE `balance_history`
  ADD CONSTRAINT `balance_history_ibfk_1` FOREIGN KEY (`acc_id`) REFERENCES `account` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `check_tasks`
--
ALTER TABLE `check_tasks`
  ADD CONSTRAINT `check_tasks_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `messages`
--
ALTER TABLE `messages`
  ADD CONSTRAINT `messages_ibfk_1` FOREIGN KEY (`acc_id`) REFERENCES `account` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `player_sots`
--
ALTER TABLE `player_sots`
  ADD CONSTRAINT `player_sots_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `players`
--
ALTER TABLE `players`
  ADD CONSTRAINT `players_ibfk_3` FOREIGN KEY (`acc_id`) REFERENCES `account` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `players_ibfk_4` FOREIGN KEY (`world_id`) REFERENCES `worlds` (`id`);

--
-- Constraints for table `proxy_list`
--
ALTER TABLE `proxy_list`
  ADD CONSTRAINT `proxy_list_ibfk_1` FOREIGN KEY (`network_id`) REFERENCES `proxy_networks` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
