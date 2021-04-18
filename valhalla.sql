/*
Navicat MySQL Data Transfer

Source Server         : Database
Source Server Version : 50717
Source Host           : localhost:3306
Source Database       : data

Target Server Type    : MYSQL
Target Server Version : 50717
File Encoding         : 65001

Date: 2021-04-18 20:52:57
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for `accounts`
-- ----------------------------
DROP TABLE IF EXISTS `accounts`;
CREATE TABLE `accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` text,
  `password` varchar(32) NOT NULL,
  `salt` varchar(30) NOT NULL DEFAULT '1234567890',
  `email` varchar(100) NOT NULL,
  `registerdate` text,
  `lastlogin` datetime DEFAULT NULL,
  `ip` text,
  `admin` float NOT NULL DEFAULT '0',
  `supporter` float NOT NULL DEFAULT '0',
  `vct` float NOT NULL DEFAULT '0',
  `mapper` float NOT NULL DEFAULT '0',
  `scripter` float NOT NULL DEFAULT '0',
  `warn_style` int(1) NOT NULL DEFAULT '1',
  `hiddenadmin` tinyint(3) unsigned DEFAULT '0',
  `adminjail` tinyint(3) unsigned DEFAULT '0',
  `adminjail_time` int(11) DEFAULT NULL,
  `adminjail_by` text,
  `adminjail_reason` text,
  `muted` tinyint(3) unsigned DEFAULT '0',
  `globalooc` tinyint(3) unsigned DEFAULT '1',
  `friendsmessage` varchar(255) NOT NULL DEFAULT 'Hi!',
  `adminjail_permanent` tinyint(3) unsigned DEFAULT '0',
  `adminreports` int(11) DEFAULT '0',
  `warns` tinyint(3) unsigned DEFAULT '0',
  `chatbubbles` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `adminnote` text,
  `appstate` tinyint(1) DEFAULT '3',
  `appdatetime` datetime DEFAULT NULL,
  `appreason` longtext,
  `help` int(1) NOT NULL DEFAULT '1',
  `adblocked` int(1) NOT NULL DEFAULT '0',
  `newsblocked` int(1) DEFAULT '0',
  `mtaserial` text,
  `d_addiction` text,
  `loginhash` varchar(64) DEFAULT NULL,
  `credits` int(11) NOT NULL DEFAULT '0',
  `transfers` int(11) DEFAULT '0',
  `monitored` varchar(255) NOT NULL DEFAULT '',
  `autopark` int(1) NOT NULL DEFAULT '1',
  `forceUpdate` smallint(1) NOT NULL DEFAULT '0',
  `anotes` text,
  `oldAdminRank` int(11) DEFAULT '0',
  `suspensionTime` bigint(20) DEFAULT NULL,
  `car_license` int(1) NOT NULL DEFAULT '0',
  `adminreports_saved` int(3) DEFAULT '0',
  `cpa_earned` double DEFAULT '0',
  `electionsvoted` int(11) NOT NULL DEFAULT '0',
  `referrer` int(11) DEFAULT '0',
  `activated` tinyint(1) NOT NULL DEFAULT '1',
  `serial_whitelist_cap` int(2) NOT NULL DEFAULT '2',
  `tc_backend` tinyint(1) NOT NULL DEFAULT '0',
  `youtuber` varchar(1) DEFAULT NULL,
  `log_id` int(11) DEFAULT NULL,
  `bakiyeMiktar` int(11) DEFAULT '0',
  `bakiyeMiktari` int(11) DEFAULT '0',
  `BorcbakiyeMiktari` int(11) DEFAULT NULL,
  `custom_animations` text,
  `online` int(3) DEFAULT NULL,
  `charlimit` int(255) NOT NULL DEFAULT '1',
  `rdstats` int(11) NOT NULL DEFAULT '0',
  `bakiye` int(11) DEFAULT '0',
  `uyk` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=17936 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of accounts
-- ----------------------------
INSERT INTO `accounts` VALUES ('17926', 'bekiroj', 'ec99e52e65270fc55fa5c0cbcde4fc6a', '2222888860', '@', '2021-04-06 03:49:33', null, '88.246.78.97', '8', '0', '2', '0', '0', '1', '0', '0', '0', 'Abdulrezzak Rahi', 'GÃœVENLÄ° BÃ–LGE Ä°HLALÄ°', '0', '1', 'Hi!', '0', '1', '0', '1', null, '3', null, null, '1', '0', '0', 'FE75EE2BF33AF3C57E75CC4F163C0134', null, null, '0', '0', '', '1', '0', null, '0', null, '0', '0', '0', '0', '0', '5', '2', '0', null, null, '0', '0', null, '[ { \"fortnite_2\": true, \"custom_2\": true, \"watchdogs\": true, \"custom_9\": true } ]', '0', '1', '0', '2690', '1');

-- ----------------------------
-- Table structure for `account_settings`
-- ----------------------------
DROP TABLE IF EXISTS `account_settings`;
CREATE TABLE `account_settings` (
  `id` int(11) DEFAULT NULL,
  `name` varchar(45) DEFAULT NULL,
  `value` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of account_settings
-- ----------------------------

-- ----------------------------
-- Table structure for `adminhistory`
-- ----------------------------
DROP TABLE IF EXISTS `adminhistory`;
CREATE TABLE `adminhistory` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `user` int(10) NOT NULL,
  `user_char` int(11) NOT NULL DEFAULT '0',
  `admin` int(10) NOT NULL DEFAULT '0',
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `action` tinyint(3) NOT NULL DEFAULT '6',
  `duration` int(10) NOT NULL DEFAULT '0',
  `reason` text NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of adminhistory
-- ----------------------------

-- ----------------------------
-- Table structure for `advertisements`
-- ----------------------------
DROP TABLE IF EXISTS `advertisements`;
CREATE TABLE `advertisements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `phone` varchar(10) NOT NULL,
  `name` varchar(50) NOT NULL,
  `address` varchar(100) NOT NULL,
  `advertisement` text NOT NULL,
  `start` int(11) NOT NULL,
  `expiry` int(11) NOT NULL,
  `created_by` int(11) NOT NULL,
  `section` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of advertisements
-- ----------------------------

-- ----------------------------
-- Table structure for `applications`
-- ----------------------------
DROP TABLE IF EXISTS `applications`;
CREATE TABLE `applications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `applicant` int(11) NOT NULL DEFAULT '0',
  `dateposted` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `datereviewed` datetime DEFAULT NULL,
  `reviewer` int(11) NOT NULL DEFAULT '0',
  `note` text,
  `state` tinyint(1) NOT NULL DEFAULT '0',
  `question1` text,
  `question2` text,
  `question3` text,
  `question4` text,
  `answer1` text,
  `answer2` text,
  `answer3` text,
  `answer4` text,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of applications
-- ----------------------------

-- ----------------------------
-- Table structure for `applications_questions`
-- ----------------------------
DROP TABLE IF EXISTS `applications_questions`;
CREATE TABLE `applications_questions` (
  `id` int(4) NOT NULL AUTO_INCREMENT,
  `question` text,
  `answer1` text,
  `answer2` text,
  `answer3` text,
  `key` tinyint(1) NOT NULL DEFAULT '1',
  `createdBy` int(8) NOT NULL DEFAULT '0',
  `updatedBy` int(8) NOT NULL DEFAULT '0',
  `createDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updateDate` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `part` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Records of applications_questions
-- ----------------------------

-- ----------------------------
-- Table structure for `atms`
-- ----------------------------
DROP TABLE IF EXISTS `atms`;
CREATE TABLE `atms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `x` decimal(10,6) DEFAULT '0.000000',
  `y` decimal(10,6) DEFAULT '0.000000',
  `z` decimal(10,6) DEFAULT '0.000000',
  `rotation` decimal(10,6) DEFAULT '0.000000',
  `dimension` int(5) DEFAULT '0',
  `interior` int(5) DEFAULT '0',
  `deposit` tinyint(3) unsigned DEFAULT '0',
  `limit` int(10) unsigned DEFAULT '5000',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of atms
-- ----------------------------

-- ----------------------------
-- Table structure for `atm_cards`
-- ----------------------------
DROP TABLE IF EXISTS `atm_cards`;
CREATE TABLE `atm_cards` (
  `card_id` int(11) NOT NULL AUTO_INCREMENT,
  `card_owner` int(11) DEFAULT NULL,
  `card_number` text,
  `card_pin` varchar(4) NOT NULL DEFAULT '0000',
  `card_locked` tinyint(1) NOT NULL DEFAULT '0',
  `card_type` tinyint(1) NOT NULL DEFAULT '1',
  `limit_type` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`card_id`) USING BTREE,
  UNIQUE KEY `card_id_UNIQUE` (`card_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of atm_cards
-- ----------------------------

-- ----------------------------
-- Table structure for `bans`
-- ----------------------------
DROP TABLE IF EXISTS `bans`;
CREATE TABLE `bans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `serial` varchar(32) DEFAULT NULL,
  `ip` varchar(15) DEFAULT NULL,
  `account` int(11) DEFAULT NULL,
  `admin` int(11) DEFAULT NULL,
  `reason` text NOT NULL,
  `date` text,
  `threadid` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC COMMENT='Handle serial bans instead of using MTA built-in / Maxime';

-- ----------------------------
-- Records of bans
-- ----------------------------

-- ----------------------------
-- Table structure for `billiard`
-- ----------------------------
DROP TABLE IF EXISTS `billiard`;
CREATE TABLE `billiard` (
  `tableId` int(255) NOT NULL DEFAULT '0',
  `posX` float NOT NULL DEFAULT '0',
  `posY` float NOT NULL DEFAULT '0',
  `posZ` float NOT NULL DEFAULT '0',
  `rotZ` float NOT NULL DEFAULT '0',
  `interior` int(255) NOT NULL DEFAULT '0',
  `dimension` int(255) NOT NULL DEFAULT '0',
  PRIMARY KEY (`tableId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of billiard
-- ----------------------------

-- ----------------------------
-- Table structure for `books`
-- ----------------------------
DROP TABLE IF EXISTS `books`;
CREATE TABLE `books` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` text,
  `author` text,
  `book` longtext,
  `readOnly` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `id_UNIQUE` (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC COMMENT='This is used for the book system. // Chaos';

-- ----------------------------
-- Records of books
-- ----------------------------

-- ----------------------------
-- Table structure for `businesses`
-- ----------------------------
DROP TABLE IF EXISTS `businesses`;
CREATE TABLE `businesses` (
  `id` int(11) NOT NULL,
  `title` varchar(200) NOT NULL,
  `bank_card` varchar(100) NOT NULL DEFAULT '0000 0000 0000 0000',
  `created_by` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of businesses
-- ----------------------------

-- ----------------------------
-- Table structure for `business_accounts`
-- ----------------------------
DROP TABLE IF EXISTS `business_accounts`;
CREATE TABLE `business_accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `recipient` varchar(250) NOT NULL,
  `recipient_type` int(11) NOT NULL,
  `amount` int(11) NOT NULL,
  `description` varchar(250) NOT NULL,
  `business` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of business_accounts
-- ----------------------------

-- ----------------------------
-- Table structure for `business_members`
-- ----------------------------
DROP TABLE IF EXISTS `business_members`;
CREATE TABLE `business_members` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `character` int(11) NOT NULL,
  `business` int(11) NOT NULL,
  `rank` varchar(200) NOT NULL,
  `wage` int(11) NOT NULL,
  `leader` int(11) NOT NULL,
  `phone` varchar(30) NOT NULL DEFAULT '0',
  `address` varchar(200) NOT NULL DEFAULT 'None',
  `date_hired` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of business_members
-- ----------------------------

-- ----------------------------
-- Table structure for `business_rentals`
-- ----------------------------
DROP TABLE IF EXISTS `business_rentals`;
CREATE TABLE `business_rentals` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `business` int(11) NOT NULL,
  `rental_id` int(11) NOT NULL,
  `rental_type` int(11) NOT NULL,
  `rental_price` int(11) NOT NULL,
  `rented_to` int(11) NOT NULL,
  `rented_time` int(11) NOT NULL,
  `rented_phone` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of business_rentals
-- ----------------------------

-- ----------------------------
-- Table structure for `cabinets`
-- ----------------------------
DROP TABLE IF EXISTS `cabinets`;
CREATE TABLE `cabinets` (
  `id` int(255) NOT NULL,
  `item` int(255) NOT NULL,
  `value` varchar(255) NOT NULL DEFAULT '0',
  `text` varchar(255) NOT NULL,
  `weapon` int(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of cabinets
-- ----------------------------

-- ----------------------------
-- Table structure for `characters`
-- ----------------------------
DROP TABLE IF EXISTS `characters`;
CREATE TABLE `characters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `charactername` text,
  `account` int(11) DEFAULT '0',
  `x` float DEFAULT '1770',
  `y` float DEFAULT '-1860',
  `z` float DEFAULT '13',
  `rotation` float DEFAULT '359',
  `interior_id` int(5) DEFAULT '0',
  `dimension_id` int(5) DEFAULT '0',
  `health` float DEFAULT '100',
  `armor` float DEFAULT '0',
  `skin` int(3) DEFAULT '264',
  `money` bigint(20) DEFAULT '750',
  `gender` int(1) DEFAULT '0',
  `cuffed` int(11) DEFAULT '0',
  `duty` int(3) DEFAULT '0',
  `fightstyle` int(2) DEFAULT '4',
  `pdjail` int(1) DEFAULT '0',
  `pdjail_time` int(11) DEFAULT '0',
  `cked` int(1) DEFAULT '0',
  `lastarea` text,
  `age` int(3) DEFAULT '18',
  `faction_id` int(11) DEFAULT '-1',
  `faction_rank` int(2) DEFAULT '1',
  `faction_perks` text,
  `faction_phone` int(3) unsigned DEFAULT NULL,
  `skincolor` int(1) DEFAULT '0',
  `weight` int(3) DEFAULT '180',
  `height` int(3) DEFAULT '180',
  `description` text,
  `deaths` int(11) DEFAULT '0',
  `faction_leader` int(1) DEFAULT '0',
  `fingerprint` text,
  `casualskin` int(3) DEFAULT '0',
  `bankmoney` bigint(20) DEFAULT '1000',
  `car_license` int(1) DEFAULT '0',
  `bike_license` int(1) DEFAULT '0',
  `pilot_license` int(1) DEFAULT '0',
  `fish_license` int(1) DEFAULT '1',
  `boat_license` int(1) DEFAULT '0',
  `gun_license` int(1) DEFAULT '0',
  `gun2_license` int(1) DEFAULT '0',
  `tag` int(3) DEFAULT '1',
  `hoursplayed` int(11) DEFAULT '0',
  `pdjail_station` int(1) DEFAULT '0',
  `timeinserver` int(2) DEFAULT '0',
  `restrainedobj` int(11) DEFAULT '0',
  `restrainedby` int(11) DEFAULT '0',
  `dutyskin` int(3) DEFAULT '-1',
  `fish` int(10) unsigned NOT NULL DEFAULT '0',
  `blindfold` tinyint(4) NOT NULL DEFAULT '0',
  `lang1` tinyint(2) DEFAULT '1',
  `lang1skill` tinyint(3) DEFAULT '100',
  `lang2` tinyint(2) DEFAULT '0',
  `lang2skill` tinyint(3) DEFAULT '0',
  `lang3` tinyint(2) DEFAULT '0',
  `lang3skill` tinyint(3) DEFAULT '0',
  `currlang` tinyint(1) DEFAULT '1',
  `lastlogin` datetime DEFAULT NULL,
  `creationdate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `election_candidate` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `election_canvote` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `election_votedfor` int(10) unsigned NOT NULL DEFAULT '0',
  `marriedto` int(10) unsigned NOT NULL DEFAULT '0',
  `photos` int(10) unsigned NOT NULL DEFAULT '0',
  `maxvehicles` int(4) unsigned NOT NULL DEFAULT '2',
  `ck_info` text,
  `alcohollevel` float NOT NULL DEFAULT '0',
  `active` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `recovery` int(1) DEFAULT '0',
  `recoverytime` bigint(20) DEFAULT NULL,
  `walkingstyle` int(3) NOT NULL DEFAULT '0',
  `job` int(3) NOT NULL DEFAULT '0',
  `day` tinyint(2) NOT NULL DEFAULT '1',
  `month` tinyint(2) NOT NULL DEFAULT '1',
  `maxinteriors` int(4) NOT NULL DEFAULT '5',
  `clothingid` int(10) unsigned DEFAULT NULL,
  `death_date` datetime DEFAULT NULL,
  `thirst` varchar(255) DEFAULT '100',
  `hunger` varchar(255) DEFAULT '100',
  `level` varchar(255) DEFAULT '1',
  `hoursaim` varchar(255) DEFAULT '20',
  `isDead` int(255) DEFAULT NULL,
  `customanim` text,
  `minutesPlayed` int(12) DEFAULT '0',
  `nation` varchar(255) DEFAULT '1',
  `online` varchar(255) DEFAULT '0',
  `country` int(255) DEFAULT '1',
  `roldersi` int(3) NOT NULL DEFAULT '0',
  `etiket` int(3) DEFAULT '0',
  `youtuber` int(3) DEFAULT '0',
  `boxexp` int(255) DEFAULT '0',
  `box` int(255) DEFAULT '0',
  `kelepce` int(11) DEFAULT '0',
  `tamirci` int(11) DEFAULT '0',
  `bakiye` int(11) NOT NULL DEFAULT '0',
  `hapis_sure` int(11) NOT NULL DEFAULT '0',
  `hapis_sebep` text,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=22281 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of characters
-- ----------------------------
INSERT INTO `characters` VALUES ('1', 'bekiroj', '17926', '694.172', '-599.041', '15.9613', '79.7802', '0', '0', '100', '0', '10', '150', '0', '0', '0', '4', '0', '0', '0', 'Dillimore, Red County', '18', '-1', '1', null, null, '0', '180', '180', null, '0', '0', null, '0', '800', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0', '19', '0', '0', '-1', '0', '0', '1', '100', '0', '0', '0', '0', '1', '2021-04-18 20:25:56', '2021-04-15 21:06:48', '0', '0', '0', '0', '0', '2', null, '0', '1', '0', null, '0', '0', '1', '1', '5', null, null, '96', '96', '1', '20', null, 'custom_6', '39', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', null);

-- ----------------------------
-- Table structure for `character_settings`
-- ----------------------------
DROP TABLE IF EXISTS `character_settings`;
CREATE TABLE `character_settings` (
  `id` int(11) DEFAULT NULL,
  `name` varchar(45) DEFAULT NULL,
  `value` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of character_settings
-- ----------------------------

-- ----------------------------
-- Table structure for `clothing`
-- ----------------------------
DROP TABLE IF EXISTS `clothing`;
CREATE TABLE `clothing` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `skin` int(11) unsigned NOT NULL,
  `url` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `price` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of clothing
-- ----------------------------
INSERT INTO `clothing` VALUES ('2', '240', 'https://i.ibb.co/2vqK0b4/swMYRI.png', 'barn', '31');
INSERT INTO `clothing` VALUES ('6', '141', 'https://i.ibb.co/686Kw1p/resim-2021-04-13-043346.png', 'helyum private', '111');
INSERT INTO `clothing` VALUES ('7', '280', 'https://cdn.discordapp.com/attachments/686639425916239891/831343407204794368/lapds.png', 'Priv IEM', '1');
INSERT INTO `clothing` VALUES ('10', '240', 'https://i.ibb.co/R0kHNmH/sw-MYRIssss.png', 'baran', '1');

-- ----------------------------
-- Table structure for `commands`
-- ----------------------------
DROP TABLE IF EXISTS `commands`;
CREATE TABLE `commands` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `command` text,
  `hotkey` text,
  `explanation` text,
  `permission` int(3) NOT NULL DEFAULT '0',
  `category` int(2) NOT NULL DEFAULT '1',
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='Saves all info about all kinds of supported commands and con';

-- ----------------------------
-- Records of commands
-- ----------------------------

-- ----------------------------
-- Table structure for `commands_library`
-- ----------------------------
DROP TABLE IF EXISTS `commands_library`;
CREATE TABLE `commands_library` (
  `cmID` int(11) NOT NULL AUTO_INCREMENT,
  `cmType` int(3) NOT NULL DEFAULT '1',
  `cmLevel` int(3) NOT NULL DEFAULT '0',
  `cmSubType` int(3) NOT NULL DEFAULT '0',
  `cmName` text,
  `cmExplanation` text,
  `cmCreationDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`cmID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='Saves all info about all kinds of commands in /cmds, /gh and';

-- ----------------------------
-- Records of commands_library
-- ----------------------------

-- ----------------------------
-- Table structure for `computers`
-- ----------------------------
DROP TABLE IF EXISTS `computers`;
CREATE TABLE `computers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `posX` float(10,5) NOT NULL,
  `posY` float(10,5) NOT NULL,
  `posZ` float(10,5) NOT NULL,
  `rotX` float(10,5) NOT NULL,
  `rotY` float(10,5) NOT NULL,
  `rotZ` float(10,5) NOT NULL,
  `interior` int(8) NOT NULL,
  `dimension` int(8) NOT NULL,
  `model` int(8) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of computers
-- ----------------------------

-- ----------------------------
-- Table structure for `cpa_postbacks`
-- ----------------------------
DROP TABLE IF EXISTS `cpa_postbacks`;
CREATE TABLE `cpa_postbacks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tracking_id` int(11) NOT NULL,
  `payout` double DEFAULT '0',
  `message` text,
  `offer_id` int(11) DEFAULT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `id_UNIQUE` (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of cpa_postbacks
-- ----------------------------

-- ----------------------------
-- Table structure for `dancers`
-- ----------------------------
DROP TABLE IF EXISTS `dancers`;
CREATE TABLE `dancers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `rotation` float NOT NULL,
  `skin` smallint(5) unsigned NOT NULL,
  `type` tinyint(3) unsigned NOT NULL,
  `interior` int(10) unsigned NOT NULL,
  `dimension` int(10) unsigned NOT NULL,
  `offset` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of dancers
-- ----------------------------

-- ----------------------------
-- Table structure for `donates`
-- ----------------------------
DROP TABLE IF EXISTS `donates`;
CREATE TABLE `donates` (
  `order_id` int(11) NOT NULL AUTO_INCREMENT,
  `txn_id` varchar(19) NOT NULL,
  `payer_email` varchar(75) NOT NULL,
  `mc_gross` float(9,2) NOT NULL,
  `donor` int(11) DEFAULT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `donated_for` int(11) DEFAULT NULL,
  PRIMARY KEY (`order_id`) USING BTREE,
  UNIQUE KEY `txn_id` (`txn_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of donates
-- ----------------------------

-- ----------------------------
-- Table structure for `donators`
-- ----------------------------
DROP TABLE IF EXISTS `donators`;
CREATE TABLE `donators` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `accountID` int(11) NOT NULL,
  `charID` int(11) NOT NULL DEFAULT '-1',
  `perkID` int(4) NOT NULL,
  `perkValue` varchar(10) NOT NULL DEFAULT '1',
  `expirationDate` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of donators
-- ----------------------------

-- ----------------------------
-- Table structure for `don_purchases`
-- ----------------------------
DROP TABLE IF EXISTS `don_purchases`;
CREATE TABLE `don_purchases` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` text,
  `cost` int(11) DEFAULT '0',
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `account` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of don_purchases
-- ----------------------------

-- ----------------------------
-- Table structure for `don_transaction_failed`
-- ----------------------------
DROP TABLE IF EXISTS `don_transaction_failed`;
CREATE TABLE `don_transaction_failed` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `output` text NOT NULL,
  `ip` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of don_transaction_failed
-- ----------------------------

-- ----------------------------
-- Table structure for `drugs`
-- ----------------------------
DROP TABLE IF EXISTS `drugs`;
CREATE TABLE `drugs` (
  `id` int(11) DEFAULT NULL,
  `owner` int(11) DEFAULT NULL,
  `x` float DEFAULT NULL,
  `y` float DEFAULT NULL,
  `z` float DEFAULT NULL,
  `interior` float DEFAULT NULL,
  `dimension` float DEFAULT NULL,
  `state` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of drugs
-- ----------------------------

-- ----------------------------
-- Table structure for `duty_allowed`
-- ----------------------------
DROP TABLE IF EXISTS `duty_allowed`;
CREATE TABLE `duty_allowed` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `faction` int(11) NOT NULL,
  `itemID` int(11) NOT NULL,
  `itemValue` varchar(45) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `id_UNIQUE` (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=174 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT COMMENT='Used for an admin allow list.';

-- ----------------------------
-- Records of duty_allowed
-- ----------------------------
INSERT INTO `duty_allowed` VALUES ('1', '1', '45', '1');
INSERT INTO `duty_allowed` VALUES ('20', '1', '-34', '10');
INSERT INTO `duty_allowed` VALUES ('23', '1', '-25', '50');
INSERT INTO `duty_allowed` VALUES ('25', '1', '-43', '50');
INSERT INTO `duty_allowed` VALUES ('26', '7', '-44', '1');
INSERT INTO `duty_allowed` VALUES ('27', '7', '-45', '1');
INSERT INTO `duty_allowed` VALUES ('28', '1', '-46', '1');
INSERT INTO `duty_allowed` VALUES ('30', '1', '-3', '1');
INSERT INTO `duty_allowed` VALUES ('31', '1', '126', '1');
INSERT INTO `duty_allowed` VALUES ('33', '1', '137', '1');
INSERT INTO `duty_allowed` VALUES ('34', '1', '13', '');
INSERT INTO `duty_allowed` VALUES ('35', '1', '83', '');
INSERT INTO `duty_allowed` VALUES ('36', '1', '29', '');
INSERT INTO `duty_allowed` VALUES ('38', '1', '-4', '1');
INSERT INTO `duty_allowed` VALUES ('68', '7', '27', '4');
INSERT INTO `duty_allowed` VALUES ('69', '1', '-100', '100');
INSERT INTO `duty_allowed` VALUES ('74', '7', '120', '');
INSERT INTO `duty_allowed` VALUES ('135', '2', '70', '1');
INSERT INTO `duty_allowed` VALUES ('136', '2', '164', '1');
INSERT INTO `duty_allowed` VALUES ('137', '2', '9', '1');
INSERT INTO `duty_allowed` VALUES ('138', '2', '13', '1');
INSERT INTO `duty_allowed` VALUES ('139', '2', '-3', '1');
INSERT INTO `duty_allowed` VALUES ('140', '1', '346', '1');
INSERT INTO `duty_allowed` VALUES ('141', '7', '-24', '35');
INSERT INTO `duty_allowed` VALUES ('142', '7', '-30', '250');
INSERT INTO `duty_allowed` VALUES ('143', '7', '-31', '250');
INSERT INTO `duty_allowed` VALUES ('144', '7', '-29', '150');
INSERT INTO `duty_allowed` VALUES ('145', '7', '-33', '60');
INSERT INTO `duty_allowed` VALUES ('146', '7', '-34', '40');
INSERT INTO `duty_allowed` VALUES ('147', '7', '1', '1');
INSERT INTO `duty_allowed` VALUES ('148', '7', '45', '1');
INSERT INTO `duty_allowed` VALUES ('149', '7', '26', '1');
INSERT INTO `duty_allowed` VALUES ('150', '7', '126', '1');
INSERT INTO `duty_allowed` VALUES ('151', '7', '137', '1');
INSERT INTO `duty_allowed` VALUES ('152', '7', '83', '1');
INSERT INTO `duty_allowed` VALUES ('153', '7', '13', '1');
INSERT INTO `duty_allowed` VALUES ('154', '7', '346', '1');
INSERT INTO `duty_allowed` VALUES ('155', '7', '29', '1');
INSERT INTO `duty_allowed` VALUES ('156', '7', '70', '1');
INSERT INTO `duty_allowed` VALUES ('157', '7', '-27', '85');
INSERT INTO `duty_allowed` VALUES ('158', '7', '-16', '2');
INSERT INTO `duty_allowed` VALUES ('159', '7', '-17', '2');
INSERT INTO `duty_allowed` VALUES ('160', '7', '-100', '100');
INSERT INTO `duty_allowed` VALUES ('161', '1', '-34', '40');
INSERT INTO `duty_allowed` VALUES ('162', '1', '-24', '100');
INSERT INTO `duty_allowed` VALUES ('163', '1', '26', '');
INSERT INTO `duty_allowed` VALUES ('164', '1', '-17', '5');
INSERT INTO `duty_allowed` VALUES ('165', '1', '-31', '250');
INSERT INTO `duty_allowed` VALUES ('166', '1', '-31', '200');
INSERT INTO `duty_allowed` VALUES ('167', '1', '-31', '50');
INSERT INTO `duty_allowed` VALUES ('168', '1', '76', '1');
INSERT INTO `duty_allowed` VALUES ('169', '2', '6', '1');
INSERT INTO `duty_allowed` VALUES ('170', '1', '299', '1');
INSERT INTO `duty_allowed` VALUES ('171', '1', '299', '20');
INSERT INTO `duty_allowed` VALUES ('172', '1', '-29', '150');
INSERT INTO `duty_allowed` VALUES ('173', '1', '-30', '250');

-- ----------------------------
-- Table structure for `duty_custom`
-- ----------------------------
DROP TABLE IF EXISTS `duty_custom`;
CREATE TABLE `duty_custom` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `factionid` int(11) NOT NULL,
  `name` text NOT NULL,
  `skins` text NOT NULL,
  `locations` text NOT NULL,
  `items` text NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `id_UNIQUE` (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT COMMENT='Used for custom duties.';

-- ----------------------------
-- Records of duty_custom
-- ----------------------------
INSERT INTO `duty_custom` VALUES ('3', '1', 'Sergeant I-II', '[ [ [ 78, \"N/A\" ], [ 83, \"N/A\" ], [ 84, \"N/A\" ] ] ]', '[ { \"192\": \"VEHICLE\", \"193\": \"Duty Oda\", \"204\": \"Dolap\" } ]', '[ { \"1\": [ \"1\", 45, \"1\" ], \"170\": [ \"170\", 299, \"1\" ], \"34\": [ \"34\", 13, \"\" ], \"35\": [ \"35\", 83, \"\" ], \"165\": [ \"165\", -31, 250, \"250\" ], \"23\": [ \"23\", -25, 35, \"50\" ], \"31\": [ 31, 126, \"1\" ], \"30\": [ \"30\", -3, 1, \"1\" ], \"162\": [ 162, -24, 100, \"100\" ], \"69\": [ \"69\", -100, 100, \"100\" ] } ]');
INSERT INTO `duty_custom` VALUES ('4', '1', 'Komiser YardÄ±mcÄ±sÄ±', '[ [ [ 88, \"N/A\" ], [ 96, \"N/A\" ] ] ]', '[ { \"204\": \"Dolap\", \"193\": \"Duty Oda\" } ]', '[ { \"1\": [ \"1\", 45, \"1\" ], \"172\": [ 172, -29, 150, \"150\" ], \"34\": [ \"34\", 13, \"\" ], \"35\": [ \"35\", 83, \"\" ], \"25\": [ \"25\", -43, 50, \"50\" ], \"165\": [ \"165\", -31, 250, \"250\" ], \"31\": [ \"31\", 126, \"1\" ], \"30\": [ \"30\", -3, 1, \"1\" ], \"162\": [ \"162\", -24, 70, \"100\" ], \"23\": [ \"23\", -25, 25, \"50\" ] } ]');
INSERT INTO `duty_custom` VALUES ('5', '1', 'PÃ–H', '[ [ [ 87, \"N/A\" ], [ 98, \"N/A\" ], [ 100, \"N/A\" ] ] ]', '[ { \"204\": \"Dolap\", \"193\": \"Duty Oda\" } ]', '[ { \"1\": [ 1, 45, \"1\" ], \"36\": [ \"36\", 29, \"\" ], \"23\": [ \"23\", -25, 35, \"50\" ], \"165\": [ \"165\", -31, 200, \"250\" ], \"30\": [ \"30\", -3, 1, \"1\" ], \"164\": [ 164, -17, 2, 5 ], \"163\": [ 163, 26, \"\" ], \"28\": [ \"28\", -46, 1, \"1\" ], \"162\": [ 162, -24, 70, 0 ], \"31\": [ \"31\", 126, \"1\" ], \"168\": [ 168, 76, \"1\" ], \"33\": [ \"33\", 137, \"1\" ], \"69\": [ \"69\", -100, 100, \"100\" ] } ]');
INSERT INTO `duty_custom` VALUES ('10', '1', 'PÃ–H YÃ¶netim', '[ [ [ 87, \"N/A\" ], [ 92, \"N/A\" ], [ 98, \"N/A\" ], [ 100, \"N/A\" ], [ 285, \"N/A\" ] ] ]', '[ { \"204\": \"Dolap\", \"193\": \"Duty Oda\", \"206\": \"D\", \"205\": \"D\" } ]', '[ { \"1\": [ 1, 45, \"1\" ], \"36\": [ 36, 29, \"\" ], \"162\": [ \"162\", -24, 35, \"100\" ], \"165\": [ 165, -31, 250, \"250\" ], \"30\": [ \"30\", -3, 1, \"1\" ], \"163\": [ 163, 26, \"\" ], \"164\": [ 164, -17, 2, \"5\" ], \"161\": [ 161, -34, 20, \"40\" ], \"31\": [ \"31\", 126, \"1\" ], \"168\": [ 168, 76, \"1\" ], \"33\": [ 33, 137, \"1\" ], \"69\": [ 69, -100, 100, \"100\" ] } ]');
INSERT INTO `duty_custom` VALUES ('11', '1', 'Polis Memuru', '[ [ [ 85, \"N/A\" ], [ 95, \"N/A\" ] ] ]', '[ { \"204\": \"Dolap\", \"193\": \"Duty Oda\" } ]', '[ { \"162\": [ \"162\", -24, 65, \"100\" ], \"25\": [ \"25\", -43, 50, \"50\" ], \"31\": [ \"31\", 126, \"1\" ], \"30\": [ \"30\", -3, 1, \"1\" ], \"1\": [ 1, 45, \"1\" ], \"23\": [ \"23\", -25, 50, \"50\" ] } ]');
INSERT INTO `duty_custom` VALUES ('13', '1', 'KÄ±demli Polis Memuru', '[ [ [ 75, \"N/A\" ], [ 79, \"N/A\" ] ] ]', '[ { \"204\": \"Dolap\", \"193\": \"Duty Oda\" } ]', '[ { \"1\": [ 1, 45, \"1\" ], \"172\": [ 172, -29, 150, \"150\" ], \"25\": [ \"25\", -43, 50, \"50\" ], \"31\": [ \"31\", 126, \"1\" ], \"30\": [ \"30\", -3, 1, \"1\" ], \"162\": [ \"162\", -24, 65, \"100\" ], \"23\": [ \"23\", -25, 50, \"50\" ] } ]');
INSERT INTO `duty_custom` VALUES ('16', '7', 'Saha Ajan (Sivil)', '[ [ ] ]', '[ [ ] ]', '[ { \"141\": [ 141, -24, 35, \"35\" ] } ]');
INSERT INTO `duty_custom` VALUES ('17', '7', 'Security Guard', '[ [ ] ]', '[ [ ] ]', '[ [ ] ]');
INSERT INTO `duty_custom` VALUES ('18', '1', 'BaÅŸ Polis Memuru', '[ [ [ 90, \"N/A\" ], [ 96, \"N/A\" ] ] ]', '[ { \"204\": \"Dolap\", \"193\": \"Duty Oda\" } ]', '[ { \"162\": [ \"162\", -24, 65, \"100\" ], \"172\": [ 172, -29, 125, \"150\" ], \"166\": [ \"166\", -31, 200, \"200\" ], \"34\": [ \"34\", 13, \"\" ], \"35\": [ \"35\", 83, \"\" ], \"25\": [ \"25\", -43, 50, 50 ], \"30\": [ \"30\", -3, 1, \"1\" ], \"31\": [ \"31\", 126, \"1\" ], \"168\": [ 168, 76, \"1\" ], \"1\": [ \"1\", 45, \"1\" ], \"23\": [ \"23\", -25, 50, \"50\" ] } ]');
INSERT INTO `duty_custom` VALUES ('20', '1', 'YÃ¶netim', '[ [ [ 61, \"N/A\" ], [ 77, \"N/A\" ], [ 96, \"N/A\" ], [ 240, \"N/A\" ] ] ]', '[ { \"204\": \"Dolap\" } ]', '[ { \"1\": [ \"1\", 45, \"1\" ], \"36\": [ \"36\", 29, \"\" ], \"69\": [ \"69\", -100, 100, \"100\" ], \"165\": [ \"165\", -31, 250, \"250\" ], \"30\": [ \"30\", -3, 1, \"1\" ], \"173\": [ 173, -30, 250, \"250\" ], \"163\": [ \"163\", 26, \"\" ], \"162\": [ 162, -24, 50, 1 ], \"161\": [ 161, -34, 20, \"40\" ], \"31\": [ \"31\", 126, \"1\" ], \"168\": [ 168, 76, \"1\" ], \"33\": [ \"33\", 137, \"1\" ], \"23\": [ 23, -25, 50, \"50\" ] } ]');
INSERT INTO `duty_custom` VALUES ('21', '1', 'CCW', '[ [ [ 4, \"N/A\" ] ] ]', '[ { \"204\": \"Dolap\" } ]', '[ { \"162\": [ \"162\", -24, 35, \"100\" ] } ]');
INSERT INTO `duty_custom` VALUES ('31', '2', 'Paramedik, EMT', '[ [ [ 69, \"N/A\" ], [ 70, \"N/A\" ] ] ]', '[ [ ] ]', '[ { \"137\": [ 137, 9, \"1\" ], \"136\": [ 136, 164, \"1\" ], \"139\": [ 139, -3, 1, \"1\" ], \"138\": [ 138, 13, \"1\" ], \"169\": [ 169, 6, \"1\" ], \"135\": [ 135, 70, \"1\" ] } ]');
INSERT INTO `duty_custom` VALUES ('32', '2', 'Doktor', '[ [ [ 71, \"N/A\" ], [ 72, \"N/A\" ] ] ]', '[ [ ] ]', '[ { \"137\": [ 137, 9, \"1\" ], \"136\": [ 136, 164, \"1\" ], \"135\": [ 135, 70, \"1\" ], \"138\": [ 138, 13, \"1\" ], \"169\": [ 169, 6, \"1\" ], \"139\": [ 139, -3, 1, \"1\" ] } ]');
INSERT INTO `duty_custom` VALUES ('33', '2', 'GÃ¼venlik', '[ [ [ 163, \"N/A\" ], [ 164, \"N/A\" ] ] ]', '[ [ ] ]', '[ { \"139\": [ \"139\", -3, 1, \"1\" ], \"169\": [ \"169\", 6, \"1\" ] } ]');
INSERT INTO `duty_custom` VALUES ('34', '1', 'Dedektif', '[ [ [ 45, \"N/A\" ], [ 25, \"N/A\" ], [ 299, \"N/A\" ], [ 58, \"N/A\" ], [ 51, \"N/A\" ], [ 67, \"N/A\" ], [ 12, \"N/A\" ], [ 13, \"N/A\" ], [ 63, \"N/A\" ], [ 11, \"N/A\" ], [ 10, \"N/A\" ], [ 9, \"N/A\" ], [ 31, \"N/A\" ], [ 39, \"N/A\" ], [ 40, \"N/A\" ], [ 41, \"N/A\" ] ] ]', '[ [ ] ]', '[ { \"162\": [ \"162\", -24, 100, \"100\" ], \"34\": [ \"34\", 13, \"\" ], \"35\": [ \"35\", 83, \"\" ], \"25\": [ \"25\", -43, 50, \"50\" ], \"165\": [ \"165\", -31, 250, \"250\" ], \"31\": [ \"31\", 126, \"1\" ], \"1\": [ \"1\", 45, \"1\" ], \"163\": [ \"163\", 26, \"\" ], \"69\": [ \"69\", -100, 100, \"100\" ] } ]');

-- ----------------------------
-- Table structure for `duty_locations`
-- ----------------------------
DROP TABLE IF EXISTS `duty_locations`;
CREATE TABLE `duty_locations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `factionid` int(11) NOT NULL,
  `name` text NOT NULL,
  `x` int(11) DEFAULT NULL,
  `y` int(11) DEFAULT NULL,
  `z` int(11) DEFAULT NULL,
  `radius` int(11) DEFAULT NULL,
  `dimension` int(11) DEFAULT '0',
  `interior` int(11) DEFAULT '0',
  `vehicleid` int(11) DEFAULT NULL,
  `model` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `id_UNIQUE` (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=460 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT COMMENT='Used for custom duty locations.';

-- ----------------------------
-- Records of duty_locations
-- ----------------------------
INSERT INTO `duty_locations` VALUES ('204', '1', 'Esya Odasi', '275', '1855', '96', '5', '23', '0', null, null);
INSERT INTO `duty_locations` VALUES ('347', '2', 'VEHICLE', null, null, null, null, '0', '0', '246', '426');
INSERT INTO `duty_locations` VALUES ('348', '2', 'VEHICLE', null, null, null, null, '0', '0', '246', '426');
INSERT INTO `duty_locations` VALUES ('349', '2', 'VEHICLE', null, null, null, null, '0', '0', '243', '586');
INSERT INTO `duty_locations` VALUES ('350', '2', 'VEHICLE', null, null, null, null, '0', '0', '246', '426');
INSERT INTO `duty_locations` VALUES ('351', '2', 'VEHICLE', null, null, null, null, '0', '0', '341', '416');
INSERT INTO `duty_locations` VALUES ('352', '2', 'VEHICLE', null, null, null, null, '0', '0', '246', '426');
INSERT INTO `duty_locations` VALUES ('358', '2', 'VEHICLE', null, null, null, null, '0', '0', '341', '416');
INSERT INTO `duty_locations` VALUES ('361', '2', 'VEHICLE', null, null, null, null, '0', '0', '246', '426');
INSERT INTO `duty_locations` VALUES ('365', '2', 'VEHICLE', null, null, null, null, '0', '0', '243', '586');
INSERT INTO `duty_locations` VALUES ('372', '2', 'VEHICLE', null, null, null, null, '0', '0', '246', '426');
INSERT INTO `duty_locations` VALUES ('373', '2', 'VEHICLE', null, null, null, null, '0', '0', '246', '426');
INSERT INTO `duty_locations` VALUES ('374', '2', 'VEHICLE', null, null, null, null, '0', '0', '341', '416');
INSERT INTO `duty_locations` VALUES ('377', '2', 'VEHICLE', null, null, null, null, '0', '0', '343', '416');
INSERT INTO `duty_locations` VALUES ('378', '2', 'VEHICLE', null, null, null, null, '0', '0', '245', '586');
INSERT INTO `duty_locations` VALUES ('379', '2', 'VEHICLE', null, null, null, null, '0', '0', '244', '586');
INSERT INTO `duty_locations` VALUES ('380', '2', 'VEHICLE', null, null, null, null, '0', '0', '243', '586');
INSERT INTO `duty_locations` VALUES ('396', '1', 'VEHICLE', null, null, null, null, '0', '0', '12', '490');
INSERT INTO `duty_locations` VALUES ('397', '1', 'VEHICLE', null, null, null, null, '0', '0', '13', '490');
INSERT INTO `duty_locations` VALUES ('398', '1', 'VEHICLE', null, null, null, null, '0', '0', '18', '490');
INSERT INTO `duty_locations` VALUES ('399', '1', 'VEHICLE', null, null, null, null, '0', '0', '22', '426');
INSERT INTO `duty_locations` VALUES ('400', '1', 'VEHICLE', null, null, null, null, '0', '0', '23', '426');
INSERT INTO `duty_locations` VALUES ('401', '1', 'VEHICLE', null, null, null, null, '0', '0', '29', '587');
INSERT INTO `duty_locations` VALUES ('402', '1', 'VEHICLE', null, null, null, null, '0', '0', '20', '541');
INSERT INTO `duty_locations` VALUES ('403', '1', 'VEHICLE', null, null, null, null, '0', '0', '439', '579');
INSERT INTO `duty_locations` VALUES ('405', '1', 'VEHICLE', null, null, null, null, '0', '0', '51', '427');
INSERT INTO `duty_locations` VALUES ('406', '1', 'VEHICLE', null, null, null, null, '0', '0', '50', '427');
INSERT INTO `duty_locations` VALUES ('407', '1', 'VEHICLE', null, null, null, null, '0', '0', '49', '427');
INSERT INTO `duty_locations` VALUES ('408', '1', 'VEHICLE', null, null, null, null, '0', '0', '46', '528');
INSERT INTO `duty_locations` VALUES ('409', '1', 'VEHICLE', null, null, null, null, '0', '0', '45', '528');
INSERT INTO `duty_locations` VALUES ('410', '1', 'VEHICLE', null, null, null, null, '0', '0', '47', '528');
INSERT INTO `duty_locations` VALUES ('411', '1', 'VEHICLE', null, null, null, null, '0', '0', '41', '490');
INSERT INTO `duty_locations` VALUES ('412', '1', 'VEHICLE', null, null, null, null, '0', '0', '39', '490');
INSERT INTO `duty_locations` VALUES ('413', '1', 'VEHICLE', null, null, null, null, '0', '0', '40', '490');
INSERT INTO `duty_locations` VALUES ('414', '1', 'VEHICLE', null, null, null, null, '0', '0', '6', '596');
INSERT INTO `duty_locations` VALUES ('415', '1', 'VEHICLE', null, null, null, null, '0', '0', '171', '598');
INSERT INTO `duty_locations` VALUES ('416', '1', 'VEHICLE', null, null, null, null, '0', '0', '15', '598');
INSERT INTO `duty_locations` VALUES ('417', '1', 'VEHICLE', null, null, null, null, '0', '0', '94', '497');
INSERT INTO `duty_locations` VALUES ('418', '1', 'VEHICLE', null, null, null, null, '0', '0', '42', '560');
INSERT INTO `duty_locations` VALUES ('422', '6', 'VEHICLE', null, null, null, null, '0', '0', '590', '598');
INSERT INTO `duty_locations` VALUES ('423', '6', 'VEHICLE', null, null, null, null, '0', '0', '590', '598');
INSERT INTO `duty_locations` VALUES ('426', '1', 'VEHICLE', null, null, null, null, '0', '0', '10', '596');
INSERT INTO `duty_locations` VALUES ('427', '1', 'VEHICLE', null, null, null, null, '0', '0', '9', '596');
INSERT INTO `duty_locations` VALUES ('433', '1', 'VEHICLE', null, null, null, null, '0', '0', '7', '596');
INSERT INTO `duty_locations` VALUES ('435', '1', 'VEHICLE', null, null, null, null, '0', '0', '8', '596');
INSERT INTO `duty_locations` VALUES ('437', '1', 'VEHICLE', null, null, null, null, '0', '0', '6', '596');
INSERT INTO `duty_locations` VALUES ('443', '1', 'VEHICLE', null, null, null, null, '0', '0', '1', '596');
INSERT INTO `duty_locations` VALUES ('444', '1', 'VEHICLE', null, null, null, null, '0', '0', '2', '596');
INSERT INTO `duty_locations` VALUES ('445', '1', 'VEHICLE', null, null, null, null, '0', '0', '3', '596');
INSERT INTO `duty_locations` VALUES ('446', '1', 'VEHICLE', null, null, null, null, '0', '0', '4', '596');
INSERT INTO `duty_locations` VALUES ('447', '1', 'VEHICLE', null, null, null, null, '0', '0', '5', '596');
INSERT INTO `duty_locations` VALUES ('448', '1', 'VEHICLE', null, null, null, null, '0', '0', '65', '426');
INSERT INTO `duty_locations` VALUES ('449', '1', 'VEHICLE', null, null, null, null, '0', '0', '66', '426');
INSERT INTO `duty_locations` VALUES ('450', '1', 'VEHICLE', null, null, null, null, '0', '0', '30', '528');
INSERT INTO `duty_locations` VALUES ('451', '1', 'VEHICLE', null, null, null, null, '0', '0', '31', '528');
INSERT INTO `duty_locations` VALUES ('452', '1', 'VEHICLE', null, null, null, null, '0', '0', '32', '528');
INSERT INTO `duty_locations` VALUES ('453', '1', 'VEHICLE', null, null, null, null, '0', '0', '33', '528');
INSERT INTO `duty_locations` VALUES ('454', '1', 'VEHICLE', null, null, null, null, '0', '0', '27', '601');
INSERT INTO `duty_locations` VALUES ('455', '1', 'VEHICLE', null, null, null, null, '0', '0', '28', '601');
INSERT INTO `duty_locations` VALUES ('456', '1', 'VEHICLE', null, null, null, null, '0', '0', '26', '601');
INSERT INTO `duty_locations` VALUES ('457', '1', 'VEHICLE', null, null, null, null, '0', '0', '29', '601');
INSERT INTO `duty_locations` VALUES ('458', '1', 'VEHICLE', null, null, null, null, '0', '0', '19', '560');
INSERT INTO `duty_locations` VALUES ('459', '1', 'VEHICLE', null, null, null, null, '0', '0', '20', '560');

-- ----------------------------
-- Table structure for `elections`
-- ----------------------------
DROP TABLE IF EXISTS `elections`;
CREATE TABLE `elections` (
  `idelections` varchar(45) NOT NULL,
  `Votes` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`idelections`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of elections
-- ----------------------------

-- ----------------------------
-- Table structure for `elevators`
-- ----------------------------
DROP TABLE IF EXISTS `elevators`;
CREATE TABLE `elevators` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `x` decimal(10,6) DEFAULT '0.000000',
  `y` decimal(10,6) DEFAULT '0.000000',
  `z` decimal(10,6) DEFAULT '0.000000',
  `tpx` decimal(10,6) DEFAULT '0.000000',
  `tpy` decimal(10,6) DEFAULT '0.000000',
  `tpz` decimal(10,6) DEFAULT '0.000000',
  `dimensionwithin` int(5) DEFAULT '0',
  `interiorwithin` int(5) DEFAULT '0',
  `dimension` int(5) DEFAULT '0',
  `interior` int(5) DEFAULT '0',
  `car` tinyint(3) unsigned DEFAULT '0',
  `disabled` tinyint(3) unsigned DEFAULT '0',
  `rot` decimal(10,6) DEFAULT '0.000000',
  `tprot` decimal(10,6) DEFAULT '0.000000',
  `oneway` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of elevators
-- ----------------------------
INSERT INTO `elevators` VALUES ('1', '0.000000', '0.000000', '0.000000', '0.000000', '0.000000', '0.000000', '0', '0', '0', '0', '0', '0', '0.000000', '0.000000', '0');
INSERT INTO `elevators` VALUES ('2', '1106.090820', '-1305.420898', '79.062500', '1532.537109', '-1678.035156', '5.890625', '10', '1', '0', '0', '2', '0', '358.536041', '88.647278', '0');
INSERT INTO `elevators` VALUES ('3', '-2624.517578', '1412.546875', '7.093750', '-2624.517578', '1412.546875', '7.093750', '0', '0', '0', '0', '0', '0', '29.479523', '29.479523', '0');

-- ----------------------------
-- Table structure for `emailaccounts`
-- ----------------------------
DROP TABLE IF EXISTS `emailaccounts`;
CREATE TABLE `emailaccounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` text,
  `password` text,
  `creator` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of emailaccounts
-- ----------------------------

-- ----------------------------
-- Table structure for `emails`
-- ----------------------------
DROP TABLE IF EXISTS `emails`;
CREATE TABLE `emails` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` datetime NOT NULL,
  `sender` text,
  `receiver` text,
  `subject` text,
  `message` text,
  `inbox` int(1) NOT NULL DEFAULT '0',
  `outbox` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of emails
-- ----------------------------

-- ----------------------------
-- Table structure for `factions`
-- ----------------------------
DROP TABLE IF EXISTS `factions`;
CREATE TABLE `factions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` text,
  `bankbalance` bigint(20) DEFAULT NULL,
  `type` int(11) DEFAULT NULL,
  `rank_1` text,
  `rank_2` text,
  `rank_3` text,
  `rank_4` text,
  `rank_5` text,
  `rank_6` text,
  `rank_7` text,
  `rank_8` text,
  `rank_9` text,
  `rank_10` text,
  `rank_11` text,
  `rank_12` text,
  `rank_13` text,
  `rank_14` text,
  `rank_15` text,
  `rank_16` text,
  `rank_17` text,
  `rank_18` text,
  `rank_19` text,
  `rank_20` text,
  `wage_1` int(11) DEFAULT '100',
  `wage_2` int(11) DEFAULT '100',
  `wage_3` int(11) DEFAULT '100',
  `wage_4` int(11) DEFAULT '100',
  `wage_5` int(11) DEFAULT '100',
  `wage_6` int(11) DEFAULT '100',
  `wage_7` int(11) DEFAULT '100',
  `wage_8` int(11) DEFAULT '100',
  `wage_9` int(11) DEFAULT '100',
  `wage_10` int(11) DEFAULT '100',
  `wage_11` int(11) DEFAULT '100',
  `wage_12` int(11) DEFAULT '100',
  `wage_13` int(11) DEFAULT '100',
  `wage_14` int(11) DEFAULT '100',
  `wage_15` int(11) DEFAULT '100',
  `wage_16` int(11) DEFAULT '100',
  `wage_17` int(11) DEFAULT '100',
  `wage_18` int(11) DEFAULT '100',
  `wage_19` int(11) DEFAULT '100',
  `wage_20` int(11) DEFAULT '100',
  `motd` text,
  `note` text,
  `fnote` text,
  `phone` varchar(20) DEFAULT NULL,
  `max_interiors` int(11) DEFAULT '20',
  `level` int(6) NOT NULL DEFAULT '1',
  `onay` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=163 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of factions
-- ----------------------------
INSERT INTO `factions` VALUES ('1', 'Los Santos Police Department', '10000121674', '2', 'Ä°zinli / Pasif / CezalÄ±', 'Academy student', 'Police Officer I', 'Police Officer II', 'Police Officer III', 'Senior Lead Officer', 'Dedective I', 'Dedective II', 'Dedective III', 'Sergeant I', 'Sergeant II', 'Lieutenant I', 'Lieutenant II', 'Captain I', 'Captain II', 'Captain III', 'Commander', '', '', 'Chief Of Police', '0', '50', '200', '225', '295', '325', '325', '350', '380', '395', '400', '425', '465', '500', '565', '575', '595', '0', '0', '600', 'Sahada 4 ADAM birimi olmadan divizyon devriyesi Ã§Ä±kmayÄ±n, sahaya Ã§Ä±kÄ±ÅŸ yaptÄ±ÄŸÄ±nÄ±zda TS3 te bulunmanÄ±z zorunludur aksi taktirde uyarÄ± yazÄ±lÄ±r.', '____________________________________________________\r____________________________________________________\r____________________________________________________\r____________________________________________________\r\n** UYARILAR ** \n- Carlino Esposito 2 - UyarÄ±\n\n\n\n\n____________________________________________________\r\n\n** DÃœZENLENEBÄ°LECEK AR-GE **\n\n\n\n\n\n____________________________________________________\r\n/findalts\n/ojail\n____________________________________________________\r\n* ARTILAR *\n\n- Marquiz Rayshawm +1\n- Alexander David +1 \n- Victor Merchantz +1\n- Westley Harper +1\n', '________________________________________________________________________________________________________________________________________________________________________________________________________________________\nDUYURU\n\nArtÄ±k herÅŸey forum Ã¼zerinden ve Ts3 Ã¼zeri yapÄ±lacaktÄ±r. GÃ¶rmedim, duymadÄ±m diye bahanelerle yÃ¶netime gelmeyiniz.\n\nï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ LÄ°NKï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹\nTutuklama raporu yapacaÄŸÄ±nÄ±z zaman; http://melancia-roleplay.com/index.php?topic=371.0\nSaha devriye raporu yapacaÄŸÄ±nÄ±z zaman; http://melancia-roleplay.com/index.php?topic=349.0\nPersonel DosyasÄ± hazÄ±rlayacaÄŸÄ±nÄ±z zaman; http://melancia-roleplay.com/index.php?topic=370.0\nLSPD El kitapÃ§Ä±ÄŸÄ±na bakacaÄŸÄ±nÄ±z zaman; http://melancia-roleplay.com/index.php?board=35.0\nBirlik duyurularÄ±na bakacaÄŸnÄ±z zaman; http://melancia-roleplay.com/index.php?topic=55.0\nIC Åžikayet bÃ¶lÃ¼mÃ¼(Savunma yapmanÄ±z yasak!); http://melancia-roleplay.com/index.php?board=20.0\nOOC Åžikayet bÃ¶lÃ¼mÃ¼(Savunma yapabilirsiniz); http://melancia-roleplay.com/index.php?board=19.0\n________________________________________________________________________________________________________________________________________________________________________________________________________________________\n\n\nONLUK KOD DIZINI\r\n10-1 = TÃ¼m gruplarÄ±n belirtilen bÃ¶lgede toplanmasÄ±, bu kod verildiÄŸinde tamamlamanÄ±z gereken iÅŸleri tamamlayÄ±p belirtilen bÃ¶lgeye yÃ¶nelmelisiniz.\r\n10-01 = TÃ¼m birimler belirtilen yere yÃ¶nelin. (ALL Units \'01 to Briefing room)\r\n10-03 = Telsiz kullanmayÄ±n/kapatÄ±n. \r\n10-04 = Olumlu, anlaÅŸÄ±ldÄ±.\r\n10-05 = Son anonsu, sÃ¶yleneni tekrarlayÄ±n.\r\n10-06 = Son sÃ¶ylediÄŸimi dikkate almayÄ±n. (Anons iptali)\r\n10-07 = MeÅŸgulÃ¼m / Ã‡aÄŸrÄ±lara kapalÄ±yÄ±z.\r\n10-07B = MeÅŸgulÃ¼m / Ã‡aÄŸrÄ±lara kapalÄ±yÄ±z. (KiÅŸisel)\r\n10-08 = MÃ¼saitiz / Ã‡aÄŸrÄ±lara aÃ§Ä±ÄŸÄ±z, devam ediyoruz.\r\n10-11 = Mesai bitiÅŸi.\r\n10-12 = Aktif STAFF sahada. (Supervisor)\r\n10-14 = Beni alÄ±n, araÃ§ gerekli. (MÃ¼sait saha ekipleri yÃ¶nelebilir. Genelde crash durumlarÄ±nda kullanÄ±lÄ±r.)\r\n10-15 = SuÃ§lu yakalandÄ±, tutuklamak iÃ§in departmana yÃ¶neliyoruz. SACF - LSPD\r\n10-18 = Destek gerekiyor mu? (Birim\'in desteÄŸe ihtiyacÄ± olup olmadÄ±ÄŸÄ± durumlarÄ±nda kullanÄ±lÄ±r.)\r\n10-20 = Konum bildirimi.\r\n10-21 = Rapor verin / Durumu belirtin.\r\n10-22 = Åžuraya gidin / buraya gelin.\r\n10-27 = (TS3) Kanal\'Ä± deÄŸiÅŸtirin (TAC-1 - TAC-2 odasÄ±na geÃ§iÅŸ saÄŸlayabilirsiniz.)\r\n10-40 = KalabalÄ±k grup.\r\n10-41 = OlasÄ± il-legal durum.\r\n10-46 = Ãœst arama - sicil kontrolÃ¼.\r\n10-55 = Trafik kontrolÃ¼/Ã§evirme.\r\n10-56 = VeritabanÄ± kontrol edin. (MDC kontrolÃ¼)\r\n10-57 = \"Victor\" AraÃ§ kovalama.\r\n10-57 = \"Foxtrot\" yayan kovalama.\r\n10-60 = AraÃ§ bilgisi.\r\n10-61 = EÅŸgal bilgisi.\r\n10-66 = Trafik kontrol (\'66 Felony stop)\r\n10-70 = Destek gerekli. (KOD 2-3)\r\n10-71 = SaÄŸlÄ±k ekibi gerekli. (LSFD)\r\n10-99 = Olay sonlandÄ±.\r\nï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹\nKODLAR\r\n(-) KOD 0 = Her ÅŸeyi bÄ±rak, gel. Acil durum (Memur vuruldu, memur yerde.) [/destekiste yazmalÄ±sÄ±nÄ±z.] \r\n(-) KOD 1 = YardÄ±m Ã§aÄŸrÄ±sÄ±, Memur tehlikede. [/destekiste yazmalÄ±sÄ±nÄ±z.]\r\n(-) KOD 2 = Sirensiz yÃ¶nelmek.(Rutin, normal Ã¶ncelik.)\r\n(-) KOD 2- = Sirensiz yÃ¶nelmek(YÃ¼ksek Ã¶ncelik)\r\n(-) KOD 3 = Sirenli yÃ¶nelmek.\r\n(-) KOD 4 = DesteÄŸe ihtiyacÄ±mÄ±z yok.\r\n(-) KOD 5 = UzaklaÅŸÄ±n / Uzak durun.\r\n(-) KOD 6 = SoruÅŸturma kapsamÄ±nda araÃ§ dÄ±ÅŸÄ±ndayÄ±z.\r\n(-) KOD 6A = SoruÅŸturma kapsamÄ±nda araÃ§ dÄ±ÅŸÄ±ndayÄ±z (Destek gerekiyor.)\r\n(-) KOD 6C = SoruÅŸturma kapsamÄ±nda araÃ§ dÄ±ÅŸÄ±ndayÄ±z (Aranan ÅŸÃ¼pheliyle kontaÄŸÄ±mÄ±z var.)\r\n(-) KOD 6G = SoruÅŸturma kapsamÄ±nda araÃ§ dÄ±ÅŸÄ±ndayÄ±z (Ã‡eteleÅŸme vakasÄ±.)\r\n(-) KOD 7 = Ä°htiyaÃ§ molasÄ±. (Yemek vb)\r\n(-) KOD 8 = YangÄ±n alarmÄ±.\r\n(-) KOD 9 ECHO = TerÃ¶rizm eylemi, aÄŸÄ±r silahlar tarafÄ±ndan ateÅŸ altÄ±ndayÄ±m!\r\n(-) KOD 10 = SuÃ§ vakasÄ± iÃ§in frekansÄ± temizleme talep ediliyor.\r\n(-) KOD 12 = YanlÄ±ÅŸ alarm/niner.\r\n(-) KOD 20 = BasÄ±na haber verin.\r\nï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹\nEÅžGAL KODLARI\r\nIC1 - Siyahi\r\nIC2 - Beyaz\r\nIC3 - Latin\r\nIC4 - Orta DoÄŸulu\r\nIC5 - AsyalÄ±\r\nIC6 - Bilinmeyen Etnik KÃ¶ken\r\nDevriye partneri nasÄ±l aranÄ±r?\r\n27016 Memur Chloe, devriye iÃ§in partner arÄ±yorum.\r\nï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹\r\nDevriye baÅŸlangÄ±cÄ± nasÄ±l bildirilir?\r\nMemur Chloe, Memur Henningsen, 1ADAM1 birim kodu altÄ±nda aktif sahaya Ã§Ä±kÄ±ÅŸÄ±nÄ± bildiriyor. \'20 PDHQ \'08\r\nDevriye bitiÅŸi nasÄ±l bildirilir?\r\n1ADAM1; aktif sahadan ayrÄ±ldÄ±ÄŸÄ±nÄ± bildiriyor. \'20 PDHQ \'07\r\nBolo kaydÄ± nasÄ±l oluÅŸturulur?\r\n((DEPARTMAN KANALI))27016 PD\'den BOLO, AraÃ§ bilgileri, Siyah-kÄ±rmÄ±zÄ± NRG-500. KiÅŸi bilgileri, siyahi, 2 kiÅŸi bayan. SuÃ§larÄ±, Dur ihtarÄ±na uymamak. Son gÃ¶rÃ¼ldÃ¼ÄŸÃ¼ yer; East Los Santos kuzeyi.\r\n10-06 (\'06) nasÄ±l bildirilir?\r\n2A11; \'06\r\nMesai bitiÅŸi nasÄ±l bildirilir?\r\n27016, Memur Chloe \'07b, \'11\r\n10-14 (\'14) nasÄ±l bildirilir?\r\n1ADAM1; aracÄ±mÄ±zÄ±n motoru arÄ±zalandÄ±ÄŸÄ±ndan dolayÄ± \'14 talep ediyoruz. \'20 BÃ¶lge \'07\r\n10-15 (\'15) nasÄ±l bildirilir?\r\n1ADAM1; yakalanan suÃ§lu iÃ§in \'15 bildiriyor. \'20 BÃ¶lge \'07\r\n10-15 (\'15) nasÄ±l bitirilir?\r\n1ADAM1; \'15 durumunu \'99 olarak gÃ¼ncelledi. \'20 PDHQ \'08\r\n10-18 (\'18) nasÄ±l sorulur?\r\n((YAKIN TELSÄ°Z)) \'18?\r\n10-21 (\'21) nasÄ±l cevaplanÄ±r?\r\n1ADAM1; olaÄŸan devriyesine devam ediyor, durum stabil. \'20 BÃ¶lge \'08\r\n1ADAM1; devriyemizi ÅŸehrin doÄŸu bÃ¶lgesinde sÃ¼rdÃ¼rÃ¼yoruz, herhangi bir hareketlilik yok. \'20 BÃ¶lge \'08\r\n10-40, 10-41(\'40, \'41) nasÄ±l bildirilir?\r\n1ADAM1; bulunduÄŸum bÃ¶lgede \'40, \'41 mevcut. \'70 \'20 BÃ¶lge \'07\r\n10-55 (\'55) nasÄ±l bildirilir?\r\n1ADAM1; tehlikeli sÃ¼rÃ¼ÅŸ yapan siyah Bullet iÃ§in \'55 bildiriyor. \'20 BÃ¶lge \'07\r\n10-66 (\'66) nasÄ±l bildirilir?\r\n1ADAM1; aranan araÃ§ ile kontaÄŸÄ±mÄ±z bulunmakta \'66 durumu bildiriyorum. \'70 \'20 BÃ¶lge \'07\r\n\r10-71 (\'71) nasÄ±l talep edilir?\r\n1ADAM1; yaralÄ± memur(lar) iÃ§in \'71 talep ediyorum. \'20 BÃ¶lge**\r\nTAC-1 GiriÅŸi nasÄ±l bildirilir?\r\n1A1; TAC-1 KOD-3\r\nTAC-1 AyrÄ±lÄ±ÅŸÄ± nasÄ±l bildirilir?\r\n1A1; TAC-1 FrekansÄ±ndan ayrÄ±ldÄ±ÄŸÄ±nÄ± bildiriyor. \'20 BÃ¶lge\r\nï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹ï¹\n\n', null, '20', '6', '1');
INSERT INTO `factions` VALUES ('2', 'Los Santos Medical Department', '10000223431', '4', 'Yeni gelen', 'Ä°zinli', 'Ã–ÄŸrenci EMT', 'EMT ', 'EMT Åžefi', 'Stajyer Paramedik ', 'Paramedik ', 'Paramedik I', 'Paramedik II', 'Paramedik III', 'Paramedik Åžefi', 'Stajyer Doktor', 'Uzman Doktor', 'OperatÃ¶r Doktor', 'ProfesÃ¶r Doktor', 'BaÅŸ Hekim', 'Personel MÃ¼dÃ¼rÃ¼', 'Departman Ã‡avuÅŸu', 'Åžef YardÄ±mcÄ±sÄ±', 'Departman Åžefi', '0', '0', '200', '225', '245', '300', '325', '335', '345', '400', '450', '500', '525', '530', '550', '560', '570', '580', '590', '600', 'Hafta Ä°Ã§i Saat : 12.00 - 20:00 Mesai Saatleri ||| Hafta Sonu : 11:00 - 21:00 Devriye Sonu', 'Rozet Basmak : /Ä±ssuebadge ID rozet adÄ±\nF Chat Kapatma : /togf\nBirlik Liderleri Ã–zel konuÅŸma Chat /fl \n\n\n', '                                                                            ___________________________________________________________________\n                                                                                           \n                                                                                                           LOS SANTOS MEDÄ°CAL DEPARTMENT\n                                                                            ___________________________________________________________________\n\nhttps://docs.google.com/document/d/1YfRg-rppo6lRO6salUerMLpofvr1ZrHo4ZaEwHRNEYc/edit -------------------------------> Mutlaka Okuyun.\nLos Santos Medical Department Resmi BirliÄŸidir.\nUnutmayÄ±n Doktorlar,\nGerÃ§ek doktor, Her hasta ile yaÅŸayÄ±p Ã¶lendir.\n- Stefan Zweig\n\n\n____________________________________________________________\nTelsiz KullanÄ±mÄ± : /t \n\nDEVRÄ°YEYE Ã‡IKIÅž KURALLARI :\n- Devriye baÅŸlangÄ±cÄ±nda ve bitiminde telsiz verilmelidir.\n- HÄ±z sÄ±nÄ±rÄ±na ve trafik kurallarÄ±na  uygun kullanÄ±lmalÄ±dÄ±r.(Acil Durumlar HariÃ§)\n- Acil bir vaka haricinde siren yakmak yasaktÄ±r.\n- EMT Åžefi ve altÄ± 2 KiÅŸi Ã§Ä±kmak zorunda [Tek KiÅŸi aktifse Tek Ã‡Ä±kabilir]\n- Ambulansta Paramedic ve EMT bulunmalÄ±dÄ±r.(Tek kiÅŸi aktifse tek Ã§Ä±kÄ±labilir)\n-----------------------------------\n\nTELSÄ°ZLER :\n\nDevriyeye Ã‡Ä±kÄ±ÅŸ : /t M. Bell ve N.P. Harris A-A-A-A PlakalÄ± araÃ§ ile devriyeye Ã§Ä±kÄ±ÅŸ izni belirtiyor.\nDevriye Acil Vaka Durumu : /t A-A-A-A PlakalÄ± araÃ§ devriye sÄ±rasÄ±nda acil vaka  ***** BÃ¶lgesine Ambulans Ä°steniyor.\nDevriye BitiÅŸ : /t  A-A-A-A PlakalÄ± araÃ§ devriye Sona erdiriyoruz.\nAcil Bir Ä°ÅŸte Sivil Ä°zni : /t [RÃ¼tben] [AdÄ±n ve SoyadÄ±n KÄ±saltÄ±lmÄ±ÅŸÄ±] [Nedeni] Sebebi ile [SÃ¼re] Dakika / Saat Ä°zin istemekteyim.\nÃ–rnek : /t Departman Åžefi M. Bell Vergi Ã–deme Sebebi Ä°le 15 Dakika Ä°zin Ä°stemekteyim.\nÄ°hbara YÃ¶neliÅŸ : /t Departman Åžefi M.Bell Son Ä°hbara / Son OperatÃ¶r Ä°hbarÄ±na yÃ¶neliyor.\n_________________________________________________\n\nVAKA KODLARI :\nÃ‡ok vaka kodlarÄ± ile zaman geÃ§inmeden direk :\n/t M.Bell KonuÅŸmakta ; Yemek MolasÄ±\n/t M.Bell KonuÅŸmakta ; Stabil Devriye Vb.\n________________________________________________\n                              *\nRÃœTBE SIRALAMASI   *\n- - - - - - - - - - - - - - - *\nDepartman Åžefi\nYardÄ±mcÄ± Åžef\nDepartman Ã‡avuÅŸu\nPersonel Åžefi\nBaÅŸHekim\nProfesÃ¶r Doktor\nOperatÃ¶r Doktor\nUzman Doktor\nDoktor\nStajyer Doktor\nParamedik Åžefi\nParamedik III\nParamedik II\nParamedik I\nStajyer Paramedik \nEMT Åžefi\nEMT\nStajyer EMT\nYeni Gelen\n', null, '20', '6', '1');
INSERT INTO `factions` VALUES ('3', 'Government of Los Santos', '9891872079', '3', '(( FMT Liaison )) Suspended/Leave', 'Intern', 'Trainee Licensing Officer', 'Licensing Officer', 'P.A', 'Planning Supervisor', 'Trainee Planning Supervisor', 'Director of Licensing / Planning', 'Public Safety Representative', 'Trainee Security Officer', 'Security Officer', 'Director of Security', 'Director of Public Safety', 'Press Secretary', 'Staff Secretary', 'City District Manager', 'Chief of Staff', 'Council(wo)man', 'Deputy Mayor', 'Mayor', '0', '250', '470', '800', '800', '800', '470', '1050', '900', '470', '800', '1050', '1050', '900', '1100', '1200', '1300', '0', '1400', '1500', 'Radio frequency: 316.95 ||. Please read the note for further information.  ||  We now have our own forums. Check the note for further information. ||', 'Leader Rules:\n- No OOC promotions, demotions, removals or recruitments;\n- Do not change wages without approval of the FMT;\n- Do add, remove or move faction vehicles without approval of the factionleader\n_______________________________________________\n\nInactive Member discussion. 3 Days unnotified inactivity limit for dismissal of rank, 6 Days full removal of the faction!!\nPlease write here if members are suspended and what reason they are suspended for!\n\n\n_______________________________________________\n\n~ Executive Cabinet\n- Mayor: Daniel Levi (active)\n- Deputy Mayor: Rebecca Glauber (active)\n- Chief of Staff: Taro Watanabe (active)\n- Press Secretary: VACANT\n-- Department of Licensing: Sicilia Holson (active)\n-- Department of Planning: Sicilia Holson (active)\n-- Department of Public Safety: Ryan McCarthy (active)\n-- Department of Security: VACANT\n\n~ City Council\nMayor: Daniel Levi\nDeputy Mayor: Rebecca Glauber\nChief of Police: Thor Askeland\nCommissioner of Fire Department: Jason Heywood\nTaro Watanabe\nEdison Best\nRyan McCarthy\n__________________________________________________\n\nHanding out phone numbers:\n51-xy\nx:\n- 0 = Mayor, Deputy & Chief of Staff\n- 1 = Secretaries\n- 2 = Licensing Dep\n- 3 = Planning Dep\n- 4 = Security\n- 8 = Public Safety\n- 9 = Councilmembers\n\ny: \n- Given in random order.\n\n', 'EVERYONE MUST REQUEST TO JOIN THE GOV USERGROUP ON THE FORUMS!!!!\n\nWe now have our own Government forums! YOU MUST GO THERE AND REGISTER!!!!\nhttp://gov.blankworld.org/\n\nFaction Rules ((OOC and IC))\n\n1) Inactivity:\n1.1) Inactivity of 3 days or more will lead to a removal of wage and you will be set to \"Suspended/Leave\".\n1.2) Inactivity of 6 days or more will lead to a full removal.\n\n2) Corruption:\n2.1) Any form of OOC corruption is strictly forbidden. It will reported to administrators and punished harshly.\n2.2) Any for of IC financial corruption is forbidden unless approved by the FMT leader.\n2.3) IC corruption is allowed if it has no consequnces for the faction, but for you as a member (such as drugs)\n\n3) Behavior:\n3.1) You are expected to behave proffesionally both IC\'ly and OOC\'ly. This includes being formal.\n\n4) Infrastructure & vehicles:\n4.1) The private parking lot is expected to be kept neatly and organized. Only certain members can have reserved parking spots.\n4.2) Helicopter parkings are only for governmental vehicles.\n4.3) /dep is only to be used when approved by a faction leader.\n4.4) Special vehicles may not be used for recreational goals.\n\n5) Badges:\n5.1) Badges are only to be worn in situations related to the faction or in faction-vehicles.\n\n6) A Recruitment Review team is being established by CoS Gregory Holson.  The Recruitment Review team will help to review all Employment applications that players send in on the forums. This team\nis required to review the applications and you will get back to Gregory Holson to let him know what you think on the application, whether it\'s to be accepted or denied.  If you would like to be apart\nof the Recruitment Review team, PM Gregory Holson on the forums @Behr and explain to him why you would like to be apart of the team and what makes you fit for the team.\n(( P.S: Gregory Holson actually wrote this ))\n\n-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n~ Department of Licensing: Phone number 20-29.\nWorks on Forums and IG. Respond to license applications. After application is accepted, respond to licensing calls and grant the license IG and inspect the business.\n(( Trainee Licensing Officers are not allowed to do forum work!  You must do a license with a Licensing Officer IG.  Just go with them and take note of what they do and how they work. ))\n\n~ Department of Planning: Phone number 30-39.\nWorks on Forums and IG. Respond to planning applications. After application is accepted, ensure payments are made and approval is clear.\n', '51', '20', '1', '0');
INSERT INTO `factions` VALUES ('4', 'Rapid Towing', '10000087731', '7', 'Sales Contract', 'Suspended', 'On Leave (with report)', 'On Leave (no report)', 'Student', 'Department Coordinator', 'Probationary Driver', 'Driver I', 'Driver II', 'Driver III', 'Driver IV', 'Driver V (Lead Driver)', 'Impound Manager', 'Instructor', 'Head Instructor', 'Sales Representative', 'Sales Manager', 'Supervisor', 'Assis. Chief Executive Officer', 'Chief Executive Officer', '0', '0', '0', '0', '50', '1050', '150', '300', '400', '700', '900', '1200', '800', '900', '1000', '900', '1200', '1200', '1400', '1500', 'Radio: 324.842 | Inactivity = Kick | On duty = badge and uniform. | Screenshot vehicles before impound | Minor corruption allowed, major = a kick |', '---- General ----\n- Only HC are supposed to have their own assigned phonenumber.\n- No member is not allowed to keep an income of sales earned.\n- Do not leak any info that is not supposed to get out.\n- Be sure to post in the following thread when you demote/promote/accept/fire/suspend anyone: http://forums.owlgaming.net/showthread.php?8617-Rapid-Towing-High-Command-Arrivals-Departures-Promotions-Demotions-Logbook\n\n\n---- MDC ----\nThis can be used for background checks only.\nName: RapidTow\nPW: rapidtowingleader\n\n\n---- Badge ----\nBe sure to follow the format below.\n/issuebadge id Rapid Towing - Rank - F.Lastname\n\n\n---- Faction Vehicles ----\nFaction vehicles do NOT get purchased without the approval of the CEO or Assistant CEO.\n\nCAR COLOR CODES:\nsetcolor * 000000 00D300\nFirst: 000000\nSecond: 00D300\n\nRapid towing colors:\nsetcolor * 000000 002144\n2nd 002144\n', 'ALL MEMBERS READ THIS IMMEDIATLY.\nhttp://forums.owlgaming.net/showthread.php?13183-Issues\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n---- General Notes ----\n- Received #9021 calls must be answered. Failure to respond will be result in a punishment. We need to show the server that we\'re active!\n- Fuel and fix the vehicles before returning.\n- Only English is allowed in /f. Talking foreign will result in a punishment of 1 hour.\n- Do not restock the dealership unless told by the CEO, Assistant CEO or Sales Manager.\n- Badges are not to be given out unless approved by a faction leader.\n- Upon leaving the faction, badges must be deleted.\n\n\n---- Faction Vehicles ----\n- Buckle up.\n- Lock the doors.\n- Wear your badge and uniform. Failure to wear so will result in a punishment.\n\n\n---- Impounding Cars ----\n- Find an empty space on the first floor.\n- Place it.\n- /park, /handbrake and /setvol 0 it.\n\n\n---- Impounding Bikes ----\n- Use the DFT to bring the bikes inside.\n- Have an administrator /start it.\n- Place it properly on the top floor.\n- /park and /impoundbike it.\n\n\n---- Phonenumbers ----\n- 9022 <-> 9029 = Main Department\n- 9030 <-> 9039 = Instruction Department\n- 9040 <-> 9049 = Sales Department\n\n\n---- Sales Department ----\n- All the money goes to the faction bank. Account name is Rapid Towing, have your reason like this: \"Sales - [Vehicle ID], [Buyer Name]\" (requirement from FMT)\n- You are not allowed to keep a cut of the money. This is an OOC rule which will receive OOC punishment when caught. Keeping cash will result in a kick and a reset of your account.\n- Price: to a non-employee: VehiclePrice x 0.45.\n- Contact for sales department: http://bit.ly/SalesDepartment\n\n\n---- Corruption ----\n- ALLOWED: minor corruption. Example: speeding, drugs.\n- NOT ALLOWED: major corruption. Robbery, kidnapping. Doing it will result in a faction removal.\n\n\n---- Handy Links ----\n- Picture of the 2014 Ford F-350 Towtruck equipped with a stinger towing kit. (more the less) : http://www.southbayford.com/img/layout/towtruck/specPhoto_towtruckF350.jpg\n- The trucks have something similair to this attached to their towing boom (NO HOOK!): http://www.youtube.com/watch?v=V9XVA2rvNek\n- USERGROUP: http://forums.owlgaming.net/profile.php?do=editusergroups\n\n---- Commands ----\n/rbs - Opens the roadblock HUD. \n/nearbyrbs - Find nearby roadblocks and their ID.\n/delrb (ID) - Deletes the roadblock with \'ID\'.\n/ed and add â€¢ $RetailPrice x 0.45\n\n----Student Training & Exams----\nFirst of all, if you\'re a Student, welcome to Rapid Towing, hope your career at this company will be full of positive results.\nNow, this section will be more of a feedback section for all the Students that want to know how this phase works.\nAs a Student you\'re not allowed to go on patrol by yourself neither are you allowed to answer to either Departmental or Hotline calls.\nAs you should know, the Rapid Towing\'s Forum Section has everything you need to successfully pass on your exam. Below this you\'ll find a hand full of links that will help you out:\n- http://forums.owlgaming.net/showthread.php?18403-Rapid-Towing-Student-Handbook-(MUST-READ!)\n- http://forums.owlgaming.net/showthread.php?17337-Rapid-Towing-General-Rules\n- http://forums.owlgaming.net/showthread.php?23340-Rapid-Towing-Official-Parking-Rules\n- http://forums.owlgaming.net/showthread.php?26560-Security-at-Rapid-Towing\n- http://forums.owlgaming.net/showthread.php?19576-Rapid-Towing-Sales-Department\n- http://forums.owlgaming.net/showthread.php?24075-Rapid-Towing-Radio-Usage\n- http://forums.owlgaming.net/showthread.php?27064-Idlewood-Gasstation-towing-not-allowed\n- http://forums.owlgaming.net/forumdisplay.php?729-Unlawful-Impoundment-Reports\n\nOnce you\'ve read those links, I believe you will be almost ready to take your exam.\nAll you need now is to go out on ride-alongs with your partners and ask them any questions you have about the company and how this works.\nBelow you will find a link of what us, Instructors, take in mind in your exams.\n- http://forums.owlgaming.net/showthread.php?31476-Rapid-Towing-Student-Training-amp-Exams&p=194304#post194304\n\n----Probationary Phase----\nCongratulations to all the new Probationary Drivers, this is the part where you will be doing the best you can and will be under eye of other higher ranks.\nFrom now on, you\'re allowed to go on solo patrol and answer to Departmental and Hotline calls.\nNow you have even more responsibility from your acts while on duty.\nDon\'t stick to the fifteen (15) minimum impound mark as it will make your promotion hard to appear as soon as you want. Try getting a higher amount than fifteen (15) impounds.\nKeep your attitude the best. Do not misbehave with any other employee at Rapid Towing nor with customers/civilians.\nRemember to always to pictures (screenshots) if the vehicles you impound with the plates in sight.\nWe expect you to show dedication towards the company.\nThese simple facts will make your future in Rapid Towing positive.\n\n----Behavior/Attitude----\n(( Link is coming soon... ))\n', '90', '20', '1', '0');
INSERT INTO `factions` VALUES ('11', 'Grove Street Families', '0', '0', 'Gangster', 'Melancia Rank #2', 'Melancia Rank #3', 'Melancia Rank #4', 'Melancia Rank #5', 'Melancia Rank #6', 'Melancia Rank #7', 'Melancia Rank #8', 'Melancia Rank #9', 'Melancia Rank #10', 'Melancia Rank #11', 'Melancia Rank #12', 'Melancia Rank #13', 'Melancia Rank #14', 'Melancia Rank #15', 'Melancia Rank #16', 'Melancia Rank #17', 'Melancia Rank #18', 'Melancia Rank #19', 'The Boss', '100', '100', '100', '100', '100', '100', '100', '100', '100', '100', '100', '100', '100', '100', '100', '100', '100', '100', '100', '100', 'BirliÄŸe HoÅŸgeldin Bizimle Kal...', '', '1-Birlik Ãœyelerine KardeÅŸ Gibi DavranÄ±n.\n2-BÃ¼yÃ¼k RÃ¼tbelere SaygÄ±sÄ±zlÄ±k YapmayÄ±n\n3-Birlikten Ã‡Ä±karsanÄ±z 30k kan parsÄ± zorunlu yoksa ck.\n4-KonuÅŸmaya Gidilirse Liderden BAÅŸka Birisi KonuÅŸursa CezalandÄ±rÄ±lÄ±cak.\n\n\nHerkese Ä°yi Oyunlar Para ile adam almÄ±yoruz.....\n', null, '20', '1', '0');
INSERT INTO `factions` VALUES ('12', 'Grove Street Families.', '0', '0', 'Gangster', 'Melancia Rank #2', 'Melancia Rank #3', 'Melancia Rank #4', 'Melancia Rank #5', 'Melancia Rank #6', 'Melancia Rank #7', 'Melancia Rank #8', 'Melancia Rank #9', 'Melancia Rank #10', 'Melancia Rank #11', 'Melancia Rank #12', 'Melancia Rank #13', 'Melancia Rank #14', 'Melancia Rank #15', 'Melancia Rank #16', 'Melancia Rank #17', 'Melancia Rank #18', 'Melancia Rank #19', 'The Boss', '100', '100', '100', '100', '100', '100', '100', '100', '100', '100', '100', '100', '100', '100', '100', '100', '100', '100', '100', '100', 'HoÅŸgeldin Hep Bizimle Ol...', '', '1-KÃ¼fÃ¼r SaygÄ±sÄ±zlÄ±k gibi ÅŸeyler yasaktÄ±r\n2-Kendinden BÃ¼yÃ¼k RÃ¼tbelere Artislenmeyin\n3-Yetkiniz Ã‡ok Diye BAÅŸka Birlik Ãœyelerie Atar YapmayÄ±n\n4-Benden Habersiz BaÅŸka Birliklere atarlanmayÄ±n\n\n\nMia Campel Herkese Ä°yi Oyunlar Diler.\n', null, '20', '1', '0');
INSERT INTO `factions` VALUES ('17', 'Bank of Los Santos', '10000087731', '5', 'Guest of Honour', '', '', '', 'Loan Enforcement Officer', 'Junior Loan Enforcer', '', '', '', '', '', '', '', '', '', 'Junior Loan Enforcer', 'Senior Loan Officer', 'Chief Lending Officer', 'Chief Financial Officer', 'Chief Executive Officer', '0', '1', '25', '35', '680', '750', '950', '950', '0', '0', '0', '0', '0', '0', '0', '850', '1000', '1200', '1450', '1500', '#limo', 'Hviid : 321321\nYael : 826 692\nSadiq : 866733\n\n\nSince we do not use our vehicles we are selling them.\nSHO\'s and C63s are for sale at Johnsons Automobiles currently.\nThey are being sold for 50% of their new price, he will however get 10% of the money.\nSo we are getting $22,500($25.000) for the SHO, and $29.250($32.500)  for the Mercedes C63.\n', 'Title Loans Interview Questions - \n\nName:\nPhone Number:\nAddress:\n\nIF VEHICLE:\n\nVehicle Model and Year:\nVIN Number:\nValue of the Car:\nSpeed:\nHandling on Scale of 1-10:\n\n( Offer 50-60 percent of the value of the car, depending on the model and stats. )\n\nIF PROPERTY:\n\nProperty Location:\nProperty Number:\nValue of the Property:\n(( Custom Interior: Yes/No ))\n\n( Ask to view the property. Offer 75-90 percent of what you feel the house can be sold for easily. )\n\n\n!!! Inform people of ther total amount due, number of weekly payments and the sum of each weekly payment. Also inform them that they are not allowed to sell the collateral, nor stat transfer it, as ICly it would have a lien against it and would not be able to be legally sold. !!!\n', null, '20', '1', '0');
INSERT INTO `factions` VALUES ('20', 'BBC News', '10000090003', '6', 'Intern', '((FMT))', 'On Leave', 'Suspended', 'Junior Anchor ', 'Junior Journalist', 'Anchor ', 'Journalist', 'Senior Journalist', 'Senior Anchor ', 'Journalist + Anchor', 'Phil', 'Head of Technical Staff ', 'Head Journalist ', 'Head Anchor ', 'Office Supervisor ', 'Manager ', 'Chief Financial Officer', 'Chief Operating Officer ', 'Chief Executive Officer ', '200', '0', '0', '0', '250', '250', '600', '600', '600', '900', '650', '1000', '650', '950', '950', '700', '1000', '1300', '1500', '1500', 'Apply for the LSN usergroup, and check the new obligations in the employee handbook. They will go in place today Frequency: 456.709 ', 'Ranks ( These are the Standard Rate ranks which may change due to promotion of pay not rank)\n\nChief Executive Officer - 1500\r\nChief Operating Officer - 1500\r\nChief Financial Officer - 1300\r\nManager - 1000\r\nOffice Supervisor - 700\r\n\nHead Journalist - 1000\r\nSenior Journalist - 900\r\nJournalist -  600\r\nTrial Journalist - 400\r\n\r\n\n\nHead Anchor - 1200\r\nSenior Anchor - 900\r\nAnchor - 600\r\nTrial Anchor - 400\r\n\r\nJanitor - 300\n', '\n\n\n/movetv - moves the camera to your position\n/starttv - starts the show\n/endtv - ends the show\n\n/interview name - starts interview\n/i text - to speak via the radio system\n/endinterview name - ends the interview\n\n\n\n\n\n\nRadio Channel #456.709 \n5 days of  inactivity=suspended,\n 7 days=kick!!\nIC Email: firstname.lastname@LSNetwork.sa| \n\n\n', null, '20', '1', '0');
INSERT INTO `factions` VALUES ('47', 'Federal Aviation Administration', '10000087731', '2', 'On Leave / Suspended', '[ANG] Airman', '[ANG] Master Sergeant', '[ANG] Lieutenant', '[ANG] Major', 'Trainee', 'Security Guard', 'Crew Chief', 'ATC Officer', 'Agent', 'Special Agent', 'ROT Instructor', 'SER Instructor', 'MER Instructor', 'TER Instructor', 'Chief Investigator', 'Operations Manager', 'Head Instructor', 'FAA Deputy Administrator', 'FAA Administrator', '0', '650', '800', '1000', '1200', '200', '550', '550', '550', '750', '1000', '650', '750', '900', '1100', '1000', '1100', '1200', '1200', '1200', 'Internal channel: 951.159 | Remember to apply to the usergroup on forums! | Going away? Post a inactivity notification @ FAA Staff forum & notify a HC.', '---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\nBadge format:\n\nFAA <Rank> - <F.Lastname>\nExample: FAA Administrator - D.Bryant\n\n\nShort links:\nhttp://tiny.cc/faacareer - Career Apps\nhttp://tiny.cc/flightschool - Flight School apps\nhttp://tiny.cc/flightinstructor - Instructor apps\n\nLos Santos Flight School is looking for instructors! Get free education into a lucrative and challenging job. Apply today! http://www.lossantosflightschool.tk/\n\n', 'NOTICE!: 1- Upon leaving the faction/being kicked or removed from it, you\'ll need to delete your badge and possible uniform.\n              2-Don\'t forget to apply for our Usergroup on the forums!\n\n_____________________________________________________________________________________________________________________\n\nIMPORTANT RULES: whoever break any of these rules will be suspended and charged with a crime.\n1) NO guns are allowed inside the airport field, unless the holder is a cop or FAA Agents+, unauthorized personnels will be charged with crime APC112.\n\n2) Cruisers are NOT allowed outside the airport gate under any reason such as  repairing. \n\n3) NO personal vehicles are allowed to pass from the second gates, ONLY faction vehicles.\n\n4) Driving on the runways will lead to an immediate suspension and charging with crime APC 113.\n\n5) Instructing any kind of pilot licenses or typerating without a valid CFI license will lead to charging crime APC107.\n\n6) NO vehicles are allowed to park on the airport\'s sidewalk.\n\n7) ONLY one vehicle is allowed to park inside the parking area per member.\n\n\n-----to be continued-----\n\n\n', '55', '20', '1', '0');
INSERT INTO `factions` VALUES ('50', 'Superior Court of San Andreas', '10000087731', '2', 'On Leave/Suspended', 'Janitor', '', 'SADLE Special Agent in Training', 'SADLE Special Agent', 'SADLE Supervisory Special Agent', 'SADLE Special Agent in Charge', 'SADLE Commissioner', '', 'Public Relations Officer', 'Special Assistant', 'Public Defender', 'Magistrate Judge', 'Prosecutor In Training', 'Prosecutor', 'Assistant District Attorney', 'District Attorney', 'Attorney General', 'Associate Justice', 'Chief Justice', '0', '250', '0', '700', '800', '900', '1000', '1100', '850', '650', '1000', '0', '650', '600', '650', '700', '900', '1000', '1250', '1500', 'DLE frequency - 132.2 | TS Password = cat', 'BADGE FORMAT:\n[Rank - Individual name]\n\nUse /issuebadge [ID] then the badge format above to issue an individual their badge.\n\nFACTION EXPENSES:\n\n', 'Badges:\n\n1 - Special Agent - #BADGENUMBER\n2 - POLICE || SPECIAL AGENT *Plate Carrier*\n3 - || SADLE/POLICE - \"NICKNAME\" ||\n4 - || POLICE - SPECIAL AGENT ||\n\n1 - General Duty bdge\n2 - Plate Carrier badge\n3 - Rapid Response Team, Marked\n4 - Rapid Response Team, unmarked\n\nRapid Response Team nicknames\n\nMiles Morrison -  \"TAILS\"\nJason Gordon - \"LOCKS\"\nDavid Ellsworth  - \"IRONMAIDEN\"\nDwayne Matheson - \"GRAVEDIGGER\"\n\nRadio Codes:\r\n10-1: Roll Call, all units respond to said location.\r\n10-2: Arrived on scene.\r\n10-3: Negative / No\r\n10-4: Acknowledgement / Affirmative / Yes\r\n10-5: Repeat last transmission\r\n10-6: Stand-by\r\n10-7: Unavailable for calls\r\n10-8: Available for calls\r\n10-9: Suspect Lost (Usually followed by a 10-17 and last known 10-20)\r\n10-10: (Supervisors only) requesting activity update along with giving your current position\r\n10-12: Backup Required (Specify situation and location)\r\n10-13: Requesting specific unit (specify)\r\n10-17: Requesting description on the suspect\r\n10-20: Requesting Location\r\n10-22: Disregard last transmission\r\n10-30: Starting Patrol/Resuming patrol after Code 7\r\n10-31: Returning to Station\r\n10-50: Car accident\r\n10-55: Traffic Stop\r\n10-57 Victor: Vehicle pursuit.\r\n10-57 Foxtrot: Foot pursuit.\r\n10-66: Felony Stop\r\n10-88 Suspicious Person(s)\r\n10-99: Assignment complete (State condition and at what call)\r\n11-99: Officer requires help, Emergency\r\n \r\n \r\n \r\nStatus-codes:\r\nStatus 1: In Service\r\nStatus 2: Out of Service\r\n \r\nIdentity Codes:\r\nIC-1: White\r\nIC-2: Black\r\nIC-3: Latino or Mexican\r\nIC-4: Middle-Eastern\r\nIC-5: Asian\r\nIC-6: Unknown ethnicity.\r\n \r\n \r\nSituation codes:\r\nCode 0: Absolute emergency, drop everything youâ€™re doing and respond immediately.\r\nCode 1: Non-emergency. If you\'re doing something, deal with it first. Respond without lights or sirens.\r\nCode 2: Non-emergency. If you\'re doing something, drop it and respond. Respond with lights only.\r\nCode 3: There is an emergency. Respond with lights and sirens.\r\nCode 4: No assistance required, situation under control.\r\nCode 5: All units stay out of <location>.\r\nCode 6: Out of car at <location>.\r\nCode 7: Meal break.\r\n \r\n \r\nCriminal Codes:\r\n148: Resisting Arrest\r\n187: Homicide\r\n207: Kidnapping\r\n211: Robbery\r\n240: Assault\r\n417: Brandishing a weapon\r\n459: Burglary\r\n487: Petty Theft\r\n602: Trespass/Fraud\n', null, '20', '1', '0');
INSERT INTO `factions` VALUES ('55', 'Dupont Corporation', '10000119731', '5', 'Inactive/Honorary', '', '', '', '', '', 'Some Wrestler', '', '', '', 'Claims Agent', 'Insurance Agent', 'Insurance Supervisor', 'Trial Designer', 'Designer', 'Senior Designer', 'Head Designer', 'Dupont Insurance C.E.O.', 'Dupont Fashion C.E.O.', 'Dupont Corporation C.E.O.', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '2500', '2500', '0', 'apply to the forum usergroup!', '', 'ROSTER (Not everyone is in the F3)\n\nMarcus Dupont       \n(( Anumaz ))\n\nScott Bishop          \n(( Snipes ))\n\nNick Nevin             \n(( Thomaspwn ))\n\n', null, '20', '1', '0');
INSERT INTO `factions` VALUES ('56', 'Cargo Group', '10000087731', '5', '((Admin / FMT Liaison))', 'Unpaid Leave (Suspension)', 'Payed Leave', 'Janitor', '', '', '', '', '', '', 'Delivery Driver', 'Public Relations Supervisor', 'Executive Assistant', 'Delivery Manager', 'Warehouse Manager', 'Public Relations Manager', 'General Manager', 'Advisor', 'Assistant Chief Executive Officer', 'Chief Executive Officer', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '300', '450', '600', '550', '600', '0', '750', '0', '0', '0', 'Radio: 2424.23 | Look at the note to view the rules | PM MindScape00 or Sack for corruption permission.| ', '---------------------------INACTIVITY--------------------------------\n\nThe following people have reported inactivity:\n\n\n--------------------STEPS FOR ORDERS----------------------------\n\n   -------------How to Write Notes for Orders.-------------------\n        ORDERS MUST HAVE A NOTE ATTACHED TO LABEL THEM. Make 2 notes, follow this format:\n\n        ~~~ORDER: Name of Customer~~~\n\n        Make two of these. Put one in the truck/van, and then place in all the items. This seperates orders in the van and makes it easy to tell between them!\n        Use the second one to put it on the ground in front of the truck after you park the truck in the warehouse. \n\n        If you move an order to a shelf, move the notes and stuff also. Put note in, put items in, put 2nd note on ground.\n\n   -------------HOW TO MAKE A DELIVERY-----------------------\n    1. Make sure all the items are there and ready\n    2. Contact the Customer, decide on where to meet and go.\n    3. Greet the customer happily, give them clipboard to sign! -> --SKIP THE FORM, JUST RP HAVING THEM SIGN-- Delivery Confirmation Form HERE:  http://forums.owlgaming.net/showthread.php?15353\n  --SKIP THIS--  3.5. Make sure they actually do this correctly.\n    4. Once the DCF has been signed, transfer goods from truck/van to their specified location.\n    5. Ensure them a nice day and to enjoy their goods. Leave.\n    6. Any tips are yours to keep if they\'re under $500. Anything over $500 should be put into the Cargo Group Account, reason, \"Tip Order #\" with the correct number. (Meaning, a $600 tip, you keep $500, and $100 goes to CG Account)\n\n--------PLEASE MAKE SURE TO FOLLOW FORUM POST GUIDES ALSO!--------\n\n\n----------- CREATING ADMIN SPAWNED ITEMS VIA DUTY PERKS --------------\n/coming soon\\\n\n', '4 days of inactivity = a suspension\n8 days of inactivity without notice = a kick\n\n\n----------------------------------------------------------------------------------Ranking System------------------------------------------------------------------------------------------\n\nThe Sales Manager is the person responsible to handle all the import/transport requests. He will have to handle the customers accordingly and make sure all the payments are made before the delivery is done. He has to find new prospects and expand the Cargo Group customer database. If a marketing campaign has to be set up, the Sales Manager will be the leader in the project.\r\n\r\n\r\nThe Warehouse Manager is the person responsible for the day-to-day management of the warehouse. He has to keep track of the orders and make sure the deliveries arrive where they have to be. He can assign delivery drivers to certain deliveries. He will have to make sure the handling of the goods is done well and that the goods are well ordered in the warehouse. The better he does his , the easier the delivery drivers can deliver the goods.\r\n\r\n\nThe delivery drivers are the ones who eventually make sure the company keeps going. They deliver the goods from the warehouse to the customers. They can contact the customers (via the information given on the request-sheet) and have to make sure the deliveries are only in the warehouse for the time needed and not a minute longer. The delivery drivers have to represent the company as good as possible, by actively delivering the orders and by treating the customers as good as possible.\n\n-----------------------------------------------------------------------GENERAL INFO (Order & Delivery process)---------------------------------------------------------------------------\n~~~~~~ALSO SEE THE VERY BOTTOM SECTION FOR MORE SPECIFIC DELIVERY INSTRUCTIONS AND STUFF~~~~~~\n\n1) The Request:\r\nResponsible: Sales Managers\n\r\nThis is the phase where the customer creates his order. He will take contact with the company to get his goods delivered. He will provide his name, address and eventually his order. The role of the person who handles this, is to make sure the customer receives a fair price and that the order gets forwarded to the correct people. \r\n\r\nLink: http://forums.owlgaming.net/forumdis...p?563-Requests\r\n\r\n2) The Pickup:\r\nResponsible: Anyone with Leader-status\n\r\nIn this phase, the goods will be picked up from the Las Venturas Airport. The step between the previous phase and this one, is to make sure the orders are complete and correct. If a player requested a generic, it must be the correct ID, and so-forth.\r\nOnce the goods are taken from the Airport, they will have to be brought to the warehouse.\r\n\r\n3) The warehouse management:\r\nResponsible: Warehouse Manager\r\n\r\nOnce the goods are delivered in the warehouse, the Warehouse Manager is responsible for them. He will have to classify them per order (per shelve or whatever system he has in mind) and notify the delivery drivers of the order, plus its location. He has to make sure the delivery drivers know where to find the order. \r\n\r\nIt is only when the warehouse manager notifies the delivery drivers that they will know if an order is ready to be delivered or not.\r\n\r\n4) The delivery\r\nResponsible: Delivery Drivers\r\n\r\nOnce they are notified of the order being ready, the delivery drivers can take a truck or van and contact the customer. They will have to call him to see if he\'s available. As long as a customer\'s order is not delivered, they will have to call him regularly. When they pick up, the delivery driver has to set up a meeting to deliver the goods, preferably as soon as possible. The aim is to let the goods in the warehouse for the shortest period possible.\n\n--------------------------------------------------------------------------------------- RULES ----------------------------------------------------------------------------------------------------------\n\n1. Corruption not allowed. (You\'re NOT allowed to tell information/ranks OOCly for IC use.)\n\n2. Organization. (You\'ll need to be connected to the radio and follow the manager\'s instructions.)\n\n3. Do not use faction vehicles without permission.\n\n4. Do NOT drive trucks recklessly OR you\'ll be jailed and kicked from the faction without notice.\n\n5. You -must- transfer the request price to Cargo Group. Failure to do so will result in a kick and a reset of your character if neccesary\n\n6. Management must read the (leader) notes and the threads on the Employee Lounge daily\n\n------------------------------------------------------------------------------------- Useful websites ----------------------------------------------------------------------------------------------\n\nCCTV\'s, alarm systems & others - http://www.maplin.co.uk/c/cctv-and-security/\n\nMisc, furniture etc - http://www.alibaba.com\n\n-------------------------------------------------------------------------------------STEPS FOR ORDERS------------------------------------------------------------------------------------------\n\n   -------------How to Write Notes for Orders.-------------------\n        ORDERS MUST HAVE A NOTE ATTACHED TO LABEL THEM. Make 2 note, follow this format:\n\n        ~~~ORDER: Name of Customer~~~\n\n        Make two of these. Put one in the truck/van, and then place in all the items. This seperates orders in the van and makes it easy to tell between them!\n        Use the second one to put it on the ground in front of the truck after you park the truck in the warehouse. \n\n        If you move an order to a shelf, move the notes and stuff also. Put note in, put items in, put 2nd note on ground.\n\n   -------------HOW TO MAKE A DELIVERY-----------------------\n    1. Make sure all the items are there and ready\n    2. Contact the Customer, decide on where to meet and go.\n    3. Greet the customer happily, give them clipboard to sign! -> Delivery Confirmation Form HERE:  https://forums.owlgaming.net/showthread.php?15353\n    3.5. Make sure they actually do this correctly.\n    4. Once the DCF has been signed, transfer goods from truck/van to their specified location.\n    5. Ensure them a nice day and to enjoy their goods. Leave.\n    6. Any tips are yours to keep if they\'re under $500. Anything over $500 should be put into the Cargo Group Account, reason, \"Tip Order #\" with the correct number. (Meaning, a $600 tip, you keep $500, and $100 goes to CG Account)\n\n--------PLEASE MAKE SURE TO FOLLOW FORUM POST GUIDES ALSO!--------\n', null, '20', '1', '0');
INSERT INTO `factions` VALUES ('59', 'San Andreas Highway Patrol', '10000087731', '2', 'Suspended/On Leave', 'Cadet/ Auxiliary Staff', 'Detentions Officer', 'Senior Detentions Officer', 'Probationary Trooper', 'State Trooper', 'State Trooper', 'State Trooper', 'Detective', 'Detective II', 'Corporal', 'Sergeant in Training', 'Sergeant', 'Administrative Sergeant', 'Second Lieutenant', 'First Lieutenant', 'Captain', 'Major', 'Lieutenant Colonel', 'Colonel', '100', '250', '600', '700', '550', '600', '650', '700', '650', '750', '700', '800', '850', '900', '950', '1000', '1050', '1150', '1200', '1250', '', 'MDC username: FLastname(Like RJones)\nMDC password: fag\n\n\n\n13142 - personcruiser err0r\n\nLeader Commands:\n/issuebadge - Issues a badge. Leave it blank for syntax.\n/hq - Does an announcement with a beap to the entire faction.\n/fl - Same as /f, but only for leaders.\n\nRead new 10-codes in the note! | Do not skip Charlie #! Charlie 1, 2, 3 must be activated before C4!!\n', 'Evidence Locker Passcode: 3719\nRadio Frequency: 911.1337\n\nMDC username: FLastname(Like RJones)\nMDC password: sahp\n\nPLEASE CHANGE YOUR PASSWORD WHEN YOU LOGIN - TOP RIGHT \"ACCOUNT SETTINGS\"\n\n	Alpha: Alpha â€“ Supervisory Unit\r\n	Bravo: Boat â€“ Marine unit\r\nCharlie: Cruiser â€“ Standard patrol unit\r\nDelta: Detective â€“ Detective Unit â€“ Special Investigations Unit ONLY.\r\nEcho: Tactical Unit â€“ Emergency Response Team \nFoxtrot Foot â€“ Foot patrol\r\n	Henry: High Speed â€“ High Speed Interception Unit\r\n	Mike: Motorcycle â€“ Motorcycle Unit\r\n	Oscar: Off-Road â€“ Tahoe Unit\r\n	Sierra: Sky â€“ Air Support Unit (Helicopter)\nTango: Tow Truck / Flatbed\nPapa: Prison services\n - 1 PAPA (Interior Patrol)\n - 2 PAPA (Exterior Patrol) \n - PAPA OMEGA (Prison Supervisor)\n - PAPA CONTROL (Prison NPC Control)\n - PAPA ECHO (Prison Riot team)\n - 3 PAPA (Parole Services)\nX-Ray: Plane - Air Support Unit (Plane)\n\nEmergency Response Team\n\n|| TROOPER - \"NICKNAME\" ||\n\n * James McCullah  - \"TOAD\" \n * Pilson Gongerman - \"GINGERBREAD\"\n * Vanessa McCullah - \"GODDESS\"   \n * Vincent Bishop - \"VENDETTA\"\n * Enrique Young - \"SUPERNOVA\"\n * Samuel Johnson - \"OTTER\"\n * Miles Morrison - \"HEDGEHOG\"\n\nRadio Codes:\r\n10-1: Roll Call, all units respond to said location.\r\n10-2: Arrived on scene.\r\n10-3: Negative / No\r\n10-4: Acknowledgement / Affirmative / Yes\r\n10-5: Repeat last transmission\r\n10-6: Stand-by\r\n10-7: Unavailable for calls\r\n10-8: Available for calls\r\n10-9: Suspect Lost (Usually followed by a 10-17 and last known 10-20)\r\n10-10: (Supervisors only) requesting activity update along with giving your current position\r\n10-12: Backup Required (Specify situation and location)\r\n10-13: Requesting specific unit (specify) \r\n10-17: Requesting description on the suspect\r\n10-20: Requesting Location\r\n10-22: Disregard last transmission\r\n10-30: Starting Patrol/Resuming patrol after Code 7\r\n10-31: Returning to Station\n10-50: Car accident\r\n10-55: Traffic Stop\r\n10-57 Victor: Vehicle pursuit.\r\n10-57 Foxtrot: Foot pursuit.\r\n10-66: Felony Stop\r\n10-88 Suspicious Person(s)\r\n10-99: Assignment complete (State condition and at what call)\r\n11-99: Officer requires help, Emergency\r\n\n\r\n\r\nStatus-codes:\r\nStatus 1: In Service\r\nStatus 2: Out of Service\r\n\r\nIdentity Codes:\r\nIC-1: White\r\nIC-2: Black\r\nIC-3: Latino or Mexican\r\nIC-4: Middle-Eastern\r\nIC-5: Asian\r\nIC-6: Unknown ethnicity.\r\n\r\n\r\nSituation codes:\r\nCode 0: Absolute emergency, drop everything youâ€™re doing and respond immediately.\r\nCode 1: Non-emergency. If you\'re doing something, deal with it first. Respond without lights or sirens.\r\nCode 2: Non-emergency. If you\'re doing something, drop it and respond. Respond with lights only.\r\nCode 3: There is an emergency. Respond with lights and sirens.\r\nCode 4: No assistance required, situation under control.\r\nCode 5: All units stay out of <location>.\r\nCode 6: Out of car at <location>.\r\nCode 7: Meal break.\n\r\n\r\nCriminal Codes:\r\n148: Resisting Arrest \r\n187: Homicide\r\n207: Kidnapping\r\n211: Robbery\r\n240: Assault\r\n417: Brandishing a weapon\r\n459: Burglary\r\n487: Petty Theft\r\n602: Trespass/Fraud\r\n\n', null, '20', '1', '0');
INSERT INTO `factions` VALUES ('64', 'San Andreas Public Transport', '10000087731', '5', 'Suspended/ On Leave', 'M&ER Team Member', '---', 'Trainee Train Driver', 'Freight Train Driver', 'Public Train Driver', 'Trainee Taxi Driver', 'Taxi Driver I', 'Taxi Driver II', 'Taxi Driver III', 'Taxi Team Supervisor', 'Trainee Bus Driver', 'Bus Driver Class C', 'Bus Driver Class B', 'Bus Driver Class A', 'Bus Team Supervisor', 'Dispatcher', 'Chief of Staff', 'Chief Administrative Officer', 'Chief Executive Officer', '0', '300', '0', '200', '0', '0', '300', '450', '550', '650', '700', '300', '450', '525', '625', '750', '670', '850', '1000', '1200', '|| Radio freq: 201409 || 3 Days Inactivity = Suspended - 6 Days Inactivity = Kicked || The faction is under a few changes. Please be responsive when prompted help!', '---SAPT ADs------\nSAPT | Bus traffic: LINE from STARTSTOP@TIME, OPPOSITESTOP@TIME | Hotline: 88-00\n\nExample with 1 bus on route:\np SAPT | Bus traffic: 101 from Unity@10:10, from Dillimore@10:10 | Hotline: 88-00\n\nExample with 2 buses on same route:\nSAPT | Bus traffic: 101 from Unity@10:10, from Dillimore@10:10 | Hotline: 88-00\n\n---- X1 -----\n\nSAPT | Bus traffic: X1 from Docks@14:50, from RS Haul@15:10 | Hotline: 88-00\n----\nExample with several routes:\nSAPT | Bus traffic: 101 from Unity@10:10, from Dillimore@10:20, X1 from Ocean Docks@10:00, from RS Haul@10:30 | Hotline: 88-00\n!--This actually fits, tested--!\n\nExample for Taxi:\np San Andreas Public Transport | Taxi Transportation | Hotline: 8800\n\nADS:\nTrain Driver:\np San Andreas Public Transport - Now HIRING: Train Drivers - http://bit.ly/sapttraindriverapp\nBus:\np San Andreas Public Transport - Now HIRING: Bus Drivers - http://bit.ly/saptbusdriverapp\nTaxi:\np San Andreas Public Transport - Now HIRING: Taxi Drivers - http://bit.ly/sapttaxidriverapp\nAll:\np San Andreas Public Transport - Now HIRING - http://j.mp/sapt_app\n\np San Andreas Public Transport - Now HIRING - Head to our HQ for an Interview  - Hotline: 8800\n\n\n\nSan Andreas Public Transport is looking for experienced taxi, bus and train drivers. Company is also hiring dispatchers and mechanics for emergency response team. | Apply at www.bit.ly/sapt_form\n\n', '--- NOTES ---\nFaction radio channel: 201409\n((Make sure you\'ve requested yourself permissions to access our Internal Forums >> http://forums.owlgaming.net/profile.php?do=editusergroups ))\n\n(( Panic Butoon \nAll of our buses and trains are RPly fitted with panic button. Use /me to press it and afterwards send a message to /d\r\nSAPT vehicle (vehicle number) is sending an automatic distress signal at (location)\n))\n\n-- RULES -- (in works)\n\n1. Vehicles & driving\r \n---------------------------------------\n1.1 Only use vehicles that are for you\r\n1.1.1 bus drivers are allowed to drive vehicles categorized under numbers 100-200 for city routes and 500-600 for outer city routes\r\n1.1.2 maintenance & response team members are allowed to use vehicles under numbers 900-1000\r\n1.1.3 train drivers are only allowed to drive trains\r\n1.1.4 trainee members are not allowed to drive any vehicle without supervisor\r\n\r\n1.2 After leaving your vehicle make sure you leave it properly\r\n1.2.1 turn off it\'s radio\r\n1.2.2 park it to it\'s designated position\r\n1.2.3 lock it\'s doors and remove your personal belongings\r\n1.2.4 do not remove equipment meant for those vehicles\r\n\r\n1.3 Buses\r\n1.3.1 when there are passengers on-board do not set radio volume higher than 20 and do not listen to disturbingly loud radio stations.\r\n1.3.2 speed limits for sa-pt bus drivers:\r\n1.3.2.1 in small city roads no more than 40 km/h\r\n1.3.2.2 in bigger city roads no more than 60 km/h\r\n1.3.2.3 in 4 lane city roads no more than 70 km/h\n1.3.2.4 outside of city no more than 80 km/h\r\n1.3.2.5 on highways do not go over 90 km/h\r\n\r\n1.4 Trains\r\n1.4.1 speed limits for sa-pt trains:\r\n1.4.1.1 inside of city: 80 km/h\r\n1.4.1.2 outside of city: 120 km/h\r\n1.4.1.3 near crossings: Your speed has to be so slow that crossing bars can land fully before you arrive\r\n\r\n1.5 Maintenance & Response vehicles\r\nâ€‹1.5.1 You are only allowed to use SAPT vehicles if you\'re required to use these for duty\r\n1.5.2 Obey all traffic laws\r\n1.5.3 You are allowed to use probes only in case of following situations:\r\n1.5.3.1 You are transporting other vehicles with Flatbed or Wrecker\r\n1.5.3.2 You are stopping in dangerous position for maintenance / response work\r\n1.5.3.3 You are driving to respond to emergency\r\n\r\n1.6 Parking & waiting outside of SAPT areas\r\n1.6.1 Do not park vehicles on sidewalks, look for a proper parking location\r\n1.6.2 If bus needs to wait over 5 minutes in bus stop, move your bus away from the road\r\n1.6.3 In case of emergency turn on your hazard lights\r\n\r\n1.7 Driving \r\n1.7.1 Always obey speed limits set by our company\r\n1.7.2 Do not drive on sidewalks\r\n1.7.3 When driving always keep in one lane, do not drive on the lane lines\r\n1.7.4 In curves always slow down even more\r\n-----------------------------------\n2. Worktime\r\n----------------------------------\n2.1 On Duty\r\n2.1.1 Always report in radio when you start your work\r\n2.1.2 When you start your work please click on your badge (equip it)\r\n2.1.3 When starting to drive always insert your driver\'s card (otherwise buses and trains won\'t even turn on)\r\n2.1.4 When your work ends always remove your card and un-click your badge\r\n2.1.5 No smoking when you are on-duty\r\n\r\n2.2 Free time\r\n2.2.1 When you are off-duty you are allowed to relax in our office\'s relaxation area\r\n2.2.2 When you are off-duty you are allowed to keep your vehicle in our parking lot\r\n2.2.3 When you are off-duty you are not allowed to use our vehicles & equipment\r\n\r\n2.3 Clothing\r\n2.3.1 Our company have uniform, contact with James Hamilton (harut) to get one.\n2.3.2 You aren\'t allowed to weard dirty clothes\r\n\n2.4 Duty extra\r\n2.4.1 If bus trainee does at least not try to get route permission (by doing the test) at least in 10 days after joining, his/her contract will be terminated\r\n2.4.2 If person hasn\'t showed up in working log\'s at least for 7 days, his/her contract will be terminated.\n--------------------------\n3. Leaving work & switching career inside the company\r\n-------------------------\n3.1 Leaving SAPT\r\n3.1.1 You are allowed to leave SAPT after a week long notice (after telling to leave you need to wait for 1 week)\r\n3.1.2 You are allowed to leave SAPT in case of health disorder\r\n3.1.3 After leaving SAPT you are not allowed to re-join the company within the next 30 days\r\n\r\n3.2 Switching career\'s inside the company\r\n3.2.1 You are allowed to switch careers inside our company only if your current section leader approves it (James = Bus and Taxi, Dwayne = Maintenance)\r\n3.2.2 Usually switching positions are permitted only if your current section has enough workers to replace you\r\n\r\n3.3 Vacation\n3.3.1 You allowed to take 4 free days per month.\r\n3.3.2 Taking more free days will result in unpaid vacation and is only allowed after approval of section head\n--------------------------\n4. Adverts\n-------------------------\n---SAPT ADs------\nSAPT | Bus traffic: LINE from STARTSTOP@TIME, OPPOSITESTOP@TIME | Hotline: 8800\n\nExample for Taxi:\np San Andreas Public Transport | Taxi Transportation | Hotline: 8800.\n\n\n', '8800', '20', '1', '0');
INSERT INTO `factions` VALUES ('66', 'The Montalvo Connection', '0', '1', 'Inactive', 'Wahya', 'Preso', 'Halcone', 'Sicario', 'Soldado', 'Lugarteniente', 'Capo', 'Dynamic Rank #9', 'Dynamic Rank #10', 'Dynamic Rank #11', 'Dynamic Rank #12', 'Dynamic Rank #13', 'Dynamic Rank #14', 'Dynamic Rank #15', 'Dynamic Rank #16', 'Dynamic Rank #17', 'Dynamic Rank #18', 'Dynamic Rank #19', 'Dynamic Rank #20', '100', '100', '100', '100', '100', '100', '100', '100', '100', '100', '100', '100', '100', '100', '100', '100', '100', '100', '100', '100', 'Refrain from doing anything illegal in fronts. Refrain from dealing in Idlewood/Ganton!', '-GUN PRICES-\nColts  3,5k mag 500\nDeagle 4k mag 500\nsilenced 6k mag 1k\nUzi 6k mag 1k\nMP5 13k mag 1k\nShotgun 4.5k mag 500\nRifle 6k mag 1k\nAK 20k mag 2k\nSawed-off 7k mag 200\n\n-DRUG PRICES-\nCocaine - (only sell in bulk) - $60 per gram - 60k per kilo ( Deal with bikers )\n\nInventory:\n\n-RV DRUGS-\n? marijuana\nno more cocaine-\n100 lsd\n\n-BOAT DRUGS-\n\n\n-TOTAL GUNS-\n20 Deagles, 37 mags\n25 Colts, 74 mags\n16 Silenceds, 47 mags\n10 Shotguns, 31 mags\n7 Sawed-offs, 28 mags\n8 Uzis, 16 mags\n13 MP5s, 26 mags\n14 rifles, 15 mags\n6 AKs, 14 mags\n\n\n-RV GUNS-\n15 Deagles, 27 mags\n13 Colts, 36 mags\n8 Silenceds, 23 mags\n9 Shotguns, 21 mags\n4 Sawed-offs, 16 mags\n5 Uzis, 10  mags\n8 MP5s, 16 mags\n6 Rifles,  7 mags\n5 AKs, 11 mags\n1 molotovs, 4 mags\n\n-BOAT GUNS-\n5 Deagles, 10 mags\n12 Colts, 40 mags\n8 Silenceds, 24 mags\n5 Shotguns, 18 mags\n3 sawed-offs, 12 mags\n3 Uzis, 6 mags\n5 MP5s, 10 mags\n6  Rifles, 6 mags\n1 AK, 3 mags\n\n\nPeople who owe money:\nFebruary: Armando - 2 deagles 2 colts 1 shotgun 1 rifle - 2 mags each except rifle - TOTAL: 31,5k Paid -cut 3,5k\nPablo - 60.5k\nTheodore - 1kg of Cocaine - 60k -cut for Jimenez - 55k\n\nSantiago 138,8k - Paid minus cuts = 120k left (Paid to theodore)\nTheodore 94,5k\n\n\n\nTheodore\'s drop:\nSantiago - 38k\nNorman - 15k paid\nEnrique - 25k\n\nMembers outside the F3:\nMarcus Contreras\nConnor Shelby\n\n\nADVERT FORMATS -\n\n|| El Toro Borracho || Enjoy the Mexican-American culture! || Lctd. North of Glen Park ||\nMPOV Adult Entertainment - Bringing you the best adult videos! || Hiring female models! || Contact: Website - http://goo.gl/CxWmYR | #369-951 or #806-024 for interviews.\np 331 Latexican Mechanics & Customs || STOCK CLEARENCE! - Half Priced quality upgrades! | Lctd. North Pasadena Blvd./Corner w/ Western Ave./ Market\n\nInactivity notices:\nArwin (Reach) - Inactive cause of Christmas preparations etc\n\ngate larsteosack\n', 'Colts  3,5k mag 500\nDeagle 4k mag 500\nsilenced 6k mag 1k\nUzi 6k mag 1k\nMP5 10k mag 1k\nShotgun 4.5k mag 500\nRifle 6k mag 1k\nAK 20k mag 2k\nSawed-off 7k mag 200\n\n', null, '20', '1', '0');
INSERT INTO `factions` VALUES ('69', 'Department of Motor Vehicles', '0', '3', 'Customs Service', 'Dynamic Rank #2', 'Dynamic Rank #3', 'Dynamic Rank #4', 'Dynamic Rank #5', 'Dynamic Rank #6', 'Dynamic Rank #7', 'Dynamic Rank #8', 'Dynamic Rank #9', 'Dynamic Rank #10', 'Dynamic Rank #11', 'Dynamic Rank #12', 'Dynamic Rank #13', 'Dynamic Rank #14', 'Dynamic Rank #15', 'Dynamic Rank #16', 'Dynamic Rank #17', 'Dynamic Rank #18', 'Dynamic Rank #19', 'Dynamic Rank #20', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', 'Welcome to the faction.', 'Faction ID 69\n', 'Faction ID 69\n\n---\n\n10/02/2015\nYou withdrew $1,471,340 from your business account.\nYou have donated $1,471,340 to charity.\n\n', null, '20', '1', '0');
INSERT INTO `factions` VALUES ('78', 'Los Santos County Sheriff\'s Department', '10000128165', '2', 'Ä°zinli / Pasif / CezalÄ±', 'Academy Student', 'Trial Deputy Sheriff', 'Deputy Sheriff I', 'Deputy Sheriff II', 'Senior Deputy Sheriff', 'Corporal', 'Sergeant', 'Administrative Sergeant ', 'Lieutenant', 'Captain', 'Area Commander', 'Division Chief', 'Assistant Sheriff', 'Under Sheriff', 'Sheriff', 'gereksiz', 'gereksiz', 'gereksiz', 'gereksiz', '0', '50', '200', '250', '300', '350', '400', '450', '500', '550', '600', '100', '100', '100', '100', '100', '100', '100', '100', '100', 'Devriyeye Ã§Ä±ktÄ±ÄŸÄ±nÄ±z sÃ¼rece Discord Ã¼zerinde birim odanÄ±zda bulunmanÄ±z gerekiyor.', 'sass\n', 'saas\n', null, '20', '6', '1');

-- ----------------------------
-- Table structure for `feedbacks`
-- ----------------------------
DROP TABLE IF EXISTS `feedbacks`;
CREATE TABLE `feedbacks` (
  `id` int(11) NOT NULL,
  `staff_id` int(11) NOT NULL,
  `from_id` int(11) NOT NULL,
  `rating` int(11) NOT NULL DEFAULT '3',
  `comment` varchar(500) DEFAULT NULL,
  `date` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of feedbacks
-- ----------------------------

-- ----------------------------
-- Table structure for `force_apps`
-- ----------------------------
DROP TABLE IF EXISTS `force_apps`;
CREATE TABLE `force_apps` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account` int(11) DEFAULT NULL,
  `forceapp_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `id_UNIQUE` (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC COMMENT='Save forceapped players information to keep them from resubm';

-- ----------------------------
-- Records of force_apps
-- ----------------------------

-- ----------------------------
-- Table structure for `friends`
-- ----------------------------
DROP TABLE IF EXISTS `friends`;
CREATE TABLE `friends` (
  `id` int(10) unsigned NOT NULL,
  `friend` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`,`friend`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of friends
-- ----------------------------

-- ----------------------------
-- Table structure for `fuelpeds`
-- ----------------------------
DROP TABLE IF EXISTS `fuelpeds`;
CREATE TABLE `fuelpeds` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `posX` float NOT NULL,
  `posY` float NOT NULL,
  `posZ` float NOT NULL,
  `rotZ` float NOT NULL,
  `interior` int(11) NOT NULL DEFAULT '0',
  `dimension` int(11) NOT NULL DEFAULT '0',
  `skin` int(3) DEFAULT '50',
  `name` varchar(50) NOT NULL,
  `deletedBy` int(11) DEFAULT '0',
  `shop_link` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of fuelpeds
-- ----------------------------

-- ----------------------------
-- Table structure for `fuelstations`
-- ----------------------------
DROP TABLE IF EXISTS `fuelstations`;
CREATE TABLE `fuelstations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `x` decimal(10,6) DEFAULT '0.000000',
  `y` decimal(10,6) DEFAULT '0.000000',
  `z` decimal(10,6) DEFAULT '0.000000',
  `interior` int(5) DEFAULT '0',
  `dimension` int(5) DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of fuelstations
-- ----------------------------

-- ----------------------------
-- Table structure for `furnitures`
-- ----------------------------
DROP TABLE IF EXISTS `furnitures`;
CREATE TABLE `furnitures` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `x` int(11) DEFAULT '0',
  `y` int(11) DEFAULT '0',
  `z` int(11) DEFAULT '0',
  `rot` int(11) DEFAULT '0',
  `interior` int(11) DEFAULT '0',
  `dimension` int(11) DEFAULT '0',
  `placed` varchar(255) COLLATE utf8_turkish_ci DEFAULT '0',
  `allData` varchar(255) COLLATE utf8_turkish_ci DEFAULT '0',
  `owner` int(11) DEFAULT NULL,
  `rotation` int(11) DEFAULT '0',
  `model` varchar(255) COLLATE utf8_turkish_ci DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COLLATE=utf8_turkish_ci ROW_FORMAT=COMPACT;

-- ----------------------------
-- Records of furnitures
-- ----------------------------

-- ----------------------------
-- Table structure for `furnitures_texture`
-- ----------------------------
DROP TABLE IF EXISTS `furnitures_texture`;
CREATE TABLE `furnitures_texture` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `interior` varchar(255) COLLATE utf8_turkish_ci DEFAULT NULL,
  `texture` varchar(255) COLLATE utf8_turkish_ci DEFAULT NULL,
  `url` varchar(255) COLLATE utf8_turkish_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_turkish_ci ROW_FORMAT=COMPACT;

-- ----------------------------
-- Records of furnitures_texture
-- ----------------------------

-- ----------------------------
-- Table structure for `gates`
-- ----------------------------
DROP TABLE IF EXISTS `gates`;
CREATE TABLE `gates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `objectID` int(11) NOT NULL,
  `startX` float NOT NULL,
  `startY` float NOT NULL,
  `startZ` float NOT NULL,
  `startRX` float NOT NULL,
  `startRY` float NOT NULL,
  `startRZ` float NOT NULL,
  `endX` float NOT NULL,
  `endY` float NOT NULL,
  `endZ` float NOT NULL,
  `endRX` float NOT NULL,
  `endRY` float NOT NULL,
  `endRZ` float NOT NULL,
  `gateType` tinyint(3) unsigned NOT NULL,
  `autocloseTime` int(4) NOT NULL,
  `movementTime` int(4) NOT NULL,
  `objectDimension` int(11) NOT NULL,
  `objectInterior` int(11) NOT NULL,
  `gateSecurityParameters` text,
  `creator` varchar(50) NOT NULL DEFAULT '',
  `createdDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `adminNote` varchar(300) NOT NULL DEFAULT '',
  `triggerDistance` float DEFAULT NULL,
  `triggerDistanceVehicle` float DEFAULT NULL,
  `sound` varchar(50) DEFAULT 'metalgate',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=330 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of gates
-- ----------------------------
INSERT INTO `gates` VALUES ('4', '3055', '1588.5', '-1637.8', '14.6', '0', '0', '0', '1588.5', '-1640', '16.5', '270', '0', '0', '7', '50', '25', '0', '0', '1', 'bekiroj', '2014-02-06 19:14:12', 'LSPD GATE 4', '0', '15', 'metalgate');
INSERT INTO `gates` VALUES ('8', '2949', '1584.11', '-1638.07', '12.5', '0', '0', '260', '1582.65', '-1638.07', '15.5', '0', '0', '180', '7', '50', '15', '0', '0', '1', 'Sauron', '2015-01-08 10:24:24', 'LSPD GATE 1', '5', '0', 'metalgate');
INSERT INTO `gates` VALUES ('9', '968', '1544.7', '-1630.9', '13.1', '0', '270', '270', '1544.7', '-1630.7', '13', '0', '180', '270', '7', '40', '15', '0', '0', '1', 'bekiroj', '2014-04-08 10:17:41', 'LSPD GATE 3', '35', '35', null);
INSERT INTO `gates` VALUES ('129', '971', '923.55', '-1216.5', '17.7', '0', '0', '90', '923.2', '-1216.2', '11.4', '0', '0', '90.2', '10', '60', '25', '0', '0', 'VinewoodGardens', 'bekiroj', '2014-06-18 06:56:59', 'GATE 4', '35', '35', 'metalgate');
INSERT INTO `gates` VALUES ('143', '2930', '923.6', '-1209.1', '18.6', '0', '0', '0', '923.6', '-1209.1', '18.6', '0', '0', '260', '10', '45', '15', '0', '0', 'VinewoodGardens', 'S3LCUK', '2014-06-18 07:13:58', 'GATE 2', '35', '35', 'metalgate');
INSERT INTO `gates` VALUES ('329', '3055', '1564', '-1609.96', '13.3828', '0', '0', '90', '1560.87', '-1610.09', '17.02', '99', '0', '90', '7', '40', '17', '0', '0', '1', 'Blodygard', '2014-12-24 05:23:51', 'LSPD GATE 2', '14', '14', 'metalgate');

-- ----------------------------
-- Table structure for `health_diagnose`
-- ----------------------------
DROP TABLE IF EXISTS `health_diagnose`;
CREATE TABLE `health_diagnose` (
  `uniqueID` int(11) DEFAULT NULL,
  `int_diagnose` varchar(255) DEFAULT NULL,
  `ext_diagnose` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of health_diagnose
-- ----------------------------

-- ----------------------------
-- Table structure for `informationicons`
-- ----------------------------
DROP TABLE IF EXISTS `informationicons`;
CREATE TABLE `informationicons` (
  `id` int(10) DEFAULT NULL,
  `createdby` text,
  `x` float DEFAULT NULL,
  `y` float DEFAULT NULL,
  `z` float DEFAULT NULL,
  `rx` float DEFAULT NULL,
  `ry` float DEFAULT NULL,
  `rz` float DEFAULT NULL,
  `interior` float DEFAULT NULL,
  `dimension` float DEFAULT NULL,
  `information` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of informationicons
-- ----------------------------

-- ----------------------------
-- Table structure for `insurance_data`
-- ----------------------------
DROP TABLE IF EXISTS `insurance_data`;
CREATE TABLE `insurance_data` (
  `policyid` int(11) NOT NULL AUTO_INCREMENT,
  `customername` varchar(45) NOT NULL,
  `vehicleid` int(11) NOT NULL,
  `protection` varchar(45) NOT NULL,
  `deductible` int(11) NOT NULL,
  `date` date NOT NULL,
  `claims` float NOT NULL,
  `cashout` float NOT NULL,
  `premium` int(11) NOT NULL,
  `insurancefaction` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`policyid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of insurance_data
-- ----------------------------

-- ----------------------------
-- Table structure for `insurance_factions`
-- ----------------------------
DROP TABLE IF EXISTS `insurance_factions`;
CREATE TABLE `insurance_factions` (
  `factionID` int(11) NOT NULL,
  `name` varchar(45) NOT NULL,
  `gen_maxi` float NOT NULL DEFAULT '0',
  `news` text,
  `subscription` text,
  PRIMARY KEY (`factionID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of insurance_factions
-- ----------------------------

-- ----------------------------
-- Table structure for `interiors`
-- ----------------------------
DROP TABLE IF EXISTS `interiors`;
CREATE TABLE `interiors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `x` float DEFAULT '0',
  `y` float DEFAULT '0',
  `z` float DEFAULT '0',
  `type` int(1) DEFAULT '0',
  `owner` int(11) DEFAULT '-1',
  `locked` int(1) DEFAULT '0',
  `cost` int(11) DEFAULT '0',
  `name` text,
  `interior` int(5) DEFAULT '0',
  `interiorx` float DEFAULT '0',
  `interiory` float DEFAULT '0',
  `interiorz` float DEFAULT '0',
  `dimensionwithin` int(5) DEFAULT '0',
  `interiorwithin` int(5) DEFAULT '0',
  `angle` float DEFAULT '0',
  `angleexit` float DEFAULT '0',
  `supplies` int(11) DEFAULT '100',
  `safepositionX` float DEFAULT NULL,
  `safepositionY` float DEFAULT NULL,
  `safepositionZ` float DEFAULT NULL,
  `safepositionRZ` float DEFAULT NULL,
  `disabled` tinyint(3) unsigned DEFAULT '0',
  `lastused` datetime DEFAULT NULL,
  `deleted` varchar(45) NOT NULL DEFAULT '0',
  `createdDate` datetime DEFAULT NULL,
  `creator` varchar(45) DEFAULT NULL,
  `isLightOn` tinyint(4) NOT NULL DEFAULT '0',
  `keypad_lock` int(11) DEFAULT NULL,
  `keypad_lock_pw` varchar(32) DEFAULT NULL,
  `keypad_lock_auto` tinyint(1) DEFAULT NULL,
  `uploaded_interior` datetime DEFAULT NULL,
  `faction` int(11) DEFAULT '0',
  `protected_until` datetime DEFAULT NULL,
  `furniture` int(3) NOT NULL DEFAULT '1',
  `server` int(3) DEFAULT '1',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2696 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Records of interiors
-- ----------------------------
INSERT INTO `interiors` VALUES ('7', '1555.5', '-1675.6', '16.1953', '1', '-1', '0', '0', 'Ä°stanbul Ä°l Emniyet MÃ¼dÃ¼rlÃ¼ÄŸÃ¼', '105', '1405.64', '-1579.89', '1499.59', '0', '0', '0', '270.853', '97', null, null, null, null, '0', '2021-03-23 20:20:26', 'Falcon', '2015-02-17 00:36:24', 'Spl4z', '0', null, null, null, null, '1', null, '1', '1');
INSERT INTO `interiors` VALUES ('8', '982.462', '-1520.13', '13.5494', '1', '4', '0', '45000', 'Garaaz', '24', '529.506', '63.9219', '1044.46', '0', '0', '0', '1.34311', '100', null, null, null, null, '0', '2015-02-20 12:41:58', 'Kermoo', '2015-02-17 13:41:15', 'Spl4z', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('9', '1553.11', '-1674.57', '16.1953', '0', '-1', '1', '8000', 'Garage', '21', '-2031.88', '-118.21', '1039.3', '0', '0', '0', '188.454', '100', null, null, null, null, '0', null, 'pavlov', '2021-03-18 02:03:09', 'pavlov', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('10', '1524.49', '-1677.76', '6.21875', '2', '0', '0', '0', 'Ä°EM Garaj', '1', '1105.9', '-1312.8', '79.0625', '0', '0', '0', '2.64502', '100', null, null, null, null, '0', '2021-04-13 22:42:21', '0', '2019-02-04 19:04:56', 'Luess', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('11', '1905.96', '-2426.78', '13.5669', '2', '0', '0', '0', 'Garage #2', '56', '1956.86', '-2307.28', '14.0936', '10', '56', '0', '92.8441', '100', null, null, null, null, '0', '2019-02-04 19:48:44', 'Luess', '2019-02-04 19:47:46', 'Luess', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('12', '1181.71', '-1323.39', '15.406', '2', '-1', '0', '0', 'Ä°stanbul Devlet Hastanesi', '0', '1564.71', '1799.32', '2083.41', '0', '0', '0', '86.9993', '100', null, null, null, null, '0', '2021-04-12 11:43:26', '0', '2021-03-18 18:08:30', 'Ada', '0', null, null, null, null, '2', null, '1', '1');
INSERT INTO `interiors` VALUES ('13', '649.281', '-1360.68', '13.5853', '2', '0', '0', '0', 'TRT HABER', '3', '390.44', '173.91', '1008.38', '0', '0', '90', '278.703', '100', null, null, null, null, '0', '2021-03-26 23:53:21', '0', '2021-03-18 21:01:30', 'Ada', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('14', '2137.47', '-2131.48', '13.5469', '0', '-1', '1', '8000', 'Garage', '21', '-2031.88', '-118.21', '1039.3', '0', '0', '0', '61.1536', '100', null, null, null, null, '0', '2021-03-19 17:01:03', 'SeRsEm', '2021-03-19 17:00:31', 'SeRsEm', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('15', '1275.51', '-1414.35', '13.3266', '0', '-1', '1', '8000', 'Garage', '21', '-2031.88', '-118.21', '1039.3', '0', '0', '0', '229.379', '100', null, null, null, null, '0', null, 'pavlov', '2021-03-19 18:20:58', 'pavlov', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('16', '1851.08', '-1724.15', '31.8047', '0', '486', '0', '8000', 'Garage', '21', '-2031.88', '-118.21', '1039.3', '0', '0', '0', '307.383', '100', null, null, null, null, '0', '2019-02-05 16:51:01', 'Militan', '2019-02-05 16:43:33', 'Militan', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('17', '1597.55', '-1814.63', '13.4159', '1', '-1', '1', '1', '1 1 1', '3', '975.26', '-8.64', '1001.14', '0', '0', '90', '107.78', '100', null, null, null, null, '0', '2021-03-16 22:20:14', 'cosmopolitan', '2021-03-16 22:19:57', 'cosmopolitan', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('18', '1599.37', '-1815.23', '13.4253', '1', '-1', '1', '1', '1 1', '3', '975.26', '-8.64', '1001.14', '0', '0', '90', '100.661', '100', null, null, null, null, '0', null, 'cosmopolitan', '2021-03-16 22:20:29', 'Dtuna58', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('19', '1929.06', '-1776.25', '13.5469', '2', '0', '0', '0', 'Kartal Petrol Market', '18', '-31.02', '-91.92', '1003.54', '0', '0', '0', '94.5965', '100', null, null, null, null, '0', null, 'Ada', '2021-03-16 22:24:40', 'cosmopolitan', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('20', '2229.91', '-1721.27', '13.5614', '0', '22265', '0', '8000', 'XFIT Kuyu BaÅŸÄ± Spor Salonu', '31', '269.71', '-28.78', '988.79', '0', '0', '0', '313.464', '100', null, null, null, null, '0', '2021-04-04 00:44:39', '0', '2021-03-21 02:46:29', 'pavlov', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('21', '1181.71', '-1323.56', '15.4063', '0', '-1', '1', '8000', 'Garage', '21', '-2031.88', '-118.21', '1039.3', '0', '0', '0', '91.6246', '100', null, null, null, null, '0', null, 'pavlov', '2021-03-17 00:13:42', 'pavlov', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('22', '1181.71', '-1323.42', '15.4061', '0', '-1', '1', '8000', 'Garage', '21', '-2031.88', '-118.21', '1039.3', '0', '0', '0', '91.7125', '100', null, null, null, null, '0', null, 'pavlov', '2021-03-17 00:14:42', 'pavlov', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('23', '258.965', '-24.7617', '988.798', '0', '22123', '0', '8000', 'Spor Salonu', '47', '1573.45', '-2413.11', '13.6078', '20', '31', '270', '95.3436', '92', null, null, null, null, '0', '2021-03-29 22:04:47', '0', '2021-03-21 03:14:19', 'pavlov', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('24', '1498.36', '-1580.51', '13.5498', '0', '22124', '0', '8000', 'Garage', '21', '-2031.88', '-118.21', '1039.3', '0', '0', '0', '1.85947', '100', null, null, null, null, '0', '2021-03-21 07:03:02', 'pavlov', '2021-03-21 06:51:37', 'pavlov', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('25', '1102.42', '-1440.3', '15.7969', '0', '-1', '1', '8000', 'Garage', '21', '-2031.88', '-118.21', '1039.3', '0', '0', '0', '88.9659', '100', null, null, null, null, '0', null, 'pavlov', '2021-03-21 06:52:24', 'pavlov', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('26', '1102.41', '-1458.01', '15.7969', '0', '-1', '1', '8000', 'Garage', '21', '-2031.88', '-118.21', '1039.3', '0', '0', '0', '104.32', '100', null, null, null, null, '0', null, 'pavlov', '2021-03-21 06:52:29', 'pavlov', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('27', '1133.42', '-1370.03', '13.9844', '0', '-1', '1', '8000', 'Garage', '21', '-2031.88', '-118.21', '1039.3', '0', '0', '0', '0.628967', '100', null, null, null, null, '0', null, 'pavlov', '2021-03-21 06:53:17', 'pavlov', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('28', '1498.38', '-1580.51', '13.5498', '0', '-1', '1', '8000', 'Garage', '21', '-2031.88', '-118.21', '1039.3', '0', '0', '0', '357.47', '100', null, null, null, null, '0', null, 'pavlov', '2021-03-21 07:03:28', 'pavlov', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('29', '1102.41', '-1457.77', '15.7969', '2', '0', '0', '0', 'Aksesuar MaÄŸazasÄ±', '1', '203.79', '-50.34', '1001.8', '0', '0', '0', '103.067', '100', null, null, null, null, '0', '2021-04-13 05:26:16', '0', '2021-03-21 07:04:39', 'pavlov', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('30', '1102.41', '-1440.21', '15.7969', '2', '0', '0', '0', 'Dupont MaÄŸazasÄ±', '14', '204.44', '-168.58', '1000.52', '0', '0', '0', '92.4102', '100', null, null, null, null, '0', '2021-04-16 13:05:06', '0', '2021-03-21 07:04:55', 'pavlov', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('31', '1133.45', '-1370.03', '13.9844', '2', '0', '0', '0', 'Mobilya MaÄŸazasÄ±', '27', '1877.89', '-2466.96', '13.58', '0', '0', '0', '359.981', '100', null, null, null, null, '0', '2021-04-13 05:25:57', '0', '2021-03-21 07:05:06', 'pavlov', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('32', '1498.33', '-1580.52', '13.5498', '2', '0', '0', '0', 'Vergi Dairesi', '24', '25.08', '-6.73', '40.43', '0', '0', '0', '359.981', '100', null, null, null, null, '0', '2021-04-13 03:49:40', '0', '2021-03-21 07:05:28', 'pavlov', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('33', '914.243', '-1004.63', '37.9794', '0', '22123', '0', '8000', 'Ã–zel Harekat Daire BaÅŸkanlÄ±ÄŸÄ±', '1', '-1800.77', '651.15', '960.386', '0', '0', '80', '181.066', '100', null, null, null, null, '0', '2021-03-26 15:22:59', '0', '2021-03-22 23:20:42', 'Falcon', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('34', '1097.7', '-1370.03', '13.9844', '2', '0', '0', '0', 'TRT Haber', '3', '975.26', '-8.64', '1001.14', '0', '0', '90', '359.184', '100', null, null, null, null, '0', '2021-03-26 19:04:10', 'kattolian', '2021-03-23 00:08:20', 'bekiroj', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('35', '1073.17', '-1384.81', '13.8687', '0', '-1', '1', '8000', 'Garage', '21', '-2031.88', '-118.21', '1039.3', '0', '0', '0', '297.874', '100', null, null, null, null, '0', null, 'pavlov', '2021-03-24 22:19:23', 'pavlov', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('36', '1496.9', '-687.893', '95.5633', '0', '-1', '1', '150000', 'Garage', '9', '83', '1322.48', '1083.86', '0', '0', '0', '354.614', '100', null, null, null, null, '0', '2021-04-09 07:16:33', '0', '2021-04-09 07:11:21', 'Rosel321', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('37', '2105.49', '-1806.61', '13.5547', '0', '-1', '1', '8000', 'Garage', '21', '-2031.88', '-118.21', '1039.3', '0', '0', '0', '276.005', '100', null, null, null, null, '0', null, 'pavlov', '2021-03-26 03:37:39', 'pavlov', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('38', '2105.49', '-1806.42', '13.5547', '1', '22156', '0', '10', 'Leziz Bekir Usta', '5', '372.18', '-133.28', '1001.49', '0', '0', '0', '270.051', '100', null, null, null, null, '0', '2021-04-13 04:39:42', '0', '2021-03-26 03:41:13', 'pavlov', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('39', '1247.7', '-1415.43', '13.4613', '0', '22136', '0', '8000', 'Boxing', '11', '501.84', '-67.84', '998.75', '0', '0', '180', '172.222', '100', null, null, null, null, '0', '2021-04-05 21:23:30', '0', '2021-03-26 14:13:24', 'Sauron', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('40', '1927.39', '-1779.57', '13.5469', '0', '-1', '1', '8000', 'Garage', '21', '-2031.88', '-118.21', '1039.3', '0', '0', '0', '88.7242', '100', null, null, null, null, '0', null, 'ibrhm', '2021-03-26 14:27:20', 'ibrhm', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('41', '1927.39', '-1779.59', '13.5469', '0', '-1', '1', '0', 'Benzin istasyonu Ä°GS', '6', '744.46', '1436.68', '1102.7', '0', '0', '0', '89.1087', '100', null, null, null, null, '0', null, 'ibrhm', '2021-03-26 14:30:00', 'ibrhm', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('42', '1927.39', '-1779.56', '13.5469', '2', '0', '0', '0', 'Market', '17', '-25.91', '-188.05', '1003.54', '0', '0', '0', '89.9657', '-524', null, null, null, null, '0', '2021-04-11 15:03:20', '0', '2021-03-26 14:34:34', 'ibrhm', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('43', '1520.14', '-696.448', '94.75', '0', '-1', '1', '15000', 'Garage', '21', '-2031.88', '-118.21', '1039.3', '0', '0', '0', '260.339', '100', null, null, null, null, '0', null, '0', '2021-04-09 07:22:21', 'Rosel321', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('44', '1520.21', '-686.655', '94.75', '0', '-1', '1', '15000', 'Garage', '3', '-204.31', '-44.08', '1002.27', '0', '0', '0', '288.761', '100', null, null, null, null, '0', null, '0', '2021-04-09 07:22:48', 'Rosel321', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('45', '1693.1', '1449.33', '10.7643', '2', '0', '0', '0', 'bekiroj', '3', '975.26', '-8.64', '1001.14', '0', '0', '90', '89.0263', '100', null, null, null, null, '0', '2021-04-11 19:16:11', '0', '2021-04-10 13:31:52', 'bekiroj', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('46', '2259.41', '-1019.12', '59.2971', '0', '-1', '1', '8000', 'Garage', '21', '-2031.88', '-118.21', '1039.3', '0', '0', '0', '52.5566', '100', null, null, null, null, '0', null, 'SeRsEm', '2021-03-26 19:55:20', 'SeRsEm', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('47', '1653.83', '-1655.25', '22.5156', '1', '22202', '0', '0', 'AtsÄ±zlar Holding AÅž', '24', '25.08', '-6.73', '40.43', '0', '0', '0', '0.33783', '100', null, null, null, null, '0', '2021-03-26 23:50:01', '0', '2021-03-26 20:11:35', 'cosmopolitan', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('48', '-3.08496', '-1.12695', '40.4297', '0', '-1', '0', '8000', 'Garage', '2', '1204.81', '-13.6', '1000.92', '47', '24', '0', '92.3223', '100', null, null, null, null, '0', '2021-03-26 23:49:54', '0', '2021-03-26 20:21:43', 'SeRsEm', '0', null, null, null, null, '907', null, '1', '1');
INSERT INTO `interiors` VALUES ('49', '462.271', '-1529.4', '29.9487', '2', '0', '0', '0', 'Elektronik MaÄŸaza', '6', '-2240.69', '128.43', '1035.41', '0', '0', '270', '267.875', '100', null, null, null, null, '0', '2021-04-15 20:07:17', '0', '2021-04-13 03:28:53', 'Helyumm', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('50', '872.459', '-17.9982', '64.1594', '0', '-1', '1', '8000', 'Garage', '21', '-2031.88', '-118.21', '1039.3', '0', '0', '0', '343.973', '100', null, null, null, null, '0', null, '0', '2021-03-26 20:39:04', 'cl4', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('51', '1332.21', '-633.469', '109.135', '0', '-1', '0', '8000', 'BARONOV MALÄ°KANE', '12', '2324.42', '-1149.2', '1050.71', '0', '0', '0', '183.779', '100', null, null, null, null, '0', '2021-04-09 07:05:36', '0', '2021-03-26 20:59:38', 'SeRsEm', '0', null, null, null, null, '908', null, '1', '1');
INSERT INTO `interiors` VALUES ('52', '1332.27', '-633.449', '109.135', '0', '-1', '1', '8000', 'Garage', '21', '-2031.88', '-118.21', '1039.3', '0', '0', '0', '180.401', '100', null, null, null, null, '0', null, 'SeRsEm', '2021-03-26 21:00:04', 'SeRsEm', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('53', '2421.55', '-1219.24', '25.5616', '0', '22164', '0', '8000', 'Garage', '3', '-2636.77', '1402.6', '906.46', '0', '0', '0', '4.13367', '26', null, null, null, null, '0', '2021-03-26 23:24:18', '0', '2021-03-26 21:08:47', 'cl4', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('54', '2068.67', '-1773.87', '13.5604', '0', '22165', '0', '8000', 'Ã‡ay Evi', '18', '-229.17', '1401.14', '27.76', '0', '0', '270', '106.599', '100', null, null, null, null, '0', '2021-03-26 23:51:50', '0', '2021-03-26 23:44:45', 'SeRsEm', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('55', '2224.88', '-1720.85', '13.5471', '0', '-1', '1', '8000', 'Garage', '21', '-2031.88', '-118.21', '1039.3', '0', '0', '0', '18.9544', '100', null, null, null, null, '0', null, 'pavlov', '2021-03-29 22:05:17', 'pavlov', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('56', '2224.53', '-1722.86', '13.5625', '0', '-1', '1', '8000', 'Garage', '21', '-2031.88', '-118.21', '1039.3', '0', '0', '0', '23.9478', '100', null, null, null, null, '0', null, 'pavlov', '2021-03-29 22:06:39', 'pavlov', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('57', '254.419', '-1367.17', '53.1094', '0', '4', '0', '5000', 'Richman 18', '6', '234.2', '1063.85', '1084.21', '0', '0', '0', '125.87', '100', null, null, null, null, '0', '2015-02-17 20:56:31', 'Kermoo', '2015-02-17 20:46:17', 'Kermoo', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('58', '2400.52', '-1982', '13.5469', '1', '-1', '1', '80000', 'Willowfield Gunstore', '1', '285.39', '-41.44', '1001.51', '0', '0', '0', '178.94', '100', null, null, null, null, '0', '2015-02-17 21:01:31', 'Kermoo', '2015-02-17 21:01:31', 'Kermoo', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('59', '2225.43', '-1724.25', '13.5625', '0', '-1', '1', '8000', 'Garage', '21', '-2031.88', '-118.21', '1039.3', '0', '0', '0', '359.19', '100', null, null, null, null, '0', null, 'pavlov', '2021-03-29 22:07:27', 'pavlov', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('60', '980.5', '-677.256', '121.976', '0', '4', '0', '1', 'Vinewood 85-1', '6', '234.2', '1063.85', '1084.21', '0', '0', '0', '210.921', '100', null, null, null, null, '0', '2015-02-19 16:06:19', 'Kermoo', '2015-02-18 12:51:22', 'Kermoo', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('61', '2227.25', '-1725.63', '13.546', '0', '-1', '1', '8000', 'Garage', '21', '-2031.88', '-118.21', '1039.3', '0', '0', '0', '14.5214', '100', null, null, null, null, '0', null, 'pavlov', '2021-03-29 22:13:25', 'pavlov', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('62', '1570.67', '-1337.54', '16.4844', '2', '0', '0', '0', 'Los Santose Pank', '3', '1269.72', '-714.956', '1135.41', '0', '0', '267.832', '159.648', '100', null, null, null, null, '0', '2018-12-10 18:25:21', 'Infantry', '2015-02-18 13:40:53', 'Kermoo', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('63', '461.708', '-1500.83', '31.045', '1', '-1', '1', '100000', 'Armani pood', '5', '227.08', '-8.14', '1002.21', '0', '0', '90', '280.719', '100', null, null, null, null, '0', '2015-02-19 14:30:33', 'Kermoo', '2015-02-19 14:30:33', 'Kermoo', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('64', '461.705', '-1500.89', '31.0447', '2', '0', '0', '0', 'Armani Riiete pood', '5', '227.08', '-8.14', '1002.21', '0', '0', '90', '280.697', '80', null, null, null, null, '0', '2019-01-19 13:52:38', 'Militan', '2015-02-19 14:32:28', 'Kermoo', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('65', '2225.69', '-1725.06', '13.5592', '0', '-1', '1', '8000', 'Garage', '21', '-2031.88', '-118.21', '1039.3', '0', '0', '0', '24.4257', '100', null, null, null, null, '0', null, 'pavlov', '2021-03-29 22:14:38', 'pavlov', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('66', '-61.2627', '-1116.95', '1.07812', '2', '-1', '0', '0', 'RS Haul - We\'ll dump your load.', '0', '1534.91', '1577.07', '10.8203', '0', '0', '359.816', '68.7178', '100', null, null, null, null, '0', '2018-12-30 15:12:26', 'TheniS', '2014-01-22 02:48:38', 'Maxime', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('67', '2244.45', '-1665.58', '15.4766', '2', '0', '0', '0', 'BÄ±nco Clothing Store', '15', '207.58', '-111', '1005.13', '0', '0', '0', '160.027', '-768', null, null, null, null, '0', '2021-03-27 18:30:08', '0', '2015-02-19 16:40:32', 'Kermoo', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('68', '461.688', '-1500.77', '31.0459', '2', '0', '0', '23', 'KÄ±yafet MaÄŸazasÄ±', '18', '161.46', '-96.72', '1001.8', '0', '0', '0', '281.949', '100', null, null, null, null, '0', '2021-04-14 13:23:40', '0', '2021-04-13 03:29:27', 'Helyumm', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('69', '374.335', '-2055.12', '8.01562', '2', '0', '0', '0', 'Dominos Pizza', '5', '372.18', '-133.28', '1001.49', '0', '0', '0', '88.9384', '100', null, null, null, null, '0', '2021-04-14 13:24:01', '0', '2021-04-13 03:35:27', 'Helyumm', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('70', '1628.69', '-1903.35', '13.5533', '1', '33', '0', '0', 'NyanCostums', '24', '529.506', '63.9219', '1044.46', '0', '0', '0', '90.3722', '100', null, null, null, null, '0', '2015-02-21 14:31:27', 'Kermoo', '2015-02-21 14:30:37', 'Kermoo', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('71', '1104.83', '-1370.03', '13.9844', '2', '0', '0', '0', 'TRT Haber', '77', '1150.19', '-808.095', '2099.07', '0', '0', '180', '359.459', '100', null, null, null, null, '0', '2021-04-16 13:03:56', '0', '2021-04-16 12:51:52', 'Helyumm', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('72', '1927.39', '-1779.59', '13.5469', '2', '0', '0', '0', 'IGS Market', '16', '-25.68', '-140.99', '1003.54', '0', '0', '0', '83.5386', '-382', null, null, null, null, '0', '2018-12-30 18:51:59', 'Jesse', '2015-02-21 21:51:29', 'Stayni', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('78', '1930.3', '-1785.27', '13.5469', '0', '-1', '1', '8000', 'Garage', '21', '-2031.88', '-118.21', '1039.3', '0', '0', '0', '229.055', '100', null, null, null, null, '0', null, 'George', '2015-03-03 17:42:41', 'king', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('79', '1957.86', '-1750.09', '13.3828', '0', '-1', '1', '8000', 'Garage', '21', '-2031.88', '-118.21', '1039.3', '0', '0', '0', '81.8247', '100', null, null, null, null, '0', null, 'George', '2015-03-03 17:44:10', 'George', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('81', '1927.56', '-1779.4', '13.5469', '2', '0', '0', '0', 'IGS Market', '3', '-204.31', '-44.08', '1002.27', '0', '0', '0', '227.698', '100', null, null, null, null, '0', null, 'Jesse', '2018-12-07 21:35:48', 'Jesse', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('82', '1310.04', '-1367.47', '13.5349', '3', '-1', '1', '0', 'LS Bank', '3', '390.44', '173.91', '1008.38', '0', '0', '90', '46.8711', '100', null, null, null, null, '0', null, 'Jesse', '2018-12-08 17:21:09', 'Jesse', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('83', '1309.92', '-1367.57', '13.5374', '2', '0', '0', '0', 'Ä°ÅŸ BankasÄ±', '101', '2236.95', '-1829.15', '1625.62', '0', '0', '0', '332.103', '100', null, null, null, null, '0', '2021-04-09 21:52:39', '0', '2018-12-08 17:21:52', 'Jesse', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('84', '1111.14', '-1795.61', '16.5938', '2', '0', '0', '0', 'DoF - LS', '5', '1104.17', '-778.245', '976.252', '0', '0', '0', '307.888', '100', null, null, null, null, '0', '2021-04-09 06:51:23', '0', '2018-12-08 17:33:48', 'Jesse', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('85', '2130.09', '-1761.96', '13.5625', '1', '67', '0', '1', 'Jefferson Pub', '1', '1105.9', '-1312.8', '79.0625', '0', '0', '0', '177.023', '100', null, null, null, null, '0', '2018-12-08 19:01:59', 'Infantry', '2018-12-08 18:53:41', 'OrchuN', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('86', '2480.97', '-1536.71', '24.1742', '0', '-1', '1', '8000', 'Garage', '21', '-2031.88', '-118.21', '1039.3', '0', '0', '0', '89.8228', '100', null, null, null, null, '0', null, 'Infantry', '2018-12-08 19:06:20', 'Infantry', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('87', '2480.88', '-1536.71', '24.1901', '0', '-1', '1', '8000', 'Garage', '21', '-2031.88', '-118.21', '1039.3', '0', '0', '0', '90.4491', '100', null, null, null, null, '0', null, 'Infantry', '2018-12-08 19:07:09', 'Infantry', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('88', '2480.88', '-1536.78', '24.1918', '0', '-1', '1', '8000', 'Garage', '21', '-2031.88', '-118.21', '1039.3', '0', '0', '0', '84.9723', '100', null, null, null, null, '0', null, 'Infantry', '2018-12-08 19:19:09', 'Infantry', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('89', '1172.08', '-1323.28', '15.4028', '0', '66', '0', '1', 'Los Santos Medical Departman', '21', '-2031.88', '-118.21', '1039.3', '0', '0', '0', '92.2289', '100', null, null, null, null, '0', '2018-12-08 19:46:07', 'Infantry', '2018-12-08 19:27:53', 'Infantry', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('90', '-1269.7', '-2070.65', '22.7583', '0', '66', '0', '1', 'PARKER HOME', '9', '2317.81', '-1026.55', '1050.21', '0', '0', '0', '265.805', '100', null, null, null, null, '0', '2018-12-08 21:41:05', 'Jesse', '2018-12-08 21:33:47', 'Infantry', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('91', '-1279.54', '-2053.43', '22.1605', '0', '66', '0', '1', 'Garage', '21', '-2031.88', '-118.21', '1039.3', '0', '0', '0', '258.597', '100', null, null, null, null, '0', '2018-12-08 21:42:10', 'Jesse', '2018-12-08 21:41:37', 'Infantry', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('92', '2229.92', '-1721.27', '13.5614', '0', '298', '0', '75000', 'FIGHT CLUB', '7', '773.93', '-78.49', '1000.66', '0', '0', '0', '317.254', '100', null, null, null, null, '0', '2018-12-30 16:10:41', 'Morningstar', '2018-12-09 11:59:36', 'Infantry', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('94', '2262.09', '-1722.92', '13.5469', '2', '0', '0', '0', 'ANAHTARCI', '3', '1494.28', '1303.91', '1093.28', '0', '0', '0', '4.28748', '100', null, null, null, null, '0', '2021-03-26 21:54:54', '0', '2018-12-09 12:27:37', 'Infantry', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('96', '375.924', '-2055.91', '8.01562', '2', '0', '0', '0', 'Starfish Pizza Stock Co.', '5', '372.18', '-133.28', '1001.49', '0', '0', '0', '190.673', '90', null, null, null, null, '0', '2019-01-31 23:02:55', 'Militan', '2018-12-09 15:38:37', 'Jesse', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('98', '1095', '-647.787', '113.648', '0', '66', '0', '1', 'Barnes Group Of Companies', '12', '2324.42', '-1149.2', '1050.71', '0', '0', '0', '178.275', '100', null, null, null, null, '0', '2018-12-10 19:54:57', 'Infantry', '2018-12-10 19:44:30', 'Infantry', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('104', '1524.48', '-1677.88', '6.21875', '2', '0', '0', '0', 'GARAJ', '1', '1105.9', '-1312.8', '79.0625', '0', '0', '0', '88.1749', '100', null, null, null, null, '0', '2019-01-29 18:40:58', 'Luess', '2018-12-14 18:45:21', 'Lucifer', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('105', '1489.35', '-1719.45', '8.24291', '0', '-1', '0', '1', 'Miguel\'s House', '1', '-1800.77', '651.15', '960.386', '0', '0', '80', '342.847', '100', null, null, null, null, '0', '2021-03-21 21:56:50', '0', '2018-12-14 20:20:30', 'Lucifer', '0', null, null, null, null, '47', null, '1', '1');
INSERT INTO `interiors` VALUES ('106', '1102.41', '-1440.11', '15.7969', '1', '131', '0', '0', 'Dupont Fashion', '14', '204.44', '-168.58', '1000.52', '0', '0', '0', '90.5205', '100', null, null, null, null, '0', '2018-12-15 19:15:35', 'Lucifer', '2018-12-15 13:35:43', 'Sequent', '0', null, null, null, null, '0', null, '0', '1');
INSERT INTO `interiors` VALUES ('107', '1836.4', '-1682.57', '13.3495', '1', '64', '0', '0', 'Alhambra, Idlewood.', '10', '2019.02', '1017.93', '996.87', '0', '0', '90', '197.589', '8', null, null, null, null, '0', '2021-03-17 15:37:20', 'EnesBey', '2018-12-15 13:48:50', 'Jesse', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('109', '189.638', '-1308.26', '70.2493', '0', '152', '0', '0', 'Dellacroe House', '7', '225.71', '1021.44', '1084.01', '0', '0', '0', '87.285', '100', null, null, null, null, '0', '2019-01-21 20:00:52', 'Luess', '2018-12-15 22:49:59', 'Tarathiel', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('110', '691.579', '-1276.01', '13.5607', '0', '-1', '0', '1', 'Adams Mansion', '5', '1260.84', '-785.42', '1091.9', '0', '0', '270', '271.463', '100', null, null, null, null, '0', '2019-01-21 18:46:13', 'Luess', '2018-12-16 18:36:15', 'Lucifer', '0', null, null, null, null, '90', null, '1', '1');
INSERT INTO `interiors` VALUES ('111', '1847.61', '-1871.57', '13.5781', '2', '0', '0', '0', 'ElectroStore, Idlewood', '6', '-2240.69', '128.43', '1035.41', '0', '0', '270', '261.498', '-475', null, null, null, null, '0', '2021-03-17 15:38:18', 'EnesBey', '2018-12-22 13:22:43', 'Jesse', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('112', '1073.06', '-1385.04', '13.8727', '2', '0', '0', '0', 'Petshop, Idlewood.', '3', '-2029.61', '-119.36', '1035.17', '0', '0', '0', '91.762', '72', null, null, null, null, '0', '2021-03-17 15:38:28', 'EnesBey', '2018-12-22 16:27:07', 'Jesse', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('116', '1797.5', '-1578.81', '14.0846', '2', '0', '0', '0', 'DoC', '47', '1816.81', '-1552.1', '60.1297', '0', '0', '270', '117.608', '100', null, null, null, null, '0', '2021-03-17 15:38:48', 'EnesBey', '2018-12-22 23:32:40', 'TheniS', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('117', '1652.13', '-1638.05', '84.165', '2', '-1', '0', '0', 'LSIA', '45', '1384.83', '1464.5', '10.8644', '0', '0', '295.149', '0.447693', '100', null, null, null, null, '0', '2021-03-17 15:38:55', 'EnesBey', '2018-12-23 10:44:53', 'TheniS', '0', null, null, null, null, '47', null, '1', '1');
INSERT INTO `interiors` VALUES ('118', '595.711', '-1250.81', '18.3016', '2', '0', '0', '0', 'Dupont Fashion', '18', '161.46', '-96.72', '1001.8', '0', '0', '0', '203.105', '100', null, null, null, null, '0', '2021-03-23 23:27:48', '0', '2018-12-23 13:57:38', 'Jesse', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('119', '1172.58', '-1323.35', '15.403', '2', '-1', '0', '0', 'LS Hospital', '0', '1564.71', '1799.32', '2083.41', '0', '0', '74.2', '343.649', '100', null, null, null, null, '0', '2021-03-17 15:39:27', 'EnesBey', '2018-12-23 15:37:30', 'Jesse', '0', null, null, null, null, '2', null, '1', '1');
INSERT INTO `interiors` VALUES ('150', '1221.16', '-1426.75', '13.4703', '2', '0', '0', '0', 'Los Santos News', '5', '1104.17', '-778.245', '976.252', '0', '0', '0', '234.696', '100', null, null, null, null, '0', '2019-01-18 23:42:23', 'Lucifer', '2019-01-18 23:41:08', 'Lucifer', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('153', '1142.82', '-1359.11', '13.7788', '0', '145', '0', '0', 'Hospital LS', '7', '315.79', '-143.27', '999.6', '0', '0', '0', '92.0146', '100', null, null, null, null, '0', '2019-01-18 10:51:47', 'Jesse', '2019-01-18 10:50:04', 'Morningstar', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('160', '138.55', '1436.85', '10.5994', '2', '0', '0', '0', 'LSPD Akademi', '0', '222.059', '157.328', '1014.15', '0', '0', '0', '69.4154', '100', null, null, null, null, '0', '2019-01-20 21:31:18', '0', '2019-01-20 20:11:08', 'Jesse', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('248', '273.172', '-195.573', '1.57045', '2', '-1', '0', '0', 'Bank of Los Santos - Blueberry Office', '5', '1104.17', '-778.245', '976.252', '0', '0', '0', '88.0156', '100', null, null, null, null, '0', '2015-02-08 23:10:16', '0', '2014-08-15 15:18:48', 'Belgica', '0', null, null, null, null, '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('617', '1712.04', '-1129.41', '24.0859', '2', '0', '0', '500000', 'Los Santos Fire Department', '1', '1509.1', '1333.9', '11', '0', '0', '88.2682', '5.38614', '100', null, null, null, null, '0', '2021-03-21 21:55:50', '0', '2014-03-12 18:55:33', 'Maxime', '0', null, null, null, '2015-01-11 13:33:51', '0', null, '1', '1');
INSERT INTO `interiors` VALUES ('2695', '1480.9', '-1771.56', '18.7958', '2', '-1', '0', '30000', 'Los Santose Linnahall', '21', '1533.33', '1474.73', '16.9535', '0', '0', '178.5', '268.458', '-125', null, null, null, null, '0', '2021-04-13 03:50:12', '0', '2015-01-16 16:05:51', 'Firebird', '0', null, null, null, null, '3', null, '1', '1');

-- ----------------------------
-- Table structure for `interior_business`
-- ----------------------------
DROP TABLE IF EXISTS `interior_business`;
CREATE TABLE `interior_business` (
  `intID` int(11) NOT NULL,
  `businessNote` varchar(101) NOT NULL DEFAULT 'Welcome to our business!',
  PRIMARY KEY (`intID`) USING BTREE,
  UNIQUE KEY `intID_UNIQUE` (`intID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='Saves info about businesses - Maxime';

-- ----------------------------
-- Records of interior_business
-- ----------------------------

-- ----------------------------
-- Table structure for `interior_logs`
-- ----------------------------
DROP TABLE IF EXISTS `interior_logs`;
CREATE TABLE `interior_logs` (
  `log_id` int(11) NOT NULL AUTO_INCREMENT,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `intID` int(11) DEFAULT NULL,
  `action` text,
  `actor` int(11) DEFAULT NULL,
  PRIMARY KEY (`log_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='Stores all admin actions on interiors - Monitored by Interio';

-- ----------------------------
-- Records of interior_logs
-- ----------------------------

-- ----------------------------
-- Table structure for `interior_notes`
-- ----------------------------
DROP TABLE IF EXISTS `interior_notes`;
CREATE TABLE `interior_notes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `intid` int(11) NOT NULL,
  `creator` int(11) NOT NULL DEFAULT '0',
  `note` text NOT NULL,
  `date` text,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of interior_notes
-- ----------------------------

-- ----------------------------
-- Table structure for `interior_textures`
-- ----------------------------
DROP TABLE IF EXISTS `interior_textures`;
CREATE TABLE `interior_textures` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `interior` int(11) NOT NULL,
  `texture` varchar(255) NOT NULL,
  `url` varchar(255) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of interior_textures
-- ----------------------------

-- ----------------------------
-- Table structure for `items`
-- ----------------------------
DROP TABLE IF EXISTS `items`;
CREATE TABLE `items` (
  `index` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type` tinyint(3) unsigned NOT NULL,
  `owner` int(10) unsigned NOT NULL,
  `itemID` int(10) NOT NULL,
  `itemValue` text NOT NULL,
  `protected` int(100) NOT NULL DEFAULT '0',
  PRIMARY KEY (`index`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6612566 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of items
-- ----------------------------

-- ----------------------------
-- Table structure for `jailed`
-- ----------------------------
DROP TABLE IF EXISTS `jailed`;
CREATE TABLE `jailed` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `charid` int(11) NOT NULL,
  `charactername` text NOT NULL,
  `jail_time` bigint(12) NOT NULL,
  `convictionDate` datetime DEFAULT NULL,
  `updatedBy` text NOT NULL,
  `charges` text NOT NULL,
  `cell` text NOT NULL,
  `fine` int(5) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of jailed
-- ----------------------------

-- ----------------------------
-- Table structure for `jobs`
-- ----------------------------
DROP TABLE IF EXISTS `jobs`;
CREATE TABLE `jobs` (
  `jobID` int(11) NOT NULL DEFAULT '0',
  `jobCharID` int(11) NOT NULL DEFAULT '-1',
  `jobLevel` int(11) NOT NULL DEFAULT '1',
  `jobProgress` int(11) NOT NULL DEFAULT '0',
  `jobTruckingRuns` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='Saves job info, skill level and progress - Maxime';

-- ----------------------------
-- Records of jobs
-- ----------------------------

-- ----------------------------
-- Table structure for `jobs_trucker_orders`
-- ----------------------------
DROP TABLE IF EXISTS `jobs_trucker_orders`;
CREATE TABLE `jobs_trucker_orders` (
  `orderID` int(11) NOT NULL AUTO_INCREMENT,
  `orderX` float NOT NULL DEFAULT '0',
  `orderY` float NOT NULL DEFAULT '0',
  `orderZ` float NOT NULL DEFAULT '0',
  `orderWeight` int(11) NOT NULL DEFAULT '0',
  `orderName` text NOT NULL,
  `orderInterior` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`orderID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='Saves info about customer orders to create markers for truck';

-- ----------------------------
-- Records of jobs_trucker_orders
-- ----------------------------

-- ----------------------------
-- Table structure for `leo_impound_lot`
-- ----------------------------
DROP TABLE IF EXISTS `leo_impound_lot`;
CREATE TABLE `leo_impound_lot` (
  `lane` int(11) NOT NULL AUTO_INCREMENT,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `rx` float NOT NULL,
  `ry` float NOT NULL,
  `rz` float NOT NULL,
  `int` float NOT NULL,
  `dim` float NOT NULL,
  `faction` int(11) NOT NULL,
  `veh` int(11) NOT NULL DEFAULT '0',
  `fine` int(11) NOT NULL DEFAULT '0',
  `release_date` datetime DEFAULT NULL,
  PRIMARY KEY (`lane`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of leo_impound_lot
-- ----------------------------

-- ----------------------------
-- Table structure for `lifts`
-- ----------------------------
DROP TABLE IF EXISTS `lifts`;
CREATE TABLE `lifts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `disabled` tinyint(1) NOT NULL DEFAULT '0',
  `comment` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of lifts
-- ----------------------------

-- ----------------------------
-- Table structure for `lift_floors`
-- ----------------------------
DROP TABLE IF EXISTS `lift_floors`;
CREATE TABLE `lift_floors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `lift` int(11) NOT NULL,
  `x` float(10,6) DEFAULT '0.000000',
  `y` float(10,6) DEFAULT '0.000000',
  `z` float(10,6) DEFAULT '0.000000',
  `dimension` int(5) DEFAULT '0',
  `interior` int(5) DEFAULT '0',
  `floor` varchar(3) NOT NULL,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of lift_floors
-- ----------------------------

-- ----------------------------
-- Table structure for `lottery`
-- ----------------------------
DROP TABLE IF EXISTS `lottery`;
CREATE TABLE `lottery` (
  `characterid` int(255) NOT NULL,
  `ticketnumber` int(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of lottery
-- ----------------------------

-- ----------------------------
-- Table structure for `makeammolog`
-- ----------------------------
DROP TABLE IF EXISTS `makeammolog`;
CREATE TABLE `makeammolog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin` varchar(100) COLLATE utf8_turkish_ci DEFAULT NULL,
  `player` varchar(100) COLLATE utf8_turkish_ci DEFAULT NULL,
  `gun` varchar(100) COLLATE utf8_turkish_ci DEFAULT NULL,
  `ammovalue` varchar(255) COLLATE utf8_turkish_ci DEFAULT NULL,
  `reason` varchar(255) COLLATE utf8_turkish_ci DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2811 DEFAULT CHARSET=utf8 COLLATE=utf8_turkish_ci ROW_FORMAT=COMPACT;

-- ----------------------------
-- Records of makeammolog
-- ----------------------------

-- ----------------------------
-- Table structure for `makegunlog`
-- ----------------------------
DROP TABLE IF EXISTS `makegunlog`;
CREATE TABLE `makegunlog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin` varchar(100) COLLATE utf8_turkish_ci DEFAULT NULL,
  `player` varchar(100) COLLATE utf8_turkish_ci DEFAULT NULL,
  `gun` varchar(100) COLLATE utf8_turkish_ci DEFAULT NULL,
  `gunserial` varchar(255) COLLATE utf8_turkish_ci DEFAULT NULL,
  `reason` varchar(255) COLLATE utf8_turkish_ci DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=843 DEFAULT CHARSET=utf8 COLLATE=utf8_turkish_ci ROW_FORMAT=COMPACT;

-- ----------------------------
-- Records of makegunlog
-- ----------------------------

-- ----------------------------
-- Table structure for `mdcusers`
-- ----------------------------
DROP TABLE IF EXISTS `mdcusers`;
CREATE TABLE `mdcusers` (
  `user_name` varchar(20) NOT NULL,
  `password` varchar(20) NOT NULL DEFAULT '123',
  `high_command` int(1) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of mdcusers
-- ----------------------------

-- ----------------------------
-- Table structure for `mdc_apb`
-- ----------------------------
DROP TABLE IF EXISTS `mdc_apb`;
CREATE TABLE `mdc_apb` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `person_involved` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `doneby` int(11) NOT NULL,
  `time` int(11) NOT NULL,
  `organization` varchar(10) NOT NULL DEFAULT 'LSPD',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of mdc_apb
-- ----------------------------

-- ----------------------------
-- Table structure for `mdc_calls`
-- ----------------------------
DROP TABLE IF EXISTS `mdc_calls`;
CREATE TABLE `mdc_calls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `caller` varchar(50) NOT NULL,
  `number` varchar(10) NOT NULL,
  `description` varchar(255) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of mdc_calls
-- ----------------------------

-- ----------------------------
-- Table structure for `mdc_crimes`
-- ----------------------------
DROP TABLE IF EXISTS `mdc_crimes`;
CREATE TABLE `mdc_crimes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `crime` varchar(255) NOT NULL,
  `punishment` varchar(255) NOT NULL,
  `character` int(11) NOT NULL,
  `officer` int(11) NOT NULL,
  `timestamp` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of mdc_crimes
-- ----------------------------

-- ----------------------------
-- Table structure for `mdc_criminals`
-- ----------------------------
DROP TABLE IF EXISTS `mdc_criminals`;
CREATE TABLE `mdc_criminals` (
  `character` int(11) NOT NULL,
  `dob` varchar(10) NOT NULL DEFAULT 'mm/dd/yyyy',
  `ethnicity` varchar(50) NOT NULL DEFAULT 'Unknown',
  `phone` varchar(10) NOT NULL DEFAULT 'Unknown',
  `occupation` varchar(50) NOT NULL DEFAULT 'Unknown',
  `address` varchar(50) NOT NULL DEFAULT 'Unknown',
  `photo` int(11) NOT NULL DEFAULT '-1',
  `details` varchar(255) NOT NULL DEFAULT 'None',
  `created_by` int(11) NOT NULL DEFAULT '0',
  `wanted` int(11) NOT NULL DEFAULT '0',
  `wanted_by` int(11) NOT NULL DEFAULT '0',
  `wanted_details` varchar(255) DEFAULT NULL,
  `pilot_details` varchar(255) DEFAULT NULL,
  UNIQUE KEY `name` (`character`) USING BTREE,
  KEY `phone` (`phone`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of mdc_criminals
-- ----------------------------

-- ----------------------------
-- Table structure for `mdc_faa_events`
-- ----------------------------
DROP TABLE IF EXISTS `mdc_faa_events`;
CREATE TABLE `mdc_faa_events` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `crime` varchar(255) NOT NULL,
  `punishment` varchar(255) NOT NULL,
  `character` int(11) NOT NULL,
  `officer` int(11) NOT NULL,
  `timestamp` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of mdc_faa_events
-- ----------------------------

-- ----------------------------
-- Table structure for `mdc_faa_licenses`
-- ----------------------------
DROP TABLE IF EXISTS `mdc_faa_licenses`;
CREATE TABLE `mdc_faa_licenses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `character` int(11) NOT NULL,
  `timestamp` int(11) NOT NULL,
  `license` int(2) NOT NULL,
  `value` int(4) DEFAULT NULL,
  `officer` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of mdc_faa_licenses
-- ----------------------------

-- ----------------------------
-- Table structure for `mdc_impounds`
-- ----------------------------
DROP TABLE IF EXISTS `mdc_impounds`;
CREATE TABLE `mdc_impounds` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `veh` int(11) NOT NULL,
  `content` text,
  `reporter` text,
  `date` text,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of mdc_impounds
-- ----------------------------

-- ----------------------------
-- Table structure for `mdc_users`
-- ----------------------------
DROP TABLE IF EXISTS `mdc_users`;
CREATE TABLE `mdc_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user` varchar(30) NOT NULL,
  `pass` varchar(30) NOT NULL,
  `level` int(11) NOT NULL,
  `organization` varchar(30) NOT NULL DEFAULT 'LSPD',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of mdc_users
-- ----------------------------

-- ----------------------------
-- Table structure for `motds`
-- ----------------------------
DROP TABLE IF EXISTS `motds`;
CREATE TABLE `motds` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(70) NOT NULL,
  `content` text NOT NULL,
  `creation_date` datetime DEFAULT NULL,
  `expiration_date` datetime DEFAULT NULL,
  `author` int(11) DEFAULT NULL,
  `dismissable` tinyint(1) NOT NULL DEFAULT '1',
  `audiences` text NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of motds
-- ----------------------------

-- ----------------------------
-- Table structure for `motd_read`
-- ----------------------------
DROP TABLE IF EXISTS `motd_read`;
CREATE TABLE `motd_read` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `motdid` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC COMMENT='Note down everyone that read and dismissed the motd.';

-- ----------------------------
-- Records of motd_read
-- ----------------------------

-- ----------------------------
-- Table structure for `notifications`
-- ----------------------------
DROP TABLE IF EXISTS `notifications`;
CREATE TABLE `notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) NOT NULL,
  `title` text,
  `details` text,
  `date` text,
  `read` tinyint(1) NOT NULL DEFAULT '0',
  `offline_pm` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of notifications
-- ----------------------------

-- ----------------------------
-- Table structure for `nshops`
-- ----------------------------
DROP TABLE IF EXISTS `nshops`;
CREATE TABLE `nshops` (
  `id` int(5) NOT NULL AUTO_INCREMENT,
  `x` float DEFAULT NULL,
  `y` float DEFAULT NULL,
  `z` float DEFAULT NULL,
  `interior` int(5) DEFAULT NULL,
  `dimension` int(5) DEFAULT NULL,
  `type` int(5) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of nshops
-- ----------------------------
INSERT INTO `nshops` VALUES ('1', '375.721', '-118.812', '1001.5', '5', '38', '1');

-- ----------------------------
-- Table structure for `objects`
-- ----------------------------
DROP TABLE IF EXISTS `objects`;
CREATE TABLE `objects` (
  `id` int(11) NOT NULL,
  `model` int(6) NOT NULL DEFAULT '0',
  `posX` float(12,7) NOT NULL DEFAULT '0.0000000',
  `posY` float(12,7) NOT NULL DEFAULT '0.0000000',
  `posZ` float(12,7) NOT NULL DEFAULT '0.0000000',
  `rotX` float(12,7) NOT NULL DEFAULT '0.0000000',
  `rotY` float(12,7) NOT NULL DEFAULT '0.0000000',
  `rotZ` float(12,7) NOT NULL DEFAULT '0.0000000',
  `interior` int(5) NOT NULL,
  `dimension` int(5) NOT NULL,
  `comment` varchar(50) DEFAULT NULL,
  `solid` int(1) NOT NULL DEFAULT '1',
  `doublesided` int(1) NOT NULL DEFAULT '0',
  `scale` float(12,7) DEFAULT NULL,
  `breakable` int(1) NOT NULL DEFAULT '0',
  `alpha` int(11) NOT NULL DEFAULT '255'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Records of objects
-- ----------------------------

-- ----------------------------
-- Table structure for `payments`
-- ----------------------------
DROP TABLE IF EXISTS `payments`;
CREATE TABLE `payments` (
  `id` int(6) NOT NULL AUTO_INCREMENT,
  `txnid` varchar(20) NOT NULL,
  `payment_amount` decimal(7,2) NOT NULL,
  `payment_status` varchar(25) NOT NULL,
  `itemid` varchar(25) NOT NULL,
  `createdtime` datetime NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of payments
-- ----------------------------

-- ----------------------------
-- Table structure for `paynspray`
-- ----------------------------
DROP TABLE IF EXISTS `paynspray`;
CREATE TABLE `paynspray` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `x` decimal(10,6) DEFAULT '0.000000',
  `y` decimal(10,6) DEFAULT '0.000000',
  `z` decimal(10,6) DEFAULT '0.000000',
  `dimension` int(5) DEFAULT '0',
  `interior` int(5) DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of paynspray
-- ----------------------------

-- ----------------------------
-- Table structure for `payrexlogs`
-- ----------------------------
DROP TABLE IF EXISTS `payrexlogs`;
CREATE TABLE `payrexlogs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) DEFAULT NULL,
  `balance` int(255) DEFAULT NULL,
  `used` int(3) DEFAULT '0',
  `buyingDate` datetime DEFAULT NULL,
  `unused` int(3) DEFAULT '0',
  `salt` int(40) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Records of payrexlogs
-- ----------------------------

-- ----------------------------
-- Table structure for `peds`
-- ----------------------------
DROP TABLE IF EXISTS `peds`;
CREATE TABLE `peds` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `type` varchar(100) DEFAULT NULL,
  `behaviour` int(3) DEFAULT '1',
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `rotation` float NOT NULL,
  `interior` int(5) NOT NULL,
  `dimension` int(5) NOT NULL,
  `skin` int(1) DEFAULT NULL,
  `money` bigint(20) NOT NULL DEFAULT '0',
  `gender` int(1) DEFAULT NULL,
  `stats` text,
  `description` text,
  `owner_type` int(1) NOT NULL DEFAULT '0',
  `owner` int(11) DEFAULT NULL,
  `animation` varchar(255) DEFAULT NULL,
  `synced` tinyint(1) NOT NULL DEFAULT '0',
  `nametag` tinyint(1) NOT NULL DEFAULT '1',
  `frozen` tinyint(1) NOT NULL DEFAULT '0',
  `comment` varchar(255) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=142 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of peds
-- ----------------------------

-- ----------------------------
-- Table structure for `ped_inventory`
-- ----------------------------
DROP TABLE IF EXISTS `ped_inventory`;
CREATE TABLE `ped_inventory` (
  `index` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type` tinyint(3) unsigned NOT NULL,
  `owner` int(10) unsigned NOT NULL,
  `itemID` int(10) NOT NULL,
  `itemValue` text NOT NULL,
  PRIMARY KEY (`index`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of ped_inventory
-- ----------------------------

-- ----------------------------
-- Table structure for `ped_mission`
-- ----------------------------
DROP TABLE IF EXISTS `ped_mission`;
CREATE TABLE `ped_mission` (
  `char_id` int(11) NOT NULL,
  `mission` varchar(255) NOT NULL,
  `value` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of ped_mission
-- ----------------------------

-- ----------------------------
-- Table structure for `phones`
-- ----------------------------
DROP TABLE IF EXISTS `phones`;
CREATE TABLE `phones` (
  `phonenumber` int(1) NOT NULL,
  `turnedon` smallint(1) NOT NULL DEFAULT '1',
  `secretnumber` smallint(1) NOT NULL DEFAULT '0',
  `phonebook` varchar(40) NOT NULL DEFAULT '0',
  `ringtone` smallint(1) NOT NULL DEFAULT '3',
  `contact_limit` int(5) NOT NULL DEFAULT '50',
  `boughtby` int(11) NOT NULL DEFAULT '-1',
  `bought_date` datetime DEFAULT NULL,
  `sms_tone` smallint(1) NOT NULL DEFAULT '7',
  `keypress_tone` smallint(1) NOT NULL DEFAULT '1',
  `tone_volume` smallint(2) NOT NULL DEFAULT '10',
  `isWhatsapp` varchar(255) DEFAULT NULL,
  `phoneSetup` int(11) DEFAULT NULL,
  `phonePassword` int(4) DEFAULT NULL,
  `phonePasswordActive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`phonenumber`) USING BTREE,
  UNIQUE KEY `phonenumber_UNIQUE` (`phonenumber`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of phones
-- ----------------------------

-- ----------------------------
-- Table structure for `phones_sms_groups`
-- ----------------------------
DROP TABLE IF EXISTS `phones_sms_groups`;
CREATE TABLE `phones_sms_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT 'YOK',
  `users` text,
  `messages` text NOT NULL,
  `leader` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Records of phones_sms_groups
-- ----------------------------

-- ----------------------------
-- Table structure for `phone_contacts`
-- ----------------------------
DROP TABLE IF EXISTS `phone_contacts`;
CREATE TABLE `phone_contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `phone` bigint(20) NOT NULL,
  `entryName` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `entryNumber` bigint(20) NOT NULL,
  `entryEmail` varchar(60) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `entryAddress` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `entryFavorited` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `id_UNIQUE` (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of phone_contacts
-- ----------------------------

-- ----------------------------
-- Table structure for `phone_history`
-- ----------------------------
DROP TABLE IF EXISTS `phone_history`;
CREATE TABLE `phone_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from` bigint(20) NOT NULL,
  `to` bigint(20) NOT NULL,
  `state` tinyint(1) NOT NULL DEFAULT '1',
  `date` text COLLATE utf8_unicode_ci,
  `private` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `ID_UNIQUE` (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=144646 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of phone_history
-- ----------------------------

-- ----------------------------
-- Table structure for `phone_sms`
-- ----------------------------
DROP TABLE IF EXISTS `phone_sms`;
CREATE TABLE `phone_sms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from` bigint(20) NOT NULL,
  `to` bigint(20) NOT NULL,
  `content` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `date` text COLLATE utf8_unicode_ci,
  `viewed` tinyint(1) NOT NULL DEFAULT '0',
  `private` tinyint(1) NOT NULL DEFAULT '0',
  `isWhatsapp` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `ID_UNIQUE` (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of phone_sms
-- ----------------------------

-- ----------------------------
-- Table structure for `pilot_notams`
-- ----------------------------
DROP TABLE IF EXISTS `pilot_notams`;
CREATE TABLE `pilot_notams` (
  `id` int(11) NOT NULL,
  `information` longtext,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of pilot_notams
-- ----------------------------

-- ----------------------------
-- Table structure for `publicphones`
-- ----------------------------
DROP TABLE IF EXISTS `publicphones`;
CREATE TABLE `publicphones` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `dimension` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of publicphones
-- ----------------------------

-- ----------------------------
-- Table structure for `radio_stations`
-- ----------------------------
DROP TABLE IF EXISTS `radio_stations`;
CREATE TABLE `radio_stations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `station_name` text,
  `source` text,
  `owner` int(11) NOT NULL DEFAULT '0',
  `register_date` datetime DEFAULT NULL,
  `expire_date` datetime DEFAULT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  `order` int(5) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `id_UNIQUE` (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC COMMENT='Dynamic radio stations.';

-- ----------------------------
-- Records of radio_stations
-- ----------------------------
INSERT INTO `radio_stations` VALUES ('1', 'Metro FM', 'http://provisioning.streamtheworld.com/pls/METRO_FMAAC.pls', '0', null, null, '1', '1');
INSERT INTO `radio_stations` VALUES ('2', 'Joy FM', 'http://provisioning.streamtheworld.com/pls/JOY_FMAAC.pls', '0', null, null, '1', '2');
INSERT INTO `radio_stations` VALUES ('3', 'Pal Station', 'http://shoutcast.radyogrup.com:1020/listen.pls?sid=1', '0', null, null, '1', '5');
INSERT INTO `radio_stations` VALUES ('4', 'Radio Pro-Hit', 'http://asculta.radioprohit.ro:8000/', '0', null, null, '1', '1');
INSERT INTO `radio_stations` VALUES ('5', 'Joy Akustik', 'http://provisioning.streamtheworld.com/pls/JOYTURK_AKUSTIKAAC.pls', '0', null, null, '1', '5');
INSERT INTO `radio_stations` VALUES ('6', 'Fenomen Rap', 'http://fenomenoriental.listenfenomen.com/fenomenrap/128/icecast.audio ', '0', null, null, '1', '6');
INSERT INTO `radio_stations` VALUES ('7', 'Power R&B', 'http://powerrbhiphop.listenpowerapp.com/powerrbhiphop/mpeg/icecast.audio ', '0', null, null, '1', '7');
INSERT INTO `radio_stations` VALUES ('8', 'VÄ±rgÄ±n RadÄ±o', 'https://playerservices.streamtheworld.com/api/livestream-redirect/VIRGIN_RADIO.mp3 ', '0', null, null, '1', '8');
INSERT INTO `radio_stations` VALUES ('9', 'Mydonose Fm', 'https://playerservices.streamtheworld.com/api/livestream-redirect/RADIO_MYDONOSE.mp3 ', '0', null, null, '1', '9');
INSERT INTO `radio_stations` VALUES ('10', 'Rap Fm', 'http://cast1.taksim.fm:8018/; ', '0', null, null, '1', '10');

-- ----------------------------
-- Table structure for `ramps`
-- ----------------------------
DROP TABLE IF EXISTS `ramps`;
CREATE TABLE `ramps` (
  `id` int(2) NOT NULL AUTO_INCREMENT,
  `position` text,
  `interior` int(2) DEFAULT NULL,
  `dimension` int(2) DEFAULT NULL,
  `rotation` int(5) DEFAULT NULL,
  `creator` text,
  `state` int(2) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of ramps
-- ----------------------------

-- ----------------------------
-- Table structure for `restricted_freqs`
-- ----------------------------
DROP TABLE IF EXISTS `restricted_freqs`;
CREATE TABLE `restricted_freqs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `frequency` text,
  `limitedto` int(5) DEFAULT NULL,
  `addedby` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of restricted_freqs
-- ----------------------------

-- ----------------------------
-- Table structure for `sapt_destinations`
-- ----------------------------
DROP TABLE IF EXISTS `sapt_destinations`;
CREATE TABLE `sapt_destinations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` text NOT NULL,
  `destinationID` varchar(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of sapt_destinations
-- ----------------------------

-- ----------------------------
-- Table structure for `sapt_locations`
-- ----------------------------
DROP TABLE IF EXISTS `sapt_locations`;
CREATE TABLE `sapt_locations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `route` int(11) NOT NULL,
  `stopID` int(11) NOT NULL,
  `name` text NOT NULL,
  `posX` float NOT NULL,
  `posY` float NOT NULL,
  `posZ` float NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of sapt_locations
-- ----------------------------

-- ----------------------------
-- Table structure for `sapt_routes`
-- ----------------------------
DROP TABLE IF EXISTS `sapt_routes`;
CREATE TABLE `sapt_routes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `line` int(11) NOT NULL,
  `route` int(11) NOT NULL,
  `destination` varchar(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of sapt_routes
-- ----------------------------

-- ----------------------------
-- Table structure for `serial_whitelist`
-- ----------------------------
DROP TABLE IF EXISTS `serial_whitelist`;
CREATE TABLE `serial_whitelist` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) NOT NULL,
  `serial` varchar(32) NOT NULL,
  `creation_date` datetime DEFAULT NULL,
  `last_login_ip` varchar(15) DEFAULT NULL,
  `last_login_date` datetime DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `id_UNIQUE` (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of serial_whitelist
-- ----------------------------

-- ----------------------------
-- Table structure for `settings`
-- ----------------------------
DROP TABLE IF EXISTS `settings`;
CREATE TABLE `settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` text,
  `value` text,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of settings
-- ----------------------------

-- ----------------------------
-- Table structure for `sfia_pilots`
-- ----------------------------
DROP TABLE IF EXISTS `sfia_pilots`;
CREATE TABLE `sfia_pilots` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `charactername` varchar(45) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of sfia_pilots
-- ----------------------------

-- ----------------------------
-- Table structure for `shops`
-- ----------------------------
DROP TABLE IF EXISTS `shops`;
CREATE TABLE `shops` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `x` float DEFAULT '0',
  `y` float DEFAULT '0',
  `z` float DEFAULT '0',
  `dimension` int(5) DEFAULT '0',
  `interior` int(5) DEFAULT '0',
  `shoptype` tinyint(4) DEFAULT '0',
  `rotationz` float NOT NULL DEFAULT '0',
  `skin` int(11) DEFAULT '-1',
  `sPendingWage` int(11) NOT NULL DEFAULT '0',
  `sIncome` bigint(20) NOT NULL DEFAULT '0',
  `sCapacity` int(11) NOT NULL DEFAULT '10',
  `sSales` varchar(5000) NOT NULL DEFAULT '',
  `pedName` text,
  `deletedBy` int(11) NOT NULL DEFAULT '0',
  `faction_belong` int(11) NOT NULL DEFAULT '0',
  `faction_access` tinyint(3) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of shops
-- ----------------------------

-- ----------------------------
-- Table structure for `shop_contacts_info`
-- ----------------------------
DROP TABLE IF EXISTS `shop_contacts_info`;
CREATE TABLE `shop_contacts_info` (
  `npcID` int(11) NOT NULL,
  `sOwner` text,
  `sPhone` text,
  `sEmail` text,
  `sForum` text,
  PRIMARY KEY (`npcID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='Saves data about business''s owners in shop system - MAXIME';

-- ----------------------------
-- Records of shop_contacts_info
-- ----------------------------

-- ----------------------------
-- Table structure for `shop_products`
-- ----------------------------
DROP TABLE IF EXISTS `shop_products`;
CREATE TABLE `shop_products` (
  `npcID` int(11) DEFAULT NULL,
  `pItemID` int(11) DEFAULT NULL,
  `pItemValue` text,
  `pDesc` text,
  `pPrice` text,
  `pDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `pID` int(11) NOT NULL AUTO_INCREMENT,
  `pQuantity` int(11) NOT NULL DEFAULT '1',
  `pSetQuantity` int(11) NOT NULL DEFAULT '1',
  `pRestockInterval` int(11) DEFAULT '0',
  `pRestockedDate` datetime DEFAULT NULL,
  PRIMARY KEY (`pID`) USING BTREE,
  UNIQUE KEY `pID_UNIQUE` (`pID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='Saves on-sale products from players, business system by Maxi';

-- ----------------------------
-- Records of shop_products
-- ----------------------------

-- ----------------------------
-- Table structure for `slotmachines`
-- ----------------------------
DROP TABLE IF EXISTS `slotmachines`;
CREATE TABLE `slotmachines` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `x` decimal(10,6) DEFAULT '0.000000',
  `y` decimal(10,6) DEFAULT '0.000000',
  `z` decimal(10,6) DEFAULT '0.000000',
  `rotation` decimal(10,6) DEFAULT '0.000000',
  `dimension` int(5) DEFAULT '0',
  `interior` int(5) DEFAULT '0',
  UNIQUE KEY `id` (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of slotmachines
-- ----------------------------

-- ----------------------------
-- Table structure for `speedcams`
-- ----------------------------
DROP TABLE IF EXISTS `speedcams`;
CREATE TABLE `speedcams` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `x` float(11,7) NOT NULL DEFAULT '0.0000000',
  `y` float(11,7) NOT NULL DEFAULT '0.0000000',
  `z` float(11,7) NOT NULL DEFAULT '0.0000000',
  `interior` int(3) NOT NULL DEFAULT '0' COMMENT 'Stores the location of the pernament speedcams',
  `dimension` int(5) NOT NULL DEFAULT '0',
  `maxspeed` int(4) NOT NULL DEFAULT '120',
  `radius` int(4) NOT NULL DEFAULT '2',
  `enabled` smallint(1) DEFAULT '1',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of speedcams
-- ----------------------------

-- ----------------------------
-- Table structure for `speedingviolations`
-- ----------------------------
DROP TABLE IF EXISTS `speedingviolations`;
CREATE TABLE `speedingviolations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `carID` int(11) NOT NULL,
  `time` datetime NOT NULL,
  `speed` int(5) NOT NULL,
  `area` varchar(50) NOT NULL,
  `personVisible` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of speedingviolations
-- ----------------------------

-- ----------------------------
-- Table structure for `staff_changelogs`
-- ----------------------------
DROP TABLE IF EXISTS `staff_changelogs`;
CREATE TABLE `staff_changelogs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) NOT NULL,
  `team` int(11) NOT NULL,
  `from_rank` int(11) NOT NULL,
  `to_rank` int(11) DEFAULT NULL,
  `by` int(11) DEFAULT NULL,
  `details` text,
  `date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1299 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of staff_changelogs
-- ----------------------------

-- ----------------------------
-- Table structure for `stats`
-- ----------------------------
DROP TABLE IF EXISTS `stats`;
CREATE TABLE `stats` (
  `district` varchar(45) NOT NULL,
  `deaths` double DEFAULT '0',
  PRIMARY KEY (`district`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of stats
-- ----------------------------

-- ----------------------------
-- Table structure for `suspectcrime`
-- ----------------------------
DROP TABLE IF EXISTS `suspectcrime`;
CREATE TABLE `suspectcrime` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `suspect_name` text,
  `time` text,
  `date` text,
  `officers` text,
  `ticket` int(11) DEFAULT NULL,
  `arrest` int(11) DEFAULT NULL,
  `fine` int(11) DEFAULT NULL,
  `ticket_price` text,
  `arrest_price` text,
  `fine_price` text,
  `illegal_items` text,
  `details` text,
  `done_by` text,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of suspectcrime
-- ----------------------------

-- ----------------------------
-- Table structure for `suspectdetails`
-- ----------------------------
DROP TABLE IF EXISTS `suspectdetails`;
CREATE TABLE `suspectdetails` (
  `suspect_name` text,
  `birth` text,
  `gender` text,
  `ethnicy` text,
  `cell` int(5) DEFAULT '0',
  `occupation` text,
  `address` text,
  `other` text,
  `is_wanted` int(1) DEFAULT '0',
  `wanted_reason` text,
  `wanted_punishment` text,
  `wanted_by` text,
  `photo` text,
  `done_by` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of suspectdetails
-- ----------------------------

-- ----------------------------
-- Table structure for `tags`
-- ----------------------------
DROP TABLE IF EXISTS `tags`;
CREATE TABLE `tags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `x` decimal(10,6) DEFAULT NULL,
  `y` decimal(10,6) DEFAULT NULL,
  `z` decimal(10,6) DEFAULT NULL,
  `interior` int(5) DEFAULT NULL,
  `dimension` int(5) DEFAULT NULL,
  `rx` decimal(10,6) DEFAULT NULL,
  `ry` decimal(10,6) DEFAULT NULL,
  `rz` decimal(10,6) DEFAULT NULL,
  `modelid` int(5) DEFAULT NULL,
  `creationdate` datetime DEFAULT NULL,
  `creator` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of tags
-- ----------------------------

-- ----------------------------
-- Table structure for `tc_comments`
-- ----------------------------
DROP TABLE IF EXISTS `tc_comments`;
CREATE TABLE `tc_comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `poster` varchar(200) NOT NULL,
  `comment` text NOT NULL,
  `date` text,
  `internal` tinyint(1) NOT NULL DEFAULT '0',
  `tcid` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of tc_comments
-- ----------------------------

-- ----------------------------
-- Table structure for `tc_tickets`
-- ----------------------------
DROP TABLE IF EXISTS `tc_tickets`;
CREATE TABLE `tc_tickets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` int(11) NOT NULL DEFAULT '0',
  `status` tinyint(4) NOT NULL DEFAULT '0',
  `assign_to` int(11) NOT NULL DEFAULT '0',
  `subcribers` varchar(500) NOT NULL DEFAULT ',',
  `date` text,
  `creator` varchar(200) NOT NULL DEFAULT '0',
  `subject` text NOT NULL,
  `content` text NOT NULL,
  `private` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of tc_tickets
-- ----------------------------

-- ----------------------------
-- Table structure for `tempinteriors`
-- ----------------------------
DROP TABLE IF EXISTS `tempinteriors`;
CREATE TABLE `tempinteriors` (
  `id` int(11) NOT NULL,
  `posX` float NOT NULL,
  `posY` float DEFAULT NULL,
  `posZ` float DEFAULT NULL,
  `interior` int(5) DEFAULT NULL,
  `uploaded_by` int(11) DEFAULT '0',
  `uploaded_at` datetime DEFAULT NULL,
  `amount_paid` int(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of tempinteriors
-- ----------------------------

-- ----------------------------
-- Table structure for `tempobjects`
-- ----------------------------
DROP TABLE IF EXISTS `tempobjects`;
CREATE TABLE `tempobjects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model` int(6) NOT NULL DEFAULT '0',
  `posX` float(12,7) NOT NULL DEFAULT '0.0000000',
  `posY` float(12,7) NOT NULL DEFAULT '0.0000000',
  `posZ` float(12,7) NOT NULL DEFAULT '0.0000000',
  `rotX` float(12,7) NOT NULL DEFAULT '0.0000000',
  `rotY` float(12,7) NOT NULL DEFAULT '0.0000000',
  `rotZ` float(12,7) NOT NULL DEFAULT '0.0000000',
  `interior` int(5) NOT NULL,
  `dimension` int(5) NOT NULL,
  `comment` varchar(50) DEFAULT NULL,
  `solid` int(1) DEFAULT '1',
  `doublesided` int(1) DEFAULT '0',
  `scale` float(12,7) DEFAULT '1.0000000',
  `breakable` int(1) DEFAULT '0',
  `alpha` int(11) NOT NULL DEFAULT '255',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of tempobjects
-- ----------------------------

-- ----------------------------
-- Table structure for `textures_animated`
-- ----------------------------
DROP TABLE IF EXISTS `textures_animated`;
CREATE TABLE `textures_animated` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `frames` text NOT NULL,
  `speed` int(4) NOT NULL,
  `createdBy` int(11) NOT NULL,
  `createdAt` datetime NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of textures_animated
-- ----------------------------

-- ----------------------------
-- Table structure for `ticketreplies`
-- ----------------------------
DROP TABLE IF EXISTS `ticketreplies`;
CREATE TABLE `ticketreplies` (
  `rid` int(11) NOT NULL AUTO_INCREMENT,
  `tid` int(11) NOT NULL,
  `text` text NOT NULL,
  `by` text NOT NULL,
  `rank` int(11) NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`rid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of ticketreplies
-- ----------------------------

-- ----------------------------
-- Table structure for `tickets`
-- ----------------------------
DROP TABLE IF EXISTS `tickets`;
CREATE TABLE `tickets` (
  `tid` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL,
  `name` text NOT NULL,
  `status` text NOT NULL,
  `subject` text NOT NULL,
  `assigned` text NOT NULL,
  `priority` text NOT NULL,
  `username` text NOT NULL,
  `gamename` text NOT NULL,
  `text` text NOT NULL,
  PRIMARY KEY (`tid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of tickets
-- ----------------------------

-- ----------------------------
-- Table structure for `tokens`
-- ----------------------------
DROP TABLE IF EXISTS `tokens`;
CREATE TABLE `tokens` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) DEFAULT NULL,
  `action` varchar(32) DEFAULT NULL,
  `token` varchar(32) NOT NULL,
  `data` varchar(500) DEFAULT NULL,
  `date` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`) USING HASH,
  UNIQUE KEY `token_UNIQUE` (`token`) USING HASH
) ENGINE=MEMORY DEFAULT CHARSET=latin1 ROW_FORMAT=FIXED COMMENT='Random token, used for security and validations - MAXIME';

-- ----------------------------
-- Records of tokens
-- ----------------------------

-- ----------------------------
-- Table structure for `towstats`
-- ----------------------------
DROP TABLE IF EXISTS `towstats`;
CREATE TABLE `towstats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `character` int(11) NOT NULL,
  `vehicle` int(11) DEFAULT NULL,
  `vehicle_plate` varchar(8) DEFAULT NULL COMMENT 'vehicle plate at the time of towing, if any',
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date of towing',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `character_idx` (`character`) USING BTREE,
  KEY `vehicle_idx` (`vehicle`) USING BTREE,
  CONSTRAINT `towstats_ibfk_1` FOREIGN KEY (`character`) REFERENCES `characters` (`id`) ON DELETE CASCADE,
  CONSTRAINT `towstats_ibfk_2` FOREIGN KEY (`vehicle`) REFERENCES `vehicles` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC COMMENT='Detailed information for TTR leaders who towed what and when';

-- ----------------------------
-- Records of towstats
-- ----------------------------

-- ----------------------------
-- Table structure for `vehicles`
-- ----------------------------
DROP TABLE IF EXISTS `vehicles`;
CREATE TABLE `vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model` int(3) DEFAULT '0',
  `x` decimal(10,6) DEFAULT '0.000000',
  `y` decimal(10,6) DEFAULT '0.000000',
  `z` decimal(10,6) DEFAULT '0.000000',
  `rotx` decimal(10,6) DEFAULT '0.000000',
  `roty` decimal(10,6) DEFAULT '0.000000',
  `rotz` decimal(10,6) DEFAULT '0.000000',
  `currx` decimal(10,6) DEFAULT '0.000000',
  `curry` decimal(10,6) DEFAULT '0.000000',
  `currz` decimal(10,6) DEFAULT '0.000000',
  `currrx` decimal(10,6) DEFAULT '0.000000',
  `currry` decimal(10,6) DEFAULT '0.000000',
  `currrz` decimal(10,6) NOT NULL DEFAULT '0.000000',
  `fuel` int(3) DEFAULT '100',
  `engine` int(1) DEFAULT '0',
  `locked` int(1) DEFAULT '0',
  `lights` int(1) DEFAULT '0',
  `sirens` int(1) DEFAULT '0',
  `paintjob` int(11) DEFAULT '0',
  `hp` float DEFAULT '1000',
  `color1` varchar(50) DEFAULT '0',
  `color2` varchar(50) DEFAULT '0',
  `color3` varchar(50) DEFAULT NULL,
  `color4` varchar(50) DEFAULT NULL,
  `plate` text,
  `faction` int(11) DEFAULT '-1',
  `owner` int(11) DEFAULT '-1',
  `job` int(11) DEFAULT '-1',
  `tintedwindows` int(1) DEFAULT '0',
  `dimension` int(5) DEFAULT '0',
  `interior` int(5) DEFAULT '0',
  `currdimension` int(5) DEFAULT '0',
  `currinterior` int(5) DEFAULT '0',
  `enginebroke` int(1) DEFAULT '0',
  `items` text,
  `itemvalues` text,
  `Impounded` int(3) DEFAULT '0',
  `handbrake` int(1) DEFAULT '0',
  `safepositionX` float DEFAULT NULL,
  `safepositionY` float DEFAULT NULL,
  `safepositionZ` float DEFAULT NULL,
  `safepositionRZ` float DEFAULT NULL,
  `upgrades` varchar(150) DEFAULT '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]',
  `wheelStates` varchar(30) DEFAULT '[ [ 0, 0, 0, 0 ] ]',
  `panelStates` varchar(40) DEFAULT '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]',
  `doorStates` varchar(30) DEFAULT '[ [ 0, 0, 0, 0, 0, 0 ] ]',
  `odometer` int(15) DEFAULT '0',
  `headlights` varchar(30) DEFAULT '[ [ 255, 255, 255 ] ]',
  `variant1` int(3) DEFAULT NULL,
  `variant2` int(3) DEFAULT NULL,
  `description1` varchar(300) NOT NULL DEFAULT '',
  `description2` varchar(300) NOT NULL DEFAULT '',
  `description3` varchar(300) NOT NULL DEFAULT '',
  `description4` varchar(300) NOT NULL DEFAULT '',
  `description5` varchar(300) NOT NULL DEFAULT '',
  `suspensionLowerLimit` float DEFAULT NULL,
  `driveType` char(5) DEFAULT NULL,
  `deleted` int(11) NOT NULL DEFAULT '0',
  `chopped` tinyint(4) NOT NULL DEFAULT '0',
  `stolen` tinyint(4) NOT NULL DEFAULT '0',
  `lastUsed` datetime DEFAULT NULL,
  `creationDate` datetime DEFAULT NULL,
  `createdBy` int(11) DEFAULT NULL,
  `trackingdevice` text,
  `registered` int(2) NOT NULL DEFAULT '1',
  `show_plate` int(2) NOT NULL DEFAULT '1',
  `show_vin` int(2) NOT NULL DEFAULT '1',
  `paintjob_url` varchar(255) DEFAULT NULL,
  `vehicle_shop_id` int(11) NOT NULL DEFAULT '0',
  `bulletproof` tinyint(4) NOT NULL DEFAULT '0',
  `textures` varchar(300) NOT NULL DEFAULT '[ [ ] ]',
  `business` int(11) NOT NULL DEFAULT '-1',
  `protected_until` datetime DEFAULT NULL,
  `otopark` int(3) DEFAULT '0',
  `otoparkci` int(3) DEFAULT NULL,
  `satilikmi` int(11) DEFAULT NULL,
  `fiyat` int(11) DEFAULT NULL,
  `iletisim` int(11) DEFAULT NULL,
  `silinmis` int(1) DEFAULT '0',
  `vergi` int(11) DEFAULT '0',
  `toplamvergi` int(11) DEFAULT '0',
  `faizkilidi` int(11) DEFAULT '0',
  `neon` text,
  `loadstate` int(3) DEFAULT '0',
  `ceza` int(11) NOT NULL DEFAULT '0',
  `ceza_sebep` text,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `id_2` (`id`) USING BTREE,
  KEY `id` (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=13104 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of vehicles
-- ----------------------------
INSERT INTO `vehicles` VALUES ('1', '596', '1095.647461', '-1293.035156', '78.972466', '359.291382', '0.005493', '178.461914', '1095.647461', '-1293.035156', '78.972466', '359.291382', '0.005493', '178.461914', '75', '1', '0', '2', '1', '0', '1000', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '34 A 5322', '1', '-1', '-1', '1', '0', '0', '0', '0', '0', null, null, '0', '1', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 1, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-13 01:26:10', '2021-04-11 17:56:25', '17927', null, '1', '1', '1', null, '358', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '1', '0', null);
INSERT INTO `vehicles` VALUES ('2', '596', '1099.848633', '-1292.911133', '78.971855', '359.285889', '0.038452', '179.549561', '1099.848633', '-1292.913086', '78.971733', '359.285889', '0.000000', '179.538574', '99', '1', '0', '1', '0', '3', '1000', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '34 A 8153', '1', '-1', '-1', '1', '10', '1', '10', '1', '0', null, null, '0', '1', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-11 18:03:53', '2021-04-11 17:56:37', '17927', null, '1', '1', '1', null, '358', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '1', '0', null);
INSERT INTO `vehicles` VALUES ('4', '596', '1112.198242', '-1292.913086', '78.970367', '359.274902', '359.994507', '179.483643', '2815.671875', '-1727.999023', '9.713161', '195.446777', '0.263672', '297.597656', '63', '0', '0', '1', '0', '0', '300', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '34 A 3567', '1', '-1', '-1', '1', '10', '1', '10', '1', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 1, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-12 00:06:24', '2021-04-11 17:57:17', '17927', null, '1', '1', '1', null, '358', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '1', '0', null);
INSERT INTO `vehicles` VALUES ('5', '596', '1104.051758', '-1293.099609', '78.970963', '359.280396', '359.994507', '180.933838', '1104.053711', '-1293.091797', '78.940048', '359.093628', '359.978027', '180.977783', '99', '1', '0', '1', '0', '0', '1000', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '34 A 8232', '1', '-1', '-1', '1', '10', '1', '10', '1', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 1, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-11 18:04:23', '2021-04-11 17:57:27', '17927', null, '1', '1', '1', null, '358', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '1', '0', null);
INSERT INTO `vehicles` VALUES ('6', '596', '1108.178711', '-1292.959961', '78.970657', '359.280396', '0.000000', '178.154297', '1108.182617', '-1292.958008', '78.971909', '359.318848', '359.923096', '178.297119', '99', '1', '0', '1', '0', '3', '1000', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '34 A 6483', '1', '-1', '-1', '1', '10', '1', '10', '1', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 1, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-11 18:04:06', '2021-04-11 17:57:47', '17927', null, '1', '1', '1', null, '358', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '1', '0', null);
INSERT INTO `vehicles` VALUES ('7', '596', '1120.571289', '-1293.011719', '78.971817', '359.285889', '0.000000', '178.786011', '1120.588867', '-1293.007813', '78.974823', '359.307861', '359.972534', '178.824463', '99', '1', '0', '1', '0', '3', '1000', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '34 A 9223', '1', '-1', '-1', '1', '10', '1', '10', '1', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 1, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-11 18:04:39', '2021-04-11 17:57:50', '17927', null, '1', '1', '1', null, '358', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '1', '0', null);
INSERT INTO `vehicles` VALUES ('8', '596', '1124.444336', '-1292.991211', '78.969391', '359.269409', '359.994507', '179.884644', '1124.447266', '-1292.979492', '78.940941', '359.104614', '0.005493', '179.945068', '99', '1', '0', '1', '0', '0', '1000', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '34 A 8643', '1', '-1', '-1', '1', '10', '1', '10', '1', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 1, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-11 18:04:40', '2021-04-11 17:57:51', '17927', null, '1', '1', '1', null, '358', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '1', '0', null);
INSERT INTO `vehicles` VALUES ('9', '596', '1128.777344', '-1292.875000', '78.969910', '359.274902', '0.000000', '183.372803', '1128.783203', '-1292.875000', '78.950768', '359.159546', '0.021973', '183.345337', '99', '1', '0', '1', '0', '0', '1000', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '34 A 4156', '1', '-1', '-1', '1', '10', '1', '10', '1', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 1, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-11 18:04:49', '2021-04-11 17:57:52', '17927', null, '1', '1', '1', null, '358', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '1', '0', null);
INSERT INTO `vehicles` VALUES ('10', '596', '1140.875977', '-1292.836914', '78.969315', '359.269409', '359.994507', '178.857422', '1140.876953', '-1292.835938', '78.970467', '359.274902', '0.016479', '178.923340', '99', '1', '0', '1', '0', '0', '1000', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '34 A 2386', '1', '-1', '-1', '1', '10', '1', '10', '1', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 1, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-11 18:05:06', '2021-04-11 17:57:53', '17927', null, '1', '1', '1', null, '358', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '1', '0', null);
INSERT INTO `vehicles` VALUES ('11', '596', '1132.703125', '-1292.778320', '78.970917', '359.280396', '0.000000', '180.318604', '1132.713867', '-1292.774414', '78.973495', '359.296875', '0.032959', '180.318604', '99', '1', '0', '1', '0', '0', '998', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '34 A 8233', '1', '-1', '-1', '1', '10', '1', '10', '1', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 1, 0 ] ]', '[ [ 0, 0, 0, 1, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-11 18:04:54', '2021-04-11 17:57:54', '17927', null, '1', '1', '1', null, '358', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '1', '0', null);
INSERT INTO `vehicles` VALUES ('12', '596', '1136.774414', '-1292.769531', '78.974190', '359.302368', '0.000000', '179.956055', '1136.778320', '-1292.769531', '78.945732', '359.104614', '0.000000', '180.043945', '99', '1', '0', '1', '0', '0', '1000', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '34 A 9387', '1', '-1', '-1', '1', '10', '1', '10', '1', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 1, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-11 18:04:59', '2021-04-11 18:01:11', '17927', null, '1', '1', '1', null, '358', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '1', '0', null);
INSERT INTO `vehicles` VALUES ('13', '596', '1149.171875', '-1292.785156', '78.971115', '359.280396', '359.994507', '180.032959', '1149.171875', '-1292.784180', '78.972336', '359.285889', '0.016479', '180.104370', '100', '1', '0', '1', '0', '0', '1000', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '34 A 5386', '1', '-1', '-1', '1', '10', '1', '10', '1', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-11 18:05:16', '2021-04-11 18:01:15', '17927', null, '1', '1', '1', null, '358', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '1', '0', null);
INSERT INTO `vehicles` VALUES ('14', '596', '1145.069336', '-1292.711914', '78.972733', '359.291382', '0.000000', '176.907349', '1145.060547', '-1292.700195', '78.941856', '359.110107', '0.005493', '176.347046', '99', '1', '0', '1', '0', '0', '1000', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '34 A 2537', '1', '-1', '-1', '1', '10', '1', '10', '1', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 1, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-11 18:05:13', '2021-04-11 18:01:17', '17927', null, '1', '1', '1', null, '358', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '1', '0', null);
INSERT INTO `vehicles` VALUES ('15', '598', '1085.569336', '-1294.047852', '78.930969', '359.670410', '359.983521', '228.641968', '1085.569336', '-1294.047852', '78.930969', '359.670410', '359.983521', '228.641968', '100', '1', '0', '2', '0', '0', '1000', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', 'WH9 8379', '1', '-1', '-1', '1', '10', '1', '10', '1', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-11 18:04:57', '2021-04-11 18:04:32', '17927', null, '1', '1', '1', null, '424', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '1', '0', null);
INSERT INTO `vehicles` VALUES ('16', '596', '1124.420898', '-1308.887695', '78.971886', '359.285889', '0.000000', '0.741577', '1124.424805', '-1308.884766', '78.974777', '359.302368', '359.967041', '0.911865', '100', '1', '0', '1', '0', '0', '1000', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', 'SL3 2884', '1', '-1', '-1', '1', '10', '1', '10', '1', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 1, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-11 18:44:30', '2021-04-11 18:42:40', '17927', null, '1', '1', '1', null, '358', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '1', '0', null);
INSERT INTO `vehicles` VALUES ('17', '596', '1120.358398', '-1309.025391', '78.969627', '359.274902', '0.000000', '358.978271', '1120.358398', '-1309.025391', '78.969627', '359.274902', '0.000000', '358.978271', '100', '1', '0', '1', '0', '0', '1000', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', 'JL2 8439', '1', '-1', '-1', '1', '10', '1', '10', '1', '0', null, null, '0', '1', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-11 18:44:13', '2021-04-11 18:42:44', '17927', null, '1', '1', '1', null, '358', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '1', '0', null);
INSERT INTO `vehicles` VALUES ('18', '596', '1116.166992', '-1309.182617', '78.971283', '359.285889', '359.994507', '1.653442', '1116.166992', '-1309.182617', '78.971283', '359.285889', '359.994507', '1.647949', '87', '1', '0', '1', '0', '3', '1000', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', 'LS2 5330', '1', '-1', '-1', '1', '10', '1', '10', '1', '0', null, null, '0', '1', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-13 01:02:14', '2021-04-11 18:42:46', '17927', null, '1', '1', '1', null, '358', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '1', '0', null);
INSERT INTO `vehicles` VALUES ('19', '560', '1099.791992', '-1309.749023', '78.704895', '359.884644', '0.000000', '1.933594', '1099.791992', '-1309.749023', '78.704895', '359.884644', '0.000000', '1.933594', '95', '0', '0', '2', '0', '0', '1000', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '34 L 3701', '1', '-1', '-1', '1', '10', '1', '10', '1', '0', null, null, '0', '1', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-13 02:09:54', '2021-04-11 18:43:28', '17927', null, '1', '1', '1', null, '847', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '1', '0', null);
INSERT INTO `vehicles` VALUES ('20', '560', '1095.484375', '-1309.826172', '78.705711', '359.884644', '359.670410', '359.978027', '2719.989258', '-1658.904297', '12.714787', '359.890137', '0.000000', '269.285889', '98', '1', '0', '2', '0', '0', '1000', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '34 L 6642', '1', '-1', '-1', '1', '10', '1', '10', '1', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-11 23:59:01', '2021-04-11 18:43:31', '17927', null, '1', '1', '1', null, '847', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '1', '0', null);
INSERT INTO `vehicles` VALUES ('21', '525', '1087.705078', '-1325.906250', '78.941010', '358.154297', '0.000000', '180.928345', '1087.706055', '-1325.905273', '78.941681', '358.159790', '359.994507', '180.966797', '100', '1', '0', '1', '0', '0', '1000', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', 'XO3 4431', '1', '-1', '-1', '1', '10', '1', '10', '1', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-11 18:47:07', '2021-04-11 18:46:32', '17927', null, '1', '1', '1', null, '233', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '1', '0', null);
INSERT INTO `vehicles` VALUES ('22', '525', '1091.541016', '-1325.865234', '78.941193', '358.154297', '0.000000', '180.499878', '1091.541992', '-1325.864258', '78.942238', '358.170776', '0.021973', '180.565796', '100', '1', '0', '1', '0', '0', '1000', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', 'IL0 5115', '1', '-1', '-1', '1', '10', '1', '10', '1', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-11 18:47:44', '2021-04-11 18:47:18', '17927', null, '1', '1', '1', null, '233', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '1', '0', null);
INSERT INTO `vehicles` VALUES ('23', '437', '1538.707031', '-1645.948242', '6.025142', '0.000000', '359.994507', '179.730835', '1538.707031', '-1645.948242', '6.025142', '0.000000', '359.994507', '179.730835', '100', '0', '0', '1', '0', '0', '1000', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', 'YI4 7700', '1', '-1', '-1', '1', '0', '0', '0', '0', '0', null, null, '0', '1', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '1', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-11 18:59:21', '2021-04-11 18:58:22', '17927', null, '1', '1', '1', null, '813', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '1', '0', null);
INSERT INTO `vehicles` VALUES ('24', '437', '1534.360352', '-1645.934570', '6.024753', '0.000000', '359.994507', '179.873657', '1534.362305', '-1645.932617', '6.026530', '359.994507', '0.197754', '179.978027', '99', '1', '0', '1', '0', '0', '972.5', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', 'SN4 3105', '1', '-1', '-1', '1', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 2, 0, 0, 0, 0, 2, 0 ] ]', '[ [ 2, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '1', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-11 18:59:53', '2021-04-11 18:58:39', '17927', null, '1', '1', '1', null, '813', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '1', '0', null);
INSERT INTO `vehicles` VALUES ('25', '541', '1546.468750', '-1667.813477', '5.514452', '359.159546', '359.994507', '87.445679', '1546.470703', '-1667.811523', '5.516260', '359.170532', '359.994507', '87.544556', '100', '1', '0', '1', '0', '0', '1000', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', 'HO6 4217', '1', '-1', '-1', '1', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-11 19:00:59', '2021-04-11 19:00:31', '17927', null, '1', '1', '1', null, '493', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '1', '0', null);
INSERT INTO `vehicles` VALUES ('26', '601', '1578.613281', '-1711.347656', '6.284224', '1.340332', '359.796753', '359.143066', '1578.615234', '-1711.345703', '6.285845', '1.323853', '359.840698', '359.236450', '100', '1', '0', '1', '0', '0', '1000', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', 'ZR0 6296', '1', '-1', '-1', '1', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '3', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-11 19:02:03', '2021-04-11 19:01:25', '17927', null, '1', '1', '1', null, '812', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '1', '0', null);
INSERT INTO `vehicles` VALUES ('27', '601', '1570.353516', '-1711.394531', '6.290461', '1.279907', '359.802246', '359.241943', '1570.356445', '-1711.392578', '6.292238', '0.999756', '0.027466', '359.340820', '100', '1', '0', '1', '0', '0', '1000', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', 'TN4 1095', '1', '-1', '-1', '1', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 1, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '2', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-11 19:06:36', '2021-04-11 19:01:29', '17927', null, '1', '1', '1', null, '812', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '1', '0', null);
INSERT INTO `vehicles` VALUES ('28', '601', '1574.349609', '-1711.485352', '6.284059', '1.340332', '359.796753', '359.467163', '1574.351563', '-1711.483398', '6.285872', '1.323853', '359.829712', '359.571533', '100', '1', '0', '1', '0', '0', '1000', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', 'MX3 3467', '1', '-1', '-1', '1', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '2', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-11 19:02:27', '2021-04-11 19:01:30', '17927', null, '1', '1', '1', null, '812', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '1', '0', null);
INSERT INTO `vehicles` VALUES ('29', '601', '1565.158203', '-1711.584961', '6.280215', '1.373291', '359.796753', '0.043945', '1565.160156', '-1711.583008', '6.281908', '1.356812', '359.846191', '0.137329', '100', '1', '0', '1', '0', '0', '1000', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', 'IO9 9110', '1', '-1', '-1', '1', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '0', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-11 19:03:35', '2021-04-11 19:01:32', '17927', null, '1', '1', '1', null, '812', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '1', '0', null);
INSERT INTO `vehicles` VALUES ('30', '528', '1601.852539', '-1696.028320', '5.929030', '0.648193', '0.000000', '90.373535', '1601.852539', '-1696.028320', '5.929030', '0.648193', '0.000000', '90.373535', '100', '0', '0', '1', '0', '0', '1000', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', 'IR1 2425', '1', '-1', '-1', '1', '0', '0', '0', '0', '0', null, null, '0', '1', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-13 02:07:25', '2021-04-11 19:04:17', '17927', null, '1', '1', '1', null, '678', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '1', '0', null);
INSERT INTO `vehicles` VALUES ('31', '528', '1601.867188', '-1691.991211', '5.928205', '0.648193', '0.000000', '90.016479', '1602.069336', '-1691.869141', '5.928673', '0.648193', '359.994507', '89.324341', '97', '1', '0', '1', '0', '0', '1000', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', 'XZ8 2434', '1', '-1', '-1', '1', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-11 19:18:46', '2021-04-11 19:04:21', '17927', null, '1', '1', '1', null, '678', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '1', '0', null);
INSERT INTO `vehicles` VALUES ('32', '528', '1602.131836', '-1704.386719', '5.930801', '0.637207', '0.000000', '91.296387', '1602.132813', '-1704.385742', '5.961768', '0.505371', '359.994507', '91.351318', '73', '1', '0', '1', '0', '0', '1000', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', 'KW1 3435', '1', '-1', '-1', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-11 23:27:33', '2021-04-11 19:04:22', '17927', null, '1', '1', '1', null, '678', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '1', '0', null);
INSERT INTO `vehicles` VALUES ('33', '528', '1602.017578', '-1700.198242', '5.929178', '0.642700', '0.000000', '89.862671', '1602.019531', '-1700.196289', '5.931033', '0.637207', '0.005493', '89.972534', '100', '1', '0', '1', '0', '0', '1000', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', 'IZ5 6641', '1', '-1', '-1', '1', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-11 19:05:22', '2021-04-11 19:04:23', '17927', null, '1', '1', '1', null, '678', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '1', '0', null);
INSERT INTO `vehicles` VALUES ('34', '523', '1585.656250', '-1677.142578', '5.462375', '359.000244', '359.967041', '271.027222', '1585.656250', '-1677.142578', '5.462375', '359.000244', '359.967041', '271.027222', '100', '1', '0', '1', '0', '3', '1000', '[ [ 0, 0, 0 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 245, 245, 245 ] ]', 'TO5 3290', '1', '-1', '-1', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-11 19:11:58', '2021-04-11 19:10:28', '17927', null, '1', '1', '1', null, '602', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '1', '0', null);
INSERT INTO `vehicles` VALUES ('35', '523', '1585.620117', '-1679.020508', '5.461173', '359.241943', '359.994507', '269.494629', '1585.620117', '-1679.020508', '5.461173', '359.241943', '359.994507', '269.494629', '100', '1', '0', '1', '0', '0', '1000', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', 'GV9 4546', '1', '-1', '-1', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-11 19:11:30', '2021-04-11 19:10:31', '17927', null, '1', '1', '1', null, '602', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '1', '0', null);
INSERT INTO `vehicles` VALUES ('36', '523', '1585.619141', '-1675.399414', '5.464398', '359.280396', '359.939575', '271.691895', '1585.619141', '-1675.399414', '5.464398', '359.280396', '359.939575', '271.691895', '100', '1', '0', '1', '0', '0', '1000', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', 'UV8 1271', '1', '-1', '-1', '1', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-11 19:12:26', '2021-04-11 19:10:32', '17927', null, '1', '1', '1', null, '602', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '1', '0', null);
INSERT INTO `vehicles` VALUES ('37', '523', '1585.464844', '-1681.189453', '5.458937', '359.219971', '0.000000', '266.495361', '1585.464844', '-1681.189453', '5.458937', '359.219971', '0.000000', '266.495361', '100', '1', '0', '2', '0', '0', '1000', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', 'CC9 4425', '1', '-1', '-1', '1', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-11 19:10:58', '2021-04-11 19:10:33', '17927', null, '1', '1', '1', null, '602', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '1', '0', null);
INSERT INTO `vehicles` VALUES ('38', '579', '1585.470703', '-1671.642578', '5.760373', '359.082642', '359.906616', '270.241699', '1585.472656', '-1671.639648', '5.762290', '359.077148', '359.818726', '270.351563', '100', '1', '0', '1', '0', '0', '1000', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', 'GU3 3195', '1', '-1', '-1', '1', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-11 19:14:40', '2021-04-11 19:13:54', '17927', null, '1', '1', '1', null, '799', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '1', '0', null);
INSERT INTO `vehicles` VALUES ('39', '579', '1585.118164', '-1667.766602', '5.763046', '359.077148', '359.950562', '268.522339', '1585.121094', '-1667.764648', '5.765087', '359.099121', '359.917603', '268.637695', '100', '1', '0', '1', '0', '0', '1000', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', 'DT3 5978', '1', '-1', '-1', '1', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-11 19:15:09', '2021-04-11 19:14:03', '17927', null, '1', '1', '1', null, '799', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '1', '0', null);
INSERT INTO `vehicles` VALUES ('40', '456', '2453.888672', '-2619.067383', '13.838411', '359.917603', '0.000000', '272.515869', '2453.891602', '-2619.064453', '13.840590', '359.923096', '359.978027', '272.642212', '100', '1', '0', '1', '0', '3', '1000', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', 'IK5 4182', '-1', '-2', '9', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '2', '255', '', '', '', '', '', null, null, '17928', '0', '0', '2021-04-11 19:35:52', '2021-04-11 19:34:06', '17927', null, '1', '1', '1', null, '0', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '0', '0', null);
INSERT INTO `vehicles` VALUES ('41', '456', '2453.674805', '-2609.735352', '13.833751', '0.005493', '359.994507', '269.197998', '2453.674805', '-2609.734375', '13.834352', '0.005493', '0.000000', '269.230957', '100', '1', '0', '1', '0', '3', '983', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', 'TD2 3453', '-1', '-2', '9', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 1, 0, 0, 0, 2, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '2', '255', '', '', '', '', '', null, null, '17928', '0', '0', '2021-04-11 19:37:09', '2021-04-11 19:34:26', '17927', null, '1', '1', '1', null, '0', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '0', '0', null);
INSERT INTO `vehicles` VALUES ('42', '456', '2453.821289', '-2584.596680', '13.829799', '359.917603', '359.994507', '268.945313', '2453.822266', '-2584.595703', '13.830948', '359.917603', '359.978027', '269.011230', '100', '0', '0', '1', '0', '3', '976.5', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', 'JN1 9166', '-1', '-2', '9', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 2 ] ]', '[ [ 0, 2, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '0', '255', '', '', '', '', '', null, null, '17928', '0', '0', '2021-04-11 19:39:04', '2021-04-11 19:34:27', '17927', null, '1', '1', '1', null, '0', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '0', '0', null);
INSERT INTO `vehicles` VALUES ('43', '456', '2453.777344', '-2588.825195', '13.828554', '359.917603', '359.994507', '269.005737', '2453.779297', '-2588.822266', '13.831087', '359.917603', '359.928589', '269.148560', '100', '1', '0', '1', '0', '3', '1000', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', 'RL6 1813', '-1', '-2', '9', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '17928', '0', '0', '2021-04-11 19:38:43', '2021-04-11 19:34:28', '17927', null, '1', '1', '1', null, '0', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '0', '0', null);
INSERT INTO `vehicles` VALUES ('44', '456', '2453.789063', '-2605.301758', '13.833282', '0.005493', '359.994507', '268.154297', '2453.791016', '-2605.299805', '13.834511', '0.005493', '359.967041', '268.225708', '100', '1', '0', '1', '0', '3', '993.5', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', 'AJ3 7275', '-1', '-2', '9', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '17928', '0', '0', '2021-04-11 19:37:47', '2021-04-11 19:34:31', '17927', null, '1', '1', '1', null, '0', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '0', '0', null);
INSERT INTO `vehicles` VALUES ('45', '456', '2453.798828', '-2594.879883', '13.829253', '359.917603', '0.000000', '269.511108', '2453.799805', '-2594.878906', '13.830412', '359.917603', '359.978027', '269.577026', '100', '0', '0', '1', '0', '3', '980.5', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', 'BR7 2788', '-1', '-2', '9', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 2, 0, 0, 0, 2, 1 ] ]', '[ [ 0, 2, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '2', '255', '', '', '', '', '', null, null, '17928', '0', '0', '2021-04-11 19:38:26', '2021-04-11 19:34:31', '17927', null, '1', '1', '1', null, '0', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '0', '0', null);
INSERT INTO `vehicles` VALUES ('46', '456', '2453.738281', '-2598.914063', '13.834556', '359.923096', '0.000000', '270.098877', '2453.738281', '-2598.914063', '13.834556', '359.923096', '0.000000', '270.098877', '100', '1', '0', '2', '0', '3', '1000', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', 'RO0 5908', '-1', '-2', '9', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 1, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '17928', '0', '0', '2021-04-11 19:37:59', '2021-04-11 19:34:32', '17927', null, '1', '1', '1', null, '0', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '0', '0', null);
INSERT INTO `vehicles` VALUES ('47', '456', '2453.877930', '-2614.668945', '13.834916', '359.961548', '359.879150', '271.494141', '2453.880859', '-2614.666016', '13.837704', '359.961548', '359.862671', '271.653442', '100', '1', '0', '1', '0', '3', '980', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', 'MZ7 5778', '-1', '-2', '9', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '2', '255', '', '', '', '', '', null, null, '17928', '0', '0', '2021-04-11 19:36:43', '2021-04-11 19:34:33', '17927', null, '1', '1', '1', null, '0', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '0', '0', null);
INSERT INTO `vehicles` VALUES ('48', '519', '1131.358408', '-1305.976428', '6.000000', '0.000000', '0.000000', '188.014648', '1131.358408', '-1305.976428', '6.000000', '0.000000', '0.000000', '188.014648', '100', '0', '1', '0', '0', '0', '1000', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', 'ZB5 8771', '1', '-1', '-1', '1', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '17928', '0', '0', null, '2021-04-11 19:39:56', '17928', null, '1', '1', '1', null, '416', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', null, '0', '0', null);
INSERT INTO `vehicles` VALUES ('49', '416', '1120.845703', '-1312.824219', '6.006453', '0.170288', '0.027466', '0.725098', '1120.845703', '-1312.824219', '6.006453', '0.170288', '0.027466', '0.725098', '100', '1', '0', '2', '0', '0', '1000', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', 'AA4 8721', '2', '-1', '-1', '1', '0', '0', '0', '0', '0', null, null, '0', '1', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '1', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-11 20:00:49', '2021-04-11 19:42:58', '17928', null, '1', '1', '1', null, '382', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '0', '0', null);
INSERT INTO `vehicles` VALUES ('50', '416', '1116.945313', '-1312.710938', '5.979334', '0.384521', '0.076904', '358.231201', '1116.948242', '-1312.708008', '5.982328', '0.351563', '0.060425', '358.401489', '100', '1', '0', '1', '0', '0', '1000', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', 'SP8 8878', '2', '-1', '-1', '1', '0', '0', '0', '0', '0', null, null, '0', '1', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '1', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-11 19:45:06', '2021-04-11 19:43:01', '17928', null, '1', '1', '1', null, '382', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '0', '0', null);
INSERT INTO `vehicles` VALUES ('51', '416', '1112.796875', '-1313.012695', '5.973165', '0.433960', '0.082397', '0.983276', '1112.796875', '-1313.012695', '5.973165', '0.433960', '0.082397', '0.983276', '100', '1', '0', '1', '0', '0', '987.5', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', 'CU4 6315', '2', '-1', '-1', '1', '0', '0', '0', '0', '0', null, null, '0', '1', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '1', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-11 19:43:46', '2021-04-11 19:43:04', '17928', null, '1', '1', '1', null, '382', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '0', '0', null);
INSERT INTO `vehicles` VALUES ('52', '416', '1129.425781', '-1313.211914', '5.975099', '0.417480', '0.082397', '359.972534', '1129.426758', '-1313.210938', '5.976422', '0.411987', '0.142822', '0.049438', '100', '1', '0', '2', '0', '0', '1000', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', 'VR3 1092', '2', '-1', '-1', '1', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '0', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-11 20:00:16', '2021-04-11 19:43:05', '17928', null, '1', '1', '1', null, '382', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '0', '0', null);
INSERT INTO `vehicles` VALUES ('53', '416', '1125.490234', '-1313.081055', '5.979886', '0.379028', '0.076904', '0.576782', '1125.490234', '-1313.081055', '5.979886', '0.373535', '0.071411', '0.571289', '100', '1', '0', '2', '0', '0', '999.5', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', 'GU3 8828', '2', '-1', '-1', '1', '0', '0', '0', '0', '0', null, null, '0', '1', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 1 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '0', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-11 20:00:25', '2021-04-11 19:43:07', '17928', null, '1', '1', '1', null, '382', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '0', '0', null);
INSERT INTO `vehicles` VALUES ('54', '462', '1112.917043', '-1303.980767', '6.000000', '0.000000', '0.000000', '27.848022', '1112.917043', '-1303.980767', '6.000000', '0.000000', '0.000000', '27.848022', '100', '0', '1', '0', '0', '0', '1000', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', 'YW8 6658', '2', '-1', '-1', '1', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '17928', '0', '0', null, '2021-04-11 19:47:56', '17928', null, '1', '1', '1', null, '816', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', null, '0', '0', null);
INSERT INTO `vehicles` VALUES ('55', '579', '1107.089844', '-1305.707031', '5.916847', '359.494629', '359.923096', '269.197998', '1107.093750', '-1305.705078', '5.918094', '359.505615', '359.906616', '269.269409', '100', '1', '0', '2', '0', '3', '992.5', '[ [ 132, 4, 16 ] ]', '[ [ 132, 4, 16 ] ]', '[ [ 132, 4, 16 ] ]', '[ [ 132, 4, 16 ] ]', 'GG7 8092', '2', '-1', '-1', '1', '0', '0', '0', '0', '0', null, null, '0', '1', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 1, 0, 0, 0, 0, 1, 0 ] ]', '[ [ 0, 0, 1, 0, 2, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-11 19:52:12', '2021-04-11 19:48:57', '17928', null, '1', '1', '1', null, '826', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '1', '0', null);
INSERT INTO `vehicles` VALUES ('56', '579', '1107.079102', '-1302.016602', '5.923305', '359.516602', '359.928589', '268.857422', '1107.079102', '-1302.016602', '5.923305', '359.516602', '359.928589', '268.857422', '100', '0', '0', '2', '0', '3', '1000', '[ [ 132, 4, 16 ] ]', '[ [ 132, 4, 16 ] ]', '[ [ 132, 4, 16 ] ]', '[ [ 132, 4, 16 ] ]', 'MC8 8698', '2', '-1', '-1', '1', '0', '0', '0', '0', '0', null, null, '0', '1', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-11 19:52:55', '2021-04-11 19:49:03', '17928', null, '1', '1', '1', null, '826', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '1', '0', null);
INSERT INTO `vehicles` VALUES ('57', '426', '1106.915039', '-1297.840820', '5.743552', '0.115356', '0.000000', '270.274658', '1106.915039', '-1297.840820', '5.743552', '0.115356', '0.000000', '270.274658', '100', '1', '0', '2', '0', '3', '1000', '[ [ 132, 4, 16 ] ]', '[ [ 132, 4, 16 ] ]', '[ [ 132, 4, 16 ] ]', '[ [ 132, 4, 16 ] ]', 'EB2 7089', '2', '-1', '-1', '1', '0', '0', '0', '0', '0', null, null, '0', '1', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-11 19:55:56', '2021-04-11 19:54:07', '17928', null, '1', '1', '1', null, '850', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '1', '0', null);
INSERT INTO `vehicles` VALUES ('58', '426', '1106.867188', '-1294.066406', '5.743646', '0.115356', '0.000000', '267.951050', '1106.867188', '-1294.066406', '5.743646', '0.115356', '0.000000', '267.951050', '100', '1', '0', '2', '0', '3', '1000', '[ [ 132, 4, 16 ] ]', '[ [ 132, 4, 16 ] ]', '[ [ 132, 4, 16 ] ]', '[ [ 132, 4, 16 ] ]', 'JU2 6744', '2', '-1', '-1', '1', '0', '0', '0', '0', '0', null, null, '0', '1', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-11 19:55:46', '2021-04-11 19:54:09', '17928', null, '1', '1', '1', null, '850', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '1', '0', null);
INSERT INTO `vehicles` VALUES ('59', '586', '1145.385742', '-1295.623047', '5.520085', '359.906616', '0.000000', '180.708618', '1145.385742', '-1295.623047', '5.520085', '359.906616', '0.000000', '180.708618', '69', '1', '0', '1', '0', '0', '1000', '[ [ 132, 4, 16 ] ]', '[ [ 132, 4, 16 ] ]', '[ [ 132, 4, 16 ] ]', '[ [ 132, 4, 16 ] ]', 'IK4 1816', '2', '-1', '-1', '1', '0', '0', '0', '0', '0', null, null, '0', '1', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-11 23:45:17', '2021-04-11 19:57:08', '17928', null, '1', '1', '1', null, '738', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '1', '0', null);
INSERT INTO `vehicles` VALUES ('60', '586', '1149.758789', '-1295.725586', '5.520136', '359.906616', '0.000000', '181.636963', '1149.758789', '-1295.725586', '5.520136', '359.906616', '0.000000', '181.636963', '100', '1', '0', '1', '0', '0', '1000', '[ [ 132, 4, 16 ] ]', '[ [ 132, 4, 16 ] ]', '[ [ 132, 4, 16 ] ]', '[ [ 132, 4, 16 ] ]', 'IR8 5819', '2', '-1', '-1', '1', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-11 19:58:04', '2021-04-11 19:57:11', '17928', null, '1', '1', '1', null, '738', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '1', '0', null);
INSERT INTO `vehicles` VALUES ('61', '520', '2762.033378', '-2488.187373', '13.645291', '0.000000', '0.000000', '173.572876', '2794.347656', '-2339.003906', '14.356032', '1.895142', '0.000000', '193.293457', '100', '1', '0', '1', '0', '0', '881', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', 'YV8 5770', '-1', '22271', '-1', '1', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 1, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '17928', '0', '0', '2021-04-12 00:10:39', '2021-04-12 00:05:48', '17928', null, '1', '1', '1', null, '715', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '0', '0', null);
INSERT INTO `vehicles` VALUES ('62', '520', '2757.222014', '-2338.642535', '13.632813', '0.000000', '0.000000', '335.294128', '2763.564453', '-2363.089844', '14.356023', '1.906128', '0.472412', '159.455566', '100', '1', '0', '1', '0', '0', '628', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', 'RF9 8665', '-1', '22271', '-1', '1', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 1, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '17928', '0', '0', '2021-04-12 00:13:25', '2021-04-12 00:12:45', '17928', null, '1', '1', '1', null, '1018', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '0', '0', null);
INSERT INTO `vehicles` VALUES ('63', '521', '2093.165588', '-1808.899749', '13.553862', '0.000000', '0.000000', '157.593018', '2912.013672', '-1028.004883', '10.621139', '359.280396', '359.994507', '358.884888', '99', '1', '0', '2', '0', '0', '964.5', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [0, 0, 0] ]', 'IV5 3899', '-1', '-2', '-1', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '2', '4', '', '', '', '', '', null, null, '17928', '0', '0', '2021-04-12 02:06:53', '2021-04-12 02:01:02', '17926', null, '1', '1', '1', null, '0', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '0', '0', null);
INSERT INTO `vehicles` VALUES ('64', '560', '2025.391618', '-1463.794681', '15.170397', '0.000000', '0.000000', '126.995667', '1400.167969', '-1416.966797', '13.044457', '0.109863', '359.994507', '354.979248', '98', '1', '0', '1', '0', '3', '911.5', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', 'AE7 8852', '-1', '22271', '-1', '1', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 1, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '17928', '0', '0', '2021-04-13 03:48:21', '2021-04-13 03:46:09', '17928', null, '1', '1', '1', null, '604', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '0', '0', null);
INSERT INTO `vehicles` VALUES ('65', '426', '1124.725586', '-1326.334961', '78.807419', '0.115356', '359.994507', '181.395264', '1124.725586', '-1326.334961', '78.807419', '0.115356', '359.994507', '181.395264', '100', '1', '1', '1', '0', '0', '995', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', 'HE6 8233', '1', '-1', '-1', '1', '10', '1', '10', '1', '0', null, null, '0', '1', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 2, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-13 01:06:44', '2021-04-13 01:05:16', '17928', null, '1', '1', '1', null, '850', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '1', '0', null);
INSERT INTO `vehicles` VALUES ('66', '426', '1120.717773', '-1326.372070', '78.807335', '0.115356', '359.994507', '179.763794', '1120.717773', '-1326.372070', '78.807335', '0.115356', '359.994507', '179.763794', '100', '1', '0', '1', '0', '0', '1000', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', 'PE1 1161', '1', '-1', '-1', '1', '10', '1', '10', '1', '0', null, null, '0', '1', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 1, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-13 01:06:27', '2021-04-13 01:05:20', '17928', null, '1', '1', '1', null, '850', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '1', '0', null);
INSERT INTO `vehicles` VALUES ('67', '407', '880.882718', '-1035.486392', '31.905415', '0.000000', '0.000000', '213.690079', '880.882718', '-1035.486392', '31.905415', '0.000000', '0.000000', '213.690079', '100', '0', '1', '0', '0', '0', '1000', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', 'WG3 8128', '1', '-1', '-1', '1', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '1', '255', '', '', '', '', '', null, null, '17928', '0', '0', null, '2021-04-13 03:26:54', '17928', null, '1', '1', '1', null, '356', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', null, '0', '0', null);
INSERT INTO `vehicles` VALUES ('68', '528', '879.830078', '-1043.084961', '31.681679', '0.466919', '359.994507', '272.241211', '879.831055', '-1043.083984', '31.682875', '0.461426', '359.994507', '272.307129', '100', '0', '0', '1', '0', '0', '1000', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', 'LA7 1183', '1', '-1', '-1', '1', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-13 03:30:36', '2021-04-13 03:28:21', '17928', null, '1', '1', '1', null, '678', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '1', '0', null);
INSERT INTO `vehicles` VALUES ('69', '528', '879.933594', '-1046.780273', '31.660288', '0.554810', '359.989014', '270.834961', '879.934570', '-1046.779297', '31.661560', '0.549316', '359.994507', '270.911865', '100', '0', '0', '1', '0', '0', '1000', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', 'NR4 2682', '1', '-1', '-1', '1', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-13 03:30:43', '2021-04-13 03:28:27', '17928', null, '1', '1', '1', null, '678', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '1', '0', null);
INSERT INTO `vehicles` VALUES ('70', '528', '880.037109', '-1049.988281', '31.638498', '0.653687', '359.994507', '270.417480', '880.037109', '-1049.988281', '31.638498', '0.653687', '359.994507', '270.417480', '100', '1', '0', '1', '0', '0', '1000', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', 'ZN8 3975', '1', '-1', '-1', '1', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-13 03:29:41', '2021-04-13 03:28:30', '17928', null, '1', '1', '1', null, '678', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '1', '0', null);
INSERT INTO `vehicles` VALUES ('71', '560', '933.283203', '-1051.646484', '31.247116', '0.120850', '359.994507', '358.956299', '933.285156', '-1051.644531', '31.248653', '0.115356', '359.989014', '359.044189', '100', '0', '0', '1', '0', '0', '1000', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', 'DG9 2744', '1', '-1', '-1', '1', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-13 03:34:20', '2021-04-13 03:32:51', '17928', null, '1', '1', '1', null, '604', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '1', '0', null);
INSERT INTO `vehicles` VALUES ('72', '560', '936.637695', '-1051.608398', '31.259302', '0.087891', '359.961548', '359.126587', '936.637695', '-1051.608398', '31.259302', '0.087891', '359.961548', '359.126587', '100', '0', '0', '1', '0', '0', '1000', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', 'RH7 6091', '1', '-1', '-1', '1', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 1, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-13 03:34:03', '2021-04-13 03:32:53', '17928', null, '1', '1', '1', null, '604', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '1', '0', null);
INSERT INTO `vehicles` VALUES ('73', '560', '939.276367', '-1051.585938', '31.257940', '0.104370', '359.972534', '0.653687', '939.269531', '-1051.585938', '31.261089', '0.104370', '0.005493', '0.911865', '100', '1', '0', '2', '0', '0', '1000', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', 'HZ4 4970', '1', '-1', '-1', '1', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-13 03:37:05', '2021-04-13 03:32:55', '17928', null, '1', '1', '1', null, '604', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '1', '0', null);
INSERT INTO `vehicles` VALUES ('74', '560', '930.211914', '-1051.596680', '31.266088', '0.098877', '359.994507', '0.087891', '930.214844', '-1051.593750', '31.269102', '0.093384', '0.000000', '0.258179', '100', '0', '0', '2', '0', '0', '1000', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', 'CP1 1283', '1', '-1', '-1', '1', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-13 03:34:57', '2021-04-13 03:32:57', '17928', null, '1', '1', '1', null, '604', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '1', '0', null);
INSERT INTO `vehicles` VALUES ('75', '459', '2453.048828', '-2631.063477', '13.728846', '359.461670', '359.994507', '270.972290', '2453.048828', '-2631.063477', '13.728846', '359.461670', '359.994507', '270.972290', '100', '0', '0', '0', '0', '3', '1000', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', 'NU2 5059', '-1', '-2', '8', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', null, '2021-04-13 04:32:55', '17926', null, '1', '1', '1', null, '0', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', null, '0', '0', null);
INSERT INTO `vehicles` VALUES ('76', '459', '2452.568359', '-2625.091797', '13.744218', '359.577026', '359.994507', '270.730591', '2452.568359', '-2625.091797', '13.744218', '359.577026', '359.994507', '270.730591', '100', '0', '0', '0', '0', '3', '1000', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', 'VG2 7371', '-1', '-2', '8', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '0', '255', '', '', '', '', '', null, null, '0', '0', '0', null, '2021-04-13 04:32:57', '17926', null, '1', '1', '1', null, '0', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', null, '0', '0', null);
INSERT INTO `vehicles` VALUES ('77', '459', '2451.923828', '-2618.402344', '13.734375', '359.582520', '359.829712', '271.082153', '2451.923828', '-2618.402344', '13.734375', '359.582520', '359.829712', '271.082153', '100', '0', '0', '0', '0', '3', '1000', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', 'IR2 7713', '-1', '-2', '8', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', null, '2021-04-13 04:32:59', '17926', null, '1', '1', '1', null, '0', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', null, '0', '0', null);
INSERT INTO `vehicles` VALUES ('78', '459', '2451.569336', '-2613.592773', '13.688346', '359.335327', '359.994507', '271.664429', '2451.569336', '-2613.592773', '13.688346', '359.335327', '359.994507', '271.664429', '100', '0', '0', '0', '0', '3', '1000', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', 'KI3 3165', '-1', '-2', '8', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '0', '255', '', '', '', '', '', null, null, '0', '0', '0', null, '2021-04-13 04:32:59', '17926', null, '1', '1', '1', null, '0', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', null, '0', '0', null);
INSERT INTO `vehicles` VALUES ('79', '459', '2451.301758', '-2608.327148', '13.687694', '359.230957', '359.994507', '273.153076', '2451.301758', '-2608.327148', '13.687694', '359.230957', '359.994507', '273.153076', '100', '0', '0', '0', '0', '3', '1000', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', 'LM8 6760', '-1', '-2', '8', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', null, '2021-04-13 04:33:02', '17926', null, '1', '1', '1', null, '0', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', null, '0', '0', null);
INSERT INTO `vehicles` VALUES ('80', '459', '2452.644531', '-2601.871094', '13.687970', '359.236450', '359.994507', '272.103882', '2452.644531', '-2601.871094', '13.687970', '359.236450', '359.994507', '272.103882', '100', '0', '0', '0', '0', '3', '1000', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', 'RE7 7662', '-1', '-2', '8', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', null, '2021-04-13 04:33:04', '17926', null, '1', '1', '1', null, '0', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', null, '0', '0', null);
INSERT INTO `vehicles` VALUES ('81', '459', '2452.746094', '-2596.457031', '13.680352', '359.181519', '359.994507', '271.120605', '2452.746094', '-2596.457031', '13.680352', '359.181519', '359.994507', '271.120605', '100', '0', '0', '0', '0', '3', '1000', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', 'KI1 6880', '-1', '-2', '8', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '0', '255', '', '', '', '', '', null, null, '0', '0', '0', null, '2021-04-13 04:33:06', '17926', null, '1', '1', '1', null, '0', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', null, '0', '0', null);
INSERT INTO `vehicles` VALUES ('82', '459', '2452.492188', '-2591.328125', '13.728799', '359.522095', '359.994507', '270.637207', '2452.492188', '-2591.328125', '13.728799', '359.522095', '359.994507', '270.637207', '100', '0', '0', '0', '0', '3', '1000', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', 'ZL9 8857', '-1', '-2', '8', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', null, '2021-04-13 04:33:08', '17926', null, '1', '1', '1', null, '0', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', null, '0', '0', null);
INSERT INTO `vehicles` VALUES ('83', '459', '2451.933594', '-2586.613281', '13.681612', '359.192505', '359.994507', '270.642700', '2451.933594', '-2586.613281', '13.681612', '359.192505', '359.994507', '270.642700', '100', '0', '0', '0', '0', '3', '1000', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', 'BP1 2679', '-1', '-2', '8', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', null, '2021-04-13 04:33:10', '17926', null, '1', '1', '1', null, '0', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', null, '0', '0', null);
INSERT INTO `vehicles` VALUES ('84', '459', '2451.297852', '-2579.441406', '13.714057', '359.417725', '359.994507', '272.340088', '2451.297852', '-2579.441406', '13.714057', '359.417725', '359.994507', '272.340088', '100', '0', '0', '1', '0', '3', '1000', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', 'LW1 1732', '-1', '-2', '8', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '0', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-13 04:41:49', '2021-04-13 04:33:12', '17926', null, '1', '1', '1', null, '0', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '0', '0', null);
INSERT INTO `vehicles` VALUES ('85', '455', '2205.103516', '-2635.248047', '13.983570', '0.000000', '359.994507', '178.104858', '2205.106445', '-2635.245117', '13.985906', '359.994507', '0.021973', '178.236694', '100', '1', '0', '1', '0', '3', '1000', '[ [ 42, 119, 161 ] ]', '[ [ 42, 119, 161 ] ]', '[ [ 42, 119, 161 ] ]', '[ [ 42, 119, 161 ] ]', 'BD6 5437', '-1', '-2', '11', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '0', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-13 05:08:42', '2021-04-13 04:51:23', '17926', null, '1', '1', '1', null, '0', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '0', '0', null);
INSERT INTO `vehicles` VALUES ('86', '456', '2569.854492', '-2417.904297', '13.809477', '359.956055', '0.000000', '314.774780', '2569.857422', '-2417.901367', '13.812477', '359.956055', '359.939575', '314.950562', '96', '1', '0', '1', '0', '3', '940', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', 'WR5 6354', '-1', '-2', '9', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 2, 0, 0, 0, 0, 3, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-13 04:57:54', '2021-04-13 04:40:27', '17926', null, '1', '1', '1', null, '0', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '0', '0', null);
INSERT INTO `vehicles` VALUES ('87', '455', '2210.827148', '-2635.272461', '13.983525', '0.000000', '359.994507', '178.829956', '2210.827148', '-2635.270508', '13.985040', '359.994507', '359.989014', '178.917847', '100', '1', '0', '1', '0', '3', '976', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', 'CM2 2222', '-1', '-2', '11', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 1, 0, 0, 0, 2, 2 ] ]', '[ [ 0, 2, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '1', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-13 05:08:05', '2021-04-13 04:51:40', '17926', null, '1', '1', '1', null, '0', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '0', '0', null);
INSERT INTO `vehicles` VALUES ('88', '455', '2199.675781', '-2635.263672', '13.986135', '0.000000', '0.000000', '178.818970', '2199.677734', '-2635.261719', '13.988007', '359.994507', '0.005493', '178.928833', '100', '1', '0', '1', '0', '3', '996', '[ [ 132, 4, 16 ] ]', '[ [ 132, 4, 16 ] ]', '[ [ 132, 4, 16 ] ]', '[ [ 132, 4, 16 ] ]', 'KS4 9478', '-1', '-2', '11', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 2, 0, 0, 0, 0, 2, 1 ] ]', '[ [ 0, 2, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '2', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-13 05:09:04', '2021-04-13 04:51:42', '17926', null, '1', '1', '1', null, '0', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '0', '0', null);
INSERT INTO `vehicles` VALUES ('89', '456', '2562.725586', '-2410.304688', '13.808451', '359.950562', '0.000000', '313.934326', '2562.725586', '-2410.304688', '13.808451', '359.950562', '0.000000', '313.934326', '100', '1', '0', '1', '0', '3', '1000', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', 'SZ1 4783', '-1', '-2', '9', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 1, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-13 04:58:33', '2021-04-13 04:51:53', '17927', null, '1', '1', '1', null, '0', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '0', '0', null);
INSERT INTO `vehicles` VALUES ('90', '455', '2210.906250', '-2659.664063', '13.983494', '0.000000', '359.994507', '3.367310', '2210.894531', '-2659.666992', '13.973021', '0.065918', '0.065918', '3.680420', '97', '1', '0', '1', '0', '3', '1000', '[ [ 134, 68, 110 ] ]', '[ [ 134, 68, 110 ] ]', '[ [ 134, 68, 110 ] ]', '[ [ 134, 68, 110 ] ]', 'WL2 9262', '-1', '-2', '11', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '0', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-13 05:27:59', '2021-04-13 04:51:57', '17926', null, '1', '1', '1', null, '0', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '0', '0', null);
INSERT INTO `vehicles` VALUES ('91', '420', '1777.242188', '-1931.350586', '13.157082', '359.719849', '359.972534', '0.170288', '1777.244141', '-1931.349609', '13.158365', '359.719849', '359.972534', '0.247192', '100', '0', '0', '1', '0', '3', '998', '[ [ 215, 142, 16 ] ]', '[ [ 215, 142, 16 ] ]', '[ [ 215, 142, 16 ] ]', '[ [ 215, 142, 16 ] ]', 'UX0 8344', '-1', '-2', '-1', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 1, 0, 0, 0, 1, 0 ] ]', '[ [ 0, 0, 1, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-13 05:39:39', '2021-04-13 05:38:37', '17926', null, '1', '1', '1', null, '0', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '0', '0', null);
INSERT INTO `vehicles` VALUES ('92', '420', '1796.543945', '-1931.435547', '13.166347', '359.758301', '0.000000', '359.461670', '1796.544922', '-1931.434570', '13.167249', '359.758301', '359.978027', '359.516602', '100', '1', '0', '1', '0', '3', '1000', '[ [ 215, 142, 16 ] ]', '[ [ 215, 142, 16 ] ]', '[ [ 215, 142, 16 ] ]', '[ [ 215, 142, 16 ] ]', 'HB2 1738', '-1', '-2', '-1', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-13 05:42:29', '2021-04-13 05:38:48', '17926', null, '1', '1', '1', null, '0', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '0', '0', null);
INSERT INTO `vehicles` VALUES ('93', '515', '2282.197266', '-2317.211914', '14.575178', '359.604492', '0.000000', '225.175781', '2282.198242', '-2317.210938', '14.576860', '359.604492', '0.000000', '225.274658', '100', '1', '0', '1', '0', '3', '1000', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', 'TE0 1290', '-1', '-2', '10', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-13 04:58:29', '2021-04-13 04:49:01', '17926', null, '1', '1', '1', null, '0', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '0', '0', null);
INSERT INTO `vehicles` VALUES ('94', '515', '2279.210938', '-2319.816406', '14.565313', '359.566040', '0.000000', '226.312866', '2279.211914', '-2319.816406', '14.566501', '359.571533', '0.000000', '226.378784', '100', '1', '0', '1', '0', '3', '1000', '[ [ 150, 129, 108 ] ]', '[ [ 150, 129, 108 ] ]', '[ [ 150, 129, 108 ] ]', '[ [ 150, 129, 108 ] ]', 'HO2 2617', '-1', '-2', '10', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-13 04:58:55', '2021-04-13 04:49:06', '17926', null, '1', '1', '1', null, '0', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '0', '0', null);
INSERT INTO `vehicles` VALUES ('95', '515', '2275.216797', '-2323.679688', '14.563688', '359.560547', '0.000000', '227.180786', '2275.217773', '-2323.678711', '14.564953', '359.566040', '0.000000', '227.263184', '100', '1', '0', '1', '0', '3', '991.5', '[ [ 132, 4, 16 ] ]', '[ [ 132, 4, 16 ] ]', '[ [ 132, 4, 16 ] ]', '[ [ 132, 4, 16 ] ]', 'HT9 7595', '-1', '-2', '10', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-13 05:00:00', '2021-04-13 04:49:10', '17926', null, '1', '1', '1', null, '0', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '0', '0', null);
INSERT INTO `vehicles` VALUES ('96', '515', '2266.929688', '-2332.132813', '14.567523', '359.577026', '0.000000', '224.890137', '2266.930664', '-2332.131836', '14.569024', '359.577026', '0.000000', '224.983521', '100', '1', '0', '1', '0', '3', '1000', '[ [ 39, 47, 75 ] ]', '[ [ 39, 47, 75 ] ]', '[ [ 39, 47, 75 ] ]', '[ [ 39, 47, 75 ] ]', 'NP2 9776', '-1', '-2', '10', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-13 05:10:16', '2021-04-13 04:49:12', '17926', null, '1', '1', '1', null, '0', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '0', '0', null);
INSERT INTO `vehicles` VALUES ('97', '456', '2555.551758', '-2402.917969', '13.807739', '359.950562', '0.000000', '313.928833', '2555.552734', '-2402.916016', '13.809536', '359.950562', '359.961548', '314.027710', '100', '1', '0', '1', '0', '3', '985', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', 'KP9 5040', '-1', '-2', '9', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 1 ] ]', '[ [ 0, 2, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-13 05:00:01', '2021-04-13 04:49:25', '17927', null, '1', '1', '1', null, '0', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '0', '0', null);
INSERT INTO `vehicles` VALUES ('98', '515', '2271.339844', '-2328.148438', '14.568799', '359.577026', '0.000000', '226.115112', '2271.340820', '-2328.147461', '14.570176', '359.582520', '0.000000', '226.197510', '100', '1', '0', '1', '0', '3', '1000', '[ [ 96, 26, 35 ] ]', '[ [ 96, 26, 35 ] ]', '[ [ 96, 26, 35 ] ]', '[ [ 96, 26, 35 ] ]', 'AU4 2917', '-1', '-2', '10', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-13 05:11:11', '2021-04-13 04:49:26', '17926', null, '1', '1', '1', null, '0', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '0', '0', null);
INSERT INTO `vehicles` VALUES ('99', '515', '2262.165039', '-2336.816406', '14.566230', '359.571533', '359.994507', '226.153564', '2262.166992', '-2336.814453', '14.569168', '359.582520', '0.000000', '226.329346', '100', '1', '0', '1', '0', '3', '1000', '[ [ 109, 108, 110 ] ]', '[ [ 109, 108, 110 ] ]', '[ [ 109, 108, 110 ] ]', '[ [ 109, 108, 110 ] ]', 'JL8 3913', '-1', '-2', '10', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-13 05:02:05', '2021-04-13 04:49:26', '17926', null, '1', '1', '1', null, '0', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '0', '0', null);
INSERT INTO `vehicles` VALUES ('100', '515', '2303.583984', '-2297.053711', '14.570946', '359.588013', '0.000000', '135.752563', '2303.583984', '-2297.050781', '14.572432', '359.593506', '0.065918', '135.840454', '100', '1', '0', '1', '0', '3', '991.5', '[ [ 150, 145, 140 ] ]', '[ [ 150, 145, 140 ] ]', '[ [ 150, 145, 140 ] ]', '[ [ 150, 145, 140 ] ]', 'IJ4 6481', '-1', '-2', '10', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-13 05:05:03', '2021-04-13 04:49:27', '17926', null, '1', '1', '1', null, '0', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '0', '0', null);
INSERT INTO `vehicles` VALUES ('101', '515', '2319.234375', '-2312.956055', '14.565059', '359.566040', '0.000000', '135.109863', '2319.234375', '-2312.953125', '14.566484', '359.571533', '0.065918', '135.192261', '100', '1', '0', '1', '0', '3', '1000', '[ [ 134, 68, 110 ] ]', '[ [ 134, 68, 110 ] ]', '[ [ 134, 68, 110 ] ]', '[ [ 134, 68, 110 ] ]', 'HQ3 3841', '-1', '-2', '10', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-13 05:06:28', '2021-04-13 04:49:28', '17926', null, '1', '1', '1', null, '0', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '0', '0', null);
INSERT INTO `vehicles` VALUES ('102', '515', '2323.466797', '-2317.829102', '14.591229', '359.653931', '0.000000', '135.812988', '2323.467773', '-2317.825195', '14.593400', '359.664917', '0.087891', '135.939331', '100', '0', '0', '1', '0', '3', '998.5', '[ [ 42, 119, 161 ] ]', '[ [ 42, 119, 161 ] ]', '[ [ 42, 119, 161 ] ]', '[ [ 42, 119, 161 ] ]', 'CX7 8460', '-1', '-2', '10', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-13 05:06:49', '2021-04-13 04:49:28', '17926', null, '1', '1', '1', null, '0', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '0', '0', null);
INSERT INTO `vehicles` VALUES ('103', '456', '2566.379883', '-2414.243164', '13.808146', '359.950562', '0.000000', '312.703857', '2566.381836', '-2414.241211', '13.809955', '359.956055', '359.983521', '312.808228', '100', '1', '0', '1', '0', '3', '1000', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', 'FP8 3682', '-1', '-2', '9', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-13 04:57:33', '2021-04-13 04:49:45', '17927', null, '1', '1', '1', null, '0', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '0', '0', null);
INSERT INTO `vehicles` VALUES ('104', '515', '2308.042969', '-2301.829102', '14.569031', '359.577026', '0.000000', '134.494629', '2308.043945', '-2301.828125', '14.570063', '359.582520', '0.043945', '134.555054', '100', '1', '0', '1', '0', '3', '998.5', '[ [ 189, 190, 198 ] ]', '[ [ 189, 190, 198 ] ]', '[ [ 189, 190, 198 ] ]', '[ [ 189, 190, 198 ] ]', 'DY5 5097', '-1', '-2', '10', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-13 05:04:49', '2021-04-13 04:49:35', '17926', null, '1', '1', '1', null, '0', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '0', '0', null);
INSERT INTO `vehicles` VALUES ('105', '420', '1781.018555', '-1931.204102', '13.167226', '359.763794', '0.000000', '359.961548', '1781.020508', '-1931.201172', '13.169195', '359.763794', '0.016479', '0.076904', '100', '1', '0', '1', '0', '3', '998.5', '[ [ 215, 142, 16 ] ]', '[ [ 215, 142, 16 ] ]', '[ [ 215, 142, 16 ] ]', '[ [ 215, 142, 16 ] ]', 'IW1 9750', '-1', '-2', '-1', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 1, 0, 0, 0, 1, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-13 05:39:59', '2021-04-13 05:38:49', '17926', null, '1', '1', '1', null, '0', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '0', '0', null);
INSERT INTO `vehicles` VALUES ('106', '515', '2314.805664', '-2308.520508', '14.567703', '359.577026', '0.000000', '134.945068', '2314.806641', '-2308.517578', '14.569383', '359.582520', '0.076904', '135.049438', '100', '1', '0', '1', '0', '3', '996', '[ [ 132, 4, 16 ] ]', '[ [ 132, 4, 16 ] ]', '[ [ 132, 4, 16 ] ]', '[ [ 132, 4, 16 ] ]', 'TJ4 6698', '-1', '-2', '10', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-13 05:05:38', '2021-04-13 04:49:36', '17926', null, '1', '1', '1', null, '0', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '0', '0', null);
INSERT INTO `vehicles` VALUES ('107', '455', '2232.703335', '-2626.882027', '13.413385', '0.000000', '0.000000', '5.287262', '2559.460205', '-2387.470459', '13.463540', '0.000000', '0.000000', '18.366669', '100', '0', '0', '1', '0', '0', '1000', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [0, 0, 0] ]', 'HK6 4353', '-1', '-2', '11', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '17927', '0', '0', '2021-04-13 04:52:06', '2021-04-13 04:52:06', '17926', null, '1', '1', '1', null, '0', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '0', '0', null);
INSERT INTO `vehicles` VALUES ('108', '455', '2205.796875', '-2659.986328', '13.983512', '0.000000', '359.994507', '1.411743', '2205.797852', '-2659.984375', '13.985052', '0.000000', '359.983521', '1.499634', '100', '1', '0', '1', '0', '3', '983', '[ [ 215, 142, 16 ] ]', '[ [ 215, 142, 16 ] ]', '[ [ 215, 142, 16 ] ]', '[ [ 215, 142, 16 ] ]', 'ER4 6272', '-1', '-2', '11', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 2 ] ]', '[ [ 0, 2, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-13 05:11:06', '2021-04-13 04:52:03', '17926', null, '1', '1', '1', null, '0', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '0', '0', null);
INSERT INTO `vehicles` VALUES ('109', '420', '1785.114258', '-1931.306641', '13.165867', '359.758301', '0.000000', '0.170288', '1785.116211', '-1931.305664', '13.167208', '359.763794', '359.967041', '0.247192', '99', '1', '0', '1', '0', '3', '679', '[ [ 215, 142, 16 ] ]', '[ [ 215, 142, 16 ] ]', '[ [ 215, 142, 16 ] ]', '[ [ 215, 142, 16 ] ]', 'JF5 9734', '-1', '-2', '-1', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 1, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-13 05:41:49', '2021-04-13 05:38:51', '17926', null, '1', '1', '1', null, '0', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '0', '0', null);
INSERT INTO `vehicles` VALUES ('110', '456', '2559.003906', '-2406.386719', '13.808563', '359.950562', '0.000000', '314.725342', '2559.003906', '-2406.386719', '13.808563', '359.950562', '0.000000', '314.725342', '100', '1', '0', '1', '0', '3', '1000', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', 'VC9 1227', '-1', '-2', '9', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 1, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-13 04:59:18', '2021-04-13 04:52:10', '17927', null, '1', '1', '1', null, '0', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '0', '0', null);
INSERT INTO `vehicles` VALUES ('111', '455', '2200.475586', '-2659.823242', '13.983539', '0.000000', '359.994507', '0.719604', '2200.512695', '-2659.837891', '14.019437', '0.000000', '0.000000', '359.978027', '96', '1', '0', '1', '0', '3', '993', '[ [ 76, 117, 183 ] ]', '[ [ 76, 117, 183 ] ]', '[ [ 76, 117, 183 ] ]', '[ [ 76, 117, 183 ] ]', 'AX2 7997', '-1', '-2', '11', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 2 ] ]', '[ [ 0, 0, 1, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '2', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-13 05:35:24', '2021-04-13 04:52:13', '17926', null, '1', '1', '1', null, '0', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '0', '0', null);
INSERT INTO `vehicles` VALUES ('112', '455', '2216.119141', '-2659.241211', '13.974075', '0.082397', '359.533081', '4.669189', '2216.057617', '-2657.668945', '13.991002', '0.071411', '359.478149', '2.444458', '96', '1', '0', '1', '0', '3', '995.5', '[ [ 38, 55, 57 ] ]', '[ [ 38, 55, 57 ] ]', '[ [ 38, 55, 57 ] ]', '[ [ 38, 55, 57 ] ]', 'XD7 8215', '-1', '-2', '11', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 1 ] ]', '[ [ 0, 0, 1, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '2', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-13 05:31:08', '2021-04-13 04:52:17', '17926', null, '1', '1', '1', null, '0', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '0', '0', null);
INSERT INTO `vehicles` VALUES ('113', '420', '1788.838867', '-1931.377930', '13.167120', '359.763794', '0.000000', '359.901123', '1788.839844', '-1931.375977', '13.168307', '359.763794', '359.989014', '359.967041', '99', '1', '0', '1', '0', '3', '1000', '[ [ 215, 142, 16 ] ]', '[ [ 215, 142, 16 ] ]', '[ [ 215, 142, 16 ] ]', '[ [ 215, 142, 16 ] ]', 'OB2 9499', '-1', '-2', '-1', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-13 05:42:07', '2021-04-13 05:38:53', '17926', null, '1', '1', '1', null, '0', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '0', '0', null);
INSERT INTO `vehicles` VALUES ('114', '456', '2551.481445', '-2398.709961', '13.808023', '359.950562', '0.000000', '314.851685', '2551.483398', '-2398.708008', '13.809930', '359.956055', '359.939575', '314.961548', '100', '1', '0', '1', '0', '3', '1000', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', 'TQ8 2196', '-1', '-2', '9', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-13 05:01:28', '2021-04-13 05:00:20', '17927', null, '1', '1', '1', null, '0', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '0', '0', null);
INSERT INTO `vehicles` VALUES ('115', '420', '1792.648438', '-1931.303711', '13.166064', '359.758301', '0.000000', '0.054932', '1792.649414', '-1931.302734', '13.167107', '359.758301', '359.989014', '0.109863', '100', '1', '0', '1', '0', '3', '1000', '[ [ 215, 142, 16 ] ]', '[ [ 215, 142, 16 ] ]', '[ [ 215, 142, 16 ] ]', '[ [ 215, 142, 16 ] ]', 'IM6 9738', '-1', '-2', '-1', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-13 05:41:15', '2021-04-13 05:38:56', '17926', null, '1', '1', '1', null, '0', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '0', '0', null);
INSERT INTO `vehicles` VALUES ('116', '438', '1800.558594', '-1931.623047', '13.390154', '359.714355', '0.000000', '359.390259', '1800.560547', '-1931.622070', '13.391346', '359.725342', '0.027466', '359.456177', '100', '1', '0', '1', '0', '3', '1000', '[ [ 215, 142, 16 ] ]', '[ [ 215, 142, 16 ] ]', '[ [ 215, 142, 16 ] ]', '[ [ 215, 142, 16 ] ]', 'WY1 5977', '-1', '-2', '-1', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-13 05:43:00', '2021-04-13 05:39:02', '17926', null, '1', '1', '1', null, '0', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '0', '0', null);
INSERT INTO `vehicles` VALUES ('117', '456', '2536.616345', '-2382.780733', '13.638141', '0.000000', '0.000000', '157.400757', '2536.616345', '-2382.780733', '13.638141', '0.000000', '0.000000', '157.400757', '100', '0', '0', '0', '0', '0', '1000', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [0, 0, 0] ]', 'WZ3 1652', '-1', '-2', '9', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '3', '255', '', '', '', '', '', null, null, '17927', '0', '0', null, '2021-04-13 04:53:42', '17927', null, '1', '1', '1', null, '0', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', null, '0', '0', null);
INSERT INTO `vehicles` VALUES ('118', '438', '1804.688477', '-1931.686523', '13.390667', '359.714355', '0.000000', '358.994751', '1804.690430', '-1931.685547', '13.391557', '359.719849', '0.010986', '359.049683', '100', '1', '0', '1', '0', '3', '1000', '[ [ 215, 142, 16 ] ]', '[ [ 215, 142, 16 ] ]', '[ [ 215, 142, 16 ] ]', '[ [ 215, 142, 16 ] ]', 'DP2 9273', '-1', '-2', '-1', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-13 05:43:30', '2021-04-13 05:39:05', '17926', null, '1', '1', '1', null, '0', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '0', '0', null);
INSERT INTO `vehicles` VALUES ('119', '562', '1122.530597', '-1400.464805', '13.407583', '0.000000', '0.000000', '87.746399', '592.192383', '364.113281', '18.590471', '359.544067', '0.021973', '214.996948', '96', '1', '0', '2', '0', '0', '1000', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', '[ [ 245, 245, 245 ] ]', 'SF7 7886', '-1', '22269', '-1', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '17928', '0', '0', '2021-04-13 06:15:53', '2021-04-13 06:11:13', '17926', null, '1', '1', '1', null, '120', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '0', '0', null);
INSERT INTO `vehicles` VALUES ('13093', '402', '1711.066810', '-2660.867357', '13.546875', '0.000000', '0.000000', '337.040955', '1925.880859', '-2488.548828', '13.276499', '0.922852', '0.021973', '0.565796', '99', '0', '0', '2', '0', '0', '300', '[ [ 255, 255, 255 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', 'MASSERIAV1I', '-1', '22275', '-1', '1', '1', '0', '1', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-11 19:07:46', '2021-04-11 19:02:29', '-1', null, '1', '1', '1', null, '1081', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'lightblue', '0', '0', null);
INSERT INTO `vehicles` VALUES ('13094', '529', '1922.267986', '-2487.075899', '13.539118', '0.000000', '0.000000', '257.712982', '1699.130859', '-712.427734', '47.929298', '5.685425', '5.284424', '181.494141', '93', '1', '0', '2', '0', '3', '640.5', '[ [ 38, 55, 57 ] ]', '[ [ 38, 55, 57 ] ]', '[ [ 38, 55, 57 ] ]', '[ [ 38, 55, 57 ] ]', 'MASSERIA', '-1', '22275', '-1', '0', '1', '0', '1', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 1, 0, 0, 0, 0, 1, 0 ] ]', '[ [ 0, 0, 1, 3, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-13 04:09:35', '2021-04-11 19:09:33', '-1', null, '1', '1', '1', null, '1076', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'pink', '0', '0', null);
INSERT INTO `vehicles` VALUES ('13095', '529', '1121.610086', '-1305.300663', '6.000000', '0.000000', '0.000000', '1.277191', '2894.290039', '-1369.422852', '10.933234', '0.554810', '359.774780', '110.335693', '1', '0', '0', '2', '0', '0', '300', '[ [ 255, 255, 255 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', 'WP2 3894', '-1', '22270', '-1', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 2, 2, 0, 0, 0, 2, 2 ] ]', '[ [ 0, 2, 1, 2, 0, 2 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '17928', '0', '0', '2021-04-12 19:47:05', '2021-04-11 23:46:47', '-1', null, '1', '1', '1', null, '1076', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'red', '0', '0', null);
INSERT INTO `vehicles` VALUES ('13096', '561', '1202.909242', '-1301.626126', '13.383829', '0.000000', '0.000000', '258.954468', '2658.347656', '-1654.058594', '10.439549', '357.522583', '353.353271', '155.319214', '99', '0', '0', '1', '0', '3', '300', '[ [ 132, 4, 16 ] ]', '[ [ 132, 4, 16 ] ]', '[ [ 132, 4, 16 ] ]', '[ [ 132, 4, 16 ] ]', 'NE4 5238', '-1', '22271', '-1', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 2, 2, 0, 0, 0, 3, 1 ] ]', '[ [ 4, 2, 4, 2, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '17926', '0', '0', '2021-04-11 23:57:26', '2021-04-11 23:53:33', '-1', null, '1', '1', '1', null, '1077', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '0', '0', null);
INSERT INTO `vehicles` VALUES ('13097', '529', '2748.312794', '-2355.026311', '41.933167', '0.000000', '0.000000', '137.696472', '2735.830078', '-2139.577148', '11.024248', '359.923096', '0.488892', '258.601685', '100', '1', '0', '1', '0', '0', '846', '[ [ 255, 255, 255 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', 'Ã¶rn: SLR26', '-1', '22273', '-1', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 2, 2, 0, 0, 0, 3, 0 ] ]', '[ [ 4, 0, 1, 2, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-12 19:38:16', '2021-04-12 00:15:31', '-1', null, '1', '1', '1', null, '1076', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'white', '0', '0', null);
INSERT INTO `vehicles` VALUES ('13098', '490', '-1748.804253', '885.918671', '295.875000', '0.000000', '0.000000', '1.810028', '2755.572266', '-2176.278320', '10.958905', '2.735596', '359.862671', '56.727905', '100', '1', '0', '2', '0', '3', '956.5', '[ [ 63, 62, 69 ] ]', '[ [ 63, 62, 69 ] ]', '[ [ 63, 62, 69 ] ]', '[ [ 63, 62, 69 ] ]', 'CroW', '-1', '22276', '-1', '1', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 2, 1 ] ]', '[ [ 0, 2, 3, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-12 19:38:11', '2021-04-12 11:51:25', '-1', null, '1', '1', '1', null, '1078', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'rasta', '0', '0', null);
INSERT INTO `vehicles` VALUES ('13099', '561', '1462.814693', '-686.492741', '94.750000', '0.000000', '0.000000', '320.632629', '1462.814693', '-686.492741', '94.750000', '0.000000', '0.000000', '320.632629', '100', '0', '1', '0', '0', '0', '1000', '[ [ 255, 255, 255 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', 'HZ3 8164', '-1', '22273', '-1', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', null, '2021-04-12 18:07:36', '-1', null, '1', '1', '1', null, '1077', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', null, '0', '0', null);
INSERT INTO `vehicles` VALUES ('13100', '412', '1463.252339', '-684.182913', '94.750000', '0.000000', '0.000000', '321.742279', '1463.252339', '-684.182913', '94.750000', '0.000000', '0.000000', '321.742279', '100', '0', '0', '0', '0', '0', '1000', '[ [ 255, 255, 255 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', 'MH4 6531', '-1', '22273', '-1', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-12 19:36:23', '2021-04-12 18:07:42', '-1', null, '1', '1', '1', null, '1080', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', null, '0', '0', null);
INSERT INTO `vehicles` VALUES ('13101', '402', '1462.268148', '-671.191079', '94.750000', '0.000000', '0.000000', '43.130249', '1462.268148', '-671.191079', '94.750000', '0.000000', '0.000000', '43.130249', '100', '0', '1', '0', '0', '0', '1000', '[ [ 255, 255, 255 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', 'YK7 7566', '-1', '22273', '-1', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', null, '2021-04-12 18:07:48', '-1', null, '1', '1', '1', null, '1081', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', null, '0', '0', null);
INSERT INTO `vehicles` VALUES ('13103', '529', '2842.022057', '-1691.978232', '10.875000', '0.000000', '0.000000', '196.331436', '694.171875', '-599.041016', '15.961349', '359.972534', '359.994507', '79.755249', '99', '1', '0', '2', '0', '3', '1000', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', '[ [ 0, 0, 0 ] ]', 'ZE8 6170', '-1', '1', '-1', '0', '0', '0', '0', '0', '0', null, null, '0', '0', null, null, null, null, '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '0', '[ [ 255, 255, 255 ] ]', '255', '255', '', '', '', '', '', null, null, '0', '0', '0', '2021-04-18 20:25:56', '2021-04-18 20:21:01', '-1', null, '1', '1', '1', null, '1076', '0', '[ [ ] ]', '-1', null, '0', null, null, null, null, '0', '0', '0', '0', 'N/A', '0', '0', null);

-- ----------------------------
-- Table structure for `vehicles_custom`
-- ----------------------------
DROP TABLE IF EXISTS `vehicles_custom`;
CREATE TABLE `vehicles_custom` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `brand` text,
  `model` text,
  `year` int(11) DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `handling` varchar(1000) DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `tax` int(11) DEFAULT NULL,
  `createdate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `createdby` int(11) NOT NULL DEFAULT '0',
  `updatedate` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updatedby` int(11) NOT NULL DEFAULT '0',
  `notes` text,
  `doortype` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `id_UNIQUE` (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=13103 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of vehicles_custom
-- ----------------------------
INSERT INTO `vehicles_custom` VALUES ('13093', 'Masserati ', 'GranTourismo MC Stradale', '2020', null, null, null, null, '2021-04-11 19:06:21', '0', '0000-00-00 00:00:00', '0', null, '2');
INSERT INTO `vehicles_custom` VALUES ('13097', 'Audi', 'A7', '2017', null, null, null, null, '2021-04-12 00:16:23', '0', '0000-00-00 00:00:00', '0', null, '2');
INSERT INTO `vehicles_custom` VALUES ('13098', 'Land Rover', 'Range Rover', '2016', null, null, null, null, '2021-04-12 12:02:10', '0', '0000-00-00 00:00:00', '0', null, '2');
INSERT INTO `vehicles_custom` VALUES ('13102', 'Tofas', 'Dogan SLXX', '1994', null, null, '0', '0', '2021-04-12 19:36:41', '17932', '0000-00-00 00:00:00', '0', '\n', null);

-- ----------------------------
-- Table structure for `vehicles_shop`
-- ----------------------------
DROP TABLE IF EXISTS `vehicles_shop`;
CREATE TABLE `vehicles_shop` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `vehmtamodel` int(11) DEFAULT '0',
  `vehbrand` text,
  `vehmodel` text,
  `vehyear` int(11) DEFAULT '2014',
  `vehprice` int(11) DEFAULT '0',
  `vehtax` int(11) DEFAULT '0',
  `createdate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `createdby` int(11) NOT NULL DEFAULT '0',
  `updatedate` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updatedby` int(11) NOT NULL DEFAULT '0',
  `notes` text,
  `handling` varchar(1000) DEFAULT NULL,
  `duration` int(11) NOT NULL DEFAULT '1000',
  `enabled` int(1) NOT NULL DEFAULT '0',
  `spawnto` tinyint(2) NOT NULL DEFAULT '0',
  `doortype` int(11) DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `id_UNIQUE` (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1082 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of vehicles_shop
-- ----------------------------
INSERT INTO `vehicles_shop` VALUES ('73', '429', 'Honda', 'S2000', '2009', '37500', '75', '2014-02-18 16:28:49', '12', '2020-04-30 21:42:56', '744', '\n', '[ [ 1100, 3000, 2, [ 0, 0, -0.200000 ], 70, 0.750000, 0.890000, 0.500000, 5, 145, 10, 10, \"rwd\", \"petrol\", 8, 0.500000, false, 34, 1.600000, 0.100000, 5, 0.300000, -0.200000, 0.500000, 0.300000, 0.150000, 0.490000, 45000, 8196, 2097152, \"small\", \"small\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('74', '429', 'Honda', 'S2000', '2001', '21850', '70', '2014-02-18 16:29:23', '12', '2020-06-20 04:24:45', '2545', '\n', '[ [ 1200, 3000, 1.799999952316284, [ 0, 0, -0.2000000029802322 ], 70, 0.75, 0.8899999856948853, 0.5, 5, 172, 12, 10, \"rwd\", \"petrol\", 6, 0.5, false, 34, 1.600000023841858, 0.1000000014901161, 5, 0.300000011920929, -0.1000000014901161, 0.5, 0.300000011920929, 0.1500000059604645, 0.4900000095367432, 45000, 8196, 2097152, \"small\", \"small\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('75', '477', 'Nissan', '240SX Hatchback', '1990', '10000', '75', '2014-02-18 16:29:24', '55', '2014-12-27 22:05:57', '55', '\n', '[ [ 1400, 2979.699951, 2, [ 0, 0.200000, -0.100000 ], 70, 0.800000, 0.800000, 0.510000, 5, 135, 7, 10, \"rwd\", \"petrol\", 11.100000, 0.500000, false, 30, 1.200000, 0.100000, 0, 0.310000, -0.200000, 0.500000, 0.300000, 0.240000, 0.600000, 45000, 0, 12582912, \"small\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('76', '554', 'Ford', 'F-150 SVT Raptor', '2014', '94415', '200', '2014-02-18 16:32:42', '87', '2020-03-13 16:14:10', '745', '\n', '[ [ 5000, 6000, 1, [ 0, 0, -0.25 ], 80, 1.0499999523162842, 0.80000001192092896, 0.47999998927116394, 5, 180, 13.5, 9, \"awd\", \"petrol\", 9, 0.5, false, 46, 0.60000002384185791, 0.20000000298023224, 0, 0.23999999463558197, -0.40000000596046448, 0.5, 0.5, 0.43999999761581421, 0.30000001192092896, 40000, 538968096, 5260288, \"long\", \"small\", 0 ] ]', '1000', '1', '1', '0');
INSERT INTO `vehicles_shop` VALUES ('77', '554', 'Ford', 'F-250 XL', '2014', '50035', '50', '2014-02-18 16:34:38', '87', '2014-03-21 00:27:32', '705', '\n', '[ [ 2000, 6000, 3, [ 0, 0.350000, 0 ], 80, 0.600000, 0.800000, 0.400000, 5, 140, 10, 15, \"rwd\", \"petrol\", 8.500000, 0.300000, false, 30, 1, 0.120000, 0, 0.240000, -0.200000, 0.500000, 0.500000, 0.440000, 0.300000, 40000, 538968064.000000, 5260288, \"long\", \"small\", 0 ] ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('78', '477', 'Nissan', 'Sileighty', '1990', '16500', '35', '2014-02-18 16:35:05', '55', '2014-12-27 22:05:48', '55', '\n', '[ [ 1400, 2979.699951, 2, [ 0, 0.200000, -0.100000 ], 70, 0.800000, 0.800000, 0.510000, 5, 135, 7, 10, \"rwd\", \"petrol\", 11.100000, 0.500000, false, 30, 1.200000, 0.100000, 0, 0.310000, -0.200000, 0.500000, 0.300000, 0.240000, 0.600000, 45000, 0, 12582912, \"small\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('79', '477', 'Nissan', 'RPS13', '1998', '19000', '35', '2014-02-18 16:35:40', '55', '2014-08-27 02:05:33', '1622', '\n', '[ [ 1400, 2979.699951, 2, [ 0, 0.200000, -0.100000 ], 70, 0.800000, 0.800000, 0.510000, 5, 135, 7, 10, \"rwd\", \"petrol\", 11.100000, 0.500000, false, 30, 1.200000, 0.100000, 0, 0.310000, -0.200000, 0.500000, 0.300000, 0.240000, 0.600000, 45000, 0, 12582912, \"small\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('80', '580', 'Rolls-Royce', 'Phantom', '2005', '159500', '120', '2014-02-18 16:36:08', '12', '2014-12-27 22:09:20', '55', '\n', '[ [ 2200, 6000, 2.500000, [ 0, 0, 0 ], 75, 0.650000, 0.920000, 0.500000, 5, 150, 13, 15, \"rwd\", \"petrol\", 5, 0.600000, false, 30, 1.100000, 0.100000, 0, 0.270000, -0.200000, 0.500000, 0.300000, 0.200000, 0.560000, 35000, 0, 4194304, \"long\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('81', '580', 'Rolls-Royce', 'Phantom', '2014', '435750', '125', '2014-02-18 16:36:30', '12', '2019-11-06 20:15:33', '1438', '\n', '[ [ 2200, 6000, 2.5, [ 0, 0, 0 ], 75, 0.6499999761581421, 0.9200000166893005, 0.5, 5, 240, 17, 4, \"awd\", \"petrol\", 5, 0.6000000238418579, false, 30, 1.100000023841858, 0.1000000014901161, 0, 0.2700000107288361, -0.1000000014901161, 0.5, 0.300000011920929, 0.2000000029802322, 0.5600000023841858, 35000, 0, 4194304, \"long\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('82', '554', 'Ford', 'F-350 XL', '2014', '50930', '60', '2014-02-18 16:37:00', '87', '2014-03-20 23:00:18', '705', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('83', '554', 'Ford', 'F-250 XLT', '2014', '54065', '60', '2014-02-18 16:37:53', '87', '2014-07-26 14:43:47', '1115', '\n', null, '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('84', '554', 'Ford', 'F-350 XLT', '2014', '54965', '60', '2014-02-18 16:39:39', '87', '2014-07-27 15:40:39', '1115', '\n', null, '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('85', '554', 'Ford', 'F-250 Lariat', '2014', '61730', '65', '2014-02-18 16:41:52', '87', '2014-03-20 22:58:11', '705', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('86', '554', 'Ford', 'F-350 Lariat', '2014', '92625', '100', '2014-02-18 16:42:17', '87', '2020-05-29 14:53:32', '744', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('87', '554', 'Ford', 'F-250 King Ranch', '2014', '69515', '65', '2014-02-18 16:43:39', '87', '2014-03-20 22:58:20', '705', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('88', '554', 'Ford', 'F-350 King Ranch', '2014', '70415', '70', '2014-02-18 16:45:15', '87', '2014-03-20 22:58:52', '705', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('89', '554', 'Ford', 'F-250 Platinum', '2014', '73400', '70', '2014-02-18 16:47:04', '87', '2021-03-26 22:06:00', '17825', '\n', '[ [ 3000, 6000, 3, [ 0, 0.3499999940395355, 0 ], 80, 0.6000000238418579, 0.800000011920929, 0.4000000059604645, 5, 170, 10, 15, \"rwd\", \"petrol\", 8.5, 0.300000011920929, false, 30, 1, 0.119999997317791, 0, 0.239999994635582, -0.2000000029802322, 0.5, 0.5, 0.4399999976158142, 0.300000011920929, 40000, 538968096, 5260288, \"long\", \"small\", 0 ] ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('90', '554', 'Ford', 'F-350 Platinum', '2014', '74300', '70', '2014-02-18 16:47:22', '87', '2014-03-20 22:58:36', '705', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('91', '554', 'Ford', 'F-150 XL', '2014', '44445', '50', '2014-02-18 16:59:30', '87', '2014-03-20 22:58:42', '705', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('92', '554', 'Ford', 'F-150 STX', '2014', '96930', '50', '2014-02-18 16:59:55', '87', '2020-04-30 21:55:56', '744', '\n', '[ [ 3000, 6000, 3, [ 0, 0.350000, 0 ], 80, 0.600000, 0.800000, 0.400000, 5, 170, 10, 15, \"rwd\", \"petrol\", 8.500000, 0.300000, false, 30, 1, 0.120000, 0, 0.240000, -0.200000, 0.500000, 0.500000, 0.440000, 0.300000, 40000, 538968096, 5260288, \"long\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('93', '554', 'Ford', 'F-150 XLT', '2014', '49775', '50', '2014-02-18 17:00:21', '87', '2014-03-20 22:59:37', '705', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('94', '554', 'Ford', 'F-150 Lariat', '2014', '57060', '60', '2014-02-18 17:01:22', '87', '2014-03-20 22:58:59', '705', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('95', '554', 'Ford', 'F-150 FX2', '2014', '58545', '60', '2014-02-18 17:02:19', '87', '2014-03-20 22:59:07', '705', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('96', '554', 'Ford', 'F-150 FX4', '2014', '62660', '60', '2014-02-18 17:03:58', '87', '2014-07-26 14:43:25', '1115', '\n', null, '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('97', '554', 'Ford', 'F-150 King Ranch', '2014', '64300', '60', '2014-02-18 17:04:21', '87', '2014-03-20 22:59:54', '705', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('98', '554', 'Ford', 'F-150 Platinum', '2014', '67325', '60', '2014-02-18 17:05:55', '87', '2014-03-20 23:00:08', '705', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('99', '554', 'Ford', 'F-150 Limited', '2014', '97405', '90', '2014-02-18 17:06:12', '87', '2020-04-30 21:57:03', '744', '\n', '[ [ 3000, 6000, 2.500000, [ 0, 0.350000, 0 ], 80, 0.600000, 0.800000, 0.400000, 5, 220, 13, 10, \"rwd\", \"petrol\", 8.500000, 0.300000, false, 35, 1, 0.120000, 0, 0.240000, -0.200000, 0.500000, 0.500000, 0.440000, 0.300000, 40000, 538968096, 5260288, \"long\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('100', '580', 'Bentley', 'Mulsanne', '2011', '270000', '13', '2014-02-18 17:07:10', '12', '2020-04-30 21:56:58', '744', '\n', '[ [ 3200, 6000, 2.5, [ 0, 0, 0 ], 75, 0.64999997615814209, 0.92000001668930054, 0.5, 5, 260, 20, 20, \"awd\", \"petrol\", 30, 0.5, false, 30, 1.1000000238418579, 0.10000000149011612, 0, 0.27000001072883606, -0.20000000298023224, 0.5, 0.30000001192092896, 0.20000000298023224, 0.56000000238418579, 35000, 0, 4194304, \"long\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('101', '477', 'Mazda', 'RX-7 FD3S', '1991', '20500', '50', '2014-02-18 17:10:34', '12', '2015-01-20 07:58:36', '10139', '\n', '[ [ 1000, 2979.699951171875, 1.2999999523162842, [ 0, 0.20000000298023224, -0.10000000149011612 ], 70, 0.80000001192092896, 0.80000001192092896, 0.50999999046325684, 5, 158, 7, 10, \"rwd\", \"petrol\", 6, 0.60000002384185791, false, 30, 1.2000000476837158, 0.10000000149011612, 0, 0.31000000238418579, -0.10000000149011612, 0.5, 0.30000001192092896, 0.23999999463558197, 0.60000002384185791, 45000, 0, 12582912, \"small\", \"small\", 0 ] ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('109', '496', 'Audi', 'S3', '2009', '37000', '50', '2014-02-18 17:20:17', '12', '2014-04-29 00:06:35', '860', '\n', '[ [ 1000, 2141.699951, 2.400000, [ 0, 0, -0.100000 ], 50, 0.850000, 0.850000, 0.500000, 5, 140, 9, 5, \"fwd\", \"petrol\", 11, 0.400000, false, 30, 1.400000, 0.100000, 0, 0.280000, -0.100000, 0.500000, 0, 0.250000, 0.500000, 35000, 2147483648.000000, 12582912, \"small\", \"small\", 0 ] ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('114', '496', 'Honda', 'CR-X', '1984', '7500', '25', '2014-02-18 17:22:21', '12', '2014-06-19 00:06:03', '1107', '\n', '[ [ 1000, 2141.699951, 2.400000, [ 0, 0, -0.100000 ], 50, 0.850000, 0.850000, 0.500000, 5, 135, 8.500000, 5, \"fwd\", \"petrol\", 11, 0.400000, false, 30, 1.400000, 0.100000, 0, 0.280000, -0.100000, 0.500000, 0, 0.250000, 0.500000, 35000, 3221225472.000000, 12582912, \"small\", \"small\", 0 ] ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('115', '496', 'Honda', 'CR-X Del Sol', '1992', '10900', '25', '2014-02-18 17:23:56', '12', '2014-06-19 01:33:10', '1107', '\n', '[ [ 1000, 2141.699951, 2.400000, [ 0, 0, -0.100000 ], 50, 0.850000, 0.850000, 0.500000, 5, 140, 9.500000, 5, \"fwd\", \"petrol\", 11, 0.400000, false, 30, 1.400000, 0.100000, 0, 0.280000, -0.100000, 0.500000, 0, 0.250000, 0.500000, 35000, 3221225472.000000, 12582912, \"small\", \"small\", 0 ] ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('116', '436', 'Nissan', 'R31', '1987', '12000', '25', '2014-02-18 17:24:58', '55', '2014-08-27 02:08:39', '1622', '\n', '[ [ 1400, 3000, 2, [ 0, 0.300000, -0.100000 ], 70, 0.700000, 0.800000, 0.450000, 4, 140, 10, 7, \"rwd\", \"petrol\", 8, 0.600000, false, 35, 1.100000, 0.080000, 2, 0.310000, -0.200000, 0.600000, 0.300000, 0.210000, 0.500000, 9000, 0, 0, \"long\", \"long\", 0 ] ]', '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('117', '565', 'Honda', 'Civic', '1992', '11000', '25', '2014-02-18 17:25:55', '12', '2015-01-24 18:56:57', '1260', '\n', '[ [ 1400, 2998.300048828125, 1.7999999523162842, [ 0, 0.20000000298023224, -0.10000000149011612 ], 75, 0.75, 0.89999997615814209, 0.5, 5, 125, 7.1999998092651367, 10, \"fwd\", \"petrol\", 8, 0.60000002384185791, false, 30, 1.3999999761581421, 0.15000000596046448, 0, 0.2800000011920929, -0.10000000149011612, 0.5, 0.30000001192092896, 0.25, 0.60000002384185791, 35000, 10244, 67108864, \"small\", \"small\", 1 ] ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('118', '451', 'Toyota', 'GT-One', '1999', '1300000', '360', '2014-02-18 17:26:15', '87', '2020-05-01 18:57:48', '2545', '\n', '[ [ 1100, 3000, 0.5, [ 0, -0.300000011920929, -0.300000011920929 ], 70, 1.200000047683716, 0.8500000238418579, 0.449999988079071, 5, 240, 17, 22, \"awd\", \"petrol\", 8, 0.5, false, 30, 1.200000047683716, 0.1299999952316284, 0, 0.1500000059604645, -0.1000000014901161, 0.5, 0.4000000059604645, 0.1700000017881393, 0.7200000286102295, 95000, 1073750020, 12616705, \"small\", \"small\", 1 ] ]', '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('119', '565', 'Honda', 'Civic SiR', '1992', '14500', '30', '2014-02-18 17:26:16', '12', '2014-06-19 01:33:25', '1107', '\n', '[ [ 1400, 2998.300049, 2.200000, [ 0, 0.200000, -0.100000 ], 75, 0.750000, 0.900000, 0.500000, 5, 135, 8.200000, 10, \"fwd\", \"petrol\", 8, 0.600000, false, 30, 1.400000, 0.150000, 0, 0.280000, -0.100000, 0.500000, 0.300000, 0.250000, 0.600000, 35000, 10244, 67108864, \"small\", \"small\", 1 ] ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('120', '562', 'Nissan', '240SX S14 Kouki', '1996', '17000', '30', '2014-02-18 17:26:59', '55', '2014-12-27 22:05:36', '55', '\n', '[ [ 1500, 3500, 2.200000, [ 0, 0.300000, -0.150000 ], 75, 0.650000, 0.900000, 0.500000, 5, 135, 7, 5, \"rwd\", \"petrol\", 8, 0.500000, false, 35, 1, 0.200000, 0, 0.280000, -0.100000, 0.500000, 0.300000, 0.250000, 0.600000, 35000, 1073752064, 67108864, \"small\", \"small\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('121', '410', 'Honda', 'Civic EX', '1996', '12000', '25', '2014-02-18 17:27:45', '12', '2014-06-25 22:14:44', '1737', '\n', '[ [ 1400, 2998.300049, 2.200000, [ 0, 0.200000, -0.100000 ], 75, 0.750000, 0.900000, 0.500000, 5, 130, 7.500000, 10, \"fwd\", \"petrol\", 8, 0.600000, false, 30, 1.400000, 0.150000, 0, 0.280000, -0.100000, 0.500000, 0.300000, 0.250000, 0.600000, 35000, 10244, 67108864, \"small\", \"small\", 1 ] ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('122', '565', 'Honda', 'Civic DX', '1996', '14000', '30', '2014-02-18 17:28:00', '12', '2014-07-22 12:12:29', '1737', '\n', '[ [ 1400, 2998.300049, 2.200000, [ 0, 0.200000, -0.100000 ], 75, 0.800000, 0.900000, 0.500000, 5, 150, 12, 10, \"fwd\", \"petrol\", 8, 0.600000, false, 30, 1.400000, 0.150000, 0, 0.280000, -0.100000, 0.500000, 0.300000, 0.250000, 0.600000, 35000, 10244, 67108864, \"small\", \"small\", 1 ] ]', '1000', '1', '2', '0');
INSERT INTO `vehicles_shop` VALUES ('123', '565', 'Honda', 'Civic GL', '1987', '6500', '20', '2014-02-18 17:29:37', '12', '2014-06-19 01:12:01', '1107', '\n', '[ [ 1200, 2998.300049, 2.200000, [ 0, 0.200000, -0.100000 ], 75, 0.750000, 0.900000, 0.500000, 5, 120, 7, 10, \"fwd\", \"petrol\", 8, 0.600000, false, 30, 1.400000, 0.150000, 0, 0.280000, -0.100000, 0.500000, 0.300000, 0.250000, 0.600000, 35000, 10244, 67108864, \"small\", \"small\", 1 ] ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('124', '565', 'Honda', 'Civic Si', '1987', '10000', '25', '2014-02-18 17:30:18', '12', '2014-06-19 01:14:12', '1107', '\n', '[ [ 1400, 2998.300049, 2.200000, [ 0, 0.200000, -0.100000 ], 75, 0.750000, 0.900000, 0.500000, 5, 130, 7.500000, 10, \"fwd\", \"petrol\", 8, 0.600000, false, 30, 1.400000, 0.150000, 0, 0.280000, -0.100000, 0.500000, 0.300000, 0.250000, 0.600000, 35000, 10244, 67108864.000000, \"small\", \"small\", 1 ] ]', '1000', '0', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('125', '562', 'Nissan', 'Skyline BNR32 GXi Type-X', '1994', '21000', '50', '2014-02-18 17:30:34', '55', '2014-08-27 02:10:22', '1622', '\n', '[ [ 1500, 3500, 2.200000, [ 0, 0.300000, -0.150000 ], 75, 0.600000, 0.900000, 0.500000, 5, 150, 7, 2, \"rwd\", \"petrol\", 8, 0.500000, false, 35, 0.800000, 0.200000, 0, 0.280000, -0.200000, 0.500000, 0.300000, 0.250000, 0.600000, 35000, 1073752064, 67108864, \"small\", \"small\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('128', '482', 'Ford', 'Commercial E-150', '2014', '38600', '50', '2014-02-18 17:32:22', '87', '2014-03-20 23:05:57', '705', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('129', '482', 'Ford', 'Commercial E-150 Extended', '2014', '39815', '50', '2014-02-18 17:32:53', '87', '2014-03-20 23:02:15', '705', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('130', '482', 'Ford', 'Commercial E-250', '2014', '40060', '50', '2014-02-18 17:33:13', '87', '2014-03-20 23:02:22', '705', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('131', '482', 'Ford', 'Commercial E-250 Extended', '2014', '41420', '50', '2014-02-18 17:33:46', '87', '2014-03-20 23:05:28', '705', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('132', '482', 'Ford', 'Recreational E-250', '2014', '42790', '50', '2014-02-18 17:34:10', '87', '2020-03-29 17:02:57', '1438', '\n', '[ [ 1900, 5000, 2.5, [ 0, 0, -0.2000000029802322 ], 85, 0.6000000238418579, 0.8700000047683716, 0.5099999904632568, 5, 150, 6, 20, \"rwd\", \"petrol\", 8.5, 0.4000000059604645, false, 30, 1.299999952316284, 0.07000000029802322, 2, 0.4000000059604645, -0.25, 0.4000000059604645, 0.5, 0.2000000029802322, 0.5, 26000, 1, 4194304, \"long\", \"small\", 13 ] ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('133', '562', 'Nissan', 'Skyline BNR32 GTS-25 Type-X', '1994', '21000', '50', '2014-02-18 17:34:28', '55', '2014-10-23 23:04:11', '1622', '\n', '[ [ 1500, 3500, 2.2000000476837158, [ 0, 0.30000001192092896, -0.15000000596046448 ], 75, 0.64999997615814209, 0.89999997615814209, 0.5, 5, 150, 7, 5, \"rwd\", \"petrol\", 8, 0.5, false, 35, 1, 0.20000000298023224, 0, 0.2800000011920929, -0.10000000149011612, 0.5, 0.30000001192092896, 0.25, 0.60000002384185791, 35000, 1073752068, 67108864, \"small\", \"small\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('134', '482', 'Ford', 'Recreational E-250 Extended', '2014', '43460', '50', '2014-02-18 17:34:31', '87', '2014-03-20 23:06:30', '705', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('136', '482', 'Ford', 'E-150 XL', '2014', '40230', '50', '2014-02-18 17:36:00', '87', '2014-03-20 23:02:29', '705', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('137', '482', 'Ford', 'E-150 XLT', '2014', '42675', '50', '2014-02-18 17:36:31', '87', '2014-03-20 23:05:45', '705', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('138', '482', 'Ford', 'E-150 XLT Premium', '2014', '45705', '50', '2014-02-18 17:37:01', '87', '2014-03-20 23:06:36', '705', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('139', '562', 'Nissan', 'Skyline BNR32 GTS-t', '1994', '27000', '50', '2014-02-18 17:37:08', '55', '2014-10-23 23:10:42', '1622', '\n', '[ [ 1500, 3500, 2.2000000476837158, [ 0, 0.30000001192092896, -0.15000000596046448 ], 75, 0.64999997615814209, 0.89999997615814209, 0.5, 5, 165, 9.3000001907348633, 5, \"rwd\", \"petrol\", 8, 0.5, false, 35, 1, 0.20000000298023224, 0, 0.2800000011920929, -0.10000000149011612, 0.5, 0.30000001192092896, 0.25, 0.60000002384185791, 35000, 1073752068, 67108864, \"small\", \"small\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('141', '402', 'Ford', 'Mustang V6', '2014', '32510', '50', '2014-02-18 17:39:13', '87', '2014-04-02 18:23:35', '705', '\n', '[ [ 1500, 4000, 1.800000, [ 0, 0, -0.100000 ], 85, 0.700000, 0.900000, 0.500000, 5, 190, 10.500000, 10, \"rwd\", \"petrol\", 11, 0.400000, false, 30, 1.200000, 0.120000, 0, 0.280000, -0.200000, 0.500000, 0.400000, 0.250000, 0.500000, 35000, 10240, 270532608, \"small\", \"small\", 0 ] ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('142', '402', 'Ford', 'Mustang V6 Premium', '2014', '36610', '50', '2014-02-18 17:39:31', '87', '2014-04-02 18:24:32', '705', '\n', '[ [ 1500, 4000, 1.700000, [ 0, 0, -0.100000 ], 85, 0.700000, 0.900000, 0.500000, 5, 210, 11.500000, 10, \"rwd\", \"petrol\", 11, 0.400000, false, 30, 1.200000, 0.120000, 0, 0.280000, -0.200000, 0.500000, 0.400000, 0.250000, 0.500000, 35000, 10240, 270532608, \"small\", \"small\", 0 ] ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('143', '562', 'Nissan', 'Skyline BNR35 GT-R ', '2016', '100000', '90', '2014-02-18 17:39:44', '55', '2020-04-30 21:43:40', '744', '\n', '[ [ 2500, 3500, 0.1000000014901161, [ 0, 0.300000011920929, -0.1000000014901161 ], 75, 0.699999988079071, 0.8999999761581421, 0.5, 5, 220, 18, 30, \"rwd\", \"petrol\", 8, 0.5, false, 35, 2, 0.2000000029802322, 0, 0.2800000011920929, -0.1000000014901161, 0.6000000238418579, 0.300000011920929, 0.25, 0.6000000238418579, 35000, 1073752068, 67108864, \"small\", \"small\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('144', '402', 'Ford', 'Mustang GT', '2014', '41610', '50', '2014-02-18 17:40:47', '87', '2014-04-28 08:18:06', '705', '\n', '[ [ 1500, 4000, 1.800000, [ 0, 0.200000, -0.100000 ], 85, 0.800000, 0.900000, 0.500000, 5, 180, 12.500000, 5, \"rwd\", \"petrol\", 11, 0.400000, false, 30, 1.500000, 0.120000, 0, 0.280000, -0.100000, 0.500000, 0.400000, 0.250000, 0.500000, 35000, 10240, 270532608, \"small\", \"small\", 0 ] ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('145', '402', 'Ford', 'Shelby GT-500', '2014', '170000', '120', '2014-02-18 17:43:01', '87', '2020-05-01 18:59:00', '2545', '\n', '[ [ 1700, 4000, 1.7999999523162842, [ 0, 0, -0.20000000298023224 ], 85, 0.80000001192092896, 0.89999997615814209, 0.50499999523162842, 5, 195, 15, 8, \"rwd\", \"petrol\", 11, 0.40000000596046448, false, 30, 1, 0.10000000149011612, 0, 0.2800000011920929, -0.15999999642372131, 0.5, 0.40000000596046448, 0.25, 0.5, 35000, 10240, 270532608, \"small\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('146', '440', 'Ford', 'Transit Connect XLT', '2014', '34525', '50', '2014-02-18 17:45:42', '87', '2014-12-23 04:45:10', '1622', '\n', '[ [ 2300, 4901.7001953125, 2.4000000953674316, [ 0, 0, -0.20000000298023224 ], 85, 0.60000002384185791, 0.75, 0.51999998092651367, 5, 190, 8, 12, \"fwd\", \"petrol\", 5.5, 0.40000000596046448, false, 30, 1.2000000476837158, 0.05000000074505806, 0, 0.43000000715255737, -0.10000000149011612, 0.5, 0, 0.20000000298023224, 0.60000002384185791, 26000, 1, 0, \"long\", \"small\", 13 ] ]', '1000', '1', '5', '0');
INSERT INTO `vehicles_shop` VALUES ('147', '440', 'Ford', 'Transit Connect XL', '2014', '35000', '50', '2014-02-18 17:46:04', '87', '2014-12-23 04:46:12', '1622', '\n', '[ [ 2200, 4901.700195, 2.400000, [ 0, 0.400000, -0.100000 ], 85, 0.600000, 0.750000, 0.520000, 5, 160, 6.500000, 15, \"fwd\", \"petrol\", 5.500000, 0.400000, false, 30, 1.400000, 0.050000, 0, 0.430000, -0.100000, 0.500000, 0, 0.200000, 0.600000, 26000, 1, 0, \"long\", \"small\", 13 ] ]', '1000', '1', '5', '0');
INSERT INTO `vehicles_shop` VALUES ('148', '440', 'Ford', 'Transit Connect Titanium', '2014', '39000', '50', '2014-02-18 17:46:33', '87', '2014-12-23 04:44:56', '1622', '\n', null, '1000', '1', '5', '0');
INSERT INTO `vehicles_shop` VALUES ('171', '422', 'Toyota', 'Hilux N50', '1997', '16500', '40', '2014-02-18 19:00:53', '55', '2014-12-27 22:17:29', '55', '\n', '[ [ 1100, 4000, 2.500000, [ 0, 0.050000, -0.200000 ], 75, 0.650000, 0.850000, 0.570000, 5, 140, 8, 15, \"awd\", \"diesel\", 8.500000, 0.500000, false, 35, 1.500000, 0.100000, 5, 0.350000, -0.200000, 0.400000, 0, 0.260000, 0.200000, 26000, 64, 1064964, \"long\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('172', '402', 'Toyota', 'Supra JZA70', '1991', '17000', '40', '2014-02-18 19:07:58', '55', '2015-01-20 08:35:04', '10139', '\n', '[ [ 1500, 4000, 0.20000000298023224, [ 0, 0, -0.10000000149011612 ], 85, 0.69999998807907104, 0.89999997615814209, 0.5, 5, 207, 6, 13, \"rwd\", \"petrol\", 6.5, 0.60000002384185791, false, 30, 0.69999998807907104, 0.11999999731779099, 0, 0.2800000011920929, -0.23999999463558197, 0.5, 0.40000000596046448, 0.25, 0.5, 35000, 10240, 270532608, \"small\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('173', '587', 'Tesla', 'model z olacak', '2017', '100000', '0', '2014-02-18 19:10:19', '55', '2021-03-27 10:57:36', '17826', '\n', '[ [ 2800, 2998.300048828125, 3.400000095367432, [ 0, 0.1000000014901161, -0.1000000014901161 ], 75, 0.699999988079071, 0.800000011920929, 0.5, 5, 170, 35, 13.5, \"awd\", \"petrol\", 44, 0.300000011920929, false, 30, 1.200000047683716, 0.1500000059604645, 0, 0.300000011920929, -0.1000000014901161, 0.5, 0.300000011920929, 0.25, 0.6000000238418579, 35000, 1073752068, 0, \"small\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('174', '561', 'Opel', 'Omega B Caravan ', '1999', '12500', '20', '2014-02-18 19:16:38', '55', '2014-06-19 23:59:49', '1107', '\n', null, '1000', '1', '2', '0');
INSERT INTO `vehicles_shop` VALUES ('175', '602', '[DONATE] Chevrolet', 'Camaro SS 6.2', '2016', '999999999', '100', '2014-02-18 19:19:33', '55', '2021-03-27 10:48:59', '17826', '\n', '[ [ 2000, 3400, 0.800000011920929, [ 0, 0.5, -0.2000000029802322 ], 85, 1, 0.800000011920929, 0.5, 5, 230, 20, 5, \"awd\", \"petrol\", 9, 0.6000000238418579, false, 30, 1.899999976158142, 0.119999997317791, 0, 0.300000011920929, -0.07000000774860382, 0.5, 0.4000000059604645, 0.25, 0.5, 35000, 1073752064, 2097152, \"small\", \"small\", 0 ] ]', '1000', '1', '0', null);
INSERT INTO `vehicles_shop` VALUES ('176', '411', 'Honda', 'NSX', '1992', '48000', '100', '2014-02-18 19:25:03', '55', '2014-12-31 00:16:05', '55', '\n', '[ [ 1300, 2725.300048828125, 1.7999999523162842, [ 0, 0, -0.25 ], 70, 0.80000001192092896, 0.80000001192092896, 0.5, 5, 180, 12, 10, \"rwd\", \"petrol\", 7, 0.60000002384185791, false, 45, 0.69999998807907104, 0.18999999761581421, 0, 0.25, -0.090000003576278687, 0.5, 0.40000000596046448, 0.37000000476837158, 0.72000002861022949, 95000, 1073750020, 12599296, \"small\", \"small\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('178', '489', 'Chevrolet', 'K5 Blazer', '1994', '16000', '55', '2014-02-18 19:29:52', '55', '2014-07-19 10:43:52', '1737', '\n', '[ [ 2000, 7604.200195, 2.500000, [ 0, 0, -0.350000 ], 80, 0.850000, 0.850000, 0.540000, 5, 170, 12, 10, \"awd\", \"petrol\", 7, 0.400000, false, 35, 0.800000, 0.080000, 0, 0.450000, -0.200000, 0.400000, 0.300000, 0.440000, 0.350000, 40000, 16416, 1048580, \"long\", \"small\", 0 ] ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('179', '411', 'Bugatti', 'EB110', '2015', '1000000', '450', '2014-02-18 19:29:57', '12', '2019-10-11 17:32:58', '1438', '\n', '[ [ 1400, 2725.300048828125, 1.5, [ 0, 0, -0.25 ], 70, 0.699999988079071, 0.800000011920929, 0.5, 5, 275, 28, 10, \"awd\", \"petrol\", 11, 0.5, false, 30, 1.200000047683716, 0.1899999976158142, 0, 0.25, -0.1000000014901161, 0.5, 0.4000000059604645, 0.3700000047683716, 0.7200000286102295, 95000, 1073750020, 12599296, \"small\", \"small\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('180', '489', 'Ford', 'Bronco', '1996', '17500', '55', '2014-02-18 19:31:45', '55', '2014-06-19 23:53:52', '1107', '\n', '[ [ 1800, 7604.200195, 3, [ 0, -0.050000, -0.500000 ], 80, 0.700000, 0.850000, 0.400000, 5, 170, 10, 5, \"awd\", \"petrol\", 7, 0.400000, false, 35, 1.200000, 0.080000, 0, 0.450000, -0.150000, 0.500000, 0.300000, 0.440000, 0.350000, 40000, 16416, 1048580, \"long\", \"small\", 0 ] ]', '1000', '1', '2', '0');
INSERT INTO `vehicles_shop` VALUES ('181', '402', 'Chevrolet', 'Camaro SS', '2002', '24000', '50', '2014-02-18 19:31:59', '12', '2014-03-21 02:39:22', '705', '\n', '[ [ 1500, 4000, 2, [ 0, 0, -0.100000 ], 85, 0.700000, 0.900000, 0.500000, 5, 160, 9, 5, \"rwd\", \"petrol\", 11, 0.400000, false, 30, 1.200000, 0.120000, 0, 0.280000, -0.200000, 0.500000, 0.400000, 0.250000, 0.500000, 35000, 10240, 270532608, \"small\", \"small\", 0 ] ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('182', '558', 'Plymouth', 'Laser', '1993', '15000', '35', '2014-02-18 19:35:06', '55', '2014-06-19 23:38:35', '1107', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('183', '560', 'Subaru', 'Impreza WRX STI RA', '2015', '25000', '50', '2014-02-18 19:35:39', '12', '2019-11-19 22:02:29', '1438', '\n', '[ [ 1400, 3400, 2.400000095367432, [ 0, 0.1000000014901161, -0.1000000014901161 ], 75, 0.800000011920929, 0.800000011920929, 0.5, 5, 250, 25, 15, \"awd\", \"petrol\", 10, 0.5, false, 30, 1.200000047683716, 0.1500000059604645, 0, 0.2800000011920929, -0.2000000029802322, 0.5, 0.300000011920929, 0.25, 0.6000000238418579, 35000, 10240, 67108866, \"small\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('184', '560', 'Subaru', 'Impreza WRX', '1995', '22500', '50', '2014-02-18 19:36:58', '12', '2014-12-27 22:11:03', '55', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('185', '560', 'Mitsubishi', 'Lancer Evo II', '1995', '23000', '45', '2014-02-18 19:39:58', '55', '2014-06-19 23:49:22', '1107', '\n', '[ [ 1400, 3400, 2.400000, [ 0, 0.100000, -0.100000 ], 75, 0.800000, 0.800000, 0.500000, 5, 200, 9.500000, 5, \"awd\", \"petrol\", 10, 0.500000, false, 30, 1.200000, 0.150000, 0, 0.280000, -0.200000, 0.500000, 0.300000, 0.250000, 0.600000, 35000, 10240, 67108864.000000, \"small\", \"small\", 0 ] ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('186', '560', 'Mitsubishi', 'Lancer Evo V', '1997', '37500', '50', '2014-02-18 19:41:01', '55', '2014-06-19 23:56:27', '1107', '\n', '[ [ 1400, 3400, 2.400000, [ 0, 0.100000, -0.100000 ], 75, 0.800000, 0.800000, 0.500000, 5, 200, 10.300000, 5, \"awd\", \"petrol\", 10, 0.500000, false, 30, 1.200000, 0.150000, 0, 0.280000, -0.200000, 0.500000, 0.300000, 0.250000, 0.600000, 35000, 10240, 67108864.000000, \"small\", \"small\", 0 ] ]', '1000', '1', '2', '0');
INSERT INTO `vehicles_shop` VALUES ('187', '560', 'Mitsubishi', 'Lancer Evo V GSR', '1997', '40300', '60', '2014-02-18 19:41:35', '55', '2014-06-19 23:56:44', '1107', '\n', null, '1000', '1', '2', '0');
INSERT INTO `vehicles_shop` VALUES ('188', '412', 'Chevrolet', 'Impala', '1960', '80000', '25', '2014-02-18 19:42:20', '12', '2014-06-18 02:02:30', '1737', '\n', null, '1000', '0', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('189', '560', 'Mitsubishi', 'Lancer Evo X', '2007', '51000', '60', '2014-02-18 19:42:27', '55', '2020-04-30 21:56:42', '744', '\n', '[ [ 1400, 3400, 2, [ 0, 0.100000, -0.100000 ], 75, 0.800000, 0.800000, 0.500000, 5, 200, 14, 5, \"awd\", \"petrol\", 10, 0.500000, false, 30, 1.200000, 0.150000, 0, 0.280000, -0.200000, 0.500000, 0.300000, 0.250000, 0.600000, 35000, 10240, 67108864.000000, \"small\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('190', '475', 'Dodge', 'Charger R/T', '1969', '39999', '50', '2014-02-18 19:45:20', '12', '2014-06-18 23:06:27', '1107', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('191', '475', 'Dodge', 'Challenger R/T', '1970', '35000', '50', '2014-02-18 19:45:39', '12', '2014-06-18 23:10:12', '1107', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('192', '475', 'Ford', 'Mustang GT500', '1967', '38000', '50', '2014-02-18 19:46:08', '12', '2014-06-18 02:49:36', '1107', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('193', '475', 'Ford', 'Mustang Fastback', '1965', '62500', '50', '2014-02-18 19:46:39', '12', '2014-06-18 02:44:19', '1107', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('195', '475', 'Chevrolet', 'Camaro Z28', '1968', '39500', '50', '2014-02-18 19:47:34', '12', '2014-06-18 03:01:33', '1107', '\n', null, '1000', '0', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('196', '475', 'Chevrolet', 'Camaro SS', '1968', '39900', '50', '2014-02-18 19:47:53', '12', '2014-06-18 02:55:08', '1107', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('197', '419', 'Cadillac', 'Eldorado', '1970', '15900', '20', '2014-02-18 19:49:24', '55', '2014-06-18 23:19:09', '1107', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('198', '475', 'Pontiac', 'Firebird', '1967', '39000', '50', '2014-02-18 19:49:48', '12', '2020-04-30 21:53:27', '744', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('199', '475', 'Pontiac', 'Firebird Trans Am', '1969', '45000', '50', '2014-02-18 19:50:44', '12', '2014-06-18 23:04:26', '1107', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('201', '475', 'Pontiac', 'GTO \"The Judge\"', '1969', '59500', '50', '2014-02-18 19:51:25', '12', '2014-06-18 23:05:14', '1107', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('202', '475', 'Pontiac', 'GTO', '1968', '26995', '50', '2014-02-18 19:51:55', '12', '2014-06-18 02:58:26', '1107', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('203', '474', 'Mercury', 'Eight Coupe', '1951', '33500', '45', '2014-02-18 19:53:22', '12', '2014-06-18 01:40:31', '1737', '\n', '[ { \"1\": 1950, \"2\": 4712.500000, \"3\": 2, \"4\": [ 0, 0.300000, 0 ], \"5\": 70, \"6\": 0.700000, \"7\": 0.750000, \"8\": 0.510000, \"9\": 5, \"10\": 160, \"11\": 7.800000, \"12\": 15, \"13\": \"rwd\", \"14\": \"petrol\", \"15\": 3.500000, \"16\": 0.600000, \"17\": false, \"18\": 28, \"19\": 1, \"20\": 0.050000, \"21\": 0, \"22\": 0.350000, \"23\": -0.200000, \"24\": 0.600000, \"25\": 0, \"26\": 0.250000, \"27\": 0.420000, \"28\": 19000, \"29\": 1073750016, \"30\": 1, \"31\": \"small\", \"33\": 0 } ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('204', '547', 'Audi', 'A4', '2014', '42500', '45', '2014-02-18 19:53:53', '55', '2021-03-26 19:03:35', '17826', '\n', null, '1000', '1', '0', null);
INSERT INTO `vehicles_shop` VALUES ('205', '410', 'Pontiac', 'Grand Am', '1991', '5500', '10', '2014-02-18 19:55:50', '55', '2014-06-19 01:24:01', '1107', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('206', '547', 'Audi', 'A4', '2014', '42500', '45', '2014-02-18 20:00:42', '55', '2021-03-26 19:03:08', '17826', '\n', null, '1000', '1', '0', null);
INSERT INTO `vehicles_shop` VALUES ('208', '536', 'Chevrolet', 'Impala Convertible Coupe', '1961', '45500', '45', '2014-02-18 20:05:42', '55', '2014-06-18 02:04:26', '1737', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('209', '545', 'Fiat', '500 Topolino', '1955', '16500', '45', '2014-02-18 20:08:12', '55', '2014-12-23 04:26:44', '1622', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('210', '466', 'Chevrolet', 'Bel Air', '1957', '27000', '45', '2014-02-18 20:11:25', '55', '2014-07-16 21:47:21', '1115', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('211', '483', 'Volkswagen', 'Type 2 T1', '1967', '45000', '15', '2014-02-18 20:12:41', '55', '2014-06-18 02:47:28', '1107', '\n', '[ [ 1900, 4000, 2.600000, [ 0, -0.500000, -0.400000 ], 85, 0.600000, 0.800000, 0.460000, 5, 100, 5, 20, \"rwd\", \"petrol\", 8.500000, 0.400000, false, 30, 1.100000, 0.080000, 0, 0.350000, -0.300000, 0.400000, 0.500000, 0.200000, 0.500000, 26000, 1073790976, 4194304, \"long\", \"small\", 0 ] ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('212', '534', 'Lincoln', 'Continental Town Coupe (Mark V)', '1978', '13995', '15', '2014-02-18 20:15:46', '55', '2014-06-18 23:42:58', '1107', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('213', '478', 'Chevrolet', '5 Window Flatbed', '1950', '12500', '15', '2014-02-18 20:19:03', '55', '2014-06-18 01:39:09', '1737', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('214', '426', 'Ford', 'Crown Victoria', '1998', '15500', '20', '2014-02-18 20:20:49', '55', '2014-06-19 23:57:56', '1107', '\n', null, '1000', '1', '2', '0');
INSERT INTO `vehicles_shop` VALUES ('215', '467', 'Dodge', 'Dart Phoenix', '1961', '32500', '15', '2014-02-18 20:23:20', '55', '2014-06-18 02:05:12', '1737', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('216', '589', 'Volkswagen', 'Golf I', '1984', '5500', '10', '2014-02-18 20:31:56', '55', '2014-06-19 00:04:36', '1107', '\n', '[ [ 1400, 3000, 2.800000, [ 0, 0, 0 ], 80, 0.750000, 0.900000, 0.490000, 5, 200, 11, 10, \"fwd\", \"petrol\", 11, 0.400000, false, 30, 1.700000, 0.100000, 0, 0.280000, -0.100000, 0.500000, 0, 0.250000, 0.500000, 35000, 8192, 12582912, \"small\", \"small\", 0 ] ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('223', '554', 'Chevrolet', 'Avalanche LTZ', '2014', '58880', '50', '2014-02-19 02:37:13', '87', '2014-03-20 23:17:13', '705', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('225', '554', 'Chevrolet', 'Avalanche LS', '2014', '100000', '500', '2014-02-19 02:37:52', '87', '2020-03-13 16:11:59', '745', '\n', '[ [ 3000, 6000, 3, [ 0, 0.350000, 0 ], 80, 0.600000, 0.800000, 0.400000, 5, 170, 10, 15, \"rwd\", \"petrol\", 8.500000, 0.300000, false, 30, 1, 0.120000, 0, 0.240000, -0.200000, 0.500000, 0.500000, 0.440000, 0.300000, 40000, 538968096, 5260288, \"long\", \"small\", 0 ] ]', '1000', '0', '1', '0');
INSERT INTO `vehicles_shop` VALUES ('226', '471', 'Yamaha', 'YFZ450', '2013', '6750', '0', '2014-02-19 09:39:32', '12', '2014-11-25 06:12:39', '1107', '\n', '[ [ 400, 300, 5, [ 0, -0.100000, -0.200000 ], 70, 0.900000, 0.900000, 0.550000, 4, 160, 14, 5, \"rwd\", \"petrol\", 8, 0.500000, false, 35, 0.800000, 0.100000, 0, 0.150000, -0.200000, 0.500000, 0, 0.200000, 0.500000, 9000, 2626304, 517, \"small\", \"small\", 12 ] ]', '1000', '1', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('227', '543', 'Ford', 'F-250', '1977', '17900', '30', '2014-02-19 09:40:34', '12', '2014-06-18 23:30:55', '1107', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('228', '554', 'Ford', 'F-150', '1994', '20500', '40', '2014-02-19 09:41:02', '12', '2014-06-19 23:44:38', '1107', '\n', '[ [ 2700, 6000, 3, [ 0, 0.350000, 0 ], 80, 0.600000, 0.800000, 0.400000, 5, 170, 8.500000, 15, \"awd\", \"petrol\", 8.500000, 0.300000, false, 30, 1, 0.120000, 0, 0.240000, -0.200000, 0.500000, 0.500000, 0.440000, 0.300000, 40000, 538968064.000000, 5260288, \"long\", \"small\", 0 ] ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('229', '521', 'Suzuki', 'Bandit 600 S', '1996', '4750', '15', '2014-02-19 09:41:54', '12', '2014-11-15 23:11:17', '1260', '\n', '[ [ 500, 200, 0.10000000149011612, [ 0, 0.05000000074505806, -0.090000003576278687 ], 103, 1.5, 0.89999997615814209, 0.47999998927116394, 5, 172, 35, 10, \"rwd\", \"petrol\", 15, 0.5, false, 35, 0.85000002384185791, 0.15000000596046448, 0, 0.15000000596046448, -0.20000000298023224, 0.5, 0, 0, 0.10999999940395355, 10000, 16777216, 0, \"small\", \"small\", 4 ] ]', '1000', '1', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('230', '418', 'Dodge', 'Ram Van', '2003', '13500', '20', '2014-02-20 17:02:22', '55', '2014-03-20 23:18:21', '705', '\n', null, '1000', '1', '2', '0');
INSERT INTO `vehicles_shop` VALUES ('231', '401', 'Dodge', 'Spirit', '1995', '5750', '10', '2014-02-20 17:08:34', '55', '2014-06-19 23:48:48', '1107', '\n', '[ [ 1300, 2200, 1.700000, [ 0, 0.300000, 0 ], 70, 0.650000, 0.800000, 0.520000, 5, 160, 4, 10, \"fwd\", \"petrol\", 8, 0.800000, false, 30, 1.300000, 0.080000, 0, 0.310000, -0.200000, 0.600000, 0, 0.260000, 0.500000, 9000, 1, 1, \"long\", \"long\", 0 ] ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('232', '445', 'Mercedes-Benz', 'W123', '1985', '22500', '25', '2014-02-20 17:10:32', '55', '2021-03-26 22:20:08', '17902', '\n', '[ [ 1650, 3851.39990234375, 2, [ 0, 0, -0.05000000074505806 ], 75, 0.6499999761581421, 0.8999999761581421, 0.5199999809265137, 5, 165, 8, 8, \"rwd\", \"petrol\", 8.5, 0.5, false, 30, 1, 0.1500000059604645, 0, 0.2700000107288361, -0.2000000029802322, 0.5, 0.550000011920929, 0.2000000029802322, 0.5600000023841858, 35000, 0, 4194304, \"long\", \"small\", 0 ] ]', '1000', '1', '0', null);
INSERT INTO `vehicles_shop` VALUES ('233', '525', 'Ford', 'F-150 Towtruck', '2010', '61355', '75', '2014-02-20 17:12:57', '55', '2014-07-28 22:13:20', '1737', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('235', '518', 'Chevrolet', 'Monte Carlo', '1972', '14500', '35', '2014-02-21 16:08:19', '12', '2014-06-18 23:23:23', '1107', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('236', '429', 'Dodge', 'Viper RT', '1992', '62500', '80', '2014-02-21 16:08:44', '12', '2014-08-27 01:31:25', '1107', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('237', '401', 'Mercury', 'Cougar', '1991', '13500', '25', '2014-02-21 16:09:11', '12', '2014-06-19 01:26:50', '1107', '\n', '[ [ 1300, 2200, 1.500000, [ 0, 0.300000, 0 ], 70, 0.700000, 0.800000, 0.520000, 5, 160, 5, 10, \"fwd\", \"petrol\", 8, 0.800000, false, 30, 1.300000, 0.080000, 0, 0.310000, -0.200000, 0.600000, 0, 0.260000, 0.500000, 9000, 1, 1, \"long\", \"long\", 0 ] ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('238', '536', 'Chevrolet', 'Caprice', '1970', '33000', '35', '2014-02-21 16:09:37', '12', '2014-06-18 23:15:13', '1107', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('239', '422', 'Ford', 'Ranger', '1986', '17550', '30', '2014-02-21 16:09:59', '12', '2014-06-19 01:09:31', '1107', '\n', '[ [ 1800, 4000, 2.500000, [ 0, 0.050000, -0.200000 ], 75, 0.650000, 0.850000, 0.570000, 5, 120, 7, 15, \"awd\", \"diesel\", 8.500000, 0.500000, false, 35, 1.500000, 0.100000, 5, 0.350000, -0.200000, 0.400000, 0, 0.260000, 0.200000, 26000, 64, 1064964, \"long\", \"small\", 0 ] ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('240', '575', 'Cadillac', 'De Ville', '1950', '37500', '25', '2014-02-21 16:10:26', '12', '2019-11-17 04:36:31', '1438', '\n', null, '1000', '1', '2', '0');
INSERT INTO `vehicles_shop` VALUES ('241', '402', 'Chevrolet', 'Camaro IROC-Z', '1987', '22525', '45', '2014-02-21 16:11:07', '12', '2014-12-04 11:49:49', '9736', '\n', '[ [ 1500, 4000, 1.8999999761581421, [ 0, 0, -0.10000000149011612 ], 85, 0.80000001192092896, 0.89999997615814209, 0.50999999046325684, 5, 200, 11, 5, \"rwd\", \"petrol\", 11, 0.40000000596046448, false, 30, 0.69999998807907104, 0.11999999731779099, 0, 0.2800000011920929, -0.20000000298023224, 0.5, 0.40000000596046448, 0.25, 0.5, 35000, 10240, 270532608, \"small\", \"small\", 0 ] ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('242', '541', 'Ford', 'GT40', '1960', '245575', '100', '2014-02-21 16:11:33', '12', '2014-12-03 06:39:40', '1622', '\n', '[ [ 1200, 2500, 1.7999999523162842, [ 0, -0.15000000596046448, -0.20000000298023224 ], 70, 0.75, 0.89999997615814209, 0.47999998927116394, 5, 230, 12, 10, \"rwd\", \"petrol\", 8, 0.60000002384185791, false, 30, 1, 0.12999999523162842, 5, 0.25, -0.10000000149011612, 0.40000000596046448, 0.30000001192092896, 0.15000000596046448, 0.54000002145767212, 105000, 3221233664, 2113536, \"long\", \"long\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('243', '415', 'Ferrari', '512 TR', '1993', '70500', '115', '2014-02-21 16:12:36', '12', '2015-01-17 07:23:04', '10139', '\n', '[ [ 1473, 3000, 1.6000000238418579, [ 0, -0.20000000298023224, -0.20000000298023224 ], 70, 0.80000001192092896, 0.89999997615814209, 0.5, 5, 230, 13, 10, \"rwd\", \"petrol\", 7, 0.60000002384185791, false, 35, 0.80000001192092896, 0.20000000298023224, 0, 0.10000000149011612, -0.05000000074505806, 0.5, 0.60000002384185791, 0.40000000596046448, 0.54000002145767212, 105000, 3221233664, 2129920, \"long\", \"long\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('245', '480', 'Porsche', '911', '1990', '53000', '55', '2014-02-21 16:13:28', '12', '2014-05-23 03:12:06', '1622', '\n', null, '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('246', '585', 'TofaÅŸ', 'Åžahin 5Vites', '1992', '16500', '35', '2014-02-21 16:13:57', '12', '2021-03-27 10:55:58', '17826', 'Ada\n', null, '1000', '1', '0', null);
INSERT INTO `vehicles_shop` VALUES ('247', '533', 'Mercedes-Benz', 'SL 500', '1989', '25750', '45', '2014-02-21 16:14:46', '12', '2014-06-19 01:15:58', '1107', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('249', '545', 'Ford', 'Coupe', '1938', '150000', '300', '2014-02-21 16:15:43', '12', '2020-05-01 18:55:27', '2545', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('251', '517', 'Buick', 'Regal T-Type', '1987', '35000', '30', '2014-02-21 16:16:48', '12', '2014-06-19 01:14:49', '1107', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('252', '500', 'Jeep', 'Wrangler', '1992', '22500', '45', '2014-02-21 16:17:36', '12', '2014-06-19 01:32:31', '1107', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('253', '404', 'Volkswagen Passat', '2.0 TDi BlueMotion Highline', '2016', '999999', '0', '2014-02-21 16:18:27', '12', '2019-12-31 15:15:04', '1438', '\n', '[ [ 2200, 3000, 1.200000047683716, [ 0, 0.300000011920929, -0.1000000014901161 ], 70, 1.100000023841858, 0.8999999761581421, 0.5, 5, 235, 26, 3, \"awd\", \"petrol\", 8.5, 0.6000000238418579, false, 35, 2, 0.2000000029802322, 0, 0.3700000047683716, -0.1000000014901161, 0.6000000238418579, 0, 0.2000000029802322, 0.6000000238418579, 10000, 32, 0, \"small\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('254', '600', 'Chevrolet', 'El Camino', '1985', '19500', '45', '2014-02-21 16:19:23', '12', '2014-06-19 00:11:14', '1107', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('255', '426', 'Chevrolet', 'Caprice', '1992', '22500', '30', '2014-02-21 16:20:10', '12', '2014-06-19 01:32:43', '1107', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('256', '479', 'Ford', 'LTD Wagon', '1977', '34000', '35', '2014-02-21 16:20:43', '12', '2014-06-18 23:32:48', '1107', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('257', '580', 'Rolls-Royce', 'Silver-Shadow', '1977', '39840', '85', '2014-02-21 16:21:28', '12', '2014-12-27 22:09:40', '55', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('258', '451', 'Ferrari', 'F40 LM', '1992', '1900355', '425', '2014-02-21 16:22:13', '12', '2015-02-05 03:51:31', '120', '\n', '[ [ 1400, 3000, 0.10000000149011612, [ 0, -0.30000001192092896, -0.20000000298023224 ], 70, 1.1000000238418579, 0.85000002384185791, 0.41999998688697815, 5, 260, 15, 4, \"rwd\", \"petrol\", 11, 0.5, false, 35, 1.8999999761581421, 0.20000000298023224, 0, 0.15000000596046448, -0.10000000149011612, 0.5, 0.40000000596046448, 0.17000000178813934, 0.72000002861022949, 95000, 1073750020, 12616705, \"small\", \"small\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('259', '558', 'Mitsubishi', 'Eclipse', '1992', '19275', '35', '2014-02-21 16:22:40', '12', '2014-06-19 01:33:45', '1107', '\n', '[ [ 1400, 2998.300049, 2, [ 0, 0.100000, -0.300000 ], 75, 0.800000, 0.850000, 0.470000, 5, 139, 7, 5, \"fwd\", \"petrol\", 8, 0.400000, false, 30, 1.300000, 0.150000, 0, 0.280000, -0.100000, 0.500000, 0.300000, 0.250000, 0.600000, 35000, 3221235712.000000, 67108864.000000, \"small\", \"small\", 0 ] ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('260', '576', 'Chevrolet', 'Bel Air Coupe', '1958', '42250', '45', '2014-02-21 16:24:25', '12', '2014-06-18 01:44:41', '1737', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('261', '462', 'Vespa', 'PX 125', '1963', '1950', '5', '2014-02-21 17:07:24', '12', '2014-11-16 00:01:37', '1260', '\n', '[ [ 350, 119.59999847412109, 5, [ 0, 0.05000000074505806, -0.10000000149011612 ], 103, 1.7999999523162842, 0.89999997615814209, 0.47999998927116394, 3, 65, 12, 5, \"rwd\", \"petrol\", 14, 0.5, false, 35, 1, 0.15000000596046448, 0, 0.11999999731779099, -0.20000000298023224, 0.5, 0, 0, 0.10999999940395355, 10000, 16777216, 0, \"small\", \"small\", 5 ] ]', '1000', '1', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('264', '578', 'Iveco', 'Cargo Flatbed', '2000', '29500', '110', '2014-02-21 18:06:17', '12', '2014-12-23 11:39:01', '1622', '\n', '[ [ 5500, 33187.8984375, 2, [ 0, 0, -0.20000000298023224 ], 90, 0.64999997615814209, 0.80000001192092896, 0.40000000596046448, 5, 110, 8, 20, \"rwd\", \"diesel\", 3.5, 0.40000000596046448, false, 55, 1.3999999761581421, 0.059999998658895493, 0, 0.44999998807907104, -0.25, 0.60000002384185791, 0, 0.44999998807907104, 0.20000000298023224, 5000, 16392, 512, \"long\", \"small\", 2 ] ]', '1000', '1', '5', '0');
INSERT INTO `vehicles_shop` VALUES ('265', '578', 'Mitsubishi', 'Fuso Fighter Carrier', '1993', '33500', '100', '2014-02-21 18:09:45', '12', '2014-10-23 23:37:53', '1107', '\n', '[ [ 5500, 33187.8984375, 2, [ 0, 0, -0.20000000298023224 ], 90, 0.64999997615814209, 0.80000001192092896, 0.40000000596046448, 5, 110, 8, 20, \"rwd\", \"diesel\", 3.5, 0.40000000596046448, false, 55, 1.3999999761581421, 0.059999998658895493, 0, 0.44999998807907104, -0.30000001192092896, 0.60000002384185791, 0, 0.44999998807907104, 0.20000000298023224, 5000, 16392, 512, \"long\", \"small\", 2 ] ]', '1000', '1', '5', '0');
INSERT INTO `vehicles_shop` VALUES ('266', '562', 'Nissan', 'GT-R', '2007', '64575', '80', '2014-02-22 11:12:40', '12', '2015-01-13 14:29:07', '9736', '\n', '[ [ 1500, 3500, 1.5, [ 0, 0.30000001192092896, -0.15000000596046448 ], 75, 0.85000002384185791, 0.89999997615814209, 0.52999997138977051, 5, 211, 12, 5, \"awd\", \"petrol\", 7, 0.69999998807907104, false, 35, 1.2999999523162842, 0.20000000298023224, 0, 0.2800000011920929, -0.079999998211860657, 0.5, 0.30000001192092896, 0.25, 0.60000002384185791, 35000, 1073752068, 67108864, \"small\", \"small\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('267', '562', 'Nissan', 'GT-R', '2011', '69575', '80', '2014-02-22 11:13:26', '12', '2015-01-13 14:13:15', '9736', '\n', '[ [ 1500, 3500, 0.30000001192092896, [ 0, 0.30000001192092896, -0.15000000596046448 ], 75, 0.94999998807907104, 0.89999997615814209, 0.52999997138977051, 5, 200, 14, 8, \"awd\", \"petrol\", 8, 0.69999998807907104, false, 34, 1, 0.20000000298023224, 0, 0.2800000011920929, -0.05000000074505806, 0.5, 0.30000001192092896, 0.25, 0.60000002384185791, 35000, 1073752068, 67108864, \"small\", \"small\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('268', '562', 'Nissan', 'GT-R', '2014', '295000', '150', '2014-02-22 11:13:42', '12', '2020-04-30 21:43:31', '744', '\n', '[ [ 1500, 3500, 1, [ 0, 0.300000011920929, -0.1500000059604645 ], 75, 0.8999999761581421, 0.8999999761581421, 0.5299999713897705, 5, 180, 14.5, 5, \"rwd\", \"petrol\", 32, 0.699999988079071, false, 35, 1, 0.2000000029802322, 0, 0.2800000011920929, -0.05000000074505806, 0.5, 0.300000011920929, 0.25, 0.6000000238418579, 35000, 1073752068, 67108864, \"small\", \"small\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('269', '562', 'Nissan', 'GT-R Spec V', '2009', '80000', '80', '2014-02-22 11:15:16', '12', '2015-01-13 14:36:01', '9736', '\n', '[ [ 1500, 3500, 1.5, [ 0, 0.30000001192092896, -0.15000000596046448 ], 75, 0.94999998807907104, 0.89999997615814209, 0.52999997138977051, 5, 190, 15, 5, \"awd\", \"petrol\", 7, 0.69999998807907104, false, 35, 1, 0.20000000298023224, 0, 0.2800000011920929, -0.10000000149011612, 0.5, 0.30000001192092896, 0.25, 0.60000002384185791, 35000, 1073752068, 67108864, \"small\", \"small\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('270', '429', 'Chevrolet', 'Corvette Z06', '2006', '75000', '85', '2014-02-22 11:22:41', '12', '2015-01-20 07:25:48', '10139', '\n', '[ [ 1400, 3000, 1.4249999523162842, [ 0, 0, -0.20000000298023224 ], 70, 0.80000001192092896, 0.88999998569488525, 0.5, 5, 260, 12, 10, \"rwd\", \"petrol\", 7.5, 0.60000002384185791, false, 34, 1.6000000238418579, 0.10000000149011612, 5, 0.30000001192092896, -0.10000000149011612, 0.5, 0.30000001192092896, 0.15000000596046448, 0.49000000953674316, 45000, 8196, 2097152, \"small\", \"small\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('271', '402', 'Dodge', 'Challenger SRT-8', '2012', '140000', '100', '2014-02-22 11:27:50', '12', '2020-04-30 21:41:30', '744', '\n', '[ [ 1500, 4000, 1.7999999523162842, [ -0.10000000149011612, 0.20000000298023224, -0.10000000149011612 ], 85, 0.99000000953674316, 0.89999997615814209, 0.5, 5, 200, 15, 5, \"rwd\", \"petrol\", 11, 0.40000000596046448, false, 30, 1.1000000238418579, 0.11999999731779099, 0, 0.2800000011920929, -0.10000000149011612, 0.5, 0.40000000596046448, 0.25, 0.5, 35000, 10240, 270532608, \"small\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('274', '461', 'Honda', 'NC700X', '2012', '6500', '15', '2014-02-22 13:16:40', '12', '2014-03-20 12:30:32', '1', '\n', null, '1000', '1', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('275', '451', 'Ferrari', 'F40', '1992', '1700355', '420', '2014-02-22 13:19:42', '12', '2015-02-05 03:50:45', '120', '\n', '[ [ 1400, 3000, 1.2000000476837158, [ 0, -0.30000001192092896, -0.20000000298023224 ], 70, 0.85000002384185791, 0.85000002384185791, 0.43000000715255737, 5, 240, 14, 9, \"rwd\", \"petrol\", 11, 0.5, false, 30, 1.2000000476837158, 0.12999999523162842, 0, 0.15000000596046448, -0.20000000298023224, 0.5, 0.40000000596046448, 0.17000000178813934, 0.72000002861022949, 95000, 1073750020, 12616705, \"small\", \"small\", 1 ] ]', '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('276', '475', 'Chevrolet', 'Camaro \"427\" COPO', '1968', '65225', '50', '2014-02-22 13:21:23', '12', '2014-12-27 22:01:08', '55', '\n', '[ [ 1700, 4000, 2, [ 0, 0.10000000149011612, 0 ], 70, 0.80000001192092896, 0.80000001192092896, 0.40000000596046448, 4, 270, 17, 8, \"rwd\", \"petrol\", 8, 0.5, false, 35, 1.2999999523162842, 0.079999998211860657, 5, 0.30000001192092896, -0.10000000149011612, 0.5, 0.25, 0.25, 0.51999998092651367, 19000, 0, 268435462, \"small\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('277', '541', 'Lotus', 'Esprit', '1993', '83500', '55', '2014-02-22 13:23:01', '12', '2014-05-27 03:47:36', '1737', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('278', '429', 'TVR', 'Griffith', '1992', '67550', '75', '2014-02-22 13:23:29', '12', '2014-06-19 01:32:58', '1107', '\n', null, '1000', '1', '1', '0');
INSERT INTO `vehicles_shop` VALUES ('279', '451', 'Noble', 'M12 M400', '2005', '105000', '280', '2014-02-22 13:24:04', '12', '2015-02-05 04:12:12', '120', '\n', '[ [ 1100, 3000, 1.600000, [ 0, -0.300000, -0.200000 ], 70, 0.750000, 0.850000, 0.450000, 5, 245, 12, 8, \"rwd\", \"petrol\", 11, 0.500000, false, 30, 1.200000, 0.130000, 0, 0.150000, -0.180000, 0.500000, 0.400000, 0.170000, 0.720000, 95000, 1073750020, 12616705, \"small\", \"small\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('280', '506', 'Ferrari', '360 Modena', '2001', '119654', '195', '2014-02-22 13:24:52', '12', '2015-02-05 04:04:23', '120', '\n', '[ [ 1400, 2800, 1.600000, [ 0, -0.200000, -0.240000 ], 70, 0.750000, 0.860000, 0.430000, 5, 235, 13.500000, 5, \"rwd\", \"petrol\", 8, 0.500000, false, 30, 1, 0.200000, 0, 0.250000, -0.100000, 0.500000, 0.300000, 0.400000, 0.540000, 105000, 1073750016, 2129920, \"long\", \"long\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('281', '411', 'Lamborghini', 'Diablo', '1992', '215900', '300', '2014-02-22 13:25:22', '12', '2015-02-05 03:56:54', '120', '\n', '[ [ 1400, 2725.300048828125, 1.2899999618530273, [ 0, 0, -0.25 ], 70, 0.94999998807907104, 0.80000001192092896, 0.44999998807907104, 5, 240, 12, 16.5, \"rwd\", \"petrol\", 7, 0.60000002384185791, false, 35, 1.2000000476837158, 0.18999999761581421, 0, 0.25, -0.090000003576278687, 0.5, 0.40000000596046448, 0.37000000476837158, 0.72000002861022949, 95000, 1073750020, 12599296, \"small\", \"small\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('282', '411', 'Lamborghini', 'Reventon', '2008', '1600000', '380', '2014-02-22 13:25:58', '12', '2015-02-05 03:51:11', '120', '\n', '[ [ 1400, 2725.300049, 1.500000, [ 0, 0, -0.250000 ], 70, 0.700000, 0.800000, 0.500000, 5, 185, 14, 10, \"rwd\", \"petrol\", 11, 0.500000, false, 30, 1.200000, 0.190000, 0, 0.250000, -0.100000, 0.500000, 0.400000, 0.370000, 0.720000, 95000, 1073750016, 12599296, \"small\", \"small\", 1 ] ]', '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('283', '541', 'Lotus', 'Elise', '1996', '70500', '35', '2014-02-22 13:26:25', '12', '2014-05-27 03:47:16', '1737', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('284', '555', 'Triumph', 'Spitfire', '1963', '28500', '25', '2014-02-22 13:26:49', '12', '2014-06-18 02:08:20', '1737', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('285', '429', 'TVR', 'Tuscan', '2000', '85600', '75', '2014-02-22 13:27:27', '12', '2014-03-20 23:25:03', '705', '\n', null, '1000', '1', '1', '0');
INSERT INTO `vehicles_shop` VALUES ('286', '506', 'Lexus', 'LFA', '2010', '345500', '290', '2014-02-22 13:27:53', '12', '2015-02-05 04:07:03', '120', '\n', '[ [ 1300, 2800, 1.600000, [ 0, -0.200000, -0.240000 ], 70, 0.900000, 0.860000, 0.430000, 5, 200, 15, 8, \"rwd\", \"petrol\", 8, 0.500000, false, 30, 1, 0.200000, 0, 0.250000, -0.100000, 0.500000, 0.300000, 0.400000, 0.540000, 105000, 1073750016, 2129920, \"long\", \"long\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('287', '415', 'Lamborghini', 'Gallardo LP 560-4', '2010', '166000', '100', '2014-02-22 13:28:25', '12', '2014-12-23 03:56:58', '1622', '\n', '[ [ 1400, 3000, 1.7999999523162842, [ 0, -0.20000000298023224, -0.25 ], 70, 1, 0.89999997615814209, 0.47999998927116394, 5, 210, 16, 10, \"awd\", \"petrol\", 11.100000381469727, 0.5, false, 35, 1.2000000476837158, 0.18999999761581421, 0, 0.10000000149011612, -0.10000000149011612, 0.5, 0.60000002384185791, 0.40000000596046448, 0.54000002145767212, 105000, 3221233664, 2129920, \"long\", \"long\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('288', '411', 'Lamborghini', 'Aventador LP700-4', '2013', '401575', '155', '2014-02-22 13:29:09', '12', '2014-10-13 20:53:51', '1622', '\n', '[ [ 1400, 2725.300048828125, 1.2000000476837158, [ 0, 0, -0.25 ], 70, 0.69999998807907104, 0.80000001192092896, 0.5, 5, 220, 17, 8, \"awd\", \"petrol\", 11, 0.5, false, 30, 1.2000000476837158, 0.18999999761581421, 0, 0.25, -0.05000000074505806, 0.5, 0.40000000596046448, 0.37000000476837158, 0.72000002861022949, 95000, 1073750020, 12599296, \"small\", \"small\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('289', '451', 'Ferrari', 'F50', '2017', '2800000', '650', '2014-02-22 13:29:40', '12', '2020-05-01 19:00:19', '2545', '\n', '[ [ 1400, 3000, 2, [ 0, -0.300000011920929, -0.2000000029802322 ], 70, 0.75, 0.8500000238418579, 0.449999988079071, 5, 275, 38, 15, \"awd\", \"petrol\", 11, 0.5, false, 30, 1.200000047683716, 0.1299999952316284, 0, 0.1500000059604645, -0.2000000029802322, 0.5, 0.4000000059604645, 0.1700000017881393, 0.7200000286102295, 95000, 1073750020, 12616705, \"small\", \"small\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('291', '506', 'Audi', 'R8 (V10 5.2L) Spyder', '2014', '175000', '210', '2014-02-22 13:30:44', '12', '2015-02-05 03:58:33', '120', '\n', '[ [ 1400, 2800, 1.5, [ 0, -0.20000000298023224, -0.23999999463558197 ], 70, 0.75, 0.86000001430511475, 0.43000000715255737, 5, 230, 14, 5, \"awd\", \"petrol\", 8, 0.5, false, 30, 1, 0.20000000298023224, 0, 0.25, -0.10000000149011612, 0.5, 0.30000001192092896, 0.40000000596046448, 0.54000002145767212, 105000, 1073750020, 2129920, \"long\", \"long\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('292', '480', 'Porsche', '911 Carrera S', '2014', '104355', '135', '2014-02-22 13:31:15', '12', '2015-02-05 04:13:19', '120', '\n', '[ [ 1400, 2200, 2.200000, [ 0, 0.100000, -0.200000 ], 75, 0.750000, 0.900000, 0.500000, 5, 198, 12, 10, \"awd\", \"petrol\", 11, 0.400000, false, 30, 1.400000, 0.140000, 3, 0.280000, -0.100000, 0.500000, 0.300000, 0.250000, 0.600000, 35000, 1073743872, 0, \"small\", \"small\", 19 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('293', '451', 'Ferrari', 'Enzo', '2003', '1500000', '360', '2014-02-22 13:31:50', '12', '2019-10-11 17:39:11', '1438', '\n', '[ [ 1300, 3000, 1.600000023841858, [ 0, -0.300000011920929, -0.2000000029802322 ], 70, 0.8999999761581421, 0.8500000238418579, 0.4300000071525574, 5, 275, 16.5, 10, \"rwd\", \"petrol\", 11, 0.5, false, 30, 1.399999976158142, 0.1299999952316284, 0, 0.1500000059604645, -0.1000000014901161, 0.5, 0.4000000059604645, 0.1700000017881393, 0.7200000286102295, 95000, 1073750020, 12616705, \"small\", \"small\", 1 ] ]', '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('294', '506', 'Ferrari', 'F430', '2005', '215000', '100', '2014-02-22 13:32:20', '12', '2014-08-27 02:13:49', '1622', '\n', '[ [ 1400, 2800, 1.450000, [ 0, -0.200000, -0.240000 ], 70, 0.850000, 0.860000, 0.430000, 5, 275, 17, 5, \"rwd\", \"petrol\", 8, 0.500000, false, 30, 1, 0.200000, 0, 0.250000, -0.100000, 0.500000, 0.300000, 0.400000, 0.540000, 105000, 1073750016, 2129920, \"long\", \"long\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('295', '411', 'Pagani', 'Zonda Fangio', '2006', '745000', '125', '2014-02-22 13:32:46', '12', '2014-08-21 21:22:32', '1622', '\n', '[ [ 1400, 2725.300049, 1, [ 0, 0, 0 ], 70, 1, 0.800000, 0.500000, 5, 220, 15, 10, \"rwd\", \"petrol\", 11, 0.500000, false, 30, 1.500000, 0.190000, 0, 0.250000, 0.020000, 0.500000, 0.400000, 0.370000, 0.720000, 95000, 1073750016, 12599296, \"small\", \"small\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('296', '480', 'Porsche', '959', '1986', '90000', '65', '2014-02-22 13:33:17', '12', '2014-06-19 01:10:40', '1107', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('297', '506', 'McLaren', 'MP4-12C', '2011', '259060', '260', '2014-02-22 13:33:58', '12', '2015-02-05 04:07:54', '120', '\n', '[ [ 1400, 2800, 2, [ 0, -0.20000000298023224, -0.23999999463558197 ], 70, 0.89999997615814209, 0.86000001430511475, 0.43000000715255737, 5, 230, 21, 5, \"rwd\", \"petrol\", 8, 0.5, false, 35, 1, 0.20000000298023224, 0, 0.25, -0.05000000074505806, 0.5, 0.30000001192092896, 0.40000000596046448, 0.54000002145767212, 105000, 1073750020, 2129920, \"long\", \"long\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('298', '480', 'Porsche', 'Carrera 2.7 RS', '1973', '147425', '100', '2014-02-22 13:34:36', '12', '2020-04-25 12:11:07', '745', '\n', null, '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('299', '566', 'Ford', 'FocusRS', '2013', '45500', '60', '2014-02-22 16:40:55', '55', '2021-03-26 17:07:58', '17800', '\n', '[ [ 1800, 4000, 2.299999952316284, [ 0, -0.300000011920929, 0 ], 75, 0.75, 0.8500000238418579, 0.5199999809265137, 5, 160, 12, 10, \"rwd\", \"petrol\", 7, 0.5, false, 35, 1, 0.07999999821186066, 0, 0.2800000011920929, -0.2000000029802322, 0.4000000059604645, 0.300000011920929, 0.25, 0.6000000238418579, 35000, 0, 302055424, \"small\", \"small\", 0 ] ]', '1000', '1', '0', null);
INSERT INTO `vehicles_shop` VALUES ('300', '529', 'Toyota', 'Cressida', '1984', '11500', '15', '2014-02-22 16:42:35', '55', '2014-12-31 10:54:30', '9736', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('301', '529', 'Audi', 'A7', '2017', '9500', '15', '2014-02-22 16:44:25', '55', '2021-04-06 23:52:49', '17927', '\n', '[ { \"1\": 5000, \"2\": 4350, \"3\": 0.1000000014901161, \"4\": [ 0, 0, -0.5 ], \"5\": 70, \"6\": 1.5, \"7\": 0.800000011920929, \"8\": 0.3899999856948853, \"9\": 4, \"10\": 219, \"11\": 25, \"12\": 15, \"13\": \"awd\", \"14\": \"petrol\", \"15\": 8, \"16\": 0.5, \"17\": false, \"18\": 25, \"19\": 1, \"20\": 0.2000000029802322, \"21\": 0, \"22\": 0.3199999928474426, \"23\": -0.1400000005960464, \"24\": 0.5, \"25\": 0, \"26\": 0.2599999904632568, \"27\": 0.5400000214576721, \"28\": 19000, \"29\": 1073741824, \"30\": 0, \"31\": \"long\", \"33\": 0 } ]', '1000', '1', '0', null);
INSERT INTO `vehicles_shop` VALUES ('302', '492', 'Chrysler', 'Fifth Avenue', '1993', '6500', '10', '2014-02-22 16:45:37', '55', '2014-06-19 23:38:50', '1107', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('303', '413', 'Ford', 'E-Series Wagon', '2008', '15050', '20', '2014-02-22 16:47:46', '55', '2014-12-23 04:45:32', '1622', '\n', null, '1000', '1', '5', '0');
INSERT INTO `vehicles_shop` VALUES ('304', '546', 'Toyota', 'Camry', '1996', '6600', '10', '2014-02-22 17:05:49', '55', '2014-12-27 22:21:00', '55', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('306', '530', 'Mitsubishi', 'Caterpillar GC15K', '2008', '14500', '15', '2014-02-22 17:12:22', '55', '2020-03-31 15:51:26', '1438', '\n', '[ [ 1000, 1354.199951171875, 2, [ 0, -0.2000000029802322, -0.3499999940395355 ], 70, 0.800000011920929, 0.8500000238418579, 0.5, 3, 60, 8, 15, \"fwd\", \"electric\", 6, 0.5, false, 30, 2, 0.1400000005960464, 0, 0.25, -0.2000000029802322, 0.5, 0, 0.2599999904632568, 0.5, 9000, 4864, 17039396, \"small\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('307', '552', 'Ford', 'F-150 Utility Van', '1990', '17600', '35', '2014-02-22 17:13:30', '55', '2014-08-23 01:44:21', '12', '\n', null, '1000', '1', '5', '0');
INSERT INTO `vehicles_shop` VALUES ('308', '524', 'Mack', 'RD Mixer', '2005', '66000', '70', '2014-02-22 17:19:59', '55', '2014-05-24 04:42:26', '1622', '\n', '[ [ 5500, 33187.898438, 2, [ 0, 0, 0 ], 90, 0.580000, 0.800000, 0.500000, 4, 110, 5, 20, \"rwd\", \"diesel\", 3.170000, 0.400000, false, 30, 1.400000, 0.060000, 0, 0.450000, -0.300000, 0.600000, 0, 0.450000, 0.200000, 5000, 4210696, 262656, \"long\", \"small\", 0 ] ]', '1000', '1', '5', '0');
INSERT INTO `vehicles_shop` VALUES ('309', '491', 'Lincoln', 'Continental Mark V', '1979', '23550', '25', '2014-02-22 17:22:15', '55', '2014-05-20 18:17:06', '12', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('310', '409', 'Lincoln', 'Town Car Limousine', '2011', '70000', '55', '2014-02-22 17:34:13', '55', '2014-07-28 21:56:56', '1737', '\n', '[ [ 2200, 10000, 1.800000, [ 0, 0, 0 ], 75, 0.600000, 0.800000, 0.500000, 5, 130, 7.200000, 25, \"rwd\", \"petrol\", 10, 0.400000, false, 30, 1.100000, 0.070000, 0, 0.350000, -0.200000, 0.500000, 0, 0.200000, 0.720000, 40000, 2629632, 272629760.000000, \"small\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('311', '409', 'Lincoln', 'Town Car Limousine', '2005', '25000', '50', '2014-02-22 17:34:56', '55', '2014-07-28 22:02:09', '1737', '\n', '[ [ 2500, 10000, 2, [ 0, 0, 0 ], 75, 0.850000, 0.800000, 0.500000, 5, 160, 10, 25, \"rwd\", \"petrol\", 10, 0.400000, false, 35, 1.100000, 0.070000, 0, 0.350000, -0.200000, 0.500000, 0, 0.200000, 0.720000, 40000, 2629632, 272629760, \"small\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('313', '458', '[DONATE] BMW', 'M5', '2020', '999999999', '70', '2014-02-22 23:08:36', '68', '2021-03-27 11:13:35', '17826', '\n', '[ [ 2000, 5500, 2, [ 0, 0, 0 ], 75, 0.75, 0.800000011920929, 0.5199999809265137, 4, 250, 23, 7, \"awd\", \"petrol\", 15, 0.6000000238418579, false, 30, 1.200000047683716, 0.1000000014901161, 0, 0.2700000107288361, -0.01799999922513962, 0.5, 0.2000000029802322, 0.239999994635582, 0.4799999892711639, 18000, 32, 0, \"small\", \"small\", 0 ] ]', '1000', '0', '0', null);
INSERT INTO `vehicles_shop` VALUES ('314', '561', 'Honda', 'Accord Wagon', '1992', '10500', '35', '2014-02-22 23:09:59', '68', '2014-06-19 01:29:50', '1107', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('315', '550', 'Honda', 'Accord Sedan', '1991', '9500', '30', '2014-02-22 23:11:33', '68', '2014-06-19 01:24:07', '1107', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('316', '589', 'Ford', 'Fiesta', '2008', '15500', '35', '2014-02-22 23:13:09', '68', '2014-04-17 23:06:42', '140', '\n', '[ [ 1400, 3000, 2.800000, [ 0, 0, 0 ], 80, 0.750000, 0.900000, 0.490000, 5, 150, 12.500000, 10, \"fwd\", \"petrol\", 11, 0.400000, false, 30, 1.700000, 0.100000, 0, 0.280000, -0.100000, 0.500000, 0, 0.250000, 0.500000, 35000, 8192, 12582912, \"small\", \"small\", 0 ] ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('317', '533', 'Mercedes-Benz', 'SLK320 Convertible', '2001', '23550', '45', '2014-02-22 23:14:38', '68', '2014-10-08 19:48:20', '1622', '\n', '[ [ 1500, 4500, 2.200000, [ 0, 0, -0.150000 ], 75, 0.700000, 0.900000, 0.470000, 5, 200, 11.700000, 19, \"rwd\", \"petrol\", 7, 0.500000, false, 30, 1.100000, 0.090000, 0, 0.300000, -0.100000, 0.500000, 0.300000, 0.250000, 0.600000, 35000, 1073752064, 0, \"small\", \"small\", 19 ] ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('318', '561', 'Nissan', 'Stagea', '1996', '13000', '35', '2014-02-22 23:57:10', '68', '2014-08-27 02:06:00', '1622', '\n', null, '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('319', '535', 'GMC', 'C/K', '1967', '19500', '40', '2014-02-23 00:04:14', '68', '2014-06-18 02:55:32', '1107', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('320', '421', 'Lincoln', 'Mark V', '1989', '21500', '45', '2014-02-23 00:06:12', '68', '2014-06-19 01:15:25', '1107', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('322', '410', 'Dodge', 'Aires Coupe', '1980', '10750', '20', '2014-02-23 00:14:00', '68', '2014-06-18 23:53:44', '1107', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('323', '410', 'Toyota', 'Corolla AE86 Coupe', '1985', '8950', '20', '2014-02-23 00:14:50', '68', '2019-11-06 20:24:04', '1438', 'troll aracÄ±dÄ±r\n', '[ [ 1000, 1400, 2.799999952316284, [ 0, 0.2000000029802322, 0 ], 70, 0.800000011920929, 0.800000011920929, 0.5, 3, 275, 75, 0.1000000014901161, \"awd\", \"petrol\", 8, 0.800000011920929, false, 30, 0.8999999761581421, 0.1000000014901161, 5, 0.3100000023841858, -0.2000000029802322, 0.5, 0.2000000029802322, 0.2599999904632568, 0.5, 9000, 0, 0, \"long\", \"long\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('325', '603', 'Pontiac', 'Firebird Trans Am', '1983', '20000', '45', '2014-02-23 14:22:38', '12', '2015-01-03 08:44:23', '99', '\n', '[ [ 1600, 4000, 2.2000000476837158, [ 0, -0.10000000149011612, -0.15000000596046448 ], 85, 0.80000001192092896, 0.89999997615814209, 0.51999998092651367, 5, 150, 12, 5, \"rwd\", \"petrol\", 6, 0.60000002384185791, false, 30, 1.2000000476837158, 0.20000000298023224, 0, 0.2800000011920929, -0.15000000596046448, 0.5, 0.40000000596046448, 0.25, 0.5, 35000, 10240, 2097152, \"small\", \"small\", 0 ] ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('326', '603', 'Pontiac', 'Firebird Trans Am', '1984', '22000', '45', '2014-02-23 14:22:52', '12', '2015-01-03 08:49:35', '99', '\n', '[ [ 1650, 4000, 2.2000000476837158, [ 0, -0.10000000149011612, -0.15000000596046448 ], 85, 0.80000001192092896, 0.89999997615814209, 0.51999998092651367, 5, 160, 11.5, 5, \"rwd\", \"petrol\", 6, 0.60000002384185791, false, 30, 1.2000000476837158, 0.20000000298023224, 0, 0.2800000011920929, -0.15000000596046448, 0.5, 0.40000000596046448, 0.25, 0.5, 35000, 10240, 2097152, \"small\", \"small\", 0 ] ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('327', '517', 'Buick', 'Regal GNX', '1987', '30000', '30', '2014-02-23 14:39:49', '12', '2014-07-16 20:38:00', '1115', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('328', '516', 'Buick', 'Century', '1986', '14000', '30', '2014-02-23 14:41:42', '68', '2014-06-19 01:09:14', '1107', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('329', '418', 'Chevrolet', 'Astrovan', '1990', '8000', '25', '2014-02-23 14:42:26', '68', '2014-06-19 01:22:06', '1107', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('330', '468', 'Honda', 'CR500R', '1984', '5525', '0', '2014-02-23 22:10:00', '12', '2014-10-13 17:46:40', '1622', '\n', '[ [ 500, 195, 5, [ 0, 0.05000000074505806, -0.090000003576278687 ], 103, 1.3999999761581421, 0.89999997615814209, 0.40000000596046448, 5, 190, 30, 7, \"rwd\", \"petrol\", 14, 0.5, false, 35, 0.85000002384185791, 0.15000000596046448, 0, 0.15000000596046448, -0.20000000298023224, 0.5, 0, 0, 0.15000000596046448, 10000, 16777216, 0, \"small\", \"small\", 7 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('332', '468', 'Honda', 'CR500R', '1994', '6575', '5', '2014-02-23 22:10:29', '12', '2014-03-23 19:42:43', '55', '\n', null, '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('333', '468', 'Honda', 'CR500R', '2001', '7150', '5', '2014-02-23 22:10:41', '12', '2014-08-10 21:07:02', '12', '\n', '[ [ 350, 195, 5, [ 0, -0.230000, -0.090000 ], 103, 1.800000, 0.900000, 0.480000, 5, 190, 33, 2, \"rwd\", \"petrol\", 14, 0.500000, false, 35, 0.850000, 0.150000, 0, 0.150000, -0.200000, 0.500000, 0, 0, 0.150000, 10000, 16777216, 0, \"small\", \"small\", 7 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('334', '540', 'BMW', 'E30 318i', '1982', '11500', '30', '2014-02-23 23:57:31', '68', '2014-09-11 21:44:02', '1107', '\n', '[ { \"1\": 1800, \"2\": 3000, \"3\": 2, \"4\": [ 0, 0.30000001192092896, 0 ], \"5\": 70, \"6\": 0.69999998807907104, \"7\": 0.80000001192092896, \"8\": 0.5, \"9\": 4, \"10\": 160, \"11\": 7.1999998092651367, \"12\": 20, \"13\": \"rwd\", \"14\": \"petrol\", \"15\": 5.4000000953674316, \"16\": 0.60000002384185791, \"17\": false, \"18\": 30, \"19\": 1, \"20\": 0.090000003576278687, \"21\": 0, \"22\": 0.31999999284744263, \"23\": -0.20000000298023224, \"24\": 0.60000002384185791, \"25\": 0, \"26\": 0.25999999046325684, \"27\": 0.54000002145767212, \"28\": 19000, \"29\": 0, \"30\": 2, \"31\": \"long\", \"33\": 0 } ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('336', '470', 'Hummer', 'H1', '1992', '70000', '30', '2014-03-02 10:55:41', '68', '2014-08-11 16:09:22', '1115', '\n', '[ [ 3100, 7968.700195, 2.500000, [ 0, 0, 0 ], 80, 0.700000, 0.850000, 0.500000, 5, 135, 10, 20, \"awd\", \"petrol\", 8, 0.500000, false, 30, 1.500000, 0.080000, 4, 0.350000, -0.300000, 0.500000, 0, 0.280000, 0.250000, 40000, 8, 3145728, \"long\", \"small\", 0 ] ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('338', '479', 'Volvo', '745', '1992', '14000', '15', '2014-03-02 13:09:38', '55', '2014-06-19 01:35:41', '1107', '\n', '[ [ 1500, 3800, 2, [ 0, 0.200000, 0 ], 75, 0.650000, 0.850000, 0.520000, 4, 165, 6.400000, 25, \"rwd\", \"petrol\", 5, 0.600000, false, 30, 1, 0.100000, 0, 0.270000, -0.200000, 0.500000, 0.200000, 0.240000, 0.480000, 18000, 32, 1, \"small\", \"small\", 0 ] ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('340', '420', 'Ford', 'Crown Victoria', '2006', '20500', '25', '2014-03-06 20:26:09', '1', '2014-10-03 01:44:43', '1107', '\n', '[ [ 1450, 4056.39990234375, 2.2000000476837158, [ 0, 0.30000001192092896, -0.25 ], 75, 0.80000001192092896, 0.75, 0.44999998807907104, 5, 180, 7.5999999046325684, 10, \"rwd\", \"petrol\", 9.1000003814697266, 0.60000002384185791, false, 35, 1.3999999761581421, 0.10000000149011612, 0, 0.25, -0.20000000298023224, 0.5, 0, 0.20000000298023224, 0.50999999046325684, 20000, 0, 2097152, \"long\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('341', '527', 'Mercedes-Benz', 'S500 CDI', '2017', '135500', '80', '2014-03-07 04:36:01', '12', '2021-03-26 17:10:06', '17800', '\n', '[ [ 1900, 2000, 1, [ 0, 0.1500000059604645, -0.1000000014901161 ], 70, 0.8500000238418579, 0.8600000143051147, 0.5, 4, 200, 12, 8, \"awd\", \"petrol\", 8, 0.6000000238418579, false, 15, 1.399999976158142, 0.119999997317791, 0, 0.300000011920929, -0.05999999865889549, 0.5, 0, 0.2599999904632568, 0.5, 9000, 1073741824, 2, \"long\", \"long\", 0 ] ]', '1000', '1', '0', null);
INSERT INTO `vehicles_shop` VALUES ('344', '603', 'Pontiac', 'Firebird Trans Am', '1982', '21500', '40', '2014-03-07 06:08:34', '68', '2015-01-03 08:46:19', '99', '\n', '[ [ 1600, 4000, 2.2000000476837158, [ 0, -0.10000000149011612, -0.15000000596046448 ], 85, 0.80000001192092896, 0.89999997615814209, 0.51999998092651367, 5, 150, 12.5, 5, \"rwd\", \"petrol\", 6, 0.60000002384185791, false, 30, 1.2000000476837158, 0.20000000298023224, 0, 0.2800000011920929, -0.15000000596046448, 0.5, 0.40000000596046448, 0.25, 0.5, 35000, 10240, 2097152, \"small\", \"small\", 0 ] ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('346', '475', 'Chevrolet', 'Chevelle SS', '1969', '39900', '35', '2014-03-07 09:32:29', '12', '2014-06-18 23:05:54', '1107', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('347', '558', 'Toyota', 'Corolla AE86 Levin', '1985', '12000', '15', '2014-03-07 09:38:09', '12', '2015-01-20 08:08:28', '10139', '\n', '[ [ 923, 2998.300048828125, 1.6000000238418579, [ 0, 0, -0.30000001192092896 ], 75, 0.68000000715255737, 0.85000002384185791, 0.4699999988079071, 5, 123, 3.5, 5, \"rwd\", \"petrol\", 4, 0.40000000596046448, false, 36, 0.80000001192092896, 0.10000000149011612, 0, 0.2800000011920929, -0.15000000596046448, 0.5, 0.30000001192092896, 0.25, 0.60000002384185791, 35000, 3221235712, 67108865, \"small\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('348', '484', 'Laguna', '26\' Sail Boat', '1985', '39650', '125', '2014-03-07 23:23:09', '12', '2014-03-21 04:14:56', '705', '\n', null, '1000', '1', '6', '0');
INSERT INTO `vehicles_shop` VALUES ('349', '473', 'Mistral', '460', '2011', '7500', '25', '2014-03-07 23:24:05', '12', '2015-02-03 05:49:33', '1107', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('350', '446', 'Crownline', '220 EX', '2005', '34500', '25', '2014-03-07 23:26:45', '12', '2014-03-21 04:06:59', '1', '\n', null, '1000', '1', '6', '0');
INSERT INTO `vehicles_shop` VALUES ('351', '472', 'Action Craft', '2020 Special Edition', '1998', '25000', '35', '2014-03-07 23:27:35', '12', '2014-03-21 04:15:04', '705', '\n', null, '1000', '1', '6', '0');
INSERT INTO `vehicles_shop` VALUES ('352', '454', 'Viking Yachts', 'Motor Yacht', '1990', '225000', '155', '2014-03-07 23:29:11', '12', '2014-04-29 05:10:01', '705', '\n', null, '1000', '1', '6', '0');
INSERT INTO `vehicles_shop` VALUES ('353', '453', 'Post Sport', 'Fisherman', '1975', '34500', '75', '2014-03-07 23:31:26', '12', '2014-03-21 04:04:51', '1', '\n', null, '1000', '1', '6', '0');
INSERT INTO `vehicles_shop` VALUES ('354', '493', 'Supra', 'SA350', '2013', '65700', '75', '2014-03-07 23:32:08', '12', '2014-03-22 00:46:14', '705', '\n', null, '1000', '1', '6', '0');
INSERT INTO `vehicles_shop` VALUES ('355', '452', 'Supra', 'Launch 21V', '2013', '85750', '125', '2014-03-07 23:34:22', '12', '2014-03-21 04:15:10', '705', '\n', null, '1000', '1', '6', '0');
INSERT INTO `vehicles_shop` VALUES ('356', '407', 'Sutphen Wildland ', 'Interface Pumper', '2012', '415000', '200', '2014-03-10 00:30:30', '55', '2014-03-17 03:22:23', '705', '\n', '[ [ 5000, 36670.800781, 3, [ 0, 0, -0.400000 ], 90, 0.900000, 0.800000, 0.500000, 5, 170, 11, 10, \"rwd\", \"diesel\", 10, 0.400000, false, 27, 1.200000, 0.080000, 0, 0.470000, -0.200000, 0.500000, 0, 0.200000, 0.260000, 15000, 16536, 0, \"long\", \"small\", 2 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('357', '416', 'Mercedes-Benz', 'Sprinter Ambulans', '2016', '56000', '50', '2014-03-11 00:03:00', '55', '2021-03-27 11:00:39', '17826', '\n', null, '1000', '1', '0', null);
INSERT INTO `vehicles_shop` VALUES ('358', '596', 'Hyundai Accent', 'Mondeo', '2016', '55000', '50', '2014-03-11 01:12:24', '55', '2021-04-06 13:54:49', '17927', '\n', '[ [ 2300, 4500, 1.6000000238418579, [ 0, 0.30000001192092896, -0.34999999403953552 ], 75, 1.1100000143051147, 0.85000002384185791, 0.5, 5, 170, 14, 3, \"rwd\", \"petrol\", 10, 0.5, false, 46, 1, 0.20000000298023224, 0, 0.2800000011920929, -0.20000000298023224, 0.5, 0, 0.20000000298023224, 0.23999999463558197, 25000, 1073741824, 270532616, \"long\", \"small\", 0 ] ]', '1000', '1', '0', null);
INSERT INTO `vehicles_shop` VALUES ('359', '522', 'Ducati', 'Superbike 1199 Panigale R', '2017', '300000', '150', '2014-03-11 03:46:36', '705', '2020-06-06 02:01:12', '744', '\n', '[ [ 400, 200, 0.1000000014901161, [ 0, 0, -0.300000011920929 ], 103, 2.299999952316284, 0.8999999761581421, 0.4799999892711639, 5, 275, 50, 25, \"rwd\", \"petrol\", 50, 0.5, false, 26, 0.8500000238418579, 0.1500000059604645, 0, 0.1500000059604645, -0.1599999964237213, 0.5, 0, 0, 0.1500000059604645, 10000, 16785408, 2, \"small\", \"small\", 4 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('360', '560', 'Mitsubishi', 'Galant VR4 Coupe', '1989', '19500', '45', '2014-03-11 07:43:19', '194', '2014-06-19 01:16:29', '1107', '\n', '[ [ 1400, 3400, 2.500000, [ 0, 0.100000, -0.100000 ], 75, 0.800000, 0.800000, 0.500000, 5, 200, 9, 5, \"awd\", \"petrol\", 10, 0.500000, false, 30, 1.200000, 0.150000, 0, 0.280000, -0.200000, 0.500000, 0.300000, 0.250000, 0.600000, 35000, 10240, 67108864.000000, \"small\", \"small\", 0 ] ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('361', '544', 'Pierce', 'Enforcer', '2003', '185000', '60', '2014-03-13 03:37:31', '1', '2014-03-13 03:37:31', '0', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('365', '589', 'Volkswagen', 'Golf V GTI', '2006', '14500', '40', '2014-03-19 22:17:45', '705', '2014-10-13 14:39:41', '1107', '\n', '[ [ 1100, 3000, 2.5, [ 0, 0, 0 ], 80, 0.75, 0.89999997615814209, 0.49000000953674316, 5, 200, 12.5, 10, \"fwd\", \"petrol\", 11, 0.40000000596046448, false, 30, 1.7000000476837158, 0.10000000149011612, 0, 0.2800000011920929, -0.10000000149011612, 0.5, 0, 0.25, 0.5, 35000, 8192, 12582912, \"small\", \"small\", 0 ] ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('366', '589', 'Volkswagen', 'Golf VI', '2012', '17500', '50', '2014-03-19 22:23:20', '705', '2014-10-23 21:56:41', '1622', '\n', '[ [ 1300, 3000, 2, [ 0, 0, 0 ], 80, 0.64999997615814209, 0.89999997615814209, 0.5, 5, 165, 8, 10, \"fwd\", \"petrol\", 11, 0.40000000596046448, false, 30, 1.7000000476837158, 0.10000000149011612, 0, 0.2800000011920929, -0.10000000149011612, 0.5, 0, 0.25, 0.5, 35000, 8192, 12582912, \"small\", \"small\", 0 ] ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('367', '589', 'Audi', 'A3', '2010', '16500', '45', '2014-03-19 22:25:45', '705', '2014-04-13 14:16:17', '705', '\n', '[ [ 1200, 3000, 2.600000, [ 0, 0, 0 ], 80, 0.750000, 0.900000, 0.490000, 5, 200, 12.500000, 10, \"fwd\", \"petrol\", 11, 0.400000, false, 30, 1.700000, 0.100000, 0, 0.280000, -0.100000, 0.500000, 0, 0.250000, 0.500000, 35000, 8192, 12582912, \"small\", \"small\", 0 ] ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('369', '420', 'Ford', 'Crown Victoria', '2002', '20000', '50', '2014-03-20 23:58:46', '705', '2014-10-03 01:44:08', '1107', '\n', '[ [ 1450, 4056.39990234375, 2.2000000476837158, [ 0, 0.30000001192092896, -0.25 ], 75, 0.80000001192092896, 0.75, 0.44999998807907104, 5, 160, 7, 10, \"rwd\", \"petrol\", 9.1000003814697266, 0.60000002384185791, false, 35, 1.3999999761581421, 0.10000000149011612, 0, 0.25, -0.20000000298023224, 0.5, 0, 0.20000000298023224, 0.50999999046325684, 20000, 0, 2097152, \"long\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('370', '438', 'Jeep', 'Grand Cherokee', '2016', '99999999', '0', '2014-03-21 00:02:38', '705', '2020-06-22 21:05:25', '2545', '\n', '[ [ 4000, 4351.7001953125, 1.600000023841858, [ 0, 0.300000011920929, -0.6000000238418579 ], 75, 1.100000023841858, 0.8500000238418579, 0.5099999904632568, 4, 200, 35, 30, \"rwd\", \"petrol\", 50, 0.6000000238418579, false, 35, 1, 0.2000000029802322, 2, 0.25, -0.1899998933076859, 0.6000000238418579, 0.5, 0.2000000029802322, 0.4000000059604645, 10000, 0, 0, \"small\", \"small\", 0 ] ]', '1000', '1', '0', null);
INSERT INTO `vehicles_shop` VALUES ('371', '456', 'Ford', 'F700', '1997', '22500', '65', '2014-03-21 00:03:25', '705', '2014-11-11 23:08:06', '1622', '\n', '[ [ 4500, 18003.699219, 4, [ 0, 0, 0 ], 80, 0.550000, 0.700000, 0.480000, 5, 140, 8, 40, \"rwd\", \"diesel\", 4.500000, 0.800000, false, 30, 1.800000, 0.120000, 0, 0.300000, -0.300000, 0.500000, 0, 0.350000, 0.450000, 22000, 16520, 1, \"long\", \"small\", 0 ] ]', '1000', '1', '5', '0');
INSERT INTO `vehicles_shop` VALUES ('372', '414', 'Ford', 'E-350', '2003', '20000', '65', '2014-03-21 00:04:09', '705', '2014-03-24 03:54:47', '65', '\n', '[ { \"1\": 3500, \"2\": 14000, \"3\": 4, \"4\": [ 0, 0, 0.100000 ], \"5\": 80, \"6\": 0.550000, \"7\": 0.850000, \"8\": 0.460000, \"9\": 5, \"10\": 140, \"11\": 6.800000, \"12\": 20, \"13\": \"rwd\", \"14\": \"diesel\", \"15\": 4.500000, \"16\": 0.600000, \"17\": false, \"18\": 30, \"19\": 2, \"20\": 0.070000, \"21\": 5, \"22\": 0.300000, \"23\": -0.200000, \"24\": 0.500000, \"25\": 0, \"26\": 0.460000, \"27\": 0.530000, \"28\": 22000, \"29\": 16520, \"30\": 0, \"31\": \"long\", \"33\": 0 } ]', '1000', '1', '5', '0');
INSERT INTO `vehicles_shop` VALUES ('373', '499', 'Ford', 'Econoline Box Van', '1990', '25000', '65', '2014-03-21 00:05:06', '705', '2014-06-19 01:23:27', '1107', '\n', '[ { \"1\": 3500, \"2\": 13865.799805, \"3\": 2.300000, \"4\": [ 0, 0, -0.200000 ], \"5\": 80, \"6\": 0.750000, \"7\": 0.700000, \"8\": 0.460000, \"9\": 5, \"10\": 140, \"11\": 5.500000, \"12\": 20, \"13\": \"rwd\", \"14\": \"diesel\", \"15\": 4.500000, \"16\": 0.600000, \"17\": false, \"18\": 30, \"19\": 1.200000, \"20\": 0.200000, \"21\": 0, \"22\": 0.350000, \"23\": -0.200000, \"24\": 0.400000, \"25\": 0, \"26\": 0.460000, \"27\": 0.530000, \"28\": 22000, \"29\": 16520, \"30\": 1, \"31\": \"small\", \"33\": 0 } ]', '1000', '1', '5', '0');
INSERT INTO `vehicles_shop` VALUES ('374', '440', 'Dodge', 'Ram Van', '1992', '12000', '65', '2014-03-21 00:05:47', '705', '2014-06-19 01:41:53', '1107', '\n', '[ [ 2000, 4901.700195, 2.400000, [ 0, 0.400000, -0.100000 ], 85, 0.600000, 0.750000, 0.520000, 5, 140, 6, 15, \"fwd\", \"petrol\", 5.500000, 0.400000, false, 30, 1.400000, 0.050000, 0, 0.430000, -0.100000, 0.500000, 0, 0.200000, 0.600000, 26000, 1, 0, \"long\", \"small\", 13 ] ]', '1000', '1', '5', '0');
INSERT INTO `vehicles_shop` VALUES ('375', '498', 'Ford', 'Utilimaster E350 Step Van', '2004', '18000', '65', '2014-03-21 00:08:19', '705', '2014-03-21 00:15:01', '705', '\n', '[ { \"1\": 5500, \"2\": 23489.599609, \"3\": 3.500000, \"4\": [ 0, 0, 0 ], \"5\": 80, \"6\": 0.820000, \"7\": 0.700000, \"8\": 0.460000, \"9\": 5, \"10\": 120, \"11\": 5, \"12\": 25, \"13\": \"rwd\", \"14\": \"diesel\", \"15\": 4.500000, \"16\": 0.600000, \"17\": false, \"18\": 30, \"19\": 0.900000, \"20\": 0.080000, \"21\": 0, \"22\": 0.250000, \"23\": -0.300000, \"24\": 0.300000, \"25\": 0.600000, \"26\": 0.260000, \"27\": 0.400000, \"28\": 22000, \"29\": 16393, \"30\": 513, \"31\": \"long\", \"33\": 13 } ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('376', '473', 'BRIG', 'Eagle 480', '2014', '12000', '35', '2014-03-21 04:19:42', '705', '2015-02-03 05:50:02', '1107', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('377', '452', 'Riva', 'Aquarama Special', '1996', '65000', '75', '2014-03-21 04:24:02', '705', '2014-03-21 04:32:04', '1', '\n', null, '1000', '1', '6', '0');
INSERT INTO `vehicles_shop` VALUES ('378', '446', 'Chris-Craft', 'Stinger 312', '1988', '35000', '85', '2014-03-21 04:29:38', '705', '2014-03-21 04:31:58', '1', '\n', null, '1000', '1', '6', '0');
INSERT INTO `vehicles_shop` VALUES ('379', '454', 'Rodman', '1250', '2007', '90500', '145', '2014-03-21 04:40:40', '705', '2014-03-22 00:42:29', '705', '\n', null, '1000', '1', '6', '0');
INSERT INTO `vehicles_shop` VALUES ('380', '454', 'Princess', 'V39', '2012', '140500', '195', '2014-03-21 04:41:40', '705', '2014-03-22 00:42:16', '705', '\n', null, '1000', '1', '6', '0');
INSERT INTO `vehicles_shop` VALUES ('381', '454', 'Sunseeker', '82', '2006', '210500', '245', '2014-03-21 04:42:28', '705', '2014-03-22 00:42:23', '705', '\n', null, '1000', '1', '6', '0');
INSERT INTO `vehicles_shop` VALUES ('382', '416', 'Mercedes-Benz', 'Sprinter Ambulans', '2016', '62000', '100', '2014-03-22 03:13:35', '55', '2021-03-27 11:01:00', '17826', '\n', '[ [ 2600, 10202.7998046875, 1, [ 0, 0, -0.300000011920929 ], 90, 0.75, 0.800000011920929, 0.4699999988079071, 5, 230, 14.5, 10, \"awd\", \"diesel\", 7, 0.6000000238418579, false, 35, 1, 0.2000000029802322, 0, 0.4000000059604645, -0.2000000029802322, 0.5, 0, 0.5799999833106995, 0.3300000131130219, 10000, 16385, 4, \"long\", \"small\", 13 ] ]', '1000', '1', '0', null);
INSERT INTO `vehicles_shop` VALUES ('383', '547', 'Audi', 'A4', '2014', '42500', '45', '2014-03-23 23:50:48', '705', '2021-03-26 19:02:17', '17826', '\n', '[ { \"1\": 1600, \"2\": 3300, \"3\": 2.200000, \"4\": [ 0, 0, 0 ], \"5\": 70, \"6\": 0.700000, \"7\": 0.800000, \"8\": 0.540000, \"9\": 4, \"10\": 160, \"11\": 7.500000, \"12\": 7, \"13\": \"rwd\", \"14\": \"petrol\", \"15\": 5.400000, \"16\": 0.600000, \"17\": false, \"18\": 30, \"19\": 1.100000, \"20\": 0.140000, \"21\": 0, \"22\": 0.320000, \"23\": -0.100000, \"24\": 0.500000, \"25\": 0, \"26\": 0.260000, \"27\": 0.540000, \"28\": 19000, \"29\": 0, \"30\": 0, \"31\": \"long\", \"33\": 0 } ]', '1000', '1', '0', null);
INSERT INTO `vehicles_shop` VALUES ('384', '547', 'Audi', 'A4', '2014', '42500', '45', '2014-03-23 23:51:48', '705', '2021-03-26 19:01:53', '17826', '\n', '[ { \"1\": 1600, \"2\": 3300, \"3\": 2.200000, \"4\": [ 0, 0, 0 ], \"5\": 70, \"6\": 0.700000, \"7\": 0.800000, \"8\": 0.540000, \"9\": 4, \"10\": 160, \"11\": 7.200000, \"12\": 7, \"13\": \"fwd\", \"14\": \"petrol\", \"15\": 5.400000, \"16\": 0.600000, \"17\": false, \"18\": 30, \"19\": 1.100000, \"20\": 0.140000, \"21\": 0, \"22\": 0.320000, \"23\": -0.100000, \"24\": 0.500000, \"25\": 0, \"26\": 0.260000, \"27\": 0.540000, \"28\": 19000, \"29\": 0, \"30\": 0, \"31\": \"long\", \"33\": 0 } ]', '1000', '1', '0', null);
INSERT INTO `vehicles_shop` VALUES ('385', '542', '[DONATE] Nissan', 'GT-R R35', '2018', '999999999', '100', '2014-03-23 23:53:58', '705', '2021-03-26 22:24:52', '17824', '\n', '[ [ 2500, 3000, 1.200000047683716, [ 0, 0, 0 ], 70, 1.5, 0.800000011920929, 0.5, 4, 260, 22.5, 10, \"awd\", \"petrol\", 27, 0.4000000059604645, false, 35, 2, 0.2000000029802322, 0, 0.300000011920929, -0.1000000014901161, 0.5, 0.25, 0.25, 0.5199999809265137, 19000, 1076363264, 268468224, \"small\", \"small\", 0 ] ]', '1000', '0', '0', null);
INSERT INTO `vehicles_shop` VALUES ('387', '481', 'Spire', 'Premium', '2012', '600', '0', '2014-03-25 04:28:33', '55', '2020-01-02 11:49:49', '745', '\n', '[ [ 100, 39, 7, [ 0, 0.05000000074505806, -0.090000003576278687 ], 103, 1.6000000238418579, 0.89999997615814209, 0.47999998927116394, 5, 120, 7.1999998092651367, 5, \"rwd\", \"petrol\", 19, 0.5, false, 35, 0.80000001192092896, 0.15000000596046448, 0, 0.20000000298023224, -0.10000000149011612, 0.5, 0, 0, 0.15000000596046448, 10000, 1090519040, 0, \"small\", \"small\", 9 ] ]', '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('388', '402', 'Ford ', 'Mustang Fastback', '1965', '62500', '40', '2014-03-25 05:41:35', '55', '2014-12-23 04:35:37', '1622', '\n', '[ [ 1500, 4000, 2, [ 0, 0, -0.100000 ], 85, 0.700000, 0.900000, 0.500000, 5, 160, 8.500000, 5, \"rwd\", \"petrol\", 11, 0.400000, false, 30, 0.800000, 0.200000, 0, 0.280000, -0.240000, 0.500000, 0.400000, 0.250000, 0.500000, 35000, 10240, 270532608, \"small\", \"small\", 0 ] ]', '1000', '1', '1', '0');
INSERT INTO `vehicles_shop` VALUES ('389', '562', 'Nissan', 'Skyline R33 GT-R', '1996', '41355', '50', '2014-03-25 22:59:00', '705', '2014-05-18 21:32:37', '1737', '\n', '[ [ 1500, 3500, 2.200000, [ 0, 0.300000, -0.150000 ], 75, 0.650000, 0.900000, 0.500000, 5, 200, 11.200000, 5, \"awd\", \"petrol\", 8, 0.500000, false, 35, 1, 0.200000, 0, 0.280000, -0.100000, 0.500000, 0.300000, 0.250000, 0.600000, 35000, 1073752064, 67108864, \"small\", \"small\", 1 ] ]', '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('392', '510', 'Scott', 'Genius', '2014', '600', '0', '2014-03-26 03:52:59', '705', '2020-01-22 12:53:01', '1438', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('395', '443', 'Peterbilt', '379 Car Carrier', '1986', '45500', '120', '2014-03-29 19:56:09', '705', '2015-01-02 06:34:51', '10139', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('396', '402', 'Shelby', 'Mustang GT500', '1967', '95000', '55', '2014-03-29 22:12:26', '55', '2014-06-18 02:54:09', '1107', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('398', '463', 'Harley-Davidson', 'Dyna Super Glide Sport', '2003', '7000', '20', '2014-03-30 18:24:29', '705', '2015-01-30 01:04:05', '1107', '\n', '[ [ 800, 403.29998779296875, 3, [ 0, 0.10000000149011612, 0 ], 103, 1.5, 0.81999999284744263, 0.50999999046325684, 4, 170, 35, 10, \"rwd\", \"petrol\", 11.699999809265137, 0.60000002384185791, false, 35, 0.64999997615814209, 0.20000000298023224, 0, 0.090000003576278687, -0.10999999940395355, 0.60000002384185791, 0, 0, 0.23999999463558197, 10000, 16785408, 0, \"small\", \"small\", 6 ] ]', '1000', '1', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('399', '463', 'Harley-Davidson', 'Sportster XL883N IRON', '2009', '8000', '20', '2014-03-30 18:25:14', '705', '2014-11-16 02:14:59', '1260', '\n', '[ [ 800, 403.29998779296875, 3, [ 0, 0.10000000149011612, 0 ], 103, 1.5, 0.81999999284744263, 0.50999999046325684, 4, 170, 35, 10, \"rwd\", \"petrol\", 10, 0.60000002384185791, false, 35, 0.64999997615814209, 0.20000000298023224, 0, 0.090000003576278687, -0.10000000149011612, 0.60000002384185791, 0, 0, 0.23999999463558197, 10000, 16785408, 0, \"small\", \"small\", 6 ] ]', '1000', '1', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('400', '463', 'Harley-Davidson', 'Iron', '1990', '6500', '20', '2014-03-30 18:30:25', '705', '2014-08-10 21:42:07', '12', '\n', '[ [ 800, 403.299988, 4, [ 0, 0.100000, 0 ], 103, 1.200000, 0.820000, 0.510000, 4, 190, 16, 5, \"rwd\", \"petrol\", 10, 0.600000, false, 35, 0.650000, 0.200000, 0, 0.090000, -0.100000, 0.600000, 0, 0, 0.240000, 10000, 16785408, 0, \"small\", \"small\", 6 ] ]', '1000', '1', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('412', '477', 'Mazda', 'RX-7 FD3S', '1993', '22000', '60', '2014-04-01 08:24:53', '166', '2014-10-23 23:15:07', '1622', '\n', '[ [ 1400, 2979.699951171875, 2, [ 0, 0.20000000298023224, -0.10000000149011612 ], 70, 0.80000001192092896, 0.80000001192092896, 0.50999999046325684, 5, 200, 11.199999809265137, 10, \"rwd\", \"petrol\", 11.100000381469727, 0.5, false, 30, 1.2000000476837158, 0.10000000149011612, 0, 0.31000000238418579, -0.20000000298023224, 0.5, 0.30000001192092896, 0.23999999463558197, 0.60000002384185791, 45000, 0, 12582912, \"small\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('413', '487', 'Model', 'Bell 407', '2005', '99999999', '0', '2014-04-02 01:33:51', '65', '2020-06-22 21:15:52', '2545', '\n', null, '1000', '1', '0', null);
INSERT INTO `vehicles_shop` VALUES ('414', '593', 'Cessna', '152', '1977', '90000', '280', '2014-04-02 01:46:07', '65', '2020-03-13 16:36:04', '745', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('415', '511', 'Britten-Norman', 'BN-2 Islander', '1965', '150000', '350', '2014-04-02 01:49:13', '65', '2014-08-20 19:07:59', '1622', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('416', '519', 'Cessna', 'Citation X', '1996', '3000000', '500', '2014-04-02 01:51:56', '65', '2020-05-01 18:56:26', '2545', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('417', '508', 'Itasca', 'Impulse Silver', '2014', '95000', '80', '2014-04-02 19:42:17', '705', '2014-11-27 20:10:27', '1107', '\n', '[ { \"1\": 3500, \"2\": 13865.799805, \"3\": 3, \"4\": [ 0, 0, 0 ], \"5\": 80, \"6\": 0.620000, \"7\": 0.700000, \"8\": 0.460000, \"9\": 5, \"10\": 160, \"11\": 9, \"12\": 25, \"13\": \"rwd\", \"14\": \"diesel\", \"15\": 4.500000, \"16\": 0.600000, \"17\": false, \"18\": 30, \"19\": 1.500000, \"20\": 0.110000, \"21\": 0, \"22\": 0.300000, \"23\": -0.200000, \"24\": 0.500000, \"25\": 0, \"26\": 0.460000, \"27\": 0.530000, \"28\": 22000, \"29\": 136, \"30\": 1, \"31\": \"long\", \"33\": 0 } ]', '1000', '1', '1', '0');
INSERT INTO `vehicles_shop` VALUES ('418', '508', 'Itasca', 'Navion', '2008', '60500', '50', '2014-04-02 19:44:30', '705', '2014-11-27 20:10:38', '1107', '\n', '[ { \"1\": 3500, \"2\": 13865.799805, \"3\": 3, \"4\": [ 0, 0, 0 ], \"5\": 80, \"6\": 0.620000, \"7\": 0.700000, \"8\": 0.460000, \"9\": 5, \"10\": 155, \"11\": 8, \"12\": 25, \"13\": \"rwd\", \"14\": \"diesel\", \"15\": 4.500000, \"16\": 0.600000, \"17\": false, \"18\": 30, \"19\": 1.500000, \"20\": 0.110000, \"21\": 0, \"22\": 0.300000, \"23\": -0.200000, \"24\": 0.500000, \"25\": 0, \"26\": 0.460000, \"27\": 0.530000, \"28\": 22000, \"29\": 136, \"30\": 1, \"31\": \"long\", \"33\": 0 } ]', '1000', '1', '1', '0');
INSERT INTO `vehicles_shop` VALUES ('419', '508', 'Dynamax', 'Isata', '2004', '45000', '50', '2014-04-02 19:46:01', '705', '2014-11-27 20:11:25', '1107', '\n', '[ { \"1\": 3500, \"2\": 13865.799805, \"3\": 3, \"4\": [ 0, 0, 0 ], \"5\": 80, \"6\": 0.620000, \"7\": 0.700000, \"8\": 0.460000, \"9\": 5, \"10\": 150, \"11\": 7, \"12\": 25, \"13\": \"rwd\", \"14\": \"diesel\", \"15\": 4.500000, \"16\": 0.600000, \"17\": false, \"18\": 30, \"19\": 1.500000, \"20\": 0.110000, \"21\": 0, \"22\": 0.300000, \"23\": -0.200000, \"24\": 0.500000, \"25\": 0, \"26\": 0.460000, \"27\": 0.530000, \"28\": 22000, \"29\": 136, \"30\": 1, \"31\": \"long\", \"33\": 0 } ]', '1000', '1', '1', '0');
INSERT INTO `vehicles_shop` VALUES ('420', '508', 'R-Vision', 'Condor', '2003', '32000', '50', '2014-04-02 19:46:55', '705', '2014-11-27 20:11:54', '1107', '\n', '[ { \"1\": 3500, \"2\": 13865.799805, \"3\": 3, \"4\": [ 0, 0, 0 ], \"5\": 80, \"6\": 0.620000, \"7\": 0.700000, \"8\": 0.460000, \"9\": 5, \"10\": 145, \"11\": 6.500000, \"12\": 25, \"13\": \"rwd\", \"14\": \"diesel\", \"15\": 4.500000, \"16\": 0.600000, \"17\": false, \"18\": 30, \"19\": 1.500000, \"20\": 0.110000, \"21\": 0, \"22\": 0.300000, \"23\": -0.200000, \"24\": 0.500000, \"25\": 0, \"26\": 0.460000, \"27\": 0.530000, \"28\": 22000, \"29\": 136, \"30\": 1, \"31\": \"long\", \"33\": 0 } ]', '1000', '1', '1', '0');
INSERT INTO `vehicles_shop` VALUES ('421', '508', 'Fleetwood', 'Tioga', '1985', '18500', '50', '2014-04-02 19:48:06', '705', '2014-12-23 03:57:54', '1622', '\n', '[ { \"1\": 3500, \"2\": 13865.799805, \"3\": 3, \"4\": [ 0, 0, 0 ], \"5\": 80, \"6\": 0.620000, \"7\": 0.700000, \"8\": 0.460000, \"9\": 5, \"10\": 140, \"11\": 6, \"12\": 25, \"13\": \"rwd\", \"14\": \"diesel\", \"15\": 4.500000, \"16\": 0.600000, \"17\": false, \"18\": 30, \"19\": 1.500000, \"20\": 0.110000, \"21\": 0, \"22\": 0.300000, \"23\": -0.200000, \"24\": 0.500000, \"25\": 0, \"26\": 0.460000, \"27\": 0.530000, \"28\": 22000, \"29\": 136, \"30\": 1, \"31\": \"long\", \"33\": 0 } ]', '1000', '1', '2', '0');
INSERT INTO `vehicles_shop` VALUES ('422', '508', 'Coachmen', 'Coachmen', '1989', '16500', '50', '2014-04-02 19:49:11', '705', '2014-12-23 03:58:39', '1622', '\n', '[ { \"1\": 3500, \"2\": 13865.799805, \"3\": 3, \"4\": [ 0, 0, 0 ], \"5\": 80, \"6\": 0.620000, \"7\": 0.700000, \"8\": 0.460000, \"9\": 5, \"10\": 125, \"11\": 5, \"12\": 25, \"13\": \"rwd\", \"14\": \"diesel\", \"15\": 4.500000, \"16\": 0.600000, \"17\": false, \"18\": 30, \"19\": 1.500000, \"20\": 0.110000, \"21\": 0, \"22\": 0.300000, \"23\": -0.200000, \"24\": 0.500000, \"25\": 0, \"26\": 0.460000, \"27\": 0.530000, \"28\": 22000, \"29\": 136, \"30\": 1, \"31\": \"long\", \"33\": 0 } ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('423', '477', 'Nissan', '240SX Coupe', '1989', '9850', '50', '2014-04-02 23:11:24', '705', '2014-12-27 22:06:32', '55', '\n', '[ [ 1400, 2979.699951, 2, [ 0, 0.200000, -0.100000 ], 70, 0.800000, 0.800000, 0.510000, 5, 140, 6.500000, 10, \"rwd\", \"petrol\", 11.100000, 0.500000, false, 30, 1.200000, 0.100000, 0, 0.310000, -0.200000, 0.500000, 0.300000, 0.240000, 0.600000, 45000, 0, 12582912, \"small\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('424', '598', 'Ford', 'Mondeo', '2016', '7500', '45', '2014-04-04 03:22:22', '705', '2021-03-27 11:04:21', '17826', '\n', '[ [ 1400, 4500, 1.900000, [ 0, 0.300000, -0.100000 ], 75, 0.750000, 0.850000, 0.520000, 5, 190, 9.500000, 10, \"rwd\", \"petrol\", 10, 0.500000, false, 35, 0.900000, 0.080000, 0, 0.280000, -0.200000, 0.600000, 0, 0.200000, 0.240000, 25000, 1073741824, 270532608.000000, \"long\", \"small\", 0 ] ]', '1000', '0', '0', null);
INSERT INTO `vehicles_shop` VALUES ('425', '583', 'Xinfa', 'XT20B', '2008', '6500', '20', '2014-04-04 03:39:32', '705', '2014-08-14 17:47:11', '12', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('427', '507', 'Mercedes-Benz', 'S65 AMG', '2014', '135000', '70', '2014-04-06 18:21:19', '705', '2014-06-08 09:55:48', '2432', '\n', '[ [ 2200, 5000, 1.800000, [ 0, 0.100000, -0.100000 ], 75, 0.750000, 0.800000, 0.460000, 5, 180, 12, 10, \"rwd\", \"petrol\", 6, 0.600000, false, 30, 1, 0.100000, 0, 0.350000, -0.200000, 0.500000, 0.300000, 0.200000, 0.300000, 35000, 1073741824, 272629760, \"long\", \"small\", 0 ] ]', '1000', '1', '1', '0');
INSERT INTO `vehicles_shop` VALUES ('428', '560', 'Subaru', 'Impreza WRX STi', '2005', '42500', '50', '2014-04-06 20:44:40', '705', '2015-01-02 03:18:26', '10139', '\n', '[ [ 1400, 3400, 1.8999999761581421, [ 0, 0.10000000149011612, -0.10000000149011612 ], 75, 0.80000001192092896, 0.80000001192092896, 0.5, 5, 190, 12, 9, \"awd\", \"petrol\", 10, 0.5, false, 35, 1.2000000476837158, 0.15000000596046448, 0, 0.2800000011920929, -0.17499999701976776, 0.5, 0.30000001192092896, 0.25, 0.60000002384185791, 35000, 10240, 67108864, \"small\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('429', '431', 'Scania', 'K-series', '2010', '85000', '65', '2014-04-06 23:12:44', '705', '2014-04-09 19:29:29', '705', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('431', '541', 'Tesla', 'Roadster', '2012', '80000', '0', '2014-04-07 23:31:26', '705', '2014-04-07 23:31:26', '0', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('432', '524', 'Sterling', 'LT9500', '2004', '44500', '70', '2014-04-07 23:43:34', '705', '2014-05-24 04:40:52', '1622', '\n', '[ [ 5500, 33187.898438, 2, [ 0, 0, 0 ], 90, 0.580000, 0.800000, 0.500000, 4, 110, 5, 20, \"rwd\", \"diesel\", 3.170000, 0.400000, false, 30, 1.400000, 0.060000, 0, 0.450000, -0.300000, 0.600000, 0, 0.450000, 0.200000, 5000, 4210696, 262656, \"long\", \"small\", 0 ] ]', '1000', '1', '5', '0');
INSERT INTO `vehicles_shop` VALUES ('434', '424', 'Meyers', 'Tow\'dster', '1969', '6500', '45', '2014-04-08 23:14:28', '705', '2014-04-19 23:07:16', '65', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('435', '442', 'Buick', 'Electra wagon', '1984', '8000', '30', '2014-04-09 19:29:03', '705', '2014-08-25 20:08:21', '1107', '\n', '[ [ 2500, 5960.399902, 2, [ 0, -0.800000, 0.200000 ], 70, 0.750000, 0.800000, 0.500000, 5, 130, 6, 15, \"rwd\", \"petrol\", 4, 0.800000, false, 30, 1, 0.100000, 0, 0.350000, -0.150000, 0.400000, 0, 0.200000, 1.250000, 10000, 1073741824.000000, 0, \"long\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('436', '554', 'Ford', 'F-150 XLT', '1990', '12500', '35', '2014-04-11 22:36:29', '705', '2015-01-01 23:40:21', '55', '\n', '[ [ 2500, 6000, 1.8999999761581421, [ 0, 0.34999999403953552, 0 ], 80, 0.60000002384185791, 0.80000001192092896, 0.40000000596046448, 5, 150, 7, 10, \"awd\", \"petrol\", 8.5, 0.30000001192092896, false, 30, 0.60000002384185791, 0.20000000298023224, 0, 0.23999999463558197, -0.375, 0.60000002384185791, 0.5, 0.43999999761581421, 0.30000001192092896, 40000, 538968096, 5260288, \"long\", \"small\", 0 ] ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('438', '496', 'Honda', 'Civic Si', '2003', '6500', '12', '2014-04-12 03:52:20', '65', '2014-04-12 03:52:20', '0', '\n', null, '1000', '1', '2', '0');
INSERT INTO `vehicles_shop` VALUES ('439', '565', 'Volkswagen', 'Golf GT (2.2)', '2016', '1150000', '100', '2014-04-12 03:55:45', '65', '2020-04-25 12:10:33', '745', '\n', '[ [ 1400, 2998.300048828125, 1.600000023841858, [ 0, 0.2000000029802322, -0.1000000014901161 ], 75, 0.75, 0.8999999761581421, 0.5, 5, 205, 30, 6, \"awd\", \"petrol\", 8, 0.6000000238418579, false, 30, 1.399999976158142, 0.1500000059604645, 0, 0.2800000011920929, -0.1000000014901161, 0.5, 0.300000011920929, 0.25, 0.6000000238418579, 35000, 10244, 67108865, \"small\", \"small\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('440', '589', 'Mini ', 'One', '2006', '8000', '20', '2014-04-12 03:57:00', '65', '2014-04-17 19:36:27', '705', '\n', '[ [ 1400, 3000, 2.800000, [ 0, 0, 0 ], 80, 0.750000, 0.900000, 0.490000, 5, 200, 12.500000, 10, \"fwd\", \"petrol\", 11, 0.400000, false, 30, 1.700000, 0.100000, 0, 0.280000, -0.100000, 0.500000, 0, 0.250000, 0.500000, 35000, 8192, 12582912, \"small\", \"small\", 0 ] ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('441', '558', 'BMW', 'E46 316Ti Compact', '2002', '9000', '20', '2014-04-12 03:58:39', '65', '2014-08-04 13:54:53', '1115', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('442', '589', 'Volkswagen', 'Golf IV', '2001', '7000', '20', '2014-04-12 04:00:43', '65', '2014-10-23 21:57:51', '1622', '\n', '[ [ 1200, 3000, 2.5999999046325684, [ 0, 0, 0 ], 80, 0.64999997615814209, 0.89999997615814209, 0.55000001192092896, 5, 165, 8, 10, \"fwd\", \"petrol\", 11, 0.40000000596046448, false, 30, 1.7000000476837158, 0.10000000149011612, 0, 0.2800000011920929, -0.10000000149011612, 0.5, 0, 0.25, 0.5, 35000, 8192, 12582912, \"small\", \"small\", 0 ] ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('443', '565', 'Honda', 'Civic EP1', '2004', '7000', '20', '2014-04-12 04:01:41', '65', '2014-05-24 05:10:16', '1622', '\n', '[ [ 1400, 2998.300049, 2.200000, [ 0, 0.200000, -0.100000 ], 75, 0.750000, 0.900000, 0.500000, 5, 200, 9.600000, 10, \"fwd\", \"petrol\", 8, 0.600000, false, 30, 1.400000, 0.150000, 0, 0.280000, -0.100000, 0.500000, 0.300000, 0.250000, 0.600000, 35000, 10244, 67108865, \"small\", \"small\", 1 ] ]', '1000', '1', '2', '0');
INSERT INTO `vehicles_shop` VALUES ('445', '439', 'Ford', 'Mercury Cougar XR7', '1967', '19525', '25', '2014-04-12 07:37:11', '860', '2014-07-03 23:32:42', '1107', '\n', '[ [ 1600, 3921.300049, 2, [ 0, 0, -0.150000 ], 70, 0.800000, 0.750000, 0.550000, 4, 140, 8.800000, 5, \"rwd\", \"petrol\", 8.170000, 0.500000, false, 35, 1.200000, 0.100000, 0, 0.300000, -0.200000, 0.500000, 0, 0.300000, 0.640000, 19000, 10240, 4, \"small\", \"small\", 0 ] ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('446', '508', 'Fleetwood', 'Bounder', '1986', '14500', '50', '2014-04-13 00:02:29', '705', '2014-12-23 03:58:06', '1622', '\n', '[ { \"1\": 3500, \"2\": 13865.799805, \"3\": 3, \"4\": [ 0, 0, 0 ], \"5\": 80, \"6\": 0.620000, \"7\": 0.700000, \"8\": 0.460000, \"9\": 5, \"10\": 140, \"11\": 6, \"12\": 25, \"13\": \"rwd\", \"14\": \"diesel\", \"15\": 4.500000, \"16\": 0.600000, \"17\": false, \"18\": 30, \"19\": 1.500000, \"20\": 0.110000, \"21\": 0, \"22\": 0.300000, \"23\": -0.200000, \"24\": 0.500000, \"25\": 0, \"26\": 0.460000, \"27\": 0.530000, \"28\": 22000, \"29\": 136, \"30\": 1, \"31\": \"long\", \"33\": 0 } ]', '1000', '1', '2', '0');
INSERT INTO `vehicles_shop` VALUES ('447', '481', 'FIT', 'Aitken', '2013', '350', '0', '2014-04-13 03:40:28', '860', '2020-01-02 11:49:16', '745', '\n', null, '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('448', '481', 'We The People', 'Zodiac', '2014', '400', '0', '2014-04-13 03:41:23', '860', '2020-01-02 11:48:37', '745', '\n', null, '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('449', '481', 'We The People', 'Envy', '2014', '400', '0', '2014-04-13 03:42:19', '860', '2020-01-02 11:48:50', '745', '\n', null, '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('450', '481', 'MirraCo', 'Five Star', '2010', '250', '0', '2014-04-13 03:43:00', '860', '2020-01-02 11:49:01', '745', '\n', null, '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('451', '481', 'Eastern Bikes', 'Reaper', '2012', '225', '0', '2014-04-13 03:44:39', '860', '2020-01-02 11:49:26', '745', '\n', null, '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('452', '481', 'Stereo', 'Electric', '2013', '300', '0', '2014-04-13 03:45:48', '860', '2020-01-02 11:49:33', '745', '\n', null, '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('453', '481', 'S&M', 'BTM', '2014', '550', '0', '2014-04-13 03:46:22', '860', '2020-01-02 11:49:41', '745', '\n', '[ [ 100, 39, 7, [ 0, 0.050000, -0.090000 ], 103, 1.600000, 0.900000, 0.480000, 5, 30, 15, 5, \"rwd\", \"petrol\", 19, 0.500000, false, 35, 0.800000, 0.150000, 0, 0.200000, -0.100000, 0.500000, 0, 0, 0.150000, 10000, 1090519040, 0, \"small\", \"small\", 9 ] ]', '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('454', '522', 'Yamaha', 'YZF-R6', '2001', '7569', '35', '2014-04-13 17:29:31', '705', '2019-10-11 17:23:12', '1438', '\n', '[ [ 350, 200, 0.100000, [ 0, 0, 0 ], 103, 1.800000, 0.900000, 0.480000, 5, 170, 24, 5, \"rwd\", \"petrol\", 15, 0.500000, false, 35, 0.850000, 0.150000, 0, 0.150000, -0.200000, 0.500000, 0, 0, 0.150000, 10000, 16785408, 2, \"small\", \"small\", 4 ] ]', '1000', '0', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('457', '553', 'Douglas', 'DC-3', '1936', '500000', '450', '2014-04-14 05:06:12', '65', '2014-08-20 19:21:20', '1622', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('458', '574', 'Applied', 'Sweeper 636 Precinct', '2009', '17000', '15', '2014-04-14 05:11:09', '65', '2014-04-14 05:11:09', '0', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('459', '470', 'Hummer', 'H3 Alpha', '2008', '48000', '65', '2014-04-14 21:33:00', '705', '2014-07-25 09:53:16', '1737', '\n', '[ [ 2500, 7968.700195, 2.500000, [ 0, 0, 0 ], 80, 0.700000, 0.850000, 0.500000, 5, 180, 14, 20, \"awd\", \"petrol\", 8, 0.500000, false, 35, 1.500000, 0.080000, 4, 0.350000, -0.300000, 0.500000, 0, 0.280000, 0.250000, 40000, 8, 3145728, \"long\", \"small\", 0 ] ]', '1000', '1', '2', '0');
INSERT INTO `vehicles_shop` VALUES ('460', '417', 'Sikorsky ', 'SH-3 Sea King', '1961', '1000000', '250', '2014-04-14 21:37:56', '166', '2019-10-11 17:33:24', '1438', '\n', '[ [ 15000, 200000, 0.1000000014901161, [ 0, 0, 0 ], 30, 0.6499999761581421, 0.8999999761581421, 0.5, 1, 200, 6.400000095367432, 5, \"awd\", \"petrol\", 5, 0.4000000059604645, false, 30, 1, 0.05000000074505806, 0, 0.5, -0.2000000029802322, 0.8999999761581421, 0, 0.300000011920929, 0.5, 25000, 33570816, 4194304, \"long\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('461', '480', 'Porsche', '911 Turbo', '2009', '88000', '85', '2014-04-15 16:41:13', '705', '2014-11-27 06:34:29', '1775', '\n', '[ [ 1400, 2200, 1.7000000476837158, [ 0, 0.10000000149011612, -0.20000000298023224 ], 75, 0.75, 0.89999997615814209, 0.5, 5, 200, 15, 10, \"awd\", \"petrol\", 11, 0.40000000596046448, false, 30, 1.3999999761581421, 0.14000000059604645, 3, 0.2800000011920929, -0.05000000074505806, 0.5, 0.30000001192092896, 0.25, 0.60000002384185791, 35000, 1073743872, 0, \"small\", \"small\", 19 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('462', '417', 'AgustaWestland', 'AW139', '2003', '2000000', '650', '2014-04-15 23:10:47', '65', '2014-08-20 19:18:46', '1622', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('463', '469', 'Robinson', 'R22', '1979', '120000', '300', '2014-04-16 00:33:00', '705', '2014-08-20 19:29:15', '1622', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('464', '513', 'Acro Sport', 'II', '2007', '120000', '200', '2014-04-16 00:33:11', '65', '2019-10-29 21:55:42', '1438', '\n', '[ [ 5000, 20000, 14, [ 0, 0, 0 ], 75, 0.6499999761581421, 0.8999999761581421, 0.5, 1, 275, 75, 30, \"awd\", \"petrol\", 1.5, 0.4000000059604645, false, 0.1000000014901161, 2, 0.1500000059604645, 0, 0.5, -0.1000000014901161, 0.8999999761581421, 0, 0.300000011920929, 0.75, 45000, 67141888, 4194336, \"long\", \"small\", 14 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('467', '469', 'Bell', '47', '1946', '100000', '275', '2014-04-17 02:39:24', '705', '2014-08-20 19:30:14', '1622', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('468', '559', 'Toyota', 'Supra JZA80 ', '1998', '27500', '45', '2014-04-17 04:39:03', '860', '2015-01-20 08:43:37', '10139', '\n', '[ [ 1500, 3600, 1.8500000238418579, [ 0, 0, -0.05000000074505806 ], 75, 0.85000002384185791, 0.80000001192092896, 0.5, 5, 187, 10.699999809265137, 10, \"rwd\", \"petrol\", 7, 0.60000002384185791, false, 30, 1.1000000238418579, 0.10000000149011612, 0, 0.2800000011920929, -0.10000000149011612, 0.5, 0.30000001192092896, 0.25, 0.60000002384185791, 35000, 3221235712, 67108864, \"small\", \"small\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('469', '457', 'Golf', 'Caddy', '2013', '2500', '20', '2014-04-17 05:06:32', '65', '2014-06-09 07:24:13', '2432', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('470', '463', 'Harley-Davidson', 'V-Rod Muscle', '2014', '14500', '50', '2014-04-17 22:12:19', '705', '2014-08-15 19:59:10', '12', '\n', '[ [ 900, 403.299988, 3, [ 0, 0, -0.300000 ], 103, 1.800000, 0.820000, 0.490000, 4, 190, 20, 10, \"rwd\", \"petrol\", 10, 0.600000, false, 35, 0.650000, 0.200000, 0, 0.090000, -0.100000, 0.600000, 0, 0, 0.240000, 10000, 16785408, 0, \"small\", \"small\", 6 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('471', '522', 'Suzuki', 'GSX-R750', '1999', '7600', '45', '2014-04-18 02:13:10', '705', '2019-10-11 17:24:10', '1438', '\n', '[ [ 450, 200, 0.100000, [ 0, 0, 0 ], 103, 2, 0.900000, 0.450000, 5, 175, 36, 10, \"rwd\", \"petrol\", 15, 0.500000, false, 35, 0.850000, 0.150000, 0, 0.150000, -0.200000, 0.500000, 0, 0, 0.150000, 10000, 16785408, 2, \"small\", \"small\", 4 ] ]', '1000', '0', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('472', '522', 'Yamaha', 'YZF-R1', '1999', '10335', '45', '2014-04-18 02:20:11', '705', '2019-10-11 17:23:50', '1438', '\n', '[ [ 450, 200, 0.100000, [ 0, 0, 0 ], 103, 2, 0.900000, 0.480000, 5, 165, 31, 5, \"rwd\", \"petrol\", 15, 0.500000, false, 35, 0.850000, 0.150000, 0, 0.150000, -0.200000, 0.500000, 0, 0, 0.150000, 10000, 16785408, 2, \"small\", \"small\", 4 ] ]', '1000', '0', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('473', '579', 'Jeep', 'Grand Cherokee', '2013', '142000', '190', '2014-04-19 06:42:09', '107', '2020-05-01 19:01:04', '2545', '\n', '[ [ 2500, 6000, 2.5, [ 0, 0, -0.2000000029802322 ], 80, 0.6200000047683716, 0.8899999856948853, 0.5, 5, 180, 14, 9, \"awd\", \"petrol\", 7, 0.4000000059604645, false, 35, 1, 0.05000000074505806, 0, 0.449999988079071, -0.2099999934434891, 0.4000000059604645, 0.300000011920929, 0.4399999976158142, 0.3499999940395355, 40000, 32, 17412, \"long\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('474', '560', 'Dodge', 'Charger SRT-8 Police Pursuit Package', '2014', '55000', '50', '2014-04-19 11:08:07', '1367', '2020-06-03 20:44:48', '4341', '\n', '[ [ 3000, 3400, 1.600000023841858, [ 0, 0.300000011920929, 0.009999999776482582 ], 75, 1.100000023841858, 0.800000011920929, 0.5, 5, 250, 38.79999923706055, 30, \"awd\", \"petrol\", 50, 0.6000000238418579, false, 35, 1, 0.2000000029802322, 0, 0.2800000011920929, -0.1899999976158142, 0.6000000238418579, 0.300000011920929, 0.25, 0.6000000238418579, 35000, 10240, 67108866, \"small\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('476', '421', 'Mercedes-Benz', 'E550', '2012', '50100', '50', '2014-04-19 16:33:11', '65', '2014-11-08 10:22:23', '1622', '\n', '[ [ 1850, 5000, 2.2000000476837158, [ 0, 0, -0.10000000149011612 ], 75, 0.89999997615814209, 0.64999997615814209, 0.51999998092651367, 5, 180, 9.5, 10, \"rwd\", \"petrol\", 7.5, 0.60000002384185791, false, 30, 1, 0.20000000298023224, 0, 0.27000001072883606, -0.20000000298023224, 0.5, 0.34999999403953552, 0.23999999463558197, 0.60000002384185791, 18000, 0, 272629760, \"small\", \"small\", 0 ] ]', '1000', '1', '1', '0');
INSERT INTO `vehicles_shop` VALUES ('477', '428', 'Mercedes-Benz', 'Vario', '2003', '85000', '120', '2014-04-19 16:53:56', '65', '2014-05-23 02:41:44', '1622', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('478', '424', 'Dune', 'Buggy', '2013', '10500', '50', '2014-04-20 18:55:55', '705', '0000-00-00 00:00:00', '0', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('480', '429', 'BMW', 'Z4 SDrive35is', '2014', '160000', '85', '2014-04-21 10:02:41', '860', '2020-04-30 21:55:27', '744', '\n', '[ [ 1400, 3000, 2, [ 0, 0, -0.20000000298023224 ], 70, 0.75, 0.88999998569488525, 0.5, 5, 170, 13.199999809265137, 10, \"rwd\", \"petrol\", 8, 0.5, false, 34, 1.6000000238418579, 0.10000000149011612, 5, 0.30000001192092896, -0.10000000149011612, 0.5, 0.30000001192092896, 0.15000000596046448, 0.49000000953674316, 45000, 8196, 2097152, \"small\", \"small\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('481', '439', 'BMW', 'E87 1M Coupe', '2012', '72000', '60', '2014-04-21 16:21:59', '178', '2015-01-10 08:47:09', '99', '\n', null, '1000', '0', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('482', '531', 'Ferguson', 'TE20', '1952', '16000', '10', '2014-04-22 01:30:42', '178', '2014-08-23 02:32:45', '12', '\n', null, '1000', '1', '5', '0');
INSERT INTO `vehicles_shop` VALUES ('483', '537', 'Alco', 'RS2-Standard DC', '1981', '100000', '0', '2014-04-24 23:22:41', '178', '2014-09-14 08:14:21', '1695', '\n', '[ [ 5500, 65000, 3, [ 0, 0, 0 ], 90, 0.57999998331069946, 0.80000001192092896, 0.5, 4, 110, 8, 20, \"rwd\", \"diesel\", 3.1700000762939453, 0.40000000596046448, false, 30, 1.3999999761581421, 0.059999998658895493, 0, 0.44999998807907104, 0, 0.60000002384185791, 0, 0.44999998807907104, 0.20000000298023224, 5000, 8, 512, \"long\", \"small\", 2 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('484', '402', 'Dodge', 'Charger LX', '2011', '56500', '55', '2014-04-26 06:20:28', '705', '2014-04-26 15:29:08', '705', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('485', '402', 'Dodge', 'Challenger SRTÂ©', '2014', '130250', '35', '2014-04-26 15:10:50', '705', '2020-04-25 23:41:33', '744', '\n', '[ [ 1500, 4000, 1.7000000476837158, [ 0, 0, -0.10000000149011612 ], 85, 0.69999998807907104, 0.89999997615814209, 0.5, 5, 185, 13, 5, \"rwd\", \"petrol\", 11, 0.40000000596046448, false, 30, 1.1000000238418579, 0.11999999731779099, 0, 0.2800000011920929, -0.20000000298023224, 0.5, 0.40000000596046448, 0.25, 0.5, 35000, 10240, 270532608, \"small\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('486', '477', 'Ford', 'Probe GT', '1996', '7000', '50', '2014-04-26 18:05:36', '705', '2015-01-20 07:38:30', '10139', '\n', '[ [ 1200, 2979.699951171875, 2.5, [ 0, 0, -0.10000000149011612 ], 70, 0.80000001192092896, 0.80000001192092896, 0.60000002384185791, 5, 132, 7, 10, \"fwd\", \"petrol\", 6, 0.60000002384185791, false, 30, 1, 0.20000000298023224, 0, 0.31000000238418579, -0.20000000298023224, 0.5, 0.30000001192092896, 0.23999999463558197, 0.60000002384185791, 45000, 0, 12582912, \"small\", \"small\", 0 ] ]', '1000', '1', '2', '0');
INSERT INTO `vehicles_shop` VALUES ('487', '475', 'Pontiac', 'GTO', '1970', '34995', '50', '2014-04-26 18:07:16', '705', '2014-06-18 23:17:57', '1107', '\n', '[ [ 1700, 4000, 2, [ 0, 0.100000, 0 ], 70, 0.700000, 0.800000, 0.530000, 4, 160, 11, 10, \"rwd\", \"petrol\", 8, 0.500000, false, 35, 1.300000, 0.080000, 5, 0.300000, -0.200000, 0.500000, 0.250000, 0.250000, 0.520000, 19000, 0, 268435462, \"small\", \"small\", 0 ] ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('488', '426', 'Chrysler', '200', '2012', '17500', '50', '2014-04-26 18:08:04', '705', '2014-04-26 18:27:15', '705', '\n', '[ [ 1600, 3921.300049, 1.800000, [ 0, -0.400000, 0 ], 75, 0.750000, 0.850000, 0.520000, 5, 160, 8, 10, \"rwd\", \"petrol\", 10, 0.500000, false, 35, 1.300000, 0.120000, 0, 0.280000, -0.100000, 0.400000, 0, 0.200000, 0.240000, 25000, 1073741824, 270532616, \"long\", \"small\", 0 ] ]', '1000', '1', '2', '0');
INSERT INTO `vehicles_shop` VALUES ('489', '429', 'Dodge', 'Viper SRTÂ©', '2014', '135500', '65', '2014-04-26 18:09:03', '705', '2014-10-17 06:19:43', '1107', '\n', '[ [ 1400, 3000, 1.6000000238418579, [ 0, 0, -0.20000000298023224 ], 70, 0.75, 0.88999998569488525, 0.5, 5, 200, 16, 10, \"rwd\", \"petrol\", 8, 0.5, false, 34, 1.6000000238418579, 0.10000000149011612, 5, 0.30000001192092896, -0.10000000149011612, 0.5, 0.30000001192092896, 0.15000000596046448, 0.49000000953674316, 45000, 8196, 2097152, \"small\", \"small\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('490', '603', 'Pontiac', 'Firebird Trans Am', '1981', '28500', '50', '2014-04-26 18:10:08', '705', '2014-06-18 23:56:11', '1107', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('491', '470', 'Hummer', 'H3', '2007', '35000', '50', '2014-04-26 18:11:15', '705', '2014-08-07 15:10:09', '1115', '\n', '[ [ 2800, 7968.700195, 2.400000, [ 0, 0, -0.150000 ], 80, 0.800000, 0.850000, 0.500000, 5, 180, 10.500000, 15, \"awd\", \"petrol\", 8, 0.500000, false, 40, 1.500000, 0.060000, 4, 0.350000, -0.300000, 0.500000, 0, 0.280000, 0.250000, 40000, 8, 3145728, \"long\", \"small\", 0 ] ]', '1000', '1', '2', '0');
INSERT INTO `vehicles_shop` VALUES ('492', '529', 'Dodge', 'Dynasty', '1993', '6000', '50', '2014-04-26 18:11:56', '705', '2014-06-19 23:40:12', '1107', '\n', '[ { \"1\": 1800, \"2\": 4350, \"3\": 2, \"4\": [ 0, 0, 0 ], \"5\": 70, \"6\": 0.700000, \"7\": 0.800000, \"8\": 0.520000, \"9\": 4, \"10\": 160, \"11\": 7.500000, \"12\": 15, \"13\": \"rwd\", \"14\": \"petrol\", \"15\": 5.400000, \"16\": 0.600000, \"17\": false, \"18\": 30, \"19\": 1.100000, \"20\": 0.150000, \"21\": 0, \"22\": 0.320000, \"23\": -0.100000, \"24\": 0.500000, \"25\": 0, \"26\": 0.260000, \"27\": 0.540000, \"28\": 19000, \"29\": 1073741824, \"30\": 0, \"31\": \"long\", \"33\": 0 } ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('493', '541', 'Ford', 'GT', '2006', '254750', '185', '2014-04-26 18:12:38', '705', '2015-02-06 07:35:44', '1107', '\n', '[ [ 1200, 2500, 1, [ 0, -0.15000000596046448, -0.20000000298023224 ], 70, 0.80000001192092896, 0.89999997615814209, 0.47999998927116394, 5, 185, 12, 8, \"rwd\", \"petrol\", 7, 0.60000002384185791, false, 35, 1, 0.12999999523162842, 5, 0.25, -0.10000000149011612, 0.40000000596046448, 0.30000001192092896, 0.15000000596046448, 0.54000002145767212, 105000, 3221233664, 2113536, \"long\", \"long\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('494', '610', 'Ferguson', 'Trailer', '1953', '1000', '1', '2014-04-26 20:50:27', '178', '0000-00-00 00:00:00', '0', '\n', null, '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('495', '415', 'Chevrolet', 'Corvette C7', '2014', '280000', '65', '2014-04-27 01:08:49', '705', '2019-10-23 04:14:38', '1438', '\n', '[ [ 1200, 3000, 1.600000, [ 0, -0.200000, -0.200000 ], 70, 0.850000, 0.900000, 0.500000, 5, 182, 16, 10, \"rwd\", \"petrol\", 11.100000, 0.500000, false, 35, 0.800000, 0.200000, 0, 0.100000, -0.100000, 0.500000, 0.600000, 0.400000, 0.540000, 105000, 3221233664.000000, 2129920, \"long\", \"long\", 1 ] ]', '1000', '1', '1', '0');
INSERT INTO `vehicles_shop` VALUES ('497', '579', 'Chevrolet', 'Tahoe', '2014', '50000', '55', '2014-04-27 03:08:49', '705', '2015-02-02 09:00:52', '1107', '\n', '[ [ 2100, 6000, 1.7999999523162842, [ 0, -0.20000000298023224, -0.5 ], 80, 0.75, 0.88999998569488525, 0.5, 5, 200, 12, 25, \"awd\", \"petrol\", 7, 0.40000000596046448, false, 35, 1.25, 0.05000000074505806, 0, 0.44999998807907104, -0.10000000149011612, 0.40000000596046448, 0.30000001192092896, 0.43999999761581421, 0.34999999403953552, 40000, 32, 17412, \"long\", \"small\", 0 ] ]', '1000', '1', '2', '0');
INSERT INTO `vehicles_shop` VALUES ('499', '576', 'Oldsmobile', 'Super 88', '1958', '24000', '45', '2014-04-27 12:42:18', '705', '2014-07-16 21:51:56', '1115', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('500', '402', 'Chevrolet', 'Camaro ZL1', '2014', '67000', '500', '2014-04-27 17:59:38', '705', '2020-03-13 16:09:21', '745', '\n', '[ [ 1500, 4000, 1.2000000476837158, [ 0, 0.10000000149011612, -0.10000000149011612 ], 85, 0.80000001192092896, 0.89999997615814209, 0.50199997425079346, 5, 200, 13, 5, \"rwd\", \"petrol\", 11, 0.40000000596046448, false, 30, 1.2000000476837158, 0.11999999731779099, 0, 0.2800000011920929, -0.20000000298023224, 0.5, 0.40000000596046448, 0.25, 0.5, 35000, 10240, 270532608, \"small\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('501', '507', 'BMW', 'E65 745Li', '2005', '35000', '55', '2014-04-27 21:38:33', '705', '2019-10-23 01:36:28', '1438', '\n', '[ [ 2200, 5000, 0.1000000014901161, [ 0, 0.1000000014901161, -0.1000000014901161 ], 75, 0.800000011920929, 0.800000011920929, 0.4799999892711639, 5, 130, 10, 10, \"rwd\", \"petrol\", 6, 0.6000000238418579, false, 30, 1, 0.2000000029802322, 0, 0.3499999940395355, -0.2000000029802322, 0.5, 0.300000011920929, 0.2000000029802322, 0.300000011920929, 35000, 1073741824, 272629760, \"long\", \"small\", 0 ] ]', '1000', '1', '2', '0');
INSERT INTO `vehicles_shop` VALUES ('502', '507', 'BMW', 'E66 760Li', '2007', '40000', '55', '2014-04-27 21:39:14', '705', '2014-09-28 23:07:54', '99', '\n', '[ [ 2200, 5000, 1.7999999523162842, [ 0, 0.10000000149011612, -0.10000000149011612 ], 75, 0.69999998807907104, 0.80000001192092896, 0.46000000834465027, 5, 165, 10, 30, \"rwd\", \"petrol\", 6, 0.60000002384185791, false, 30, 1, 0.10000000149011612, 0, 0.34999999403953552, -0.15000000596046448, 0.5, 0.30000001192092896, 0.20000000298023224, 0.30000001192092896, 35000, 1073741824, 272629760, \"long\", \"small\", 0 ] ]', '1000', '1', '2', '0');
INSERT INTO `vehicles_shop` VALUES ('503', '579', 'Cadillac', 'Escalade Premium', '2014', '72500', '55', '2014-04-27 21:40:00', '705', '2014-08-16 14:26:33', '1115', '\n', '[ [ 2500, 6000, 2, [ 0, 0, -0.200000 ], 80, 0.620000, 0.890000, 0.500000, 5, 160, 12.500000, 25, \"awd\", \"petrol\", 7, 0.400000, false, 35, 1, 0.050000, 0, 0.450000, -0.200000, 0.400000, 0.300000, 0.440000, 0.350000, 40000, 32, 17412, \"long\", \"small\", 0 ] ]', '1000', '1', '1', '0');
INSERT INTO `vehicles_shop` VALUES ('504', '421', 'Cadillac', 'DTS', '2007', '40250', '50', '2014-04-27 21:41:04', '705', '2014-04-29 00:52:58', '860', '\n', null, '1000', '1', '2', '0');
INSERT INTO `vehicles_shop` VALUES ('505', '439', 'Ford', 'Mustang', '1964', '39000', '50', '2014-04-27 21:41:42', '705', '2019-11-15 17:12:43', '1438', '\n', null, '1000', '1', '1', '0');
INSERT INTO `vehicles_shop` VALUES ('506', '500', 'Jeep', 'Wrangler', '1990', '18500', '45', '2014-04-27 22:23:53', '705', '2014-06-19 01:22:30', '1107', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('507', '467', 'Dodge', 'Coronet', '1958', '17500', '45', '2014-04-28 01:33:15', '705', '2014-06-18 01:43:21', '1737', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('508', '561', 'Dodge', 'Stratus', '1993', '12400', '45', '2014-04-28 01:34:04', '705', '2014-06-19 23:38:14', '1107', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('509', '603', 'Pontiac', 'Firebird Trans Am', '1979', '25900', '45', '2014-04-28 01:35:39', '705', '2014-06-18 23:51:57', '1107', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('510', '507', 'Mercedes-Benz', 'CLS63 AMG', '2010', '49000', '65', '2014-04-28 01:44:54', '705', '2014-06-08 10:02:17', '2432', '\n', '[ [ 2200, 5000, 1.800000, [ 0, 0.100000, -0.100000 ], 75, 0.700000, 0.800000, 0.460000, 5, 200, 14, 10, \"rwd\", \"petrol\", 6, 0.600000, false, 30, 1, 0.100000, 0, 0.350000, -0.200000, 0.500000, 0.300000, 0.200000, 0.300000, 35000, 1073741824, 272629760, \"long\", \"small\", 0 ] ]', '1000', '1', '2', '0');
INSERT INTO `vehicles_shop` VALUES ('511', '603', 'Chevrolet', 'Corvette Stingray', '1968', '43500', '50', '2014-04-28 01:52:04', '705', '2014-08-23 14:27:14', '1115', '\n', '[ [ 1500, 4000, 1.700000, [ 0, 0.400000, -0.150000 ], 85, 0.800000, 0.900000, 0.500000, 5, 200, 12, 5, \"rwd\", \"petrol\", 6, 0.600000, false, 30, 1.250000, 0.080000, 0, 0.280000, -0.200000, 0.600000, 0.400000, 0.250000, 0.500000, 35000, 10240, 2097152, \"small\", \"small\", 0 ] ]', '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('512', '500', 'Jeep', 'Wrangler Rubicon X', '2014', '35500', '50', '2014-04-28 07:33:40', '705', '2014-12-23 04:03:09', '1622', '\n', '[ [ 1900, 1900, 1.6000000238418579, [ 0, -0.55000001192092896, -0.40000000596046448 ], 85, 1.2000000476837158, 0.80000001192092896, 0.5, 5, 170, 10, 8, \"awd\", \"diesel\", 8, 0.40000000596046448, false, 35, 1.2000000476837158, 0.20000000298023224, 0, 0.31999999284744263, -0.10000000149011612, 0.30000001192092896, 0.40000000596046448, 0.18000000715255737, 0.30000001192092896, 25000, 2099264, 0, \"long\", \"small\", 0 ] ]', '1000', '1', '1', '0');
INSERT INTO `vehicles_shop` VALUES ('514', '463', 'Harley-Davidson', 'Ironhead DP Customs', '1973', '45355', '25', '2014-04-28 22:31:24', '705', '2014-11-28 12:35:29', '1622', '\n', '[ [ 800, 403.29998779296875, 3, [ 0, 0.10000000149011612, -0.30000001192092896 ], 103, 1.7999999523162842, 0.81999999284744263, 0.49000000953674316, 4, 175, 30, 10, \"rwd\", \"petrol\", 10, 0.60000002384185791, false, 35, 0.64999997615814209, 0.20000000298023224, 0, 0.090000003576278687, -0.10000000149011612, 0.60000002384185791, 0, 0, 0.23999999463558197, 10000, 16785408, 0, \"small\", \"small\", 6 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('515', '561', 'Chevrolet', 'Optra LT', '2007', '14750', '45', '2014-04-28 23:04:37', '705', '0000-00-00 00:00:00', '0', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('523', '560', 'Chevrolet', 'Lumina SS', '2010', '27540', '50', '2014-04-28 23:30:00', '705', '2014-08-04 14:12:38', '1115', '\n', null, '1000', '1', '2', '0');
INSERT INTO `vehicles_shop` VALUES ('524', '475', 'Chevrolet', 'Camaro SS', '1972', '26900', '50', '2014-04-28 23:38:21', '705', '2014-06-18 23:24:30', '1107', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('525', '411', 'Saleen', 'S7 Twin Turbo', '2005', '437950', '120', '2014-04-28 23:49:20', '705', '2015-01-07 11:52:45', '9736', '\n', '[ [ 1400, 2725.300048828125, 1.2000000476837158, [ 0, -0.30000001192092896, -0.25 ], 70, 1, 0.80000001192092896, 0.44999998807907104, 5, 270, 23, 20, \"rwd\", \"petrol\", 7, 0.30000001192092896, false, 40, 1.2000000476837158, 0.18999999761581421, 0, 0.25, -0.10000000149011612, 0.40000000596046448, 0.40000000596046448, 0.37000000476837158, 0.72000002861022949, 95000, 1073750020, 12599296, \"small\", \"small\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('526', '412', 'Chevrolet', 'Biscayne', '1960', '29500', '50', '2014-04-28 23:56:24', '705', '2014-07-16 21:54:50', '1115', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('527', '506', 'Audi', 'R8 (V8 4.2L) Spyder', '2007', '130241', '190', '2014-04-28 23:56:46', '860', '2015-02-05 03:58:14', '120', '\n', '[ [ 1400, 2800, 1.6000000238418579, [ 0, -0.20000000298023224, -0.23999999463558197 ], 70, 0.94999998807907104, 0.86000001430511475, 0.44999998807907104, 5, 195, 14, 8, \"awd\", \"petrol\", 8, 0.5, false, 35, 1.2999999523162842, 0.15000000596046448, 0, 0.25, -0.039999999105930328, 0.5, 0.30000001192092896, 0.40000000596046448, 0.54000002145767212, 105000, 1073750020, 2129920, \"long\", \"long\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('528', '506', 'Audi', 'R8 (V8 4.2L)', '2007', '125401', '190', '2014-04-29 00:00:20', '860', '2015-02-05 03:59:51', '120', '\n', '[ [ 1400, 2800, 2, [ 0, -0.20000000298023224, -0.23999999463558197 ], 70, 0.94999998807907104, 0.86000001430511475, 0.44999998807907104, 5, 200, 14, 8, \"awd\", \"petrol\", 8, 0.5, false, 35, 1, 0.20000000298023224, 0, 0.25, -0.10000000149011612, 0.5, 0.30000001192092896, 0.40000000596046448, 0.54000002145767212, 105000, 1073750020, 2129920, \"long\", \"long\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('529', '506', 'Audi', 'A5', '2017', '750000', '100', '2014-04-29 00:01:09', '860', '2021-04-11 16:39:02', '17927', '\n', '[ [ 1400, 2800, 1.600000023841858, [ 0, -0.2000000029802322, -0.239999994635582 ], 70, 1.100000023841858, 0.8600000143051147, 0.5, 5, 207, 17, 8, \"awd\", \"petrol\", 8.5, 0.6000000238418579, false, 30, 1, 0.2000000029802322, 0, 0.25, -0.1000000014901161, 0.5, 0.300000011920929, 0.4000000059604645, 0.5400000214576721, 105000, 1073750020, 2129920, \"long\", \"long\", 1 ] ]', '1000', '1', '0', null);
INSERT INTO `vehicles_shop` VALUES ('531', '491', 'Mercury', 'Cougar XR7', '1978', '12650', '50', '2014-04-29 00:17:21', '705', '2014-11-28 12:38:16', '1622', '\n', '[ [ 1700, 3435.39990234375, 2, [ 0, 0, -0.10000000149011612 ], 70, 0.69999998807907104, 0.86000001430511475, 0.5, 4, 160, 7.1999998092651367, 15, \"rwd\", \"petrol\", 7, 0.5, false, 32, 0.80000001192092896, 0.10000000149011612, 0, 0.31000000238418579, -0.20000000298023224, 0.5, 0.5, 0.25999999046325684, 0.85000002384185791, 9000, 1073741824, 268435456, \"long\", \"long\", 0 ] ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('532', '561', 'Saturn', 'SL1 Wagon', '1999', '18450', '50', '2014-04-29 00:18:38', '705', '2014-06-19 23:59:21', '1107', '\n', null, '1000', '1', '2', '0');
INSERT INTO `vehicles_shop` VALUES ('533', '413', 'Ford', 'Econoline', '1995', '18500', '50', '2014-04-29 00:21:35', '705', '0000-00-00 00:00:00', '0', '\n', null, '1000', '1', '5', '0');
INSERT INTO `vehicles_shop` VALUES ('534', '585', 'TofaÅŸ', 'Åžahin 5Vites', '1993', '17900', '50', '2014-04-29 00:22:11', '705', '2021-03-27 10:56:15', '17826', '\n', null, '1000', '1', '0', null);
INSERT INTO `vehicles_shop` VALUES ('535', '463', 'Harley-Davidson', 'V-Rod Night Rod Special', '2013', '17500', '45', '2014-04-29 15:42:51', '705', '2019-10-20 17:04:49', '1438', '\n', '[ [ 900, 403.2999877929688, 3, [ 0, 0.1000000014901161, -0.4000000059604645 ], 103, 1.899999976158142, 0.8199999928474426, 0.4900000095367432, 4, 210, 25, 20, \"rwd\", \"petrol\", 10, 0.6000000238418579, false, 35, 0.6499999761581421, 0.2000000029802322, 0, 0.09000000357627869, -0.1099999994039536, 0.6000000238418579, 0, 0, 0.239999994635582, 10000, 16785408, 0, \"small\", \"small\", 6 ] ]', '1000', '1', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('536', '463', 'Harley-Davidson', 'FXSB Softail Breakout', '2014', '18550', '35', '2014-04-29 20:26:44', '705', '2014-11-16 00:18:27', '1260', '\n', '[ [ 900, 403.29998779296875, 3, [ 0, 0.10000000149011612, -0.40000000596046448 ], 103, 1.8999999761581421, 0.81999999284744263, 0.49000000953674316, 4, 170, 35, 10, \"rwd\", \"petrol\", 10, 0.60000002384185791, false, 35, 0.64999997615814209, 0.20000000298023224, 0, 0.090000003576278687, -0.10000000149011612, 0.60000002384185791, 0, 0, 0.23999999463558197, 10000, 16785408, 0, \"small\", \"small\", 6 ] ]', '1000', '1', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('537', '532', 'New Holland', '8060', '1983', '12250', '85', '2014-04-29 22:17:49', '705', '2014-04-29 22:24:16', '705', '\n', '[ [ 8500, 48804.199219, 5, [ 0, 0.300000, -0.200000 ], 90, 0.880000, 0.700000, 0.460000, 5, 60, 10, 80, \"awd\", \"diesel\", 10, 0.400000, false, 27, 1.200000, 0.100000, 0, 0.470000, -0.100000, 0.500000, 0, 1.200000, 0.430000, 10000, 1228808, 32, \"long\", \"small\", 20 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('538', '579', 'Porsche', 'Macan S', '2014', '72000', '65', '2014-04-29 22:38:49', '705', '2014-06-09 07:35:32', '2432', '\n', '[ [ 2500, 6000, 1.800000, [ 0, -0.200000, -0.300000 ], 80, 0.700000, 0.890000, 0.500000, 5, 173, 12, 7, \"awd\", \"petrol\", 7, 0.400000, false, 35, 1, 0.050000, 0, 0.450000, -0.200000, 0.400000, 0.300000, 0.440000, 0.350000, 40000, 32, 17412, \"long\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('539', '599', 'Chevrolet', 'Tahoe PPV', '2014', '44000', '150', '2014-04-30 07:04:06', '1367', '2014-12-03 19:12:56', '9736', '\n', '[ [ 3000, 5500, 1, [ 0, 0, -0.25 ], 85, 1, 0.85000002384185791, 0.5, 5, 240, 16, 9, \"awd\", \"diesel\", 6.1999998092651367, 0.5, false, 46, 0.60000002384185791, 0.20000000298023224, 1, 0.30000001192092896, -0.10000000149011612, 0.5, 0.25, 0.27000001072883606, 0.23000000417232513, 25000, 2637856, 3180544, \"long\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('540', '415', 'Lamborghini', 'Gallardo', '2004', '142355', '100', '2014-05-01 06:27:03', '860', '2015-01-17 20:04:00', '1260', '\n', '[ [ 1400, 3000, 1.7999999523162842, [ 0, -0.20000000298023224, -0.25 ], 70, 0.89999997615814209, 0.89999997615814209, 0.5, 5, 220, 20, 5, \"awd\", \"petrol\", 7, 0.5, false, 35, 0.89999997615814209, 0.20000000298023224, 0, 0.10000000149011612, -0.0099999997764825821, 0.5, 0.60000002384185791, 0.40000000596046448, 0.54000002145767212, 105000, 3221233664, 2129920, \"long\", \"long\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('542', '489', 'Chevrolet', 'Tahoe PPV', '2014', '44000', '250', '2014-05-02 03:14:56', '1367', '2014-05-02 03:17:52', '1367', '\n', '[ [ 2500, 7604.200195, 3, [ 0, 0, -0.120000 ], 80, 1, 0.850000, 0.520000, 5, 225, 17, 17, \"rwd\", \"petrol\", 7, 0.400000, false, 45, 0.800000, 0.200000, 0, 0.450000, -0.200000, 0.500000, 0.300000, 0.440000, 0.350000, 40000, 16416, 1048580, \"long\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('543', '463', 'Harley-Davidson', 'CVO Breakout', '2014', '27995', '20', '2014-05-05 19:47:02', '141', '2014-08-15 19:59:25', '12', '\n', '[ [ 700, 403.299988, 4, [ 0, 0.100000, 0 ], 103, 1.500000, 0.820000, 0.510000, 4, 150, 20, 10, \"rwd\", \"petrol\", 10, 0.600000, false, 35, 0.650000, 0.200000, 0, 0.090000, -0.100000, 0.600000, 0, 0, 0.240000, 10000, 16785408, 0, \"small\", \"small\", 6 ] ]', '1000', '1', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('544', '463', 'Harley-Davidson', 'Forty Eight', '2013', '11849', '20', '2014-05-05 22:31:47', '141', '2014-08-15 19:58:52', '12', '\n', '[ [ 750, 403.299988, 4, [ 0, 0.100000, 0 ], 103, 1.200000, 0.820000, 0.510000, 4, 135, 20, 10, \"rwd\", \"petrol\", 10, 0.600000, false, 35, 0.650000, 0.200000, 0, 0.090000, -0.100000, 0.600000, 0, 0, 0.240000, 10000, 16785408, 0, \"small\", \"small\", 6 ] ]', '1000', '1', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('545', '463', 'Harley-Davidson', 'Dyna Fat Bob', '2014', '17255', '20', '2014-05-06 00:15:02', '141', '2014-08-15 19:58:44', '12', '\n', '[ [ 750, 403.299988, 4, [ 0, 0.100000, 0 ], 103, 1.350000, 0.820000, 0.510000, 4, 140, 23, 10, \"rwd\", \"petrol\", 10, 0.600000, false, 35, 0.650000, 0.200000, 0, 0.090000, -0.100000, 0.600000, 0, 0, 0.240000, 10000, 16785408, 0, \"small\", \"small\", 6 ] ]', '1000', '1', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('546', '555', 'TVR', 'Chimaera (5.0L V8)', '2003', '32400', '50', '2014-05-06 00:37:43', '141', '2014-05-07 05:54:53', '1737', '\n', '[ [ 1060, 3500, 3, [ 0, 0.050000, -0.200000 ], 75, 0.700000, 0.850000, 0.500000, 5, 165, 18, 10, \"rwd\", \"petrol\", 8, 0.400000, false, 30, 0.650000, 0.070000, 0, 0.150000, -0.100000, 0.500000, 0.300000, 0.250000, 0.600000, 35000, 1076373508, 0, \"small\", \"small\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('547', '589', 'Smart', 'For Two Passion Cabriolet', '2014', '16990', '20', '2014-05-06 01:31:08', '141', '2014-05-06 06:28:46', '1737', '\n', '[ [ 650, 3000, 2.800000, [ 0, 0, 0 ], 80, 0.900000, 0.900000, 0.490000, 5, 100, 11, 10, \"rwd\", \"petrol\", 11, 0.400000, false, 30, 1.700000, 0.100000, 0, 0.280000, -0.100000, 0.500000, 0, 0.250000, 0.500000, 35000, 8192, 12582912, \"small\", \"small\", 0 ] ]', '1000', '1', '2', '0');
INSERT INTO `vehicles_shop` VALUES ('548', '429', 'BMW', 'E64 M6 Convertible', '2010', '72400', '80', '2014-05-06 01:52:48', '141', '2014-12-02 11:30:09', '9736', 'Raised the price due to the Convertible version being slightly more expensive than the Coupe, whereas the Coupe is already 15 grand more expensive than previous price of Convertible -Lyricist.\n', '[ [ 2000, 3000, 2, [ 0, -0.20000000298023224, -0.20000000298023224 ], 70, 0.80000001192092896, 0.88999998569488525, 0.5, 5, 170, 17, 11, \"rwd\", \"petrol\", 8, 0.5, false, 34, 1.2999999523162842, 0.20000000298023224, 5, 0.30000001192092896, -0.10000000149011612, 0.5, 0.30000001192092896, 0.15000000596046448, 0.49000000953674316, 45000, 8196, 2097152, \"small\", \"small\", 1 ] ]', '1000', '1', '1', '0');
INSERT INTO `vehicles_shop` VALUES ('549', '457', 'Smart', 'For Two Passion', '2008', '7299', '15', '2014-05-06 06:20:54', '141', '2014-05-06 23:39:20', '65', '\n', '[ [ 1000, 1354.199951, 4, [ 0, 0, -0.100000 ], 70, 0.550000, 0.850000, 0.500000, 3, 100, 10, 10, \"awd\", \"electric\", 13, 0.500000, false, 30, 2.250000, 0.090000, 0, 0.280000, -0.150000, 0.500000, 0, 0.260000, 0.500000, 9000, 4352, 34820, \"small\", \"small\", 0 ] ]', '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('550', '415', 'BMW', 'E64 M6 ', '2010', '69502', '80', '2014-05-07 00:54:05', '141', '2015-01-10 08:43:17', '99', '\n', '[ [ 1710, 3000, 2, [ 0, -0.20000000298023224, -0.20000000298023224 ], 70, 0.69999998807907104, 0.89999997615814209, 0.5, 5, 200, 15, 10, \"rwd\", \"petrol\", 11.100000381469727, 0.5, false, 30, 1.7999999523162842, 0.20000000298023224, 0, 0.10000000149011612, -0.10000000149011612, 0.5, 0.60000002384185791, 0.40000000596046448, 0.54000002145767212, 105000, 3221233664, 2129920, \"long\", \"long\", 1 ] ]', '1000', '1', '1', '0');
INSERT INTO `vehicles_shop` VALUES ('551', '429', 'BMW', 'E64 M6 Cabriolet', '2010', '172320', '480', '2014-05-07 05:24:42', '1737', '2020-03-13 16:14:28', '745', '\n', '[ [ 1400, 3000, 2, [ 0, 0, -0.200000 ], 70, 0.750000, 0.890000, 0.500000, 5, 192, 13.200000, 10, \"rwd\", \"petrol\", 8, 0.500000, false, 34, 1.600000, 0.100000, 5, 0.300000, -0.200000, 0.500000, 0.300000, 0.150000, 0.490000, 45000, 8196, 2097152, \"small\", \"small\", 1 ] ]', '1000', '1', '1', '0');
INSERT INTO `vehicles_shop` VALUES ('552', '582', 'Ford', 'Econoline', '1994', '18250', '45', '2014-05-07 22:22:53', '860', '2014-06-19 23:47:44', '1107', '\n', null, '1000', '1', '5', '0');
INSERT INTO `vehicles_shop` VALUES ('553', '415', 'Jaguar', 'F-Type Coupe R', '2014', '105000', '60', '2014-05-08 18:47:00', '1737', '2014-05-08 19:11:11', '1737', '\n', '[ [ 1200, 3000, 2, [ 0, -0.200000, -0.200000 ], 70, 0.850000, 0.900000, 0.500000, 5, 186, 16, 10, \"rwd\", \"petrol\", 11.100000, 0.500000, false, 34, 0.800000, 0.200000, 0, 0.100000, -0.100000, 0.500000, 0.600000, 0.400000, 0.540000, 105000, 3221233664.000000, 2129920, \"long\", \"long\", 1 ] ]', '1000', '1', '1', '0');
INSERT INTO `vehicles_shop` VALUES ('554', '506', 'Aston Martin', 'V12 Vantage S', '2014', '198355', '170', '2014-05-08 19:11:01', '1737', '2015-02-05 03:57:12', '120', '\n', '[ [ 1300, 2800, 1.5, [ 0, -0.30000001192092896, -0.25 ], 70, 1.1000000238418579, 0.86000001430511475, 0.40000000596046448, 5, 206, 20.5, 8, \"rwd\", \"petrol\", 9, 0.60000002384185791, false, 35, 1.5, 0.20000000298023224, 0, 0.25, -0.0099999997764825821, 0.5, 0.30000001192092896, 0.40000000596046448, 0.54000002145767212, 105000, 1073750020, 2129920, \"long\", \"long\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('555', '506', 'Aston Martin', 'Vanquish Volante', '2014', '302355', '190', '2014-05-08 19:23:33', '1737', '2015-02-05 03:57:21', '120', '\n', '[ [ 1400, 2800, 1.800000, [ 0, -0.200000, -0.240000 ], 70, 0.900000, 0.860000, 0.460000, 5, 222, 22, 14, \"rwd\", \"petrol\", 8, 0.500000, false, 35, 1, 0.200000, 0, 0.250000, -0.100000, 0.500000, 0.300000, 0.400000, 0.540000, 105000, 1073750020, 2129920, \"long\", \"long\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('556', '477', 'Pontiac', 'Firebird Trans Am WS6', '2002', '20000', '30', '2014-05-08 19:47:48', '99', '2014-05-08 20:31:57', '99', '\n', '[ [ 1400, 2979.699951, 2, [ 0, -0.100000, -0.150000 ], 70, 0.800000, 0.800000, 0.530000, 5, 180, 12, 8, \"rwd\", \"petrol\", 11.100000, 0.600000, false, 30, 1.200000, 0.200000, 0, 0.310000, -0.200000, 0.500000, 0.300000, 0.240000, 0.600000, 45000, 0, 12582912, \"small\", \"small\", 0 ] ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('557', '506', 'Mercedes-Benz', 'SL65 AMG Roadster', '2013', '165500', '60', '2014-05-08 20:20:00', '99', '2015-01-20 07:31:37', '10139', '\n', '[ [ 2000, 2800, 1.6000000238418579, [ 0, -0.10000000149011612, -0.23999999463558197 ], 70, 0.89999997615814209, 0.86000001430511475, 0.40000000596046448, 5, 224, 13, 5, \"rwd\", \"petrol\", 7.5, 0.60000002384185791, false, 35, 1.5, 0.20000000298023224, 0, 0.25, -0.0099999997764825821, 0.5, 0.30000001192092896, 0.40000000596046448, 0.54000002145767212, 105000, 1073750020, 2129920, \"long\", \"long\", 1 ] ]', '1000', '1', '1', '0');
INSERT INTO `vehicles_shop` VALUES ('558', '415', 'Maserati', 'GranTurismo S', '2015', '320000', '210', '2014-05-09 06:02:22', '1737', '2020-06-06 02:05:29', '744', '\n', '[ [ 1200, 3000, 1.799999952316284, [ 0, -0.2000000029802322, -0.2000000029802322 ], 70, 0.8500000238418579, 0.8999999761581421, 0.4799999892711639, 5, 200, 22, 10, \"rwd\", \"petrol\", 11.10000038146973, 0.5, false, 34, 0.800000011920929, 0.2000000029802322, 0, 0.1000000014901161, -0.1000000014901161, 0.5, 0.6000000238418579, 0.4000000059604645, 0.5400000214576721, 105000, 3221233668, 2129920, \"long\", \"long\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('559', '463', 'Harley-Davidson', 'Iron 883 Sportster', '2014', '9355', '20', '2014-05-10 05:52:53', '1737', '2014-11-16 02:12:27', '1260', '\n', '[ [ 800, 403.29998779296875, 3, [ 0, 0.10000000149011612, 0 ], 103, 1.6000000238418579, 0.81999999284744263, 0.50999999046325684, 4, 162, 20, 10, \"rwd\", \"petrol\", 10, 0.60000002384185791, false, 35, 0.64999997615814209, 0.20000000298023224, 0, 0.090000003576278687, -0.10000000149011612, 0.60000002384185791, 0, 0, 0.23999999463558197, 10000, 16785408, 0, \"small\", \"small\", 6 ] ]', '1000', '1', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('561', '426', 'Ford', 'Crown Victoria', '2011', '21500', '30', '2014-05-11 08:20:42', '860', '2014-05-14 19:23:45', '1737', '\n', '[ [ 1600, 3921.300049, 1.800000, [ 0, -0.400000, 0 ], 75, 0.750000, 0.850000, 0.520000, 5, 150, 10, 6, \"rwd\", \"petrol\", 10, 0.500000, false, 35, 1.300000, 0.120000, 0, 0.280000, -0.100000, 0.400000, 0, 0.200000, 0.240000, 25000, 1073741824, 270532616, \"long\", \"small\", 0 ] ]', '1000', '1', '2', '0');
INSERT INTO `vehicles_shop` VALUES ('562', '609', 'Ford', 'Utilimaster E350 Stepvan', '2004', '18000', '50', '2014-05-12 05:18:48', '860', '2014-05-21 02:18:05', '1737', '\n', null, '1000', '1', '5', '0');
INSERT INTO `vehicles_shop` VALUES ('564', '486', 'JCB Diesel', 'Kohler', '2014', '56000', '65', '2014-05-13 23:50:45', '860', '2014-06-02 00:38:11', '120', '\n', null, '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('565', '406', 'Astra', 'RD28c', '2007', '170000', '150', '2014-05-13 23:56:50', '860', '2014-06-02 00:37:41', '120', '\n', '[ [ 20000, 200000, 4, [ 0, 0.500000, -0.400000 ], 90, 0.600000, 0.800000, 0.550000, 4, 65, 2, 30, \"rwd\", \"diesel\", 3.170000, 0.400000, false, 30, 0.800000, 0.060000, 0, 0.200000, -0.300000, 0.600000, 0, 0.450000, 0.200000, 5000, 49160, 20185601, \"long\", \"small\", 20 ] ]', '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('566', '455', '2-IH ', 'Load Star 1800 ', '1998', '43000', '100', '2014-05-13 23:59:21', '860', '2014-11-28 04:09:55', '1622', '\n', '[ [ 8500, 48804.199219, 2.500000, [ 0, 0, 0.300000 ], 90, 0.700000, 0.700000, 0.460000, 5, 140, 7, 80, \"rwd\", \"diesel\", 10, 0.400000, false, 27, 1.200000, 0.050000, 0, 0.470000, -0.200000, 0.500000, 0, 0.620000, 0.430000, 10000, 2049, 0, \"long\", \"small\", 2 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('567', '577', 'Boeing', '737-400', '1998', '10000000', '1250', '2014-05-14 00:46:32', '860', '2014-08-20 19:06:33', '1622', '\n', null, '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('568', '598', 'Ford', 'Mondeo', '2016', '59355', '50', '2014-05-14 09:56:57', '1737', '2021-03-27 11:04:40', '17826', '\n', '[ [ 2500, 4500, 1.1000000238418579, [ 0, -0.20000000298023224, -0.25 ], 75, 1.2000000476837158, 0.85000002384185791, 0.43000000715255737, 5, 210, 16, 9, \"awd\", \"petrol\", 9, 0.60000002384185791, false, 35, 1, 0.20000000298023224, 0, 0.2800000011920929, -0.15000000596046448, 0.40000000596046448, 0, 0.20000000298023224, 0.23999999463558197, 25000, 1073741824, 270532616, \"long\", \"small\", 0 ] ]', '1000', '1', '0', null);
INSERT INTO `vehicles_shop` VALUES ('569', '572', 'Mountfield', '727M Compact Lawn Rider', '2014', '2000', '0', '2014-05-15 00:19:00', '1737', '2014-05-15 00:22:36', '65', '\n', '[ [ 800, 500, 5, [ 0, 0, -0.300000 ], 80, 0.700000, 0.800000, 0.480000, 3, 25, 5, 30, \"rwd\", \"petrol\", 6.100000, 0.600000, false, 35, 1, 0.150000, 0, 0.150000, -0.100000, 0.500000, 0, 0.380000, 0.400000, 15000, 1073748736, 19955713, \"small\", \"big\", 28 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('570', '463', 'Triumph', 'Bonneville T100', '2014', '11355', '20', '2014-05-15 05:52:04', '1737', '2014-08-10 21:43:31', '12', '\n', '[ [ 800, 403.299988, 4, [ 0, 0.100000, 0 ], 103, 1.200000, 0.820000, 0.510000, 4, 140, 17, 10, \"rwd\", \"petrol\", 10, 0.600000, false, 35, 0.650000, 0.200000, 0, 0.090000, -0.100000, 0.600000, 0, 0, 0.240000, 10000, 16785408, 0, \"small\", \"small\", 6 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('571', '418', 'Scion', 'xB', '2004', '15000', '50', '2014-05-18 21:55:59', '1622', '0000-00-00 00:00:00', '0', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('572', '559', 'Scion', 'FR-S', '2013', '28000', '50', '2014-05-18 22:05:06', '1622', '2014-07-11 13:30:27', '6366', '\n', '[ [ 1200, 3600, 2, [ 0, 0.100000, -0.050000 ], 75, 0.800000, 0.800000, 0.500000, 5, 220, 12, 5, \"rwd\", \"petrol\", 10, 0.400000, false, 36, 1.500000, 0.100000, 0, 0.280000, -0.075000, 0.500000, 0.300000, 0.250000, 0.600000, 35000, 2147483648.000000, 67108864, \"small\", \"small\", 1 ] ]', '1000', '1', '2', '0');
INSERT INTO `vehicles_shop` VALUES ('573', '559', 'Subaru', 'BRZ', '2013', '120000', '250', '2014-05-18 23:41:48', '1622', '2020-04-03 02:21:27', '4341', '\n', '[ [ 1300, 3600, 2.200000047683716, [ 0, 0, -0.05000000074505806 ], 75, 0.8500000238418579, 0.800000011920929, 0.5, 5, 160, 30, 10, \"awd\", \"petrol\", 10, 0.4000000059604645, false, 30, 1.100000023841858, 0.1000000014901161, 0, 0.2800000011920929, -0.2000000029802322, 0.5, 0.300000011920929, 0.25, 0.6000000238418579, 35000, 3221235716, 67108864, \"small\", \"small\", 1 ] ]', '1000', '1', '2', '0');
INSERT INTO `vehicles_shop` VALUES ('574', '434', 'Dodge Challenger', 'SRT Hellcat', '2012', '99999999', '0', '2014-05-19 22:25:00', '860', '2020-06-20 04:14:27', '744', '\n', '[ [ 3000, 3400, 1.600000023841858, [ 0, 0.300000011920929, -0.1000000014901161 ], 75, 1.100000023841858, 0.800000011920929, 0.5, 5, 220, 35, 30, \"awd\", \"petrol\", 50, 0.6000000238418579, false, 35, 1, 0.2000000029802322, 0, 0.2800000011920929, -0.1899998933076859, 0.6000000238418579, 0.300000011920929, 0.2000000029802322, 0.6000000238418579, 35000, 1073768448, 32768, \"small\", \"small\", 0 ] ]', '1000', '0', '0', null);
INSERT INTO `vehicles_shop` VALUES ('576', '495', 'Bowler', 'Wildcat', '2015', '420000', '60', '2014-05-20 07:09:28', '1737', '2019-12-12 18:59:15', '1438', '\n', '[ [ 3200, 4000, 1.899999976158142, [ 0, 0, -0.6000000238418579 ], 80, 0.75, 0.8500000238418579, 0.5, 5, 170, 14, 10, \"awd\", \"petrol\", 8, 0.5, false, 30, 0.800000011920929, 0.07999999821186066, 0, 0.3499999940395355, -0.300000011920929, 0.5, 0, 0.3799999952316284, 0.3499999940395355, 40000, 0, 3246080, \"long\", \"small\", 22 ] ]', '1000', '1', '1', '0');
INSERT INTO `vehicles_shop` VALUES ('577', '507', 'BMW', 'F02 760Li', '2013', '146000', '65', '2014-05-20 09:23:33', '1737', '2014-11-03 21:09:36', '1107', '\n', '[ [ 2000, 5000, 0.10000000149011612, [ 0, 0.10000000149011612, -0.10000000149011612 ], 75, 0.80000001192092896, 0.80000001192092896, 0.46000000834465027, 5, 185, 14, 0.10000000149011612, \"rwd\", \"petrol\", 6, 0.60000002384185791, false, 35, 1, 0.20000000298023224, 0, 0.34999999403953552, -0.20000000298023224, 0.5, 0.30000001192092896, 0.20000000298023224, 0.30000001192092896, 35000, 1073741824, 272629760, \"long\", \"small\", 0 ] ]', '1000', '1', '1', '0');
INSERT INTO `vehicles_shop` VALUES ('578', '517', 'Chevrolet', 'Monte Carlo', '1986', '25250', '25', '2014-05-20 18:20:39', '12', '2014-06-19 01:08:50', '1107', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('579', '463', 'Triumph', 'Rocket III Roadster', '2014', '18000', '15', '2014-05-20 18:30:25', '12', '2014-12-24 09:53:36', '11396', '\n', '[ [ 800, 403.29998779296875, 4, [ 0, 0.10000000149011612, 0 ], 103, 1.2000000476837158, 0.81999999284744263, 0.50999999046325684, 4, 225, 24, 7, \"rwd\", \"petrol\", 10, 0.60000002384185791, false, 35, 0.64999997615814209, 0.20000000298023224, 0, 0.090000003576278687, -0.10999999940395355, 0.60000002384185791, 0, 0, 0.23999999463558197, 10000, 16785408, 0, \"small\", \"small\", 6 ] ]', '1000', '1', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('580', '541', 'Lotus', 'Evora S', '2011', '225000', '125', '2014-05-20 18:33:01', '12', '2019-10-23 04:13:56', '1438', '\n', '[ [ 1200, 2500, 0.699999988079071, [ 0, -0.1500000059604645, -0.2000000029802322 ], 70, 0.75, 0.8999999761581421, 0.4799999892711639, 5, 178, 12, 10, \"rwd\", \"petrol\", 5.5, 0.6000000238418579, false, 30, 0.800000011920929, 0.1299999952316284, 5, 0.25, -0.1000000014901161, 0.4000000059604645, 0.300000011920929, 0.1500000059604645, 0.5400000214576721, 105000, 3221233668, 2113536, \"long\", \"long\", 1 ] ]', '1000', '1', '1', '0');
INSERT INTO `vehicles_shop` VALUES ('581', '422', 'Chevrolet', 'S-10', '1993', '13500', '35', '2014-05-20 18:36:34', '12', '2014-06-19 23:23:37', '1107', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('584', '408', 'Kenworth', '20YD Pakmor', '2014', '75355', '55', '2014-05-21 06:25:58', '1737', '2014-10-13 00:22:13', '1107', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('585', '533', 'Mercedes-Benz', 'SL65 AMG', '2014', '152355', '120', '2014-05-22 06:34:48', '1737', '2020-06-06 02:04:45', '744', '\n', '[ [ 1600, 4500, 1.7000000476837158, [ 0, 0, -0.15000000596046448 ], 75, 0.85000002384185791, 0.89999997615814209, 0.4699999988079071, 5, 195, 18, 15, \"rwd\", \"petrol\", 7, 0.5, false, 30, 1.1000000238418579, 0.090000003576278687, 0, 0.30000001192092896, -0.10000000149011612, 0.5, 0.30000001192092896, 0.25, 0.60000002384185791, 35000, 1073752064, 0, \"small\", \"small\", 19 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('587', '558', 'Acura', 'Integra DC2 Type R', '1998', '18000', '45', '2014-05-23 02:51:09', '1622', '2014-06-19 23:58:35', '1107', '\n', '[ [ 1200, 2998.300049, 2, [ 0, 0.100000, -0.300000 ], 75, 0.800000, 0.850000, 0.470000, 5, 200, 8, 5, \"fwd\", \"petrol\", 8, 0.400000, false, 30, 1.300000, 0.150000, 0, 0.280000, -0.100000, 0.500000, 0.300000, 0.250000, 0.600000, 35000, 3221235712.000000, 67108865, \"small\", \"small\", 0 ] ]', '1000', '1', '2', '0');
INSERT INTO `vehicles_shop` VALUES ('589', '579', 'Mercedes-Benz', 'GL550', '2014', '72000', '55', '2014-05-23 03:56:43', '1622', '2015-01-01 02:03:43', '55', '\n', '[ [ 2500, 6000, 2.5, [ 0, 0, -0.20000000298023224 ], 80, 0.62000000476837158, 0.88999998569488525, 0.5, 5, 165, 11, 7, \"awd\", \"petrol\", 7, 0.40000000596046448, false, 35, 1, 0.05000000074505806, 0, 0.44999998807907104, -0.20000000298023224, 0.40000000596046448, 0.30000001192092896, 0.43999999761581421, 0.34999999403953552, 40000, 32, 17412, \"long\", \"small\", 0 ] ]', '1000', '1', '1', '0');
INSERT INTO `vehicles_shop` VALUES ('592', '547', 'Audi', 'A4', '2014', '42500', '45', '2014-05-24 04:36:08', '1622', '2021-03-26 19:00:58', '17826', '\n', '[ { \"1\": 1600, \"2\": 3300, \"3\": 2.200000, \"4\": [ 0, 0, 0 ], \"5\": 70, \"6\": 0.700000, \"7\": 0.800000, \"8\": 0.540000, \"9\": 4, \"10\": 160, \"11\": 6.500000, \"12\": 7, \"13\": \"rwd\", \"14\": \"petrol\", \"15\": 5.400000, \"16\": 0.600000, \"17\": false, \"18\": 30, \"19\": 1.100000, \"20\": 0.140000, \"21\": 0, \"22\": 0.320000, \"23\": -0.100000, \"24\": 0.500000, \"25\": 0, \"26\": 0.260000, \"27\": 0.540000, \"28\": 19000, \"29\": 0, \"30\": 0, \"31\": \"long\", \"33\": 0 } ]', '1000', '1', '0', null);
INSERT INTO `vehicles_shop` VALUES ('593', '514', 'Mack', 'MR686S', '1977', '54000', '100', '2014-05-24 18:25:31', '860', '2014-06-28 20:52:45', '99', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('594', '435', 'Trailmobile', 'Car Hauler', '1995', '32000', '50', '2014-05-24 18:30:59', '860', '2019-11-22 20:41:50', '1438', '\n', null, '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('595', '411', 'Lamborghini', 'MurciÃ©lago LP 640-4', '2010', '350355', '135', '2014-05-27 00:30:44', '1737', '2015-01-01 20:05:42', '15336', '\n', '[ [ 1400, 2725.300048828125, 1.5, [ 0, 0, -0.25 ], 70, 0.69999998807907104, 0.80000001192092896, 0.5, 5, 255, 19, 15, \"awd\", \"petrol\", 11, 0.5, false, 30, 1.2000000476837158, 0.18999999761581421, 0, 0.25, -0.10000000149011612, 0.5, 0.40000000596046448, 0.37000000476837158, 0.72000002861022949, 95000, 1073750020, 12599296, \"small\", \"small\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('596', '421', 'Cadillac', 'CTS-V Sedan', '2014', '69500', '55', '2014-05-29 22:49:53', '1737', '2014-12-03 02:04:58', '99', '\n', '[ [ 1914, 5000, 0.10000000149011612, [ 0, 0, -0.10000000149011612 ], 75, 0.94999998807907104, 0.64999997615814209, 0.47999998927116394, 5, 240, 14, 30, \"rwd\", \"petrol\", 7.5, 0.60000002384185791, false, 35, 1, 0.20000000298023224, 0, 0.27000001072883606, -0.20000000298023224, 0.5, 0.34999999403953552, 0.23999999463558197, 0.60000002384185791, 18000, 0, 272629760, \"small\", \"small\", 0 ] ]', '1000', '1', '1', '0');
INSERT INTO `vehicles_shop` VALUES ('597', '428', 'Ford', 'Armored -550 ', '2014', '100000', '125', '2014-05-30 03:43:36', '1695', '2019-10-24 12:18:37', '1438', '\n', '[ [ 10000, 30916.69921875, 1.5, [ 0, 0, 0 ], 90, 0.5, 0.699999988079071, 0.4600000083446503, 5, 170, 7, 30, \"rwd\", \"diesel\", 8.399999618530273, 0.4000000059604645, false, 27, 1, 0.05999999865889549, 0, 0.3499999940395355, -0.1500000059604645, 0.5, 0, 0.2700000107288361, 0.3499999940395355, 40000, 16385, 4, \"small\", \"small\", 13 ] ]', '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('599', '442', 'Rolls Royce', 'Funeral Hearse', '2012', '100000', '50', '2014-06-09 01:03:09', '1695', '0000-00-00 00:00:00', '0', 'For funeral - Temp\n', null, '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('601', '571', 'TonyKart', 'Krypton NSK', '2014', '2500', '10', '2014-06-09 04:46:04', '120', '2014-08-05 14:37:30', '1115', '\n', null, '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('602', '523', 'BMW', 'RT1200 RT-P', '2017', '10000000', '10', '2014-06-11 05:43:16', '1737', '2019-10-12 11:34:29', '1438', '\n', '[ [ 500, 240, 1, [ 0, 0.05000000074505806, -0.09000000357627869 ], 103, 2.5, 0.8999999761581421, 0.4799999892711639, 5, 275, 52, 30, \"rwd\", \"petrol\", 15, 0.5, false, 34, 0.8500000238418579, 0.1500000059604645, 0, 0.1500000059604645, -0.1599999964237213, 0.5, 0, 0, 0.1500000059604645, 10000, 16785408, 0, \"small\", \"small\", 4 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('604', '560', 'Dodge', 'Charger SRT-8', '2014', '950000', '300', '2014-06-11 07:25:06', '1737', '2020-06-13 12:10:59', '2301', '\n', '[ [ 1600, 3400, 1.600000023841858, [ 0, 0, -0.25 ], 75, 1.100000023841858, 0.800000011920929, 0.5, 5, 205, 30, 3, \"awd\", \"petrol\", 8, 0.6000000238418579, false, 30, 1.200000047683716, 0.1899999976158142, 0, 0.2800000011920929, -0.135000005364418, 0.5, 0.300000011920929, 0.25, 0.6000000238418579, 35000, 10240, 67108866, \"small\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('605', '562', 'Nissan', 'Skyline R35 GT-R', '2013', '300000', '155', '2014-06-17 09:56:54', '1737', '2019-10-23 23:30:14', '1438', '\n', '[ [ 1500, 3500, 1.899999976158142, [ 0, 0.300000011920929, -0.1500000059604645 ], 75, 0.8500000238418579, 0.8999999761581421, 0.4799999892711639, 5, 218, 14.5, 8, \"rwd\", \"petrol\", 8, 0.5, false, 35, 1, 0.2000000029802322, 0, 0.2800000011920929, -0.1000000014901161, 0.5, 0.300000011920929, 0.25, 0.6000000238418579, 35000, 1073752068, 67108865, \"small\", \"small\", 1 ] ]', '1000', '1', '1', '0');
INSERT INTO `vehicles_shop` VALUES ('606', '565', 'Toyota', 'Starlet Glanza', '2000', '8500', '70', '2014-06-18 23:37:41', '1107', '2014-08-23 04:40:16', '1115', '\n', '[ [ 800, 2998.300049, 2.200000, [ 0, 0.200000, -0.100000 ], 75, 0.750000, 0.900000, 0.500000, 5, 200, 10, 10, \"fwd\", \"petrol\", 8, 0.600000, false, 30, 1.400000, 0.150000, 0, 0.280000, -0.100000, 0.500000, 0.300000, 0.250000, 0.600000, 35000, 10244, 67108865, \"small\", \"small\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('607', '410', 'Nissan', 'Micra', '2011', '19000', '50', '2014-06-19 23:12:18', '1107', '2014-12-27 22:07:38', '55', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('608', '604', 'TofaÅŸ', 'Åžahin 6 Vites', '2003', '135000', '300', '2014-06-21 10:48:15', '1737', '2020-03-13 16:17:09', '745', '\n', '[ [ 1600, 4000, 2.5, [ 0, 0, 0.05000000074505806 ], 75, 0.6000000238418579, 0.8399999737739563, 0.5199999809265137, 5, 160, 9.699999809265137, 15, \"rwd\", \"petrol\", 6.199999809265137, 0.6000000238418579, false, 30, 0.800000011920929, 0.07000000029802322, 0, 0.3499999940395355, -0.2199999988079071, 0.5, 0.5, 0.2300000041723251, 0.4000000059604645, 20000, 0, 276824066, \"small\", \"small\", 0 ] ]', '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('609', '550', 'Saab', '95', '2007', '25790', '65', '2014-06-23 21:01:59', '1107', '2014-06-24 07:53:13', '1737', '\n', '[ { \"1\": 1600, \"2\": 3550, \"3\": 2, \"4\": [ 0, 0.300000, 0 ], \"5\": 70, \"6\": 0.750000, \"7\": 0.800000, \"8\": 0.520000, \"9\": 5, \"10\": 160, \"11\": 11, \"12\": 6, \"13\": \"fwd\", \"14\": \"petrol\", \"15\": 5.400000, \"16\": 0.600000, \"17\": false, \"18\": 35, \"19\": 1, \"20\": 0.090000, \"21\": 0, \"22\": 0.300000, \"23\": -0.100000, \"24\": 0.600000, \"25\": 0, \"26\": 0.260000, \"27\": 0.540000, \"28\": 19000, \"29\": 1073741824, \"30\": 1, \"31\": \"long\", \"33\": 0 } ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('610', '421', 'Cadillac', 'CTS', '2009', '25455', '35', '2014-06-23 21:11:51', '1107', '2014-06-24 07:50:58', '1737', '\n', '[ [ 1850, 5000, 2.200000, [ 0, 0, -0.100000 ], 75, 0.750000, 0.650000, 0.480000, 5, 220, 11, 10, \"rwd\", \"petrol\", 7.500000, 0.600000, false, 34, 1, 0.200000, 0, 0.270000, -0.200000, 0.500000, 0.350000, 0.240000, 0.600000, 18000, 0, 272629760, \"small\", \"small\", 0 ] ]', '1000', '1', '2', '0');
INSERT INTO `vehicles_shop` VALUES ('611', '560', 'Mitsubishi', 'Lancer Evo VIII', '2003', '21933', '65', '2014-06-23 21:14:32', '1107', '2014-06-24 07:53:30', '1737', '\n', '[ [ 1410, 3400, 2, [ 0, 0.100000, -0.100000 ], 75, 0.800000, 0.800000, 0.500000, 5, 230, 12, 7, \"awd\", \"petrol\", 10, 0.500000, false, 30, 1.200000, 0.150000, 0, 0.280000, -0.200000, 0.500000, 0.300000, 0.250000, 0.600000, 35000, 10240, 67108866, \"small\", \"small\", 0 ] ]', '1000', '1', '2', '0');
INSERT INTO `vehicles_shop` VALUES ('612', '516', 'Honda', 'Civic Sedan LX', '1998', '13500', '35', '2014-06-23 21:23:19', '1107', '2014-06-24 07:53:41', '1737', '\n', '[ [ 1300, 4000, 2.200000, [ 0, 0.300000, -0.100000 ], 75, 0.650000, 0.800000, 0.500000, 5, 150, 11, 8, \"fwd\", \"petrol\", 8, 0.600000, false, 35, 1.400000, 0.100000, 0, 0.270000, -0.100000, 0.600000, 0.300000, 0.200000, 0.560000, 35000, 0, 4194304, \"long\", \"small\", 0 ] ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('613', '565', 'Audi', 'A3 1.8T', '1998', '23900', '45', '2014-06-23 21:28:39', '1107', '2014-06-24 07:53:23', '1737', '\n', '[ [ 1140, 2998.300049, 2.200000, [ 0, 0.200000, -0.100000 ], 75, 0.750000, 0.900000, 0.500000, 5, 200, 12, 8, \"fwd\", \"petrol\", 8, 0.600000, false, 30, 1.400000, 0.150000, 0, 0.280000, -0.100000, 0.500000, 0.300000, 0.250000, 0.600000, 35000, 10244, 67108865, \"small\", \"small\", 1 ] ]', '1000', '1', '2', '0');
INSERT INTO `vehicles_shop` VALUES ('615', '497', 'Eurocopter', 'AS350B-2 A-Star', '2000', '355333', '250', '2014-06-24 07:56:45', '1737', '2020-03-13 16:16:50', '745', '\n', '[ [ 1500, 26343.69921875, 0.2000000029802322, [ 0, 0, -0.1000000014901161 ], 75, 1, 0.8999999761581421, 0.5, 1, 275, 45, 20, \"awd\", \"petrol\", 5, 0.4000000059604645, false, 35, 2, 0.1000000014901161, 0, 0.5, -0.2000000029802322, 0.5, 0, 0.300000011920929, 0.6499999761581421, 52000, 33570816, 4194304, \"long\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('617', '426', 'Ford', 'Crown Victoria Police Interceptor', '2010', '35455', '30', '2014-06-24 08:38:35', '1737', '2014-12-09 17:40:12', '1840', '\n', '[ [ 2300, 3921.300048828125, 1.6000000238418579, [ 0, -0.40000000596046448, -0.34999999403953552 ], 75, 1.1100000143051147, 0.85000002384185791, 0.5, 5, 275, 17, 3, \"rwd\", \"petrol\", 8.3000001907348633, 0.40000000596046448, false, 46, 1, 0.11999999731779099, 0, 0.2800000011920929, -0.20000000298023224, 0.30000001192092896, 0, 0.20000000298023224, 0.23999999463558197, 25000, 1073741824, 270532616, \"long\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('618', '463', 'Harley-Davidson', 'Ironhead', '1972', '15355', '25', '2014-06-24 09:59:56', '1737', '2014-08-15 19:58:35', '12', '\n', '[ [ 800, 403.299988, 4, [ 0, 0.100000, 0 ], 103, 1.200000, 0.820000, 0.510000, 4, 190, 16, 8, \"rwd\", \"petrol\", 10, 0.600000, false, 35, 0.650000, 0.200000, 0, 0.090000, -0.100000, 0.600000, 0, 0, 0.240000, 10000, 16785408, 0, \"small\", \"small\", 6 ] ]', '1000', '1', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('619', '421', 'Bentley', 'Arnage Red Label', '2000', '37355', '60', '2014-06-25 01:55:26', '1737', '2015-02-05 04:01:01', '120', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('620', '423', 'GMC', 'Savana Ice Cream Van', '2004', '12355', '25', '2014-06-25 08:15:22', '1737', '2014-10-04 03:07:44', '1775', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('621', '565', 'Volkswagen', 'Golf R32', '2004', '10000', '25', '2014-06-25 22:24:53', '1737', '2019-10-06 06:09:51', '1438', '\n', '[ [ 1400, 2998.300048828125, 2.200000047683716, [ 0, 0.2000000029802322, -0.1000000014901161 ], 75, 0.75, 0.8999999761581421, 0.5, 5, 170, 10, 6, \"awd\", \"petrol\", 8, 0.6000000238418579, false, 30, 1.399999976158142, 0.1500000059604645, 0, 0.2800000011920929, -0.1000000014901161, 0.5, 0.300000011920929, 0.25, 0.6000000238418579, 35000, 10244, 67108865, \"small\", \"small\", 1 ] ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('622', '580', 'Rolls-Royce', 'Silver Shadow', '1979', '41355', '40', '2014-06-27 01:39:45', '1737', '2014-11-07 04:29:26', '1107', '\n', '[ [ 2200, 6000, 2.0999999046325684, [ 0, 0, 0 ], 75, 0.64999997615814209, 0.92000001668930054, 0.5, 5, 165, 11.600000381469727, 15, \"rwd\", \"petrol\", 5, 0.60000002384185791, false, 30, 1.1000000238418579, 0.10000000149011612, 0, 0.27000001072883606, -0.20000000298023224, 0.5, 0.30000001192092896, 0.20000000298023224, 0.56000000238418579, 35000, 0, 4194304, \"long\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('623', '570', 'Train', 'Choo Choo', '2014', '1', '0', '2014-06-27 06:50:41', '141', '0000-00-00 00:00:00', '0', 'Temporary add for roleplay purposes - Lyricist.\n', null, '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('624', '430', 'SANJ ', 'High Speed Aluminium Patrol Boat ', '2010', '100000', '50', '2014-06-28 05:37:44', '1695', '2014-06-28 05:59:13', '1695', '\n', '[ [ 10000, 29333.300781, 1, [ 0, 0, 0 ], 14, 0.100000, 15, 0.580000, 5, 250, 3, 5, \"awd\", \"petrol\", 0.050000, 0, false, 3.750000, 1, 3, 0, 0.100000, 0.100000, 0, 0, 0.200000, 0.330000, 40000, 134217728, 0, \"long\", \"small\", 0 ] ]', '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('625', '401', 'Mazda', 'Miata MX-5', '1998', '7555', '25', '2014-07-02 16:58:26', '1737', '2014-07-02 17:08:48', '1737', '\n', '[ [ 1300, 2200, 1.700000, [ 0, 0.300000, 0 ], 70, 0.650000, 0.800000, 0.520000, 5, 160, 6, 10, \"rwd\", \"petrol\", 8, 0.800000, false, 30, 1.300000, 0.080000, 0, 0.310000, -0.200000, 0.600000, 0, 0.260000, 0.500000, 9000, 1, 1, \"long\", \"long\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('628', '540', 'Chrysler', '300 Touring', '2014', '35000', '50', '2014-07-03 22:32:07', '1107', '2014-07-04 00:02:44', '6366', '\n', '[ { \"1\": 1800, \"2\": 3000, \"3\": 2, \"4\": [ 0, 0, 0 ], \"5\": 70, \"6\": 0.800000, \"7\": 0.800000, \"8\": 0.400000, \"9\": 4, \"10\": 140, \"11\": 12, \"12\": 25, \"13\": \"rwd\", \"14\": \"petrol\", \"15\": 5.400000, \"16\": 0.600000, \"17\": false, \"18\": 35, \"19\": 2, \"20\": 0.090000, \"21\": 0, \"22\": 0.320000, \"23\": -0.100000, \"24\": 0.600000, \"25\": 0, \"26\": 0.260000, \"27\": 0.540000, \"28\": 19000, \"29\": 0, \"30\": 2, \"31\": \"long\", \"33\": 0 } ]', '1000', '1', '2', '0');
INSERT INTO `vehicles_shop` VALUES ('629', '540', 'Chrysler', '300S', '2014', '39000', '50', '2014-07-03 22:32:35', '1107', '2014-07-04 00:02:55', '6366', '\n', '[ { \"1\": 1800, \"2\": 3000, \"3\": 2, \"4\": [ 0, 0, 0 ], \"5\": 70, \"6\": 0.800000, \"7\": 0.800000, \"8\": 0.400000, \"9\": 4, \"10\": 150, \"11\": 11, \"12\": 20, \"13\": \"rwd\", \"14\": \"petrol\", \"15\": 5.400000, \"16\": 0.600000, \"17\": false, \"18\": 30, \"19\": 2, \"20\": 0.090000, \"21\": 0, \"22\": 0.320000, \"23\": -0.100000, \"24\": 0.600000, \"25\": 0, \"26\": 0.260000, \"27\": 0.540000, \"28\": 19000, \"29\": 0, \"30\": 2, \"31\": \"long\", \"33\": 0 } ]', '1000', '1', '2', '0');
INSERT INTO `vehicles_shop` VALUES ('630', '540', 'Chrysler', '300c', '2014', '40000', '50', '2014-07-03 22:33:18', '1107', '2014-07-04 00:03:09', '6366', '\n', '[ { \"1\": 1600, \"2\": 3000, \"3\": 2, \"4\": [ 0, 0, 0 ], \"5\": 70, \"6\": 0.850000, \"7\": 0.800000, \"8\": 0.400000, \"9\": 4, \"10\": 150, \"11\": 13, \"12\": 20, \"13\": \"awd\", \"14\": \"petrol\", \"15\": 5.400000, \"16\": 0.600000, \"17\": false, \"18\": 36, \"19\": 2, \"20\": 0.150000, \"21\": 0, \"22\": 0.320000, \"23\": -0.100000, \"24\": 0.600000, \"25\": 0, \"26\": 0.260000, \"27\": 0.540000, \"28\": 19000, \"29\": 0, \"30\": 2, \"31\": \"long\", \"33\": 0 } ]', '1000', '1', '2', '0');
INSERT INTO `vehicles_shop` VALUES ('632', '540', 'Chrysler', '300 SRT', '2014', '50000', '50', '2014-07-03 22:33:38', '1107', '2014-07-04 00:07:52', '6366', '\n', '[ { \"1\": 1800, \"2\": 3000, \"3\": 2, \"4\": [ 0, 0, 0 ], \"5\": 70, \"6\": 0.700000, \"7\": 0.800000, \"8\": 0.400000, \"9\": 4, \"10\": 152, \"11\": 15, \"12\": 20, \"13\": \"rwd\", \"14\": \"petrol\", \"15\": 5.400000, \"16\": 0.600000, \"17\": false, \"18\": 30, \"19\": 2, \"20\": 0.150000, \"21\": 0, \"22\": 0.320000, \"23\": -0.100000, \"24\": 0.600000, \"25\": 0, \"26\": 0.260000, \"27\": 0.540000, \"28\": 19000, \"29\": 0, \"30\": 2, \"31\": \"long\", \"33\": 0 } ]', '1000', '1', '2', '0');
INSERT INTO `vehicles_shop` VALUES ('634', '426', 'Ford', 'Taurus SHO', '2014', '38000', '50', '2014-07-03 22:35:04', '1107', '2014-12-23 04:21:16', '1622', '\n', '[ [ 1400, 3921.300048828125, 0.5, [ 0, -0.40000000596046448, 0 ], 75, 0.94999998807907104, 0.85000002384185791, 0.40000000596046448, 5, 200, 12, 10, \"awd\", \"petrol\", 10, 0.5, false, 35, 1, 0.20000000298023224, 0, 0.2800000011920929, -0.10000000149011612, 0.40000000596046448, 0, 0.20000000298023224, 0.23999999463558197, 25000, 1073741824, 270532616, \"long\", \"small\", 0 ] ]', '1000', '1', '1', '0');
INSERT INTO `vehicles_shop` VALUES ('636', '561', 'Å koda', 'Octavia vRS', '2014', '30500', '50', '2014-07-03 22:36:24', '1107', '2014-07-04 00:43:24', '1107', '\n', '[ [ 1800, 4500, 2, [ 0, 0.100000, -0.100000 ], 75, 0.600000, 0.850000, 0.500000, 5, 160, 7, 10, \"fwd\", \"petrol\", 7, 0.500000, false, 32, 1, 0.150000, 0, 0.280000, -0.200000, 0.500000, 0.300000, 0.250000, 0.600000, 35000, 10240, 67108864, \"small\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('637', '561', 'Mercedes-Benz', 'C63 AMG Estate', '2009', '50500', '50', '2014-07-03 22:37:10', '1107', '2014-07-04 00:59:20', '1107', '\n', '[ [ 1795, 4500, 2.540000, [ 0, 0.100000, -0.100000 ], 75, 0.600000, 0.850000, 0.500000, 5, 190, 15, 10, \"rwd\", \"petrol\", 7, 0.500000, false, 30, 1, 0.100000, 0, 0.280000, -0.140000, 0.500000, 0.300000, 0.250000, 0.600000, 35000, 10240, 67108864, \"small\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('638', '589', 'Volkswagen', 'Polo Mk. VII', '2013', '27000', '50', '2014-07-03 22:40:14', '1107', '2014-07-04 01:01:04', '1107', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('639', '561', 'Volkswagen ', 'Polo Variant', '1999', '8900', '20', '2014-07-03 22:40:37', '1107', '0000-00-00 00:00:00', '0', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('640', '561', 'Volkswagen', 'Golf Variant', '2006', '12500', '50', '2014-07-03 22:40:59', '1107', '0000-00-00 00:00:00', '0', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('641', '562', 'Lexus', 'SC400', '1995', '25000', '50', '2014-07-03 22:59:03', '1107', '2014-07-04 00:21:03', '6366', '\n', '[ [ 1300, 3500, 2.200000, [ 0, 0, 0 ], 75, 0.640000, 0.900000, 0.500000, 5, 180, 11, 5, \"rwd\", \"petrol\", 8, 0.500000, false, 35, 1.750000, 0.200000, 0, 0.280000, -0.100000, 0.500000, 0.300000, 0.250000, 0.600000, 35000, 1073752068, 67108865, \"small\", \"small\", 1 ] ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('642', '561', 'Ford', 'Focus SW', '2005', '12200', '40', '2014-07-03 23:43:14', '1107', '2014-07-04 00:30:30', '6366', '\n', '[ [ 1300, 4500, 2.100000, [ 0, 0.100000, -0.100000 ], 75, 0.750000, 0.850000, 0.500000, 5, 160, 10, 10, \"rwd\", \"petrol\", 7, 0.500000, false, 30, 1.500000, 0.150000, 0, 0.280000, -0.100000, 0.500000, 0.300000, 0.250000, 0.600000, 35000, 10240, 67108864, \"small\", \"small\", 0 ] ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('643', '480', 'Porsche', 'Boxster', '2007', '35500', '30', '2014-07-03 23:43:33', '1107', '2014-08-27 02:03:29', '1622', '\n', '[ [ 1400, 2200, 2.200000, [ 0, 0.100000, -0.200000 ], 75, 0.850000, 0.900000, 0.500000, 5, 185, 12, 10, \"rwd\", \"petrol\", 11, 0.400000, false, 30, 2, 0.160000, 3, 0.280000, -0.100000, 0.500000, 0.300000, 0.250000, 0.600000, 35000, 1073743872, 0, \"small\", \"small\", 19 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('644', '507', 'Audi', 'A8', '2007', '21000', '50', '2014-07-03 23:43:57', '1107', '2014-12-27 21:59:17', '55', '\n', '[ [ 1650, 5000, 1.800000, [ 0, 0, -0.100000 ], 75, 0.700000, 0.800000, 0.500000, 5, 150, 11.500000, 10, \"awd\", \"petrol\", 6, 0.600000, false, 35, 2, 0.150000, 0, 0.350000, -0.100000, 0.500000, 0.300000, 0.200000, 0.300000, 35000, 1073741824, 272629760, \"long\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('646', '506', 'Mitsubishi', '3000 GT', '1990', '52000', '40', '2014-07-04 00:54:22', '6366', '2014-07-04 00:56:40', '6366', '\n', '[ [ 1400, 2800, 2, [ 0, 0, 0 ], 70, 0.750000, 0.860000, 0.480000, 5, 155, 11, 5, \"awd\", \"petrol\", 8, 0.500000, false, 30, 2, 0.200000, 0, 0.250000, -0.070000, 0.500000, 0.300000, 0.400000, 0.540000, 105000, 1073750020, 2129920, \"long\", \"long\", 1 ] ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('648', '415', 'Aston Martin', 'DB9', '2014', '183000', '165', '2014-07-06 05:29:36', '1107', '2019-10-24 19:38:52', '1438', '\n', '[ [ 1500, 3000, 1.200000047683716, [ 0, -0.2000000029802322, -0.2000000029802322 ], 70, 0.949999988079071, 0.8999999761581421, 0.4699999988079071, 5, 200, 16, 7, \"rwd\", \"petrol\", 11.10000038146973, 0.5, false, 24, 0.800000011920929, 0.119999997317791, 0, 0.1000000014901161, -0.1000000014901161, 0.5, 0.6000000238418579, 0.4000000059604645, 0.5400000214576721, 105000, 3221233668, 2129920, \"long\", \"long\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('649', '548', 'CH-47', 'Chinook', '1998', '1', '0', '2014-07-08 00:49:20', '1107', '0000-00-00 00:00:00', '0', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('650', '460', 'de Havilland', 'DHC-3 Otter', '1953', '120000', '200', '2014-07-08 00:50:08', '1107', '2014-08-20 19:27:49', '1622', '\n', '[ [ 2000, 27083.300781, 1.500000, [ 0, 0, 0 ], 9, 0.830000, 45, 0.500000, 1, 275, 20, 20, \"awd\", \"petrol\", 0.010000, 0.100000, false, 30, 1.500000, 0.750000, 0, 0.100000, 0, 2, 0, 1, 0.050000, 10000, 67109888, 0, \"long\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('651', '447', 'Robinson', 'R44 Fixed Utility Floats', '2004', '1', '0', '2014-07-08 00:51:49', '1107', '0000-00-00 00:00:00', '0', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('652', '512', 'Grumman', 'AG Cat', '1988', '1', '0', '2014-07-08 00:52:22', '1107', '0000-00-00 00:00:00', '0', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('653', '426', 'Chevrolet', 'Impala SS', '1996', '12500', '50', '2014-07-09 21:36:49', '1107', '2015-01-21 02:00:54', '99', '\n', '[ [ 1850, 3921.300048828125, 1.7999999523162842, [ 0, -0.40000000596046448, 0 ], 75, 0.75, 0.85000002384185791, 0.51999998092651367, 5, 200, 8.1999998092651367, 10, \"rwd\", \"petrol\", 5, 0.5, false, 35, 1.2999999523162842, 0.11999999731779099, 0, 0.2800000011920929, -0.11999999731779099, 0.40000000596046448, 0, 0.20000000298023224, 0.23999999463558197, 25000, 1073741824, 270532616, \"long\", \"small\", 0 ] ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('655', '429', 'Jaguar', 'XK Convertible', '2010', '75000', '35', '2014-07-09 21:43:28', '1107', '2014-07-09 21:48:22', '1107', '\n', '[ [ 1400, 3000, 1.600000, [ 0, 0, -0.200000 ], 70, 0.750000, 0.890000, 0.500000, 5, 230, 11, 10, \"rwd\", \"petrol\", 8, 0.500000, false, 34, 1.600000, 0.100000, 5, 0.300000, -0.100000, 0.500000, 0.300000, 0.150000, 0.490000, 45000, 8196, 2097152, \"small\", \"small\", 1 ] ]', '1000', '1', '1', '0');
INSERT INTO `vehicles_shop` VALUES ('656', '451', 'Camaro', 'Z1 TURBO', '2018', '225000', '0', '2014-07-09 21:49:33', '1107', '2020-01-03 14:00:32', '1438', '\n', '[ [ 1490, 3000, 1.600000023841858, [ 0, -0.300000011920929, -0.2000000029802322 ], 70, 0.75, 0.8500000238418579, 0.449999988079071, 5, 240, 18.5, 10, \"awd\", \"petrol\", 11, 0.5, false, 30, 1.200000047683716, 0.1299999952316284, 0, 0.1500000059604645, -0.1000000014901161, 0.5, 0.4000000059604645, 0.1700000017881393, 0.7200000286102295, 95000, 1073750020, 12616705, \"small\", \"small\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('658', '418', 'Chrysler', 'Grand Voyager', '2010', '27600', '50', '2014-07-12 00:00:13', '1107', '2014-07-12 00:06:29', '1107', '\n', '[ { \"1\": 2300, \"2\": 5848.299805, \"3\": 2.700000, \"4\": [ 0, 0.200000, -0.100000 ], \"5\": 85, \"6\": 0.600000, \"7\": 0.800000, \"8\": 0.500000, \"9\": 5, \"10\": 150, \"11\": 10, \"12\": 15, \"13\": \"rwd\", \"14\": \"diesel\", \"15\": 5.500000, \"16\": 0.600000, \"17\": false, \"18\": 30, \"19\": 1.400000, \"20\": 0.100000, \"21\": 0, \"22\": 0.350000, \"23\": -0.200000, \"24\": 0.600000, \"25\": 0, \"26\": 0.200000, \"27\": 0.750000, \"28\": 16000, \"29\": 32, \"30\": 0, \"31\": \"small\", \"33\": 0 } ]', '1000', '1', '2', '0');
INSERT INTO `vehicles_shop` VALUES ('659', '588', 'Ford', 'Vanette Step Van', '1961', '35000', '25', '2014-07-16 04:12:33', '1115', '2014-07-16 04:15:26', '1115', '\n', '[ { \"1\": 5500, \"2\": 23489.599609, \"3\": 3, \"4\": [ 0, 0, 0.300000 ], \"5\": 80, \"6\": 0.720000, \"7\": 0.700000, \"8\": 0.460000, \"9\": 5, \"10\": 80, \"11\": 5, \"12\": 25, \"13\": \"rwd\", \"14\": \"diesel\", \"15\": 4.500000, \"16\": 0.600000, \"17\": false, \"18\": 30, \"19\": 0.600000, \"20\": 0.080000, \"21\": 0, \"22\": 0.300000, \"23\": -0.200000, \"24\": 0.400000, \"25\": 0.600000, \"26\": 0.360000, \"27\": 0.400000, \"28\": 22000, \"29\": 1073741833, \"30\": 513, \"31\": \"long\", \"33\": 13 } ]', '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('660', '600', 'Chevrolet', 'El Camino', '1969', '26500', '30', '2014-07-18 17:19:49', '1115', '2014-07-20 04:20:07', '1115', '\n', '[ [ 1600, 3800, 2.700000, [ 0, 0.250000, 0 ], 75, 0.650000, 0.700000, 0.520000, 5, 165, 8.500000, 20, \"rwd\", \"diesel\", 8.500000, 0.500000, false, 35, 0.800000, 0.070000, 2, 0.250000, -0.250000, 0.450000, 0.400000, 0.260000, 0.200000, 26000, 1075839040, 1064964, \"long\", \"small\", 0 ] ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('661', '565', 'Volkswagen', 'Golf GT-R (1.9)', '2015', '450000', '35', '2014-07-19 03:48:08', '1115', '2020-04-25 12:18:39', '745', '\n', '[ [ 1400, 2998.300048828125, 2.299999952316284, [ 0, 0.300000011920929, -0.1000000014901161 ], 75, 0.699999988079071, 0.8999999761581421, 0.5, 5, 237, 20, 6, \"rwd\", \"petrol\", 8, 0.5, false, 33, 2, 0.2000000029802322, 0, 0.2800000011920929, -0.1000000014901161, 0.6000000238418579, 0.300000011920929, 0.25, 0.6000000238418579, 35000, 10244, 67108865, \"small\", \"small\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('662', '479', 'Kartal', '5 Vites', '1986', '9500', '35', '2014-07-19 21:59:45', '1115', '2019-10-11 16:25:15', '1438', '\n', '[ [ 1500, 3800, 2, [ 0, 0.200000, 0 ], 75, 0.650000, 0.850000, 0.520000, 4, 170, 6.400000, 25, \"rwd\", \"petrol\", 5, 0.600000, false, 30, 1, 0.070000, 0, 0.270000, -0.200000, 0.500000, 0.200000, 0.240000, 0.480000, 18000, 32, 1, \"small\", \"small\", 0 ] ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('664', '579', 'Dodge', 'Durango SXT', '2014', '32000', '55', '2014-07-20 04:25:29', '1115', '2014-07-20 04:28:49', '1115', '\n', '[ [ 2200, 6000, 2.500000, [ 0, 0, -0.200000 ], 80, 0.620000, 0.890000, 0.500000, 5, 160, 10, 25, \"awd\", \"petrol\", 7, 0.400000, false, 35, 1, 0.050000, 0, 0.450000, -0.150000, 0.500000, 0.300000, 0.440000, 0.350000, 40000, 32, 17412, \"long\", \"small\", 0 ] ]', '1000', '1', '2', '0');
INSERT INTO `vehicles_shop` VALUES ('667', '545', 'Ford', 'Coupe', '1933', '47000', '25', '2014-07-24 02:04:03', '1737', '2014-07-24 02:23:58', '1737', '\n', '[ [ 2200, 4000, 2.400000, [ 0, 0, -0.050000 ], 75, 0.750000, 0.750000, 0.520000, 5, 170, 12.500000, 10, \"rwd\", \"petrol\", 8, 0.500000, false, 30, 0.450000, 0.100000, 0, 0.100000, -0.200000, 0.500000, 0.500000, 0.180000, 0.450000, 20000, 0, 8388608, \"big\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('668', '418', 'Chevrolet', 'HHR', '2011', '15000', '35', '2014-07-25 00:04:06', '1115', '2014-07-25 00:07:28', '1115', '\n', '[ { \"1\": 1600, \"2\": 5848.299805, \"3\": 2.400000, \"4\": [ 0, 0.200000, -0.100000 ], \"5\": 85, \"6\": 0.700000, \"7\": 0.800000, \"8\": 0.500000, \"9\": 5, \"10\": 155, \"11\": 10, \"12\": 13, \"13\": \"fwd\", \"14\": \"diesel\", \"15\": 5.500000, \"16\": 0.600000, \"17\": false, \"18\": 30, \"19\": 1.400000, \"20\": 0.100000, \"21\": 0, \"22\": 0.350000, \"23\": -0.100000, \"24\": 0.500000, \"25\": 0, \"26\": 0.200000, \"27\": 0.750000, \"28\": 16000, \"29\": 32, \"30\": 0, \"31\": \"small\", \"33\": 0 } ]', '1000', '1', '2', '0');
INSERT INTO `vehicles_shop` VALUES ('670', '568', 'Badland Buggy', 'ST2 SV1000', '2012', '7800', '20', '2014-07-26 05:30:20', '1115', '2014-07-26 18:36:49', '1115', '\n', '[ [ 850, 2500.300049, 1, [ 0, 0, -0.300000 ], 80, 0.650000, 0.880000, 0.540000, 4, 145, 17, 15, \"rwd\", \"petrol\", 6.100000, 0.600000, false, 38, 0.700000, 0.090000, 5, 0.250000, -0.350000, 0.350000, 0, 0.600000, 0.400000, 15000, 1073748740, 3179520, \"small\", \"big\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('671', '578', 'International', '4300 Flatbed', '2009', '35500', '100', '2014-07-27 19:16:31', '1115', '2014-12-23 11:38:16', '1622', '\n', '[ [ 4500, 33187.8984375, 2.2000000476837158, [ 0, 0, -0.20000000298023224 ], 90, 0.64999997615814209, 0.80000001192092896, 0.40000000596046448, 5, 110, 7, 20, \"rwd\", \"diesel\", 3.5, 0.40000000596046448, false, 55, 1.3999999761581421, 0.059999998658895493, 0, 0.44999998807907104, -0.30000001192092896, 0.60000002384185791, 0, 0.44999998807907104, 0.20000000298023224, 5000, 16392, 512, \"long\", \"small\", 2 ] ]', '1000', '1', '5', '0');
INSERT INTO `vehicles_shop` VALUES ('672', '578', 'Peterbilt', '330 Flatbed', '2006', '22000', '70', '2014-07-27 19:18:53', '1115', '2020-05-01 21:30:52', '2545', '\n', '[ [ 5000, 33187.8984375, 2.2999999523162842, [ 0, 0, -0.20000000298023224 ], 90, 0.64999997615814209, 0.80000001192092896, 0.40000000596046448, 5, 110, 6.5, 20, \"rwd\", \"diesel\", 3.5, 0.40000000596046448, false, 55, 1.3999999761581421, 0.059999998658895493, 0, 0.44999998807907104, -0.30000001192092896, 0.60000002384185791, 0, 0.44999998807907104, 0.20000000298023224, 5000, 16392, 512, \"long\", \"small\", 2 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('674', '561', 'Audi', 'RS6 Avant', '2014', '82000', '165', '2014-07-28 15:40:11', '1115', '2015-02-05 03:58:53', '120', '\n', '[ [ 1600, 4500, 1.7999999523162842, [ 0, 0.05000000074505806, -0.11999999731779099 ], 75, 0.64999997615814209, 0.85000002384185791, 0.5, 5, 200, 15, 10, \"awd\", \"petrol\", 7, 0.5, false, 30, 0.89999997615814209, 0.15999999642372131, 0, 0.2800000011920929, -0.10000000149011612, 0.5, 0.30000001192092896, 0.25, 0.60000002384185791, 35000, 10240, 67108864, \"small\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('675', '409', 'Cadillac', 'XTS Limousine', '2014', '85000', '55', '2014-07-29 23:03:43', '1737', '2014-07-29 23:05:38', '1737', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('676', '597', 'Ford', 'Mondeo', '2016', '20500', '20', '2014-08-01 13:31:11', '1737', '2021-03-27 11:05:45', '17826', '\n', null, '1000', '1', '0', null);
INSERT INTO `vehicles_shop` VALUES ('677', '597', 'Ford', 'Mondeo', '2016', '45555', '20', '2014-08-01 13:39:34', '1737', '2021-03-27 11:06:04', '17826', '\n', '[ [ 1600, 4500, 1.799999952316284, [ 0, 0, -0.1500000059604645 ], 75, 0.8500000238418579, 0.8500000238418579, 0.5, 5, 260, 17, 8, \"awd\", \"petrol\", 18, 0.5, false, 36, 1.100000023841858, 0.119999997317791, 0, 0.2800000011920929, -0.2000000029802322, 0.5, 0, 0.2000000029802322, 0.239999994635582, 25000, 1073741824, 270532616, \"long\", \"small\", 0 ] ]', '1000', '1', '0', null);
INSERT INTO `vehicles_shop` VALUES ('678', '528', 'Lenco', 'Bearcat', '2014', '50000', '30', '2014-08-01 13:50:28', '1737', '2014-08-01 14:03:15', '1737', 'For authorized law enforcement agencies only!\n', '[ [ 10000, 10000, 3, [ 0, 0, -0.200000 ], 85, 0.900000, 0.850000, 0.540000, 5, 170, 10, 25, \"awd\", \"diesel\", 6, 0.400000, false, 35, 0.800000, 0.100000, 0, 0.300000, -0.200000, 0.500000, 0, 0.320000, 0.160000, 40000, 16385, 0, \"long\", \"small\", 13 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('679', '427', 'Lenco', 'BEAR', '2014', '50333', '35', '2014-08-01 13:54:40', '1737', '2014-08-01 13:59:00', '1737', 'For authorized LEO factions only!\n', '[ [ 10000, 17333.300781, 3, [ 0, 0.100000, 0 ], 85, 0.950000, 0.800000, 0.480000, 5, 200, 12, 20, \"rwd\", \"diesel\", 5.400000, 0.400000, false, 35, 1.400000, 0.100000, 0, 0.400000, -0.300000, 0.500000, 0, 0.320000, 0.160000, 40000, 16401, 0, \"long\", \"small\", 13 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('683', '456', 'GMC', 'Savana Cutaway', '2014', '30000', '100', '2014-08-04 14:25:46', '1115', '2014-12-23 04:47:37', '1622', '\n', null, '1000', '1', '5', '0');
INSERT INTO `vehicles_shop` VALUES ('684', '423', 'Chevrolet', 'P30', '1987', '10500', '35', '2014-08-04 14:28:38', '1115', '2014-08-08 20:01:16', '1115', '\n', '[ [ 1700, 4108.299805, 3.500000, [ 0, 0, 0 ], 85, 0.750000, 0.750000, 0.500000, 5, 70, 5.600000, 50, \"rwd\", \"diesel\", 4.170000, 0.800000, false, 35, 1.200000, 0.100000, 0, 0.350000, -0.200000, 0.500000, 0, 0.240000, 0.770000, 29000, 136, 2, \"long\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('685', '515', 'Scania', 'R730 Streamline', '2013', '240000', '185', '2014-08-04 15:57:44', '1115', '2014-08-04 16:00:23', '1115', '\n', '[ [ 5000, 28000, 2.500000, [ 0, 0.500000, -0.400000 ], 90, 0.950000, 0.650000, 0.400000, 5, 120, 8, 20, \"rwd\", \"diesel\", 8, 0.300000, false, 35, 0.700000, 0.100000, 0, 0.200000, -0.200000, 0.500000, 0, 0.650000, 0.250000, 35000, 538968072, 512, \"long\", \"small\", 2 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('686', '451', 'Noble', 'M600', '2014', '450000', '295', '2014-08-05 01:49:12', '1115', '2015-02-05 04:11:39', '120', '\n', '[ [ 1200, 3000, 1, [ 0, -0.300000, -0.200000 ], 70, 0.970000, 0.850000, 0.400000, 5, 265, 17.500000, 5, \"rwd\", \"petrol\", 11, 0.500000, false, 30, 1.200000, 0.130000, 0, 0.150000, -0.200000, 0.500000, 0.400000, 0.170000, 0.720000, 95000, 1073750020, 12616705, \"small\", \"small\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('688', '560', 'Mitsubishi', 'Lancer Evolution IX MR FQ-360', '2008', '30000', '55', '2014-08-05 02:48:57', '1115', '2014-08-25 01:41:46', '1107', '\n', '[ [ 1300, 3400, 2, [ 0, 0.100000, -0.100000 ], 75, 0.800000, 0.800000, 0.500000, 5, 210, 13, 5, \"awd\", \"petrol\", 10, 0.500000, false, 30, 1.200000, 0.150000, 0, 0.280000, -0.200000, 0.500000, 0.300000, 0.250000, 0.600000, 35000, 10240, 67108866, \"small\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('689', '567', 'Chevrolet', 'Bel Air Impala Sport Coupe', '1958', '37500', '55', '2014-08-06 16:40:00', '1115', '2019-11-17 17:42:06', '1438', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('690', '484', 'Dufour', 'Arpege', '1979', '31000', '20', '2014-08-06 20:01:16', '1115', '2014-08-06 20:09:46', '1115', '\n', null, '1000', '1', '6', '0');
INSERT INTO `vehicles_shop` VALUES ('691', '448', 'Honda', 'CRF50', '2005', '1000', '0', '2014-08-10 20:28:43', '1115', '2014-08-10 23:54:07', '12', '\n', '[ [ 125, 119.599998, 2, [ 0, 0, -0.300000 ], 103, 1.900000, 0.900000, 0.480000, 3, 60, 17, 2, \"rwd\", \"petrol\", 14, 0.300000, false, 35, 1, 0.150000, 0, 0.120000, -0.200000, 0.500000, 0, 0, 0.110000, 10000, 16777216, 0, \"small\", \"small\", 5 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('693', '510', '[DONATE] Bianchi', 'Speed 2000', '2019', '999999', '0', '2014-08-10 21:53:54', '12', '2020-05-10 13:08:07', '1782', '\n', '[ [ 100, 60, 5, [ 0, 0.05000000074505806, -0.09000000357627869 ], 103, 1.600000023841858, 0.8999999761581421, 0.4799999892711639, 4, 215, 10, 15, \"rwd\", \"petrol\", 19, 0.5, false, 35, 0.8500000238418579, 0.1500000059604645, 0, 0.2000000029802322, -0.1000000014901161, 0.5, 0, 0, 0.1500000059604645, 10000, 1090519040, 2, \"small\", \"small\", 10 ] ]', '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('707', '522', 'Suzuki', 'GSX-R600 SRAD', '1998', '4600', '100', '2014-08-11 17:17:45', '12', '2020-03-13 16:24:33', '745', '\n', null, '1000', '0', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('708', '522', 'Suzuki', 'GSX-R750', '2013', '9899', '15', '2014-08-11 17:22:57', '12', '2014-08-11 17:26:14', '12', '\n', null, '1000', '0', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('710', '522', 'Suzuki', 'GSX-R1000', '2006', '25000', '15', '2014-08-11 17:25:28', '12', '2019-10-11 16:19:35', '1438', '\n', null, '1000', '0', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('711', '462', 'Honda', 'Ruckus', '2006', '2000', '15', '2014-08-11 17:26:24', '1107', '2014-11-15 23:41:12', '1260', '\n', '[ [ 350, 119.59999847412109, 5, [ 0, 0.05000000074505806, -0.10000000149011612 ], 103, 1.7999999523162842, 0.89999997615814209, 0.47999998927116394, 3, 55, 10, 5, \"rwd\", \"petrol\", 14, 0.5, false, 35, 1, 0.15000000596046448, 0, 0.11999999731779099, -0.20000000298023224, 0.5, 0, 0, 0.10999999940395355, 10000, 16777216, 0, \"small\", \"small\", 5 ] ]', '1000', '1', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('712', '600', 'Ford', 'Falcon XR6 Turbo Ute FG', '2012', '31000', '55', '2014-08-13 20:33:27', '1115', '2014-08-13 20:50:21', '1115', '\n', '[ [ 1800, 3800, 2.700000, [ 0, 0.200000, 0 ], 75, 0.680000, 0.700000, 0.480000, 5, 168, 12, 20, \"rwd\", \"diesel\", 8.500000, 0.500000, false, 35, 0.800000, 0.080000, 2, 0.250000, -0.200000, 0.400000, 0.400000, 0.260000, 0.200000, 26000, 1075839040, 1064964, \"long\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('715', '520', 'Lockheed', 'F16', '2001', '15000000', '0', '2014-08-14 07:23:48', '107', '2015-01-03 19:22:13', '55', '\n', null, '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('716', '425', 'Boeing', 'AH-64 Apache', '1999', '12000000', '0', '2014-08-14 07:24:25', '107', '2014-11-19 02:10:52', '1107', '\n', '[ [ 10000, 150000, 0.20000000298023224, [ 0, 0, 0 ], 75, 0.64999997615814209, 0.89999997615814209, 0.5, 1, 200, 6.4000000953674316, 5, \"awd\", \"petrol\", 5, 0.40000000596046448, false, 30, 1, 0.05000000074505806, 0, 0.20000000298023224, -0.20000000298023224, 0.89999997615814209, 0, 0.40000000596046448, 0.5, 99000, 33603584, 4194304, \"long\", \"small\", 14 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('717', '522', 'Honda', 'CBR1000RR', '2013', '43800', '150', '2014-08-14 17:35:28', '12', '2019-10-10 18:22:35', '1438', '\n', '[ [ 400, 200, 4, [ 0, 0.07999999821186066, -0.09000000357627869 ], 103, 1.799999952316284, 0.8999999761581421, 0.4799999892711639, 5, 275, 40, 30, \"rwd\", \"petrol\", 20, 0.5, false, 35, 0.8500000238418579, 0.1500000059604645, 0, 0.1500000059604645, -0.1599999964237213, 0.5, 0, 0, 0.1500000059604645, 10000, 16785408, 2, \"small\", \"small\", 4 ] ]', '1000', '0', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('718', '522', 'Suzuki', 'GSX-R1300 Hayabusa', '2014', '125000', '100', '2014-08-14 17:37:55', '12', '2020-05-01 21:16:15', '2545', '\n', '[ [ 400, 200, 0.100000, [ 0, 0.080000, -0.090000 ], 103, 1.800000, 0.900000, 0.480000, 5, 250, 45, 5, \"rwd\", \"petrol\", 15, 0.500000, false, 27, 0.850000, 0.150000, 0, 0.150000, -0.200000, 0.500000, 0, 0, 0.150000, 10000, 16785408, 2, \"small\", \"small\", 4 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('719', '522', 'Yamaha', 'YZF-R1', '2017', '100000', '200', '2014-08-14 17:41:39', '12', '2019-10-11 16:15:44', '1438', '\n', '[ [ 400, 200, 0.2000000029802322, [ 0, 0.07999999821186066, -0.09000000357627869 ], 103, 1.799999952316284, 0.8999999761581421, 0.4799999892711639, 5, 190, 32, 5, \"rwd\", \"petrol\", 15, 0.5, false, 35, 0.8500000238418579, 0.1500000059604645, 0, 0.1500000059604645, -0.1599999964237213, 0.5, 0, 0, 0.1500000059604645, 10000, 16785408, 2, \"small\", \"small\", 4 ] ]', '1000', '1', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('720', '522', 'Yamaha', 'YZF-R6', '2013', '65000', '175', '2014-08-14 17:41:53', '12', '2019-10-11 16:13:39', '1438', '\n', '[ [ 400, 200, 4, [ 0, 0.07999999821186066, -0.09000000357627869 ], 103, 1.799999952316284, 0.8999999761581421, 0.4799999892711639, 5, 200, 32, 5, \"rwd\", \"petrol\", 15, 0.5, false, 35, 0.8500000238418579, 0.1500000059604645, 0, 0.1500000059604645, -0.1599999964237213, 0.5, 0, 0, 0.1500000059604645, 10000, 16785408, 2, \"small\", \"small\", 4 ] ]', '1000', '1', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('721', '521', 'Honda', 'VFR800', '2007', '9250', '15', '2014-08-15 19:44:42', '12', '2014-11-15 23:02:25', '1260', '\n', '[ [ 500, 200, 4, [ 0, 0.05000000074505806, -0.090000003576278687 ], 103, 1.5, 0.89999997615814209, 0.47999998927116394, 5, 250, 45, 5, \"rwd\", \"petrol\", 15, 0.5, false, 35, 0.85000002384185791, 0.15000000596046448, 0, 0.15000000596046448, -0.20000000298023224, 0.5, 0, 0, 0.10999999940395355, 10000, 16777216, 0, \"small\", \"small\", 4 ] ]', '1000', '1', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('722', '579', 'Porsche', 'Cayenne Turbo S', '2014', '135500', '100', '2014-08-15 19:45:00', '1115', '2015-02-05 03:54:37', '120', '\n', '[ [ 2500, 6000, 1.7000000476837158, [ 0, 0.20000000298023224, -0.30000001192092896 ], 80, 0.89999997615814209, 0.88999998569488525, 0.5, 5, 220, 18, 14, \"awd\", \"petrol\", 7, 0.40000000596046448, false, 35, 0.94999998807907104, 0.20000000298023224, 0, 0.44999998807907104, -0.20000000298023224, 0.5, 0.30000001192092896, 0.43999999761581421, 0.34999999403953552, 40000, 32, 17412, \"long\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('723', '463', 'Honda', 'Fury', '2014', '13390', '20', '2014-08-15 19:46:56', '12', '0000-00-00 00:00:00', '0', '\n', null, '1000', '0', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('724', '468', 'Honda', 'Grom 125', '2014', '2999', '10', '2014-08-15 19:49:10', '12', '2014-08-15 19:50:41', '12', '\n', '[ [ 500, 195, 6, [ 0, 0.050000, -0.090000 ], 103, 1.600000, 0.900000, 0.480000, 5, 85, 15, 15, \"rwd\", \"petrol\", 14, 0.500000, false, 35, 0.850000, 0.150000, 0, 0.150000, -0.200000, 0.500000, 0, 0, 0.150000, 10000, 16777216, 0, \"small\", \"small\", 7 ] ]', '1000', '0', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('725', '463', 'Star', 'Bolt', '2014', '7990', '20', '2014-08-15 19:51:37', '12', '0000-00-00 00:00:00', '0', '\n', null, '1000', '0', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('726', '586', 'Suzuki', 'V-Strom 650 ABS', '2014', '8499', '15', '2014-08-15 19:52:06', '12', '0000-00-00 00:00:00', '0', '\n', null, '1000', '0', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('727', '586', 'Indian', 'Chief Classic', '2014', '18999', '20', '2014-08-15 19:52:54', '12', '0000-00-00 00:00:00', '0', '\n', null, '1000', '0', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('728', '521', 'Yamaha', 'FZ-09', '2014', '7990', '15', '2014-08-15 19:53:47', '12', '2014-11-15 21:38:39', '1260', '\n', null, '1000', '1', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('729', '586', 'Victory', 'Cross Roads 8-Ball', '2014', '15999', '25', '2014-08-15 19:54:16', '12', '0000-00-00 00:00:00', '0', '\n', null, '1000', '0', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('730', '522', 'Ducati', '899 Panigale', '2014', '14995', '15', '2014-08-15 19:57:29', '12', '2014-08-15 20:16:06', '12', '\n', '[ [ 400, 200, 4, [ 0, 0.080000, -0.090000 ], 103, 1.800000, 0.900000, 0.480000, 5, 160, 32, 5, \"rwd\", \"petrol\", 15, 0.500000, false, 35, 0.850000, 0.150000, 0, 0.150000, -0.200000, 0.500000, 0, 0, 0.150000, 10000, 16785408, 2, \"small\", \"small\", 4 ] ]', '1000', '0', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('731', '463', 'Harley-Davidson', 'Sportster Superlow', '2014', '8249', '20', '2014-08-15 19:57:55', '12', '0000-00-00 00:00:00', '0', '\n', null, '1000', '0', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('732', '586', 'Honda', 'CTX700N', '2014', '6999', '15', '2014-08-15 20:01:19', '12', '2020-05-16 10:08:03', '1782', '\n', '[ [ 800, 600, 4, [ 0, 0.1000000014901161, 0 ], 103, 1.399999976158142, 0.8500000238418579, 0.4799999892711639, 4, 190, 40, 5, \"rwd\", \"petrol\", 10, 0.6000000238418579, false, 35, 0.6499999761581421, 0.2000000029802322, 0, 0.09000000357627869, -0.1099999994039536, 0.6000000238418579, 0, 0, 0.239999994635582, 10000, 1090527232, 0, \"small\", \"small\", 8 ] ]', '1000', '0', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('733', '586', 'Ducati', 'Multistrada 1200S Touring', '2013', '12459', '20', '2014-08-15 20:02:47', '12', '0000-00-00 00:00:00', '0', '\n', null, '1000', '0', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('734', '522', 'MV Agusta', 'F4', '2014', '28900', '20', '2014-08-15 20:10:31', '12', '2014-08-15 20:15:00', '12', '\n', '[ [ 400, 200, 0.100000, [ 0, 0.080000, -0.090000 ], 103, 1.800000, 0.900000, 0.480000, 5, 190, 38, 5, \"rwd\", \"petrol\", 15, 0.500000, false, 35, 0.850000, 0.150000, 0, 0.150000, -0.200000, 0.500000, 0, 0, 0.150000, 10000, 16785408, 2, \"small\", \"small\", 4 ] ]', '1000', '0', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('735', '461', 'BMW', 'R nineT', '2014', '14900', '100', '2014-08-15 20:18:52', '12', '2020-03-13 16:18:49', '745', '\n', '[ [ 500, 161.6999969482422, 4, [ 0, 0.05000000074505806, -0.09000000357627869 ], 103, 1.600000023841858, 0.8999999761581421, 0.4799999892711639, 5, 190, 20, 5, \"rwd\", \"petrol\", 15, 0.5, false, 35, 0.8500000238418579, 0.1500000059604645, 0, 0.1500000059604645, -0.1599999964237213, 0.5, 0, 0, 0.1500000059604645, 10000, 16785408, 0, \"small\", \"small\", 4 ] ]', '1000', '0', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('736', '522', 'BMW', 'S 1000 RR', '2014', '15150', '20', '2014-08-15 20:21:01', '12', '2019-10-24 12:42:22', '1438', '\n', '[ [ 400, 200, 1, [ 0, 0.080000, -0.090000 ], 103, 1.800000, 0.900000, 0.480000, 5, 190, 34, 5, \"rwd\", \"petrol\", 15, 0.500000, false, 35, 0.850000, 0.150000, 0, 0.150000, -0.200000, 0.500000, 0, 0, 0.150000, 10000, 16785408, 2, \"small\", \"small\", 4 ] ]', '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('737', '522', 'BMW', 'HP4', '2014', '20300', '25', '2014-08-15 20:22:11', '12', '2014-08-15 20:29:10', '12', '\n', '[ [ 259, 200, 0.100000, [ 0, 0.080000, -0.090000 ], 103, 2.200000, 0.900000, 0.480000, 5, 190, 38, 5, \"rwd\", \"petrol\", 15, 0.500000, false, 35, 0.850000, 0.150000, 0, 0.150000, -0.200000, 0.500000, 0, 0, 0.150000, 10000, 16785408, 2, \"small\", \"small\", 4 ] ]', '1000', '0', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('738', '586', 'Honda', 'GL-1500', '2013', '45000', '25', '2014-08-15 20:23:24', '12', '2020-05-24 00:34:24', '1782', '\n', null, '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('739', '586', 'Honda', 'CTX 1300', '2014', '15999', '20', '2014-08-15 20:24:24', '12', '0000-00-00 00:00:00', '0', '\n', null, '1000', '0', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('740', '522', 'Honda', 'Interceptor', '2014', '12499', '15', '2014-08-15 20:25:17', '12', '0000-00-00 00:00:00', '0', '\n', null, '1000', '0', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('741', '586', 'Indian', 'Chief Vintage', '2014', '20999', '25', '2014-08-15 20:26:03', '12', '0000-00-00 00:00:00', '0', '\n', null, '1000', '0', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('742', '586', 'KTM', '1190 Adventure', '2014', '16499', '20', '2014-08-15 20:26:32', '12', '2014-08-15 20:50:37', '12', '\n', '[ [ 500, 600, 4, [ 0, 0.100000, 0 ], 103, 1.400000, 0.850000, 0.480000, 4, 190, 16, 5, \"rwd\", \"petrol\", 10, 0.600000, false, 35, 0.650000, 0.200000, 0, 0.090000, -0.100000, 0.600000, 0, 0, 0.240000, 10000, 1090527232, 0, \"small\", \"small\", 8 ] ]', '1000', '0', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('743', '463', 'Victory', 'Gunner', '2014', '12999', '20', '2014-08-15 20:27:00', '12', '0000-00-00 00:00:00', '0', '\n', null, '1000', '0', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('744', '463', 'Victory', 'Judge', '2013', '12549', '15', '2014-08-15 20:32:27', '12', '0000-00-00 00:00:00', '0', '\n', null, '1000', '0', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('745', '521', 'Suzuki', 'SFV 650', '2013', '7549', '15', '2014-08-15 20:33:13', '12', '2014-11-15 23:32:02', '1260', '\n', '[ [ 500, 200, 4, [ 0, 0.05000000074505806, -0.090000003576278687 ], 103, 1.5, 0.89999997615814209, 0.47999998927116394, 5, 160, 35, 5, \"rwd\", \"petrol\", 15, 0.5, false, 35, 0.85000002384185791, 0.15000000596046448, 0, 0.15000000596046448, -0.20000000298023224, 0.5, 0, 0, 0.10999999940395355, 10000, 16777216, 0, \"small\", \"small\", 4 ] ]', '1000', '0', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('746', '468', 'Ducati', 'Hypermotard 821', '2013', '12459', '15', '2014-08-15 20:36:05', '12', '0000-00-00 00:00:00', '0', '\n', null, '1000', '0', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('747', '522', 'Triumph', 'Daytona 675R', '2013', '10549', '15', '2014-08-15 20:36:52', '12', '2014-08-15 20:42:01', '12', '\n', '[ [ 400, 200, 4, [ 0, 0.080000, -0.090000 ], 103, 1.800000, 0.900000, 0.480000, 5, 190, 24, 5, \"rwd\", \"petrol\", 15, 0.500000, false, 35, 0.850000, 0.150000, 0, 0.150000, -0.200000, 0.500000, 0, 0, 0.150000, 10000, 16785408, 2, \"small\", \"small\", 4 ] ]', '1000', '0', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('748', '468', 'Husaberg', 'FE570S', '2011', '6749', '10', '2014-08-15 20:41:37', '12', '0000-00-00 00:00:00', '0', '\n', null, '1000', '0', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('749', '522', 'Honda', 'CBR1000XX Blackbird', '2007', '85500', '150', '2014-08-15 20:51:47', '12', '2019-10-11 16:11:29', '1438', '\n', '[ [ 400, 200, 4, [ 0, 0.080000, -0.090000 ], 103, 1.800000, 0.900000, 0.480000, 5, 190, 37, 5, \"rwd\", \"petrol\", 15, 0.500000, false, 35, 0.850000, 0.150000, 0, 0.150000, -0.200000, 0.500000, 0, 0, 0.150000, 10000, 16785408, 2, \"small\", \"small\", 4 ] ]', '1000', '0', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('750', '522', 'Aprilia', 'RSV 1000 R', '2010', '111449', '290', '2014-08-15 20:52:49', '12', '2019-10-10 18:27:12', '1438', '\n', '[ [ 300, 200, 2, [ 0, 0.079999998211860657, -0.090000003576278687 ], 103, 1.7999999523162842, 0.89999997615814209, 0.47999998927116394, 5, 190, 36, 5, \"rwd\", \"petrol\", 15, 0.5, false, 35, 0.85000002384185791, 0.15000000596046448, 0, 0.15000000596046448, -0.20000000298023224, 0.5, 0, 0, 0.15000000596046448, 10000, 16785408, 2, \"small\", \"small\", 4 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('751', '522', 'Suzuki', 'GSX-R1300 Hayabusa', '2016', '140000', '120', '2014-08-15 20:58:44', '12', '2020-06-06 02:06:33', '744', '\n', '[ [ 400, 200, 4, [ 0, 0.080000, -0.090000 ], 103, 1.800000, 0.900000, 0.480000, 5, 190, 43, 5, \"rwd\", \"petrol\", 15, 0.500000, false, 27, 0.850000, 0.150000, 0, 0.150000, -0.200000, 0.500000, 0, 0, 0.150000, 10000, 16785408, 2, \"small\", \"small\", 4 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('753', '415', 'Ferrari', 'Testarossa', '1987', '105000', '80', '2014-08-16 15:14:29', '1115', '2015-01-08 03:14:59', '1260', '\n', '[ [ 1200, 3000, 1.7000000476837158, [ 0, -0.20000000298023224, -0.20000000298023224 ], 70, 0.80000001192092896, 0.89999997615814209, 0.5, 5, 235, 15.5, 9, \"rwd\", \"petrol\", 11.100000381469727, 0.5, false, 35, 0.80000001192092896, 0.20000000298023224, 0, 0.10000000149011612, -0.05000000074505806, 0.5, 0.60000002384185791, 0.40000000596046448, 0.54000002145767212, 105000, 3221233664, 2129920, \"long\", \"long\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('754', '567', 'Oldsmobile', 'Jetstar 88', '1964', '12549', '25', '2014-08-17 02:59:19', '12', '2014-11-01 20:59:50', '7431', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('755', '592', 'Lockheed', 'C-5 Galaxy', '1970', '10000000', '1000', '2014-08-18 16:45:54', '1107', '2014-08-20 18:56:30', '1622', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('756', '560', 'Ford', 'Fusion', '2015', '23000', '20', '2014-08-18 16:52:57', '1107', '2014-12-26 01:37:18', '1622', '\n', '[ [ 1500, 3400, 1.3999999761581421, [ 0, 0.10000000149011612, -0.10000000149011612 ], 75, 0.80000001192092896, 0.80000001192092896, 0.5, 5, 200, 8.8000001907348633, 10, \"fwd\", \"petrol\", 10, 0.5, false, 30, 1.2000000476837158, 0.15000000596046448, 0, 0.2800000011920929, -0.11999999731779099, 0.5, 0.30000001192092896, 0.25, 0.60000002384185791, 35000, 10240, 67108866, \"small\", \"small\", 0 ] ]', '1000', '1', '2', '0');
INSERT INTO `vehicles_shop` VALUES ('757', '560', 'Ford', 'Fusion Titanium', '2015', '35000', '20', '2014-08-18 16:53:29', '1107', '2014-12-23 04:14:37', '1622', '\n', '[ [ 1400, 3400, 1.400000, [ 0, 0.100000, -0.100000 ], 75, 0.800000, 0.800000, 0.500000, 5, 200, 11.200000, 15, \"awd\", \"petrol\", 10, 0.500000, false, 30, 1.200000, 0.150000, 0, 0.280000, -0.200000, 0.500000, 0.300000, 0.250000, 0.600000, 35000, 10240, 67108866, \"small\", \"small\", 0 ] ]', '1000', '1', '1', '0');
INSERT INTO `vehicles_shop` VALUES ('758', '521', 'Suzuki', 'SV650', '2002', '5449', '20', '2014-08-18 20:52:43', '12', '2014-11-15 23:34:27', '1260', '\n', '[ [ 500, 200, 4, [ 0, 0.05000000074505806, -0.090000003576278687 ], 103, 1.5, 0.89999997615814209, 0.47999998927116394, 5, 220, 35, 5, \"rwd\", \"petrol\", 15, 0.5, false, 35, 0.85000002384185791, 0.15000000596046448, 0, 0.15000000596046448, -0.20000000298023224, 0.5, 0, 0, 0.10999999940395355, 10000, 16777216, 0, \"small\", \"small\", 4 ] ]', '1000', '0', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('759', '592', 'Boeing', 'C-17 Globemaster III', '1995', '10000000', '1000', '2014-08-20 18:57:30', '1622', '2014-08-20 19:00:18', '1622', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('760', '577', 'Boeing', '737-800', '1997', '10000000', '1250', '2014-08-20 19:01:26', '1622', '2014-08-20 22:09:04', '1107', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('761', '577', 'Airbus', 'A320', '1994', '9000000', '900', '2014-08-20 19:02:25', '1622', '2014-08-20 22:06:46', '1107', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('762', '511', 'Piper', 'PA-34-200T Seneca V', '1997', '200000', '130', '2014-08-20 19:13:52', '1622', '2020-05-29 14:53:25', '744', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('763', '593', 'Cessna', '172S Skyhawk', '1998', '110000', '300', '2014-08-20 19:15:29', '1622', '2014-11-18 22:49:51', '1107', '\n', '[ [ 5000, 27083.30078125, 12, [ 0, 0.30000001192092896, 0 ], 75, 0.64999997615814209, 0.89999997615814209, 0.5, 1, 200, 6.4000000953674316, 5, \"awd\", \"petrol\", 1.5, 0.40000000596046448, false, 45, 1.5, 0.15000000596046448, 0, 0.5, -0.10000000149011612, 0.20000000298023224, 0, 0.5, 0.75, 45000, 67108864, 4194304, \"long\", \"small\", 13 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('764', '553', 'Bombardier', 'Dash 8 Q200', '1995', '1000000', '400', '2014-08-20 19:22:11', '1622', '2020-05-01 19:00:08', '2545', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('765', '519', 'Bombardier', 'Learjet 45', '1998', '2000000', '700', '2014-08-20 19:24:24', '1622', '2014-08-20 23:43:08', '1107', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('766', '519', 'Cessna', 'Mustang', '2006', '1000000', '400', '2014-08-20 19:26:55', '1622', '2020-05-01 18:59:58', '2545', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('767', '460', 'Cessna', '172 Skyhawk Floatplane', '1970', '150000', '400', '2014-08-20 19:28:16', '1622', '2020-03-13 16:22:28', '745', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('768', '476', 'North American', 'P-51 Mustang', '1942', '850000', '200', '2014-08-20 19:31:36', '1622', '2014-11-11 01:53:46', '1107', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('769', '562', 'Nissan', 'GT-R', '2015', '305000', '165', '2014-08-20 23:35:42', '1107', '2019-10-27 13:27:28', '1438', '\n', '[ [ 1500, 3500, 2.200000047683716, [ 0, 0.300000011920929, -0.1000000014901161 ], 75, 0.699999988079071, 0.8999999761581421, 0.5, 5, 237, 20, 6, \"rwd\", \"petrol\", 38, 0.5, false, 35, 2, 0.2000000029802322, 0, 0.2800000011920929, -0.05000000074505806, 0.6000000238418579, 0.300000011920929, 0.25, 0.6000000238418579, 35000, 1073752068, 67108865, \"small\", \"small\", 1 ] ]', '1000', '1', '1', '0');
INSERT INTO `vehicles_shop` VALUES ('771', '489', 'Land Rover', 'Defender 90', '2014', '42000', '20', '2014-08-21 02:30:04', '1107', '2014-12-23 04:19:26', '1622', '\n', '[ [ 2000, 7604.2001953125, 2.5, [ 0, 0, -0.89999997615814209 ], 80, 0.94999998807907104, 0.85000002384185791, 0.5, 5, 160, 9, 30, \"awd\", \"petrol\", 7, 0.60000002384185791, false, 35, 1, 0.10000000149011612, 0, 0.44999998807907104, -0.20000000298023224, 0.5, 0.30000001192092896, 0.43999999761581421, 0.34999999403953552, 40000, 16416, 1048580, \"long\", \"small\", 0 ] ]', '1000', '1', '1', '0');
INSERT INTO `vehicles_shop` VALUES ('773', '489', 'Land Rover', 'Defender 90', '1984', '13450', '25', '2014-08-22 01:44:58', '12', '0000-00-00 00:00:00', '0', '\n', null, '1000', '1', '2', '0');
INSERT INTO `vehicles_shop` VALUES ('775', '552', 'Chevrolet', 'Silverado 1500', '2000', '15450', '35', '2014-08-23 01:45:58', '12', '2014-08-23 01:48:34', '12', '\n', null, '1000', '1', '5', '0');
INSERT INTO `vehicles_shop` VALUES ('776', '552', 'Ford', 'F-150 XL', '2000', '14549', '300', '2014-08-23 01:48:15', '12', '2020-03-13 16:36:47', '745', '\n', '[ { \"1\": 2600, \"2\": 8666.7001953125, \"3\": 3, \"4\": [ 0, 0, 0 ], \"5\": 80, \"6\": 0.85000002384185791, \"7\": 0.69999998807907104, \"8\": 0.46000000834465027, \"9\": 5, \"10\": 160, \"11\": 7.1999998092651367, \"12\": 10, \"13\": \"rwd\", \"14\": \"diesel\", \"15\": 6, \"16\": 0.80000001192092896, \"17\": false, \"18\": 30, \"19\": 1.7999999523162842, \"20\": 0.070000000298023224, \"21\": 0, \"22\": 0.34999999403953552, \"23\": -0.20000000298023224, \"24\": 0.5, \"25\": 0, \"26\": 0.20000000298023224, \"27\": 0.5, \"28\": 20000, \"29\": 1, \"30\": 0, \"31\": \"long\", \"33\": 13 } ]', '1000', '1', '5', '0');
INSERT INTO `vehicles_shop` VALUES ('777', '611', 'Novae', 'Sure-Trac 7x14', '2014', '7749', '0', '2014-08-23 01:51:54', '12', '2014-10-10 21:59:30', '1622', '\n', '[ [ 250, 1354.199951171875, 5, [ 0, 0, 0 ], 70, 1, 0.85000002384185791, 0.5, 3, 160, 8, 30, \"rwd\", \"electric\", 5, 0.5, false, 30, 2, 0.090000003576278687, 0, 0.25, -0.10000000149011612, 0.5, 0, 0.25999999046325684, 0.5, 9000, 12544, 4, \"small\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('778', '552', 'Dodge', 'Ram 1500', '2003', '17349', '35', '2014-08-23 01:53:34', '12', '2014-09-15 01:40:00', '249', '\n', '[ { \"1\": 2600, \"2\": 8666.7001953125, \"3\": 3, \"4\": [ 0, 0, 0 ], \"5\": 80, \"6\": 0.85000002384185791, \"7\": 0.69999998807907104, \"8\": 0.46000000834465027, \"9\": 5, \"10\": 175, \"11\": 10, \"12\": 10, \"13\": \"rwd\", \"14\": \"diesel\", \"15\": 6, \"16\": 0.80000001192092896, \"17\": false, \"18\": 30, \"19\": 1.7999999523162842, \"20\": 0.070000000298023224, \"21\": 0, \"22\": 0.34999999403953552, \"23\": -0.20000000298023224, \"24\": 0.30000001192092896, \"25\": 0, \"26\": 0.20000000298023224, \"27\": 0.5, \"28\": 20000, \"29\": 1, \"30\": 0, \"31\": \"long\", \"33\": 13 } ]', '1000', '1', '5', '0');
INSERT INTO `vehicles_shop` VALUES ('779', '552', 'Dodge', 'Ram 3500', '2005', '22349', '40', '2014-08-23 01:55:26', '12', '2014-09-05 16:42:58', '1107', '\n', '[ { \"1\": 2600, \"2\": 8666.7001953125, \"3\": 2.5, \"4\": [ 0, 0, 0 ], \"5\": 80, \"6\": 0.89999997615814209, \"7\": 0.69999998807907104, \"8\": 0.46000000834465027, \"9\": 5, \"10\": 200, \"11\": 13, \"12\": 8, \"13\": \"awd\", \"14\": \"diesel\", \"15\": 6, \"16\": 0.80000001192092896, \"17\": false, \"18\": 33, \"19\": 1.7999999523162842, \"20\": 0.070000000298023224, \"21\": 0, \"22\": 0.34999999403953552, \"23\": -0.20000000298023224, \"24\": 0.30000001192092896, \"25\": 0, \"26\": 0.20000000298023224, \"27\": 0.5, \"28\": 20000, \"29\": 1, \"30\": 0, \"31\": \"long\", \"33\": 13 } ]', '1000', '1', '5', '0');
INSERT INTO `vehicles_shop` VALUES ('780', '533', 'Mercedes-Benz', 'SLK 55 AMG', '2014', '71825', '50', '2014-08-23 17:01:28', '1107', '2014-08-23 17:45:46', '1107', '\n', '[ [ 1600, 4500, 1.7999999523162842, [ 0, 0, -0.15000000596046448 ], 75, 0.64999997615814209, 0.89999997615814209, 0.5, 5, 200, 15, 25, \"rwd\", \"petrol\", 7, 0.5, false, 30, 1.1000000238418579, 0.090000003576278687, 0, 0.30000001192092896, -0.10000000149011612, 0.5, 0.30000001192092896, 0.25, 0.60000002384185791, 35000, 1073752064, 0, \"small\", \"small\", 19 ] ]', '1000', '1', '2', '0');
INSERT INTO `vehicles_shop` VALUES ('781', '485', 'TransAir', 'Baggage Utility', '1999', '4001', '10', '2014-08-26 18:43:43', '1107', '2014-08-26 18:46:32', '1107', '\n', '[ [ 1000, 1354.199951171875, 3, [ 0, 0.40000000596046448, -0.20000000298023224 ], 70, 1, 0.85000002384185791, 0.5, 3, 70, 9, 30, \"rwd\", \"electric\", 5, 0.5, false, 30, 2, 0.090000003576278687, 0, 0.25, -0.10000000149011612, 0.5, 0, 0.25999999046325684, 0.5, 9000, 13056, 4, \"small\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('782', '608', 'TransAir', '10 Feet stairs', '2003', '3001', '10', '2014-08-26 18:48:02', '1107', '0000-00-00 00:00:00', '0', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('783', '598', 'Ford', 'FMondeo', '2016', '59000', '20', '2014-08-27 21:53:03', '1107', '2021-03-27 11:04:59', '17826', '\n', '[ [ 2068, 4500, 1.2000000476837158, [ 0, 0.40000000596046448, -0.34999999403953552 ], 75, 1.1100000143051147, 0.85000002384185791, 0.47999998927116394, 5, 225, 20, 8, \"awd\", \"petrol\", 10, 0.5, false, 46, 1, 0.20000000298023224, 0, 0.2800000011920929, -0.10000000149011612, 0.5, 0, 0.20000000298023224, 0.23999999463558197, 25000, 1073741824, 270532616, \"long\", \"small\", 0 ] ]', '1000', '1', '0', null);
INSERT INTO `vehicles_shop` VALUES ('786', '604', 'Rolls-Royce', 'Silver Shadow', '1977', '5500', '0', '2014-08-31 14:35:46', '1115', '0000-00-00 00:00:00', '0', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('788', '496', 'Volkswagen', 'Golf VII GTI', '2014', '75000', '400', '2014-09-10 17:43:45', '1107', '2020-03-13 16:11:07', '745', '\n', '[ [ 1000, 2141.699951171875, 1.7999999523162842, [ 0, 0, -0.10000000149011612 ], 50, 0.85000002384185791, 0.85000002384185791, 0.5, 5, 200, 15, 5, \"fwd\", \"petrol\", 11, 0.40000000596046448, false, 30, 1.3999999761581421, 0.10000000149011612, 0, 0.2800000011920929, -0.10000000149011612, 0.5, 0, 0.25, 0.5, 35000, 3221225472, 12582912, \"small\", \"small\", 0 ] ]', '1000', '1', '1', '0');
INSERT INTO `vehicles_shop` VALUES ('789', '462', 'Yamaha', 'Aerox', '2012', '4000', '15', '2014-09-10 17:48:06', '1107', '2014-11-16 00:04:18', '1260', '\n', '[ [ 350, 119.59999847412109, 5, [ 0, 0.05000000074505806, -0.10000000149011612 ], 103, 1.7999999523162842, 0.89999997615814209, 0.47999998927116394, 3, 70, 12, 5, \"rwd\", \"petrol\", 14, 0.5, false, 35, 1, 0.15000000596046448, 0, 0.11999999731779099, -0.20000000298023224, 0.5, 0, 0, 0.10999999940395355, 10000, 16777216, 0, \"small\", \"small\", 5 ] ]', '1000', '1', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('797', '549', 'Dodge', 'Dart', '1968', '28995', '20', '2014-09-11 21:21:56', '1107', '0000-00-00 00:00:00', '0', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('798', '549', 'Chevrolet', 'Corvair', '1966', '10450', '20', '2014-09-11 21:24:20', '1107', '0000-00-00 00:00:00', '0', '\n', null, '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('799', '579', 'Audi', 'Q7 (6.0 V12 TDI)', '2012', '154390', '290', '2014-09-11 21:25:49', '1107', '2019-10-23 04:17:44', '1438', '\n', '[ [ 2500, 6000, 1, [ 0, 0, -0.34000000357627869 ], 80, 0.80000001192092896, 0.88999998569488525, 0.5, 5, 220, 13.5, 4, \"awd\", \"petrol\", 7, 0.40000000596046448, false, 35, 1.2000000476837158, 0.05000000074505806, 0, 0.44999998807907104, -0.10000000149011612, 0.40000000596046448, 0.30000001192092896, 0.43999999761581421, 0.34999999403953552, 40000, 32, 17412, \"long\", \"small\", 0 ] ]', '1000', '1', '1', '0');
INSERT INTO `vehicles_shop` VALUES ('800', '477', 'Mazda', 'RX-7 Twin Turbo', '2000', '32000', '35', '2014-09-11 21:26:17', '1107', '2014-12-27 21:30:15', '55', '\n', '[ [ 1400, 2979.699951171875, 2, [ 0, 0.20000000298023224, -0.10000000149011612 ], 70, 0.80000001192092896, 0.80000001192092896, 0.50999999046325684, 5, 190, 14, 10, \"rwd\", \"petrol\", 11.100000381469727, 0.5, false, 45, 1.2000000476837158, 0.10000000149011612, 0, 0.31000000238418579, -0.20000000298023224, 0.5, 0.30000001192092896, 0.23999999463558197, 0.60000002384185791, 45000, 0, 12582912, \"small\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('801', '538', 'British Rail', 'Class 88', '2014', '150000', '100', '2014-09-13 03:19:54', '1695', '2014-09-14 08:14:29', '1695', '\n', '[ [ 10000, 65000, 0.10000000149011612, [ 0, 0, 0 ], 90, 0.57999998331069946, 0.80000001192092896, 1, 4, 0.10000000149011612, 0.10000000149011612, 0.10000000149011612, \"rwd\", \"diesel\", 3.1700000762939453, 0.40000000596046448, false, 30, 1.3999999761581421, 0.059999998658895493, 0, 0.44999998807907104, -0.10000000149011612, 0.60000002384185791, 0, 0.64999997615814209, 0.20000000298023224, 5000, 8, 512, \"long\", \"small\", 2 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('802', '570', 'British Rail', 'Class 88', '2014', '50000', '75', '2014-09-13 03:54:57', '1695', '0000-00-00 00:00:00', '0', 'SAPT\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('803', '468', 'Yamaha', 'DT125X', '2008', '2500', '15', '2014-09-13 22:40:03', '1260', '2014-09-14 00:28:12', '1260', '\n', '[ [ 500, 195, 5, [ 0, 0.05000000074505806, -0.090000003576278687 ], 103, 1.6000000238418579, 0.89999997615814209, 0.47999998927116394, 5, 100, 20, 5, \"rwd\", \"petrol\", 14, 0.5, false, 35, 0.85000002384185791, 0.15000000596046448, 0, 0.15000000596046448, -0.20000000298023224, 0.5, 0, 0, 0.15000000596046448, 10000, 16777216, 0, \"small\", \"small\", 7 ] ]', '1000', '1', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('804', '462', 'Yamaha', 'Morphous 250', '2008', '4500', '500', '2014-09-13 23:18:56', '1260', '2020-03-13 16:09:06', '745', '\n', '[ [ 350, 119.59999847412109, 5, [ 0, 0.05000000074505806, -0.10000000149011612 ], 103, 1.7999999523162842, 0.89999997615814209, 0.47999998927116394, 3, 83, 12, 5, \"rwd\", \"petrol\", 14, 0.5, false, 35, 1, 0.15000000596046448, 0, 0.11999999731779099, -0.20000000298023224, 0.5, 0, 0, 0.10999999940395355, 10000, 16777216, 0, \"small\", \"small\", 5 ] ]', '1000', '1', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('805', '522', 'Kawasaki', 'Ninja ZX8R', '2017', '115000', '250', '2014-09-14 00:13:47', '1260', '2019-10-10 18:58:37', '1438', '\n', '[ [ 400, 200, 4, [ 0, 0.07999999821186066, -0.09000000357627869 ], 103, 1.799999952316284, 0.8999999761581421, 0.4799999892711639, 5, 200, 36, 5, \"rwd\", \"petrol\", 15, 0.5, false, 35, 0.8500000238418579, 0.1500000059604645, 0, 0.1500000059604645, -0.1599999964237213, 0.5, 0, 0, 0.1500000059604645, 10000, 16785408, 2, \"small\", \"small\", 4 ] ]', '1000', '0', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('806', '521', 'Kawasaki', 'Z1000', '2003', '13000', '30', '2014-09-14 00:18:55', '1260', '2014-09-14 00:19:29', '1260', '\n', null, '1000', '1', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('807', '461', 'Kawasaki', 'ZZ-R1200', '2005', '12000', '25', '2014-09-14 00:24:44', '1260', '2014-09-14 00:25:10', '1260', '\n', null, '1000', '1', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('808', '462', 'Yamaha', 'Vino Classic', '2014', '2500', '10', '2014-09-14 00:27:36', '1260', '2014-09-14 00:27:49', '1260', '\n', null, '1000', '1', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('809', '462', 'Yamaha', 'Zuma 50F', '2014', '2500', '5', '2014-09-14 00:30:26', '1260', '2014-09-14 00:30:37', '1260', '\n', null, '1000', '1', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('810', '462', 'Yamaha', 'Vox', '2012', '1500', '5', '2014-09-14 00:32:29', '1260', '2014-09-14 00:32:35', '1260', '\n', null, '1000', '1', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('812', '601', 'TOMA', 'TOMA', '1985', '165000', '100', '2014-09-15 12:16:23', '1695', '2020-04-28 05:49:53', '744', '\n', '[ [ 10000, 10000, 2.5, [ 0, 0, -0.10000000149011612 ], 85, 0.64999997615814209, 0.69999998807907104, 0.46000000834465027, 5, 110, 9.6000003814697266, 30, \"awd\", \"diesel\", 6.4000000953674316, 0.40000000596046448, false, 27, 0.69999998807907104, 0.079999998211860657, 1, 0.30000001192092896, -0.375, 0.5, 0, 0.31999999284744263, 0.059999998658895493, 40000, 8912912, 16777216, \"long\", \"small\", 13 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('813', '437', 'Volvo ', '9900', '2014', '85000', '65', '2014-09-17 01:11:13', '1622', '0000-00-00 00:00:00', '0', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('814', '437', 'Scania', 'K-series', '2014', '85000', '65', '2014-09-17 01:11:47', '1622', '0000-00-00 00:00:00', '0', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('815', '462', 'Yamaha', 'Aerox R', '2014', '4500', '15', '2014-09-17 19:12:44', '1622', '2014-11-15 23:37:47', '1260', '\n', '[ [ 350, 119.59999847412109, 5, [ 0, 0.05000000074505806, -0.10000000149011612 ], 103, 1.7999999523162842, 0.89999997615814209, 0.47999998927116394, 3, 40, 15, 5, \"rwd\", \"petrol\", 14, 0.5, false, 35, 1, 0.15000000596046448, 0, 0.11999999731779099, -0.20000000298023224, 0.5, 0, 0, 0.10999999940395355, 10000, 16777216, 0, \"small\", \"small\", 5 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('816', '462', 'Piaggio', 'Vespa LX 50', '2012', '3500', '10', '2014-09-19 20:03:43', '1260', '2014-09-19 21:12:55', '1260', '\n', '[ [ 350, 119.59999847412109, 5, [ 0, 0.05000000074505806, -0.10000000149011612 ], 103, 1.7999999523162842, 0.89999997615814209, 0.47999998927116394, 3, 75, 15, 5, \"rwd\", \"petrol\", 14, 0.5, false, 35, 1, 0.15000000596046448, 0, 0.11999999731779099, -0.20000000298023224, 0.5, 0, 0, 0.10999999940395355, 10000, 16777216, 0, \"small\", \"small\", 5 ] ]', '1000', '1', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('817', '521', 'BMW', 'R 1150 R', '2005', '10000', '25', '2014-09-19 20:50:01', '1260', '2014-09-19 20:51:27', '1260', '\n', '[ [ 500, 200, 4, [ 0, 0.05000000074505806, -0.090000003576278687 ], 103, 1.5, 0.89999997615814209, 0.47999998927116394, 5, 102, 20, 5, \"rwd\", \"petrol\", 15, 0.5, false, 35, 0.85000002384185791, 0.15000000596046448, 0, 0.15000000596046448, -0.20000000298023224, 0.5, 0, 0, 0.10999999940395355, 10000, 16777216, 0, \"small\", \"small\", 4 ] ]', '1000', '1', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('818', '461', 'BMW', 'R 1200 R', '2006', '12000', '25', '2014-09-19 20:55:24', '1260', '2014-09-19 20:58:57', '1260', '\n', '[ [ 500, 161.69999694824219, 4, [ 0, 0.05000000074505806, -0.090000003576278687 ], 103, 1.6000000238418579, 0.89999997615814209, 0.47999998927116394, 5, 108, 20, 5, \"rwd\", \"petrol\", 15, 0.5, false, 35, 0.85000002384185791, 0.15000000596046448, 0, 0.15000000596046448, -0.20000000298023224, 0.5, 0, 0, 0.15000000596046448, 10000, 16785408, 0, \"small\", \"small\", 4 ] ]', '1000', '1', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('819', '468', 'BMW', 'G650X', '2007', '5000', '15', '2014-09-19 21:00:48', '1260', '2014-09-19 21:09:03', '1260', '\n', '[ [ 500, 195, 5, [ 0, 0.05000000074505806, -0.090000003576278687 ], 103, 1.6000000238418579, 0.89999997615814209, 0.47999998927116394, 5, 88, 20, 5, \"rwd\", \"petrol\", 14, 0.5, false, 35, 0.85000002384185791, 0.15000000596046448, 0, 0.15000000596046448, -0.20000000298023224, 0.5, 0, 0, 0.15000000596046448, 10000, 16777216, 0, \"small\", \"small\", 7 ] ]', '1000', '1', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('820', '522', 'BMW', 'F 800 R', '2015', '38900', '150', '2014-09-19 21:06:10', '1260', '2019-10-10 18:22:47', '1438', '\n', '[ [ 400, 200, 4, [ 0, 0.07999999821186066, -0.09000000357627869 ], 103, 1.799999952316284, 0.8999999761581421, 0.4799999892711639, 5, 190, 26, 7, \"rwd\", \"petrol\", 15, 0.5, false, 35, 0.8500000238418579, 0.1500000059604645, 0, 0.1500000059604645, -0.1599999964237213, 0.5, 0, 0, 0.1500000059604645, 10000, 16785408, 2, \"small\", \"small\", 4 ] ]', '1000', '1', '3', '0');
INSERT INTO `vehicles_shop` VALUES ('822', '426', 'Ford', 'Taurus', '2015', '45555', '30', '2014-09-26 16:04:14', '1107', '2014-12-27 02:57:04', '55', '\n', '[ [ 1600, 3921.300048828125, 1.5, [ 0, -0.40000000596046448, 0 ], 75, 0.89999997615814209, 0.85000002384185791, 0.40000000596046448, 5, 140, 12, 8, \"rwd\", \"petrol\", 10, 0.5, false, 42, 1.2999999523162842, 0.11999999731779099, 0, 0.2800000011920929, -0.10000000149011612, 0.40000000596046448, 0, 0.20000000298023224, 0.23999999463558197, 25000, 1073741824, 270532616, \"long\", \"small\", 0 ] ]', '1000', '1', '1', '0');
INSERT INTO `vehicles_shop` VALUES ('823', '579', 'Audi', 'Q7 TDI', '2007', '35578', '35', '2014-09-30 21:31:59', '1107', '2014-09-30 23:34:39', '1107', '\n', '[ [ 2500, 6000, 2.7000000476837158, [ 0, 0, -0.20000000298023224 ], 80, 0.74000000953674316, 0.88999998569488525, 0.47999998927116394, 5, 160, 13, 25, \"awd\", \"petrol\", 7, 0.40000000596046448, false, 35, 1, 0.05000000074505806, 0, 0.44999998807907104, -0.20000000298023224, 0.40000000596046448, 0.30000001192092896, 0.43999999761581421, 0.34999999403953552, 40000, 32, 17412, \"long\", \"small\", 0 ] ]', '1000', '1', '2', '0');
INSERT INTO `vehicles_shop` VALUES ('824', '562', 'BMW', 'E46 M3 Coupe', '2005', '33000', '35', '2014-09-30 21:35:31', '1107', '2014-09-30 21:42:30', '1107', '\n', '[ [ 1400, 3500, 1.5, [ 0, 0.10000000149011612, -0.30000001192092896 ], 75, 0.85000002384185791, 0.89999997615814209, 0.43999999761581421, 5, 225, 10.5, 5, \"rwd\", \"petrol\", 8, 0.40000000596046448, false, 30, 1.2999999523162842, 0.15000000596046448, 0, 0.2800000011920929, -0.10000000149011612, 0.5, 0.30000001192092896, 0.25, 0.60000002384185791, 35000, 1073752068, 67108865, \"small\", \"small\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('825', '562', 'BMW', 'E36 328i Coupe', '1997', '25000', '32', '2014-09-30 21:47:35', '1107', '2014-09-30 21:50:15', '1107', '\n', '[ [ 1400, 3500, 1.5, [ 0, 0.10000000149011612, -0.30000001192092896 ], 75, 0.85000002384185791, 0.89999997615814209, 0.43999999761581421, 5, 200, 10.5, 5, \"rwd\", \"petrol\", 8, 0.40000000596046448, false, 30, 1.2999999523162842, 0.15000000596046448, 0, 0.2800000011920929, -0.10000000149011612, 0.5, 0.30000001192092896, 0.25, 0.60000002384185791, 35000, 1073752068, 67108865, \"small\", \"small\", 1 ] ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('826', '579', 'BMW', 'X6 M', '2013', '1100000', '320', '2014-09-30 21:53:26', '1107', '2020-06-13 11:50:47', '744', '\n', '[ [ 2500, 6000, 1.7000000476837158, [ 0, -0.20000000298023224, -0.20000000298023224 ], 80, 0.69999998807907104, 0.88999998569488525, 0.5, 5, 220, 16, 14, \"awd\", \"petrol\", 7, 0.40000000596046448, false, 35, 1, 0.05000000074505806, 0, 0.44999998807907104, -0.20000000298023224, 0.40000000596046448, 0.30000001192092896, 0.43999999761581421, 0.34999999403953552, 40000, 32, 17412, \"long\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('827', '414', 'Mercedes-Benz', 'Sprinter', '2015', '30999', '50', '2014-10-02 14:33:06', '1107', '2014-10-02 14:37:05', '1107', '\n', '[ { \"1\": 3500, \"2\": 14000, \"3\": 2.5, \"4\": [ 0, 0, 0.10000000149011612 ], \"5\": 80, \"6\": 0.75, \"7\": 0.85000002384185791, \"8\": 0.44999998807907104, \"9\": 5, \"10\": 200, \"11\": 13, \"12\": 10, \"13\": \"rwd\", \"14\": \"diesel\", \"15\": 4.5, \"16\": 0.60000002384185791, \"17\": false, \"18\": 30, \"19\": 2, \"20\": 0.070000000298023224, \"21\": 5, \"22\": 0.30000001192092896, \"23\": -0.20000000298023224, \"24\": 0.5, \"25\": 0, \"26\": 0.46000000834465027, \"27\": 0.52999997138977051, \"28\": 22000, \"29\": 16520, \"30\": 0, \"31\": \"long\", \"33\": 0 } ]', '1000', '1', '5', '0');
INSERT INTO `vehicles_shop` VALUES ('828', '470', 'AM General', 'M1151 HMMWV', '2014', '100000', '150', '2014-10-02 15:51:34', '1737', '2019-10-15 14:21:12', '1438', '\n', '[ [ 4000, 7968.7001953125, 2.4000000953674316, [ 0, 0, 0 ], 80, 0.85000002384185791, 0.85000002384185791, 0.44999998807907104, 5, 190, 12, 10, \"awd\", \"petrol\", 8, 0.5, false, 20, 1.5, 0.079999998211860657, 4, 0.34999999403953552, -0.30000001192092896, 0.5, 0, 0.2800000011920929, 0.25, 40000, 8, 3145728, \"long\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('831', '562', 'Nissan', 'Skyline R34 GT-R V-Spec II  ', '2001', '45000', '30', '2014-10-05 01:48:50', '1775', '2014-10-05 01:50:34', '1775', '\n', '[ [ 1500, 3500, 2.2000000476837158, [ 0, 0.30000001192092896, -0.15000000596046448 ], 75, 0.80000001192092896, 0.89999997615814209, 0.5, 5, 200, 19, 5, \"awd\", \"petrol\", 8, 0.5, false, 35, 1, 0.20000000298023224, 0, 0.2800000011920929, -0.05000000074505806, 0.5, 0.30000001192092896, 0.25, 0.60000002384185791, 35000, 1073752068, 67108865, \"small\", \"small\", 1 ] ]', '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('832', '506', 'Ferrari ', '458 Speciale', '2014', '298000', '230', '2014-10-05 02:42:49', '1775', '2015-02-05 04:04:45', '120', '\n', '[ [ 1150, 2800, 2, [ 0, -0.20000000298023224, -0.23999999463558197 ], 70, 0.94999998807907104, 0.86000001430511475, 0.47999998927116394, 5, 230, 17, 5, \"rwd\", \"petrol\", 8, 0.5, false, 30, 1, 0.20000000298023224, 0, 0.25, -0.10000000149011612, 0.5, 0.30000001192092896, 0.40000000596046448, 0.54000002145767212, 105000, 1073750020, 2129920, \"long\", \"long\", 1 ] ]', '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('833', '550', 'Nissan', 'Laurel C35', '1998', '12500', '30', '2014-10-12 22:36:09', '1622', '2014-10-13 22:39:34', '1622', '\n', '[ { \"1\": 1600, \"2\": 3550, \"3\": 2, \"4\": [ 0, 0.30000001192092896, 0 ], \"5\": 70, \"6\": 0.80000001192092896, \"7\": 0.80000001192092896, \"8\": 0.51999998092651367, \"9\": 5, \"10\": 160, \"11\": 9, \"12\": 5, \"13\": \"rwd\", \"14\": \"petrol\", \"15\": 5.4000000953674316, \"16\": 0.60000002384185791, \"17\": false, \"18\": 30, \"19\": 1, \"20\": 0.090000003576278687, \"21\": 0, \"22\": 0.30000001192092896, \"23\": -0.10000000149011612, \"24\": 0.60000002384185791, \"25\": 0, \"26\": 0.25999999046325684, \"27\": 0.54000002145767212, \"28\": 19000, \"29\": 1073741824, \"30\": 1, \"31\": \"long\", \"33\": 0 } ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('834', '565', 'Volkswagen', 'Polo I', '1980', '3500', '35', '2014-10-13 15:49:23', '1107', '2020-05-01 18:54:36', '2545', '\n', '[ [ 1400, 2998.300048828125, 2.2000000476837158, [ 0, 0.20000000298023224, -0.10000000149011612 ], 75, 0.75, 0.89999997615814209, 0.5, 5, 80, 4, 10, \"fwd\", \"petrol\", 8, 0.60000002384185791, false, 30, 1.3999999761581421, 0.15000000596046448, 0, 0.2800000011920929, -0.10000000149011612, 0.5, 0.30000001192092896, 0.25, 0.60000002384185791, 35000, 10244, 67108865, \"small\", \"small\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('835', '565', 'Volkswagen', 'Polo II', '1993', '5500', '16', '2014-10-13 15:51:22', '1107', '2014-10-13 15:58:55', '1107', '\n', '[ [ 1400, 2998.300048828125, 2.2000000476837158, [ 0, 0.20000000298023224, -0.10000000149011612 ], 75, 0.75, 0.89999997615814209, 0.5, 5, 90, 7, 10, \"fwd\", \"petrol\", 8, 0.60000002384185791, false, 30, 1.3999999761581421, 0.15000000596046448, 0, 0.2800000011920929, -0.10000000149011612, 0.5, 0.30000001192092896, 0.25, 0.60000002384185791, 35000, 10244, 67108865, \"small\", \"small\", 1 ] ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('836', '565', 'Volkswagen', 'Polo III', '1995', '7500', '25', '2014-10-13 16:00:12', '1107', '2014-10-13 16:00:30', '1107', '\n', '[ [ 1400, 2998.300048828125, 2.2000000476837158, [ 0, 0.20000000298023224, -0.10000000149011612 ], 75, 0.75, 0.89999997615814209, 0.5, 5, 100, 9.6000003814697266, 10, \"fwd\", \"petrol\", 8, 0.60000002384185791, false, 30, 1.3999999761581421, 0.15000000596046448, 0, 0.2800000011920929, -0.10000000149011612, 0.5, 0.30000001192092896, 0.25, 0.60000002384185791, 35000, 10244, 67108865, \"small\", \"small\", 1 ] ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('837', '565', 'Volkswagen', 'Polo IV', '2001', '10000', '30', '2014-10-13 16:01:17', '1107', '2014-10-13 16:01:50', '1107', '\n', '[ [ 1400, 2998.300048828125, 2.2000000476837158, [ 0, 0.20000000298023224, -0.10000000149011612 ], 75, 0.75, 0.89999997615814209, 0.5, 5, 120, 9.6000003814697266, 10, \"fwd\", \"petrol\", 8, 0.60000002384185791, false, 30, 1.3999999761581421, 0.15000000596046448, 0, 0.2800000011920929, -0.10000000149011612, 0.5, 0.30000001192092896, 0.25, 0.60000002384185791, 35000, 10244, 67108865, \"small\", \"small\", 1 ] ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('838', '565', 'Volkswagen', 'Polo V', '2003', '12500', '40', '2014-10-13 16:02:17', '1107', '2014-10-13 16:02:44', '1107', '\n', '[ [ 1400, 2998.300048828125, 2.2000000476837158, [ 0, 0.20000000298023224, -0.10000000149011612 ], 75, 0.75, 0.89999997615814209, 0.5, 5, 140, 11, 10, \"fwd\", \"petrol\", 8, 0.60000002384185791, false, 30, 1.3999999761581421, 0.15000000596046448, 0, 0.2800000011920929, -0.10000000149011612, 0.5, 0.30000001192092896, 0.25, 0.60000002384185791, 35000, 10244, 67108865, \"small\", \"small\", 1 ] ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('839', '565', 'Volkswagen', 'Polo VI', '2005', '15000', '50', '2014-10-13 16:03:33', '1107', '2014-10-13 16:03:47', '1107', '\n', '[ [ 1400, 2998.300048828125, 2.2000000476837158, [ 0, 0.20000000298023224, -0.10000000149011612 ], 75, 0.75, 0.89999997615814209, 0.5, 5, 180, 13, 10, \"fwd\", \"petrol\", 8, 0.60000002384185791, false, 30, 1.3999999761581421, 0.15000000596046448, 0, 0.2800000011920929, -0.10000000149011612, 0.5, 0.30000001192092896, 0.25, 0.60000002384185791, 35000, 10244, 67108865, \"small\", \"small\", 1 ] ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('840', '565', 'Volkswagen', 'Polo VII', '2014', '90000', '70', '2014-10-13 16:04:41', '1107', '2020-05-01 18:54:58', '2545', '\n', '[ [ 1400, 2998.300048828125, 2.2000000476837158, [ 0, 0.20000000298023224, -0.10000000149011612 ], 75, 0.75, 0.89999997615814209, 0.5, 5, 200, 15, 10, \"fwd\", \"petrol\", 8, 0.60000002384185791, false, 35, 1.3999999761581421, 0.15000000596046448, 0, 0.2800000011920929, -0.10000000149011612, 0.5, 0.30000001192092896, 0.25, 0.60000002384185791, 35000, 10244, 67108865, \"small\", \"small\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('841', '402', 'Ford', 'Mustang EcoBoost', '2015', '225000', '150', '2014-10-13 16:08:02', '1107', '2020-06-06 01:58:30', '744', '\n', '[ [ 1500, 4000, 2, [ 0, 0, -0.10000000149011612 ], 85, 0.69999998807907104, 0.89999997615814209, 0.5, 5, 200, 13, 5, \"rwd\", \"petrol\", 11, 0.40000000596046448, false, 30, 1.2000000476837158, 0.11999999731779099, 0, 0.2800000011920929, -0.20000000298023224, 0.5, 0.40000000596046448, 0.25, 0.5, 35000, 10240, 270532608, \"small\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('842', '402', 'Ford', 'Mustang V6', '2015', '233000', '220', '2014-10-13 16:10:47', '1107', '2020-05-01 19:00:30', '2545', '\n', '[ [ 1500, 4000, 2, [ 0, 0, -0.10000000149011612 ], 85, 0.69999998807907104, 0.89999997615814209, 0.5, 5, 200, 14, 5, \"rwd\", \"petrol\", 11, 0.40000000596046448, false, 30, 1.2000000476837158, 0.11999999731779099, 0, 0.2800000011920929, -0.20000000298023224, 0.5, 0.40000000596046448, 0.25, 0.5, 35000, 10240, 270532608, \"small\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('843', '402', 'Ford', 'Mustang GT', '2015', '240000', '360', '2014-10-13 16:12:45', '1107', '2020-05-01 19:00:45', '2545', '\n', '[ [ 1500, 4000, 1.5, [ 0, 0, -0.10000000149011612 ], 85, 0.76999998092651367, 0.89999997615814209, 0.5, 5, 185, 15, 5, \"rwd\", \"petrol\", 7, 0.69999998807907104, false, 35, 1.2000000476837158, 0.11999999731779099, 0, 0.2800000011920929, -0.10000000149011612, 0.5, 0.40000000596046448, 0.25, 0.5, 35000, 10240, 270532608, \"small\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('844', '589', 'Volkswagen', 'Golf VII', '2014', '70000', '500', '2014-10-13 16:15:27', '1107', '2020-03-13 16:05:39', '745', '\n', '[ [ 1400, 3000, 1.7999999523162842, [ 0, 0, 0 ], 80, 0.64999997615814209, 0.89999997615814209, 0.49000000953674316, 5, 160, 9, 10, \"fwd\", \"petrol\", 11, 0.40000000596046448, false, 30, 1.7000000476837158, 0.10000000149011612, 0, 0.2800000011920929, -0.10000000149011612, 0.5, 0, 0.25, 0.5, 35000, 8192, 12582912, \"small\", \"small\", 0 ] ]', '1000', '1', '1', '0');
INSERT INTO `vehicles_shop` VALUES ('845', '415', 'Lamborghini', 'Huracan LP 610-4', '2015', '1839750', '265', '2014-10-13 19:17:12', '1622', '2019-10-31 16:19:12', '1438', '\n', '[ [ 1200, 3000, 1.100000023841858, [ 0, -0.2000000029802322, -0.2000000029802322 ], 70, 0.8999999761581421, 0.8999999761581421, 0.5199999809265137, 5, 200, 25, 15, \"awd\", \"petrol\", 11.10000038146973, 0.5, false, 35, 0.800000011920929, 0.2000000029802322, 0, 0.1000000014901161, -0.05000000074505806, 0.5, 0.6000000238418579, 0.4000000059604645, 0.5400000214576721, 105000, 3221233668, 2129920, \"long\", \"long\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('847', '560', 'Dodge', 'Charger SRTÂ© HELLCAT', '2017', '110000', '85', '2014-10-13 20:22:36', '1107', '2020-05-24 14:10:39', '1783', '\n', '[ [ 2200, 3400, 1.600000023841858, [ 0, -0.2000000029802322, -0.1000000014901161 ], 75, 1.100000023841858, 0.800000011920929, 0.5, 5, 260, 35, 18, \"awd\", \"petrol\", 9, 0.6000000238418579, false, 35, 1.200000047683716, 0.2000000029802322, 0, 0.2800000011920929, -0.119999997317791, 0.4000000059604645, 0.300000011920929, 0.25, 0.6000000238418579, 35000, 10240, 67108866, \"small\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('848', '475', 'BMW', 'E30 325i', '1990', '4500', '25', '2014-10-14 20:27:01', '1622', '2014-10-14 20:27:32', '1622', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('849', '533', 'Audi', 'A5 2.0T', '2014', '44500', '25', '2014-10-14 21:06:27', '1622', '0000-00-00 00:00:00', '0', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('850', '426', 'Audi', 'A4 2.0 TDI ', '2014', '240000', '25', '2014-10-14 21:13:17', '1622', '2019-12-14 13:19:33', '1438', '\n', '[ [ 1600, 3921.300048828125, 1.799999952316284, [ 0, -0.4000000059604645, 0 ], 75, 0.75, 0.8500000238418579, 0.5199999809265137, 5, 220, 14, 13, \"awd\", \"petrol\", 10, 0.5, false, 35, 1.299999952316284, 0.119999997317791, 0, 0.2800000011920929, -0.119999997317791, 0.4000000059604645, 0, 0.2000000029802322, 0.239999994635582, 25000, 1073741824, 270532616, \"long\", \"small\", 0 ] ]', '1000', '1', '1', '0');
INSERT INTO `vehicles_shop` VALUES ('851', '409', 'Audi', 'Q7 Limousine', '2007', '60000', '175', '2014-10-14 21:18:30', '1622', '2015-02-05 03:59:11', '120', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('852', '480', 'Audi ', 'RS5 Cabriolet', '2014', '300000', '160', '2014-10-14 21:29:43', '1622', '2020-06-06 01:59:28', '744', '\n', '[ [ 1400, 2200, 2.200000047683716, [ 0, 0.1000000014901161, -0.2000000029802322 ], 75, 0.699999988079071, 0.8999999761581421, 0.5, 5, 215, 18, 7, \"awd\", \"petrol\", 11, 0.4000000059604645, false, 30, 1.399999976158142, 0.1400000005960464, 3, 0.2800000011920929, -0.1500000059604645, 0.5, 0.300000011920929, 0.25, 0.6000000238418579, 35000, 1073743872, 0, \"small\", \"small\", 19 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('853', '468', 'Yamaha', 'YR250', '2004', '2500', '10', '2014-10-16 17:04:32', '1260', '2014-10-16 17:13:57', '1260', '\n', '[ [ 500, 195, 5, [ 0, 0.05000000074505806, -0.090000003576278687 ], 103, 1.6000000238418579, 0.89999997615814209, 0.47999998927116394, 5, 85, 15, 5, \"rwd\", \"petrol\", 14, 0.5, false, 35, 0.85000002384185791, 0.15000000596046448, 0, 0.15000000596046448, -0.20000000298023224, 0.5, 0, 0, 0.15000000596046448, 10000, 16777216, 0, \"small\", \"small\", 7 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('854', '562', 'Nissan ', 'Skyline R33 GT-RS25T', '2016', '825000', '400', '2014-10-18 03:59:35', '1775', '2020-05-01 18:59:21', '2545', '\n', '[ [ 1900, 3500, 1.200000047683716, [ 0, 0.300000011920929, -0.1000000014901161 ], 75, 0.699999988079071, 0.8999999761581421, 0.5, 5, 204, 21, 30, \"rwd\", \"petrol\", 8, 0.5, false, 35, 2, 0.2000000029802322, 0, 0.2800000011920929, -0.09000000357627869, 0.6000000238418579, 0.300000011920929, 0.25, 0.6000000238418579, 35000, 1073752068, 67108865, \"small\", \"small\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('855', '507', 'BMW', 'Alpina B7 Bi-Turbo', '2009', '54000', '55', '2014-10-18 16:44:20', '1622', '2014-12-20 02:42:06', '1260', '\n', '[ [ 2200, 5000, 1.3999999761581421, [ 0, 0.10000000149011612, -0.10000000149011612 ], 75, 0.69999998807907104, 0.80000001192092896, 0.46000000834465027, 5, 200, 13.5, 10, \"awd\", \"petrol\", 6, 0.60000002384185791, false, 30, 1, 0.10000000149011612, 0, 0.34999999403953552, -0.10000000149011612, 0.5, 0.30000001192092896, 0.20000000298023224, 0.30000001192092896, 35000, 1073741824, 272629760, \"long\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('857', '551', 'Volkswagen', 'Jetta 1.6 TDI', '2014', '91000', '60', '2014-10-18 21:52:03', '1622', '2021-03-26 17:02:36', '17797', '\n', '[ [ 1800, 4500, 0.10000000149011612, [ 0, 0.20000000298023224, -0.10000000149011612 ], 75, 0.64999997615814209, 0.80000001192092896, 0.49000000953674316, 5, 185, 11, 10, \"awd\", \"petrol\", 9, 0.60000002384185791, false, 30, 1.1000000238418579, 0.15000000596046448, 0, 0.27000001072883606, -0.10000000149011612, 0.5, 0.30000001192092896, 0.20000000298023224, 0.56000000238418579, 35000, 1073741824, 4194305, \"long\", \"small\", 0 ] ]', '1000', '1', '0', null);
INSERT INTO `vehicles_shop` VALUES ('858', '451', 'Hennessey', 'Venom GT', '2012', '1000000', '400', '2014-10-18 22:56:25', '1622', '2019-10-11 17:31:08', '1438', 'Not made in 2014 cunts.\n', '[ [ 1400, 3000, 0.300000011920929, [ 0, -0.4000000059604645, -0.2000000029802322 ], 70, 1.100000023841858, 0.8500000238418579, 0.4300000071525574, 5, 275, 26, 10, \"rwd\", \"petrol\", 9.699999809265137, 0.5, false, 35, 1.899999976158142, 0.2000000029802322, 0, 0.1500000059604645, -0.1000000014901161, 0.5, 0.4000000059604645, 0.1700000017881393, 0.7200000286102295, 95000, 1073750020, 12616705, \"small\", \"small\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('859', '506', 'McLaren', '650S Spider', '2015', '270000', '230', '2014-10-19 23:26:03', '1622', '2019-10-23 01:32:21', '1438', '\n', '[ [ 1400, 2800, 1.5, [ 0, -0.2000000029802322, -0.239999994635582 ], 70, 0.949999988079071, 0.8600000143051147, 0.4600000083446503, 5, 200, 14, 5, \"rwd\", \"petrol\", 8, 0.5, false, 40, 0.8799999952316284, 0.1879999935626984, 0, 0.25, -0.009999999776482582, 0.5, 0.300000011920929, 0.4000000059604645, 0.5400000214576721, 105000, 1073750020, 2129920, \"long\", \"long\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('860', '579', 'Mercedes-Benz', 'G63 AMG', '2015', '140150', '200', '2014-10-19 23:45:24', '1622', '2019-11-22 23:25:37', '1438', '\n', '[ [ 2500, 6000, 2, [ 0, 0, -0.2000000029802322 ], 80, 0.6200000047683716, 0.8899999856948853, 0.5, 5, 165, 13, 25, \"awd\", \"petrol\", 7, 0.4000000059604645, false, 35, 1.200000047683716, 0.05000000074505806, 0, 0.449999988079071, -0.2000000029802322, 0.5, 0.300000011920929, 0.4399999976158142, 0.3499999940395355, 40000, 32, 17412, \"long\", \"small\", 0 ] ]', '1000', '1', '1', '0');
INSERT INTO `vehicles_shop` VALUES ('861', '507', 'Audi', 'RS6', '2014', '115000', '120', '2014-10-21 01:43:39', '1622', '2015-02-05 04:00:00', '120', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('865', '489', 'Mitsubishi', 'Pajero', '1988', '11000', '25', '2014-10-22 22:35:09', '1775', '2014-10-22 22:36:28', '1775', '\n', '[ [ 2500, 7604.2001953125, 2.5, [ 0, 0, -0.34999999403953552 ], 80, 0.69999998807907104, 0.85000002384185791, 0.54000002145767212, 5, 170, 8, 5, \"awd\", \"petrol\", 7, 0.40000000596046448, false, 35, 0.80000001192092896, 0.079999998211860657, 0, 0.44999998807907104, -0.30000001192092896, 0.40000000596046448, 0.30000001192092896, 0.43999999761581421, 0.34999999403953552, 40000, 16416, 1048580, \"long\", \"small\", 0 ] ]', '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('866', '561', 'Nissan', 'Stagea Autech 260RS', '1998', '15500', '35', '2014-10-25 00:43:58', '1622', '2014-10-27 23:05:02', '1622', '\n', '[ [ 1620, 4500, 2.0999999046325684, [ 0, 0.10000000149011612, -0.10000000149011612 ], 75, 0.80000001192092896, 0.85000002384185791, 0.52999997138977051, 5, 165, 10, 10, \"awd\", \"petrol\", 7, 0.5, false, 30, 1.5, 0.17499999701976776, 0, 0.2800000011920929, -0.10000000149011612, 0.40000000596046448, 0.30000001192092896, 0.25, 0.60000002384185791, 35000, 10240, 67108864, \"small\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('868', '565', 'Fiat', 'Cinquecento', '1995', '3500', '10', '2014-11-01 01:49:27', '1775', '2014-11-01 01:51:01', '1775', '\n', '[ [ 1400, 2998.300048828125, 2.2000000476837158, [ 0, 0.20000000298023224, -0.10000000149011612 ], 75, 0.64999997615814209, 0.89999997615814209, 0.5, 5, 100, 5, 10, \"fwd\", \"petrol\", 8, 0.60000002384185791, false, 30, 1.3999999761581421, 0.15000000596046448, 0, 0.2800000011920929, -0.10000000149011612, 0.5, 0.30000001192092896, 0.25, 0.60000002384185791, 35000, 10244, 67108865, \"small\", \"small\", 1 ] ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('869', '547', 'Audi', 'A4', '2014', '42500', '45', '2014-11-01 02:00:12', '1775', '2021-03-26 19:01:29', '17826', '\n', '[ { \"1\": 1400, \"2\": 3300, \"3\": 2.2000000476837158, \"4\": [ 0, 0, 0 ], \"5\": 70, \"6\": 0.80000001192092896, \"7\": 0.80000001192092896, \"8\": 0.54000002145767212, \"9\": 4, \"10\": 150, \"11\": 13, \"12\": 7, \"13\": \"awd\", \"14\": \"petrol\", \"15\": 5.4000000953674316, \"16\": 0.60000002384185791, \"17\": false, \"18\": 30, \"19\": 1.8999999761581421, \"20\": 0.14000000059604645, \"21\": 0, \"22\": 0.31999999284744263, \"23\": -0.070000000298023224, \"24\": 0.5, \"25\": 0, \"26\": 0.25999999046325684, \"27\": 0.54000002145767212, \"28\": 19000, \"29\": 0, \"30\": 0, \"31\": \"long\", \"33\": 0 } ]', '1000', '1', '0', null);
INSERT INTO `vehicles_shop` VALUES ('871', '541', 'Lotus', 'Evora', '2014', '170000', '85', '2014-11-01 02:08:18', '1775', '2020-05-02 00:27:43', '744', '\n', '[ [ 1200, 2500, 1.799999952316284, [ 0, -0.1500000059604645, -0.2000000029802322 ], 70, 0.75, 0.8999999761581421, 0.4799999892711639, 5, 230, 12, 10, \"rwd\", \"petrol\", 8, 0.6000000238418579, false, 30, 1, 0.1299999952316284, 5, 0.25, -0.1000000014901161, 0.4000000059604645, 0.300000011920929, 0.1500000059604645, 0.5400000214576721, 105000, 3221233668, 2113536, \"long\", \"long\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('872', '541', 'Bugatti', 'Veyron 16.4 Grand Sport', '2011', '1500000', '400', '2014-11-03 02:43:32', '1622', '2019-10-12 17:31:30', '1438', '\n', '[ [ 1600, 2500, 1, [ 0, -0.1500000059604645, -0.2000000029802322 ], 70, 1, 0.8999999761581421, 0.5099999904632568, 5, 275, 25, 10, \"awd\", \"petrol\", 8, 0.6000000238418579, false, 35, 1, 0.1299999952316284, 5, 0.25, 0.01999999955296516, 0.4000000059604645, 0.300000011920929, 0.1500000059604645, 0.5400000214576721, 105000, 3221233668, 2113536, \"long\", \"long\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('874', '453', 'Nordic', 'Tug 26', '1997', '101500', '50', '2014-11-04 12:13:52', '1695', '0000-00-00 00:00:00', '0', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('875', '418', 'Chrysler', 'Voyager LX ', '2006', '14500', '35', '2014-11-04 21:01:37', '1775', '2014-11-04 21:02:47', '1775', '\n', '[ { \"1\": 2000, \"2\": 5848.2998046875, \"3\": 2.7999999523162842, \"4\": [ 0, 0.20000000298023224, -0.10000000149011612 ], \"5\": 85, \"6\": 0.60000002384185791, \"7\": 0.80000001192092896, \"8\": 0.5, \"9\": 5, \"10\": 150, \"11\": 8, \"12\": 15, \"13\": \"fwd\", \"14\": \"diesel\", \"15\": 5.5, \"16\": 0.60000002384185791, \"17\": false, \"18\": 30, \"19\": 1.3999999761581421, \"20\": 0.10000000149011612, \"21\": 0, \"22\": 0.34999999403953552, \"23\": -0.17499999701976776, \"24\": 0.60000002384185791, \"25\": 0, \"26\": 0.20000000298023224, \"27\": 0.75, \"28\": 16000, \"29\": 32, \"30\": 0, \"31\": \"small\", \"33\": 0 } ]', '1000', '1', '4', '0');
INSERT INTO `vehicles_shop` VALUES ('876', '560', 'Ford', 'Taurus SHO', '2015', '50555', '45', '2014-11-06 01:13:53', '1107', '2014-12-27 02:58:39', '55', '\n', '[ [ 1400, 3400, 0.89999997615814209, [ 0, 0.10000000149011612, -0.10000000149011612 ], 75, 0.99000000953674316, 0.80000001192092896, 0.5, 5, 140, 13, 5, \"awd\", \"petrol\", 10, 0.5, false, 42, 1.2000000476837158, 0.15000000596046448, 0, 0.2800000011920929, -0.10000000149011612, 0.5, 0.30000001192092896, 0.25, 0.60000002384185791, 35000, 10240, 67108866, \"small\", \"small\", 0 ] ]', '1000', '1', '1', '0');
INSERT INTO `vehicles_shop` VALUES ('877', '451', 'Koenigsegg', 'Agera R', '2014', '1250000', '350', '2014-11-08 09:05:53', '1622', '2019-10-11 17:35:03', '1438', '\n', '[ [ 1300, 3000, 2, [ 0, -0.300000011920929, -0.2000000029802322 ], 70, 1, 0.8500000238418579, 0.449999988079071, 5, 275, 25, 10, \"rwd\", \"petrol\", 11, 0.5, false, 35, 1.299999952316284, 0.1299999952316284, 0, 0.1500000059604645, -0.1000000014901161, 0.5, 0.4000000059604645, 0.1700000017881393, 0.7200000286102295, 95000, 1073750020, 12616705, \"small\", \"small\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('879', '451', 'McLaren', 'P1', '2014', '1250000', '380', '2014-11-08 09:15:41', '1622', '2019-10-11 17:35:43', '1438', '\n', '[ [ 1400, 3000, 2, [ 0, -0.300000011920929, -0.2000000029802322 ], 70, 1.25, 0.8500000238418579, 0.4199999868869781, 5, 238, 24, 10, \"rwd\", \"petrol\", 11, 0.5, false, 35, 1.5, 0.1299999952316284, 0, 0.1500000059604645, -0.1000000014901161, 0.5, 0.4000000059604645, 0.1700000017881393, 0.7200000286102295, 95000, 1073750020, 12616705, \"small\", \"small\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('880', '560', 'Subaru', 'Impreza WRX STi', '2015', '99999', '50', '2014-11-09 00:41:19', '1107', '2019-10-27 16:38:11', '1438', '\n', '[ [ 1400, 3400, 1.299999952316284, [ 0, 0.1000000014901161, -0.1000000014901161 ], 75, 1.100000023841858, 0.800000011920929, 0.5199999809265137, 5, 30, 20, 10, \"awd\", \"petrol\", 9, 0.6000000238418579, false, 45, 1.5, 0.1599999964237213, 0, 0.2800000011920929, -0.1000000014901161, 0.5, 0.300000011920929, 0.25, 0.6000000238418579, 35000, 10240, 67108866, \"small\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('881', '502', 'Ferrari', '812 Superfast', '2019', '99999999', '0', '2014-11-09 09:37:33', '1622', '2020-06-20 04:31:15', '2545', '\n', '[ [ 1600, 4500, 0.10000000149011612, [ 0, 0.20000000298023224, -0.40000000596046448 ], 70, 1.1000000238418579, 0.80000001192092896, 0.44999998807907104, 5, 275, 25, 5, \"rwd\", \"petrol\", 10, 0.5, false, 35, 1.5, 0.10000000149011612, 10, 0.28999999165534973, -0.20000000298023224, 0.60000002384185791, 0.40000000596046448, 0.20000000298023224, 0.56000000238418579, 45000, 1073750020, 12582912, \"small\", \"small\", 0 ] ]', '1000', '1', '0', null);
INSERT INTO `vehicles_shop` VALUES ('883', '421', 'Cadillac', 'ATS', '2014', '43250', '75', '2014-11-10 02:58:23', '1622', '2014-12-23 04:01:37', '1622', '\n', '[ [ 2000, 5000, 1.2000000476837158, [ 0, 0, -0.10000000149011612 ], 75, 0.89999997615814209, 0.64999997615814209, 0.5, 5, 200, 11, 6, \"awd\", \"petrol\", 7.5, 0.40000000596046448, false, 38, 0.89999997615814209, 0.20000000298023224, 0, 0.27000001072883606, -0.20000000298023224, 0.5, 0.34999999403953552, 0.23999999463558197, 0.60000002384185791, 18000, 0, 272629760, \"small\", \"small\", 0 ] ]', '1000', '1', '1', '0');
INSERT INTO `vehicles_shop` VALUES ('885', '411', 'Lamborghini', 'MurciÃ©lago ', '2004', '149900', '100', '2014-11-10 21:49:47', '1775', '2014-11-26 02:09:21', '1107', '\n', '[ [ 1400, 2725.300048828125, 1.5, [ 0, 0, -0.25 ], 70, 0.89999997615814209, 0.80000001192092896, 0.50999999046325684, 5, 210, 20.5, 10, \"awd\", \"petrol\", 11, 0.5, false, 30, 1.2000000476837158, 0.18999999761581421, 0, 0.25, -0.10000000149011612, 0.5, 0.40000000596046448, 0.37000000476837158, 0.72000002861022949, 95000, 1073750020, 12599296, \"small\", \"small\", 1 ] ]', '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('886', '555', 'Ford', 'Shelby Cobra 50th Anniversary Limited Edition', '2014', '94995', '20', '2014-11-11 03:35:01', '1107', '2014-11-14 04:05:31', '1107', '\n', '[ [ 1500, 3500, 2.0999999046325684, [ 0, 0.05000000074505806, -0.20000000298023224 ], 75, 0.55000001192092896, 0.85000002384185791, 0.5, 5, 180, 10, 10, \"rwd\", \"petrol\", 8, 0.40000000596046448, false, 30, 0.64999997615814209, 0.070000000298023224, 0, 0.15000000596046448, -0.10000000149011612, 0.5, 0.30000001192092896, 0.25, 0.60000002384185791, 35000, 1076373508, 0, \"small\", \"small\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('887', '506', 'Porsche', '918 Spyder', '2014', '1100000', '350', '2014-11-12 00:53:18', '1622', '2019-10-11 17:34:19', '1438', '\n', '[ [ 1400, 2800, 2, [ 0, -0.2000000029802322, -0.239999994635582 ], 70, 0.75, 0.8600000143051147, 0.4799999892711639, 5, 230, 10.39999961853027, 5, \"rwd\", \"petrol\", 8, 0.5, false, 30, 1, 0.2000000029802322, 0, 0.25, -0.1000000014901161, 0.5, 0.300000011920929, 0.4000000059604645, 0.5400000214576721, 105000, 1073750020, 2129920, \"long\", \"long\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('888', '579', 'Porsche', 'Cayenne Turbo', '2006', '31500', '55', '2014-11-12 01:48:43', '1107', '2014-11-14 23:06:00', '1107', '\n', '[ [ 2500, 6000, 2, [ 0, -0.30000001192092896, -0.20000000298023224 ], 80, 0.62000000476837158, 0.88999998569488525, 0.5, 5, 190, 13, 25, \"awd\", \"petrol\", 7, 0.40000000596046448, false, 35, 1, 0.05000000074505806, 0, 0.44999998807907104, -0.20000000298023224, 0.40000000596046448, 0.30000001192092896, 0.43999999761581421, 0.34999999403953552, 40000, 32, 17412, \"long\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('889', '562', 'Toyota', 'Soarer', '1991', '15000', '55', '2014-11-12 01:51:18', '1107', '2014-11-12 01:52:28', '1622', '\n', '[ [ 1500, 3500, 2.2000000476837158, [ 0, 0.30000001192092896, -0.15000000596046448 ], 75, 0.64999997615814209, 0.89999997615814209, 0.5, 5, 200, 10, 5, \"rwd\", \"petrol\", 8, 0.5, false, 35, 1, 0.20000000298023224, 0, 0.2800000011920929, -0.15000000596046448, 0.5, 0.30000001192092896, 0.25, 0.60000002384185791, 35000, 1073752068, 67108865, \"small\", \"small\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('890', '418', 'Volkswagen', 'Touran', '2005', '20000', '35', '2014-11-12 23:11:26', '1107', '0000-00-00 00:00:00', '0', '\n', null, '1000', '1', '2', '0');
INSERT INTO `vehicles_shop` VALUES ('891', '418', 'Seat', 'Alhambra', '2008', '22000', '35', '2014-11-12 23:11:47', '1107', '0000-00-00 00:00:00', '0', '\n', null, '1000', '1', '2', '0');
INSERT INTO `vehicles_shop` VALUES ('892', '418', 'Volkswagen', 'Sharan', '2007', '22000', '34', '2014-11-12 23:12:20', '1107', '0000-00-00 00:00:00', '0', '\n', null, '1000', '1', '2', '0');
INSERT INTO `vehicles_shop` VALUES ('893', '589', 'Hyundai', 'Getz 1.4i Active Cool', '2004', '7500', '25', '2014-11-12 23:14:35', '1107', '0000-00-00 00:00:00', '0', '\n', null, '1000', '1', '2', '0');
INSERT INTO `vehicles_shop` VALUES ('895', '402', 'Dodge', 'Challenger SRTÂ© HELLCAT', '2015', '59995', '55', '2014-11-14 03:08:12', '1107', '2015-01-09 08:12:37', '9736', '\n', '[ [ 2100, 4000, 1.6000000238418579, [ 0, -0.20000000298023224, -0.10000000149011612 ], 85, 0.80000001192092896, 0.89999997615814209, 0.4699999988079071, 5, 215, 20, 5, \"rwd\", \"petrol\", 7, 0.5, false, 35, 1.7000000476837158, 0.15999999642372131, 0, 0.2800000011920929, -0.070000000298023224, 0.40000000596046448, 0.40000000596046448, 0.25, 0.5, 35000, 10240, 270532608, \"small\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('897', '554', 'Dodge', 'RAM SRT-10', '2006', '45000', '60', '2014-11-23 23:15:31', '1107', '2014-11-23 23:32:30', '1107', '\n', '[ [ 2700, 6000, 1.5, [ 0, 0.34999999403953552, 0 ], 80, 0.94999998807907104, 0.80000001192092896, 0.47999998927116394, 5, 200, 20, 15, \"rwd\", \"petrol\", 8.5, 0.30000001192092896, false, 30, 1, 0.11999999731779099, 0, 0.23999999463558197, 0.0099999997764825821, 0.5, 0.5, 0.43999999761581421, 0.30000001192092896, 40000, 538968096, 5260288, \"long\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('898', '560', 'Dodge', 'Charger Pursuit', '2015', '55000', '300', '2014-11-24 01:09:43', '1107', '2020-03-13 16:14:49', '745', '\n', '[ [ 1400, 3400, 1.399999976158142, [ 0, 0.1000000014901161, -0.1000000014901161 ], 75, 1.100000023841858, 0.800000011920929, 0.5, 5, 230, 25, 5, \"awd\", \"petrol\", 8.100000381469727, 0.6000000238418579, false, 33, 1.799999952316284, 0.1500000059604645, 0, 0.2800000011920929, -0.1000000014901161, 0.5, 0.300000011920929, 0.25, 0.6000000238418579, 35000, 10240, 67108866, \"small\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('899', '506', 'Ferrari', '365 \"Daytona\" Spyder', '1971', '550000', '165', '2014-11-25 05:24:25', '1107', '2015-02-05 04:03:53', '1107', '\n', '[ [ 1400, 2800, 1.2000000476837158, [ 0, -0.20000000298023224, -0.23999999463558197 ], 70, 1.1000000238418579, 0.86000001430511475, 0.40000000596046448, 5, 240, 22, 6, \"rwd\", \"petrol\", 7, 0.40000000596046448, false, 33, 1, 0.20000000298023224, 0, 0.25, -0.10000000149011612, 0.5, 0.30000001192092896, 0.40000000596046448, 0.54000002145767212, 105000, 1073750020, 2129920, \"long\", \"long\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('900', '455', 'Brabus', 'B63S 700 6x6', '2015', '580000', '350', '2014-11-26 02:05:42', '1622', '2015-02-05 03:53:26', '120', '\n', '[ [ 8500, 48804.19921875, 2.5, [ 0, -0.20000000298023224, -1 ], 90, 0.85000002384185791, 0.69999998807907104, 0.43000000715255737, 5, 135, 15, 80, \"awd\", \"diesel\", 10, 0.40000000596046448, false, 35, 1.2000000476837158, 0.20000000298023224, 0, 0.4699999988079071, -0.20000000298023224, 0.5, 0, 0.62000000476837158, 0.43000000715255737, 10000, 2049, 0, \"long\", \"small\", 2 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('901', '455', 'Mercedes-Benz', 'G63 AMG 6x6', '2015', '485000', '390', '2014-11-26 03:36:48', '1622', '2015-02-05 04:08:35', '120', '\n', '[ [ 8500, 48804.19921875, 2.5, [ 0, -0.20000000298023224, -1 ], 90, 0.94999998807907104, 0.69999998807907104, 0.41999998688697815, 5, 175, 12, 80, \"rwd\", \"diesel\", 10, 0.40000000596046448, false, 35, 1.2000000476837158, 0.20000000298023224, 0, 0.4699999988079071, -0.20000000298023224, 0.5, 0, 0.62000000476837158, 0.43000000715255737, 10000, 2049, 0, \"long\", \"small\", 2 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('904', '402', 'Ford', 'Shelby GT-500 Super Snake', '2014', '580000', '2000', '2014-11-27 19:06:12', '1107', '2020-03-13 16:07:33', '745', '\n', '[ [ 1500, 4000, 1.600000023841858, [ 0, 0, -0.1000000014901161 ], 85, 0.949999988079071, 0.8999999761581421, 0.4799999892711639, 5, 251, 15, 8, \"rwd\", \"petrol\", 11, 0.4000000059604645, false, 35, 1.200000047683716, 0.119999997317791, 0, 0.2800000011920929, -0.1400000005960464, 0.5, 0.4000000059604645, 0.25, 0.5, 35000, 10240, 270532608, \"small\", \"small\", 0 ] ]', '1000', '1', '1', '0');
INSERT INTO `vehicles_shop` VALUES ('905', '410', 'Datsun', '510 SSS 1800', '1972', '5000', '15', '2014-11-27 20:05:39', '1107', '2015-01-14 13:36:55', '10139', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('906', '442', 'Cadillac', 'Fleetwood Hearse', '1994', '8000', '30', '2014-11-27 20:14:12', '1107', '2014-12-18 00:29:13', '1622', '\n', '[ [ 2500, 5960.39990234375, 2, [ 0, -0.80000001192092896, 0.20000000298023224 ], 70, 0.75, 0.80000001192092896, 0.5, 5, 150, 6.4000000953674316, 15, \"rwd\", \"petrol\", 4, 0.80000001192092896, false, 30, 1, 0.10000000149011612, 0, 0.34999999403953552, -0.15000000596046448, 0.40000000596046448, 0, 0.20000000298023224, 1.25, 10000, 1073741856, 0, \"long\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('907', '563', 'Sikorsky', 'S-70', '1991', '650000', '50', '2014-11-28 07:05:28', '1622', '0000-00-00 00:00:00', '0', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('908', '402', 'Saleen', 'Mustang 302 \"Black LabelÂ´', '2015', '54386', '15', '2014-11-29 02:57:33', '1775', '2014-11-29 03:02:10', '1775', '\n', '[ [ 1500, 4000, 2, [ 0, 0.10000000149011612, -0.10000000149011612 ], 85, 0.85000002384185791, 0.89999997615814209, 0.5, 5, 200, 20, 5, \"rwd\", \"petrol\", 11, 0.60000002384185791, false, 40, 1.6000000238418579, 0.20000000298023224, 0, 0.2800000011920929, -0.059999998658895493, 0.5, 0.40000000596046448, 0.25, 0.5, 35000, 10240, 270532608, \"small\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('910', '415', 'Aston Martin', 'DBS', '2012', '183000', '160', '2014-11-29 03:51:01', '1737', '2015-02-05 03:56:32', '120', '\n', '[ [ 1200, 3000, 1.5, [ 0, -0.20000000298023224, -0.20000000298023224 ], 70, 0.94999998807907104, 0.89999997615814209, 0.47999998927116394, 5, 228, 20, 10, \"rwd\", \"petrol\", 11.100000381469727, 0.5, false, 35, 0.80000001192092896, 0.20000000298023224, 0, 0.10000000149011612, -0.10000000149011612, 0.5, 0.60000002384185791, 0.40000000596046448, 0.54000002145767212, 105000, 3221233664, 2129920, \"long\", \"long\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('911', '479', 'Volvo', 'Amazon', '1969', '109500', '50', '2014-11-29 05:46:47', '1260', '2014-12-02 01:08:00', '1260', '\n', '[ [ 1500, 3800, 2, [ 0, 0.20000000298023224, 0 ], 75, 0.94999998807907104, 0.85000002384185791, 0.57999998331069946, 4, 195, 20, 20, \"fwd\", \"petrol\", 5, 1, false, 35, 1.3999999761581421, 0.10000000149011612, 0, 0.27000001072883606, -0.029999999329447746, 0.5, 0.20000000298023224, 0.23999999463558197, 0.47999998927116394, 18000, 32, 1, \"small\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('912', '507', 'Mercedes-Benz', 'C250 TD Sport', '1999', '5950', '15', '2014-11-30 02:25:41', '1775', '2014-11-30 02:30:02', '1775', '\n', '[ [ 2200, 5000, 1.7999999523162842, [ 0, 0.10000000149011612, -0.10000000149011612 ], 75, 0.69999998807907104, 0.80000001192092896, 0.46000000834465027, 5, 140, 10, 10, \"rwd\", \"petrol\", 6, 0.60000002384185791, false, 30, 1, 0.10000000149011612, 0, 0.34999999403953552, -0.15000000596046448, 0.5, 0.30000001192092896, 0.20000000298023224, 0.30000001192092896, 35000, 1073741824, 272629760, \"long\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('914', '515', 'Coca-Cola', 'Freightliner', '2001', '1000000', '0', '2014-12-07 05:57:27', '635', '2019-10-11 17:31:30', '1438', 'Script purposes - Exciter\n', '[ [ 5000, 28000, 2, [ 0, 0.5, -0.4000000059604645 ], 90, 0.949999988079071, 0.6499999761581421, 0.4000000059604645, 5, 120, 10, 20, \"rwd\", \"diesel\", 8, 0.300000011920929, false, 25, 0.699999988079071, 0.1000000014901161, 0, 0.2000000029802322, -0.1700000017881393, 0.5, 0, 0.6499999761581421, 0.25, 35000, 538968072, 512, \"long\", \"small\", 2 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('915', '591', 'Coca-Cola', 'Trailer', '2001', '1000000', '0', '2014-12-07 06:00:04', '635', '0000-00-00 00:00:00', '0', 'Script purposes - Exciter\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('917', '590', '0', '0', '2000', '1', '1', '2014-12-08 00:06:53', '1622', '0000-00-00 00:00:00', '0', '\n', null, '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('918', '570', '0', '0', '2000', '2', '0', '2014-12-08 00:10:17', '1622', '0000-00-00 00:00:00', '0', 'SAPT\n', null, '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('919', '501', 'AAI RQ-7', 'Shadow', '2015', '1', '1', '2014-12-08 06:11:12', '397', '2014-12-10 02:46:45', '1260', '\n', null, '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('920', '464', 'HobbyKingÂ®', 'Piper J3 Cub Balsa/Ply', '2014', '1', '0', '2014-12-08 07:00:29', '397', '2019-10-11 17:29:46', '1438', '\n', null, '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('924', '486', 'International', '7500 SFA Snow Plow Truck', '2010', '175000', '80', '2014-12-09 16:24:49', '1695', '2014-12-09 16:41:35', '1695', 'Winter Season vehicle\n', '[ [ 10000, 35000, 20, [ 0, -0.5, -0.5 ], 90, 0.85000002384185791, 0.80000001192092896, 0.60000002384185791, 5, 70, 6, 150, \"awd\", \"diesel\", 10, 0.40000000596046448, false, 20, 1.3999999761581421, 0.15000000596046448, 0, 0.25, 0.10000000149011612, 0.30000001192092896, 0, 0.44999998807907104, 0.20000000298023224, 5000, 776, 3408416, \"long\", \"small\", 17 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('925', '482', 'Ford', 'Econoline 4x4', '2014', '55600', '50', '2014-12-10 00:42:47', '1260', '2014-12-10 00:48:52', '1260', '\n', '[ [ 1900, 5000, 2.5, [ 0, 0, -0.10000000149011612 ], 85, 0.60000002384185791, 0.87000000476837158, 0.50999999046325684, 5, 135.5, 12, 20, \"awd\", \"petrol\", 8.5, 0.40000000596046448, false, 30, 1.2999999523162842, 0.070000000298023224, 2, 0.40000000596046448, -0.33500000834465027, 0.40000000596046448, 0.5, 0.20000000298023224, 0.5, 26000, 1, 4194304, \"long\", \"small\", 13 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('926', '470', 'M1025', 'Slantback HMMWV', '1993', '50000', '85', '2014-12-10 02:02:40', '1622', '2014-12-11 11:18:15', '9736', '\n', '[ [ 3500, 7968.7001953125, 4, [ 0, 0, -0.20000000298023224 ], 80, 1, 0.85000002384185791, 0.55000001192092896, 5, 170, 16, 20, \"awd\", \"petrol\", 8, 0.5, false, 30, 1.8999999761581421, 0.20000000298023224, 4, 0.34999999403953552, -0.30000001192092896, 0.60000002384185791, 0, 0.2800000011920929, 0.25, 40000, 8, 3145728, \"long\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('927', '561', 'HSV', 'Clubsport R8 Tourer', '2014', '93100', '85', '2014-12-10 02:06:24', '1622', '2014-12-18 00:37:47', '1622', '\n', '[ [ 1800, 4500, 1.7999999523162842, [ 0, 0.10000000149011612, -0.10000000149011612 ], 75, 0.75, 0.85000002384185791, 0.5, 5, 200, 13, 10, \"rwd\", \"petrol\", 7, 0.5, false, 30, 1, 0.15000000596046448, 0, 0.2800000011920929, -0.05000000074505806, 0.5, 0.30000001192092896, 0.25, 0.60000002384185791, 35000, 10240, 67108864, \"small\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('929', '560', 'Audi', 'A4', '2014', '160000', '10', '2014-12-10 02:18:02', '1622', '2020-04-26 12:59:44', '745', '\n', '[ [ 1400, 3400, 1.5, [ 0, 0.1000000014901161, -0.1000000014901161 ], 75, 0.800000011920929, 0.800000011920929, 0.5, 5, 260, 13, 13, \"awd\", \"petrol\", 10, 0.5, false, 30, 1.200000047683716, 0.1500000059604645, 0, 0.2800000011920929, -0.2000000029802322, 0.5, 0.300000011920929, 0.25, 0.6000000238418579, 35000, 10240, 67108866, \"small\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('930', '470', 'Lamborghini', 'LM002', '2015', '117500', '100', '2014-12-10 02:24:29', '1622', '2020-03-24 20:24:44', '745', '\n', '[ [ 2500, 7968.7001953125, 2.5, [ 0, 0, 0 ], 80, 0.699999988079071, 0.8500000238418579, 0.5, 5, 275, 14, 20, \"awd\", \"petrol\", 8, 0.5, false, 30, 1.5, 0.07999999821186066, 4, 0.3499999940395355, -0.1500000059604645, 0.5, 0, 0.2800000011920929, 0.25, 40000, 8, 3145728, \"long\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('931', '598', 'Ford', 'Mondeo', '2016', '55000', '30', '2014-12-11 05:09:58', '9736', '2021-03-27 11:05:19', '17826', '\n', '[ [ 2000, 4500, 1, [ 0, 0.30000001192092896, -0.2199999988079071 ], 75, 1.1000000238418579, 0.85000002384185791, 0.5, 5, 200, 16, 5, \"awd\", \"petrol\", 23, 0.30000001192092896, false, 44, 1.3999999761581421, 0.20000000298023224, 0, 0.2800000011920929, -0.15000000596046448, 0.60000002384185791, 0, 0.20000000298023224, 0.23999999463558197, 25000, 1073741824, 270532616, \"long\", \"small\", 0 ] ]', '1000', '1', '0', null);
INSERT INTO `vehicles_shop` VALUES ('932', '562', 'BMW', 'E36 M3', '1999', '19900', '25', '2014-12-15 21:53:03', '1775', '2015-01-12 00:58:22', '99', '\n', '[ [ 1150, 3500, 2.2000000476837158, [ 0, 0.30000001192092896, -0.15000000596046448 ], 75, 0.75, 0.89999997615814209, 0.5, 5, 200, 13.5, 5, \"rwd\", \"petrol\", 8, 0.5, false, 35, 1, 0.20000000298023224, 0, 0.2800000011920929, -0.10000000149011612, 0.5, 0.30000001192092896, 0.25, 0.60000002384185791, 35000, 1073752068, 67108865, \"small\", \"small\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('933', '579', 'Toyota', 'LandCruiser Base', '2006', '26500', '75', '2014-12-18 00:23:47', '1622', '2015-02-02 18:01:50', '1107', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('934', '573', 'Rosenbauer', 'Panther CA-5 4x4', '2014', '84500', '100', '2014-12-22 05:12:28', '1622', '2014-12-22 05:22:20', '1622', '\n', '[ [ 10000, 50000, 2, [ 0, 0, -0.60000002384185791 ], 80, 0.64999997615814209, 0.85000002384185791, 0.5, 5, 110, 17, 25, \"awd\", \"petrol\", 7, 0.40000000596046448, false, 35, 0.80000001192092896, 0.10000000149011612, 0, 0.40000000596046448, -0.40000000596046448, 0.5, 0.30000001192092896, 0.28999999165534973, 0.34999999403953552, 40000, 24616, 19922949, \"long\", \"small\", 2 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('937', '568', 'Ariel', 'Atom V8', '2014', '78000', '20', '2014-12-25 08:21:38', '1622', '2014-12-27 10:47:37', '1622', '\n', '[ [ 1000, 2500.300048828125, 2, [ 0, 0, -0.30000001192092896 ], 80, 0.89999997615814209, 0.87999999523162842, 0.55000001192092896, 4, 225, 20, 5, \"rwd\", \"petrol\", 6.0999999046325684, 0.60000002384185791, false, 35, 1.2000000476837158, 0.10000000149011612, 5, 0.25, 0.075000002980232239, 0.5, 0, 0.60000002384185791, 0.40000000596046448, 15000, 1073748740, 3179520, \"small\", \"big\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('938', '404', 'Lada', 'Riva 1300', '1990', '7000', '10', '2014-12-25 08:32:33', '10704', '2014-12-26 03:15:25', '55', '\n', '[ [ 10000, 3000, 2.5, [ 0, 0.10000000149011612, 0 ], 70, 1.5, 0.89999997615814209, 0.47999998927116394, 5, 275, 75, 26, \"awd\", \"petrol\", 7, 0.80000001192092896, false, 50, 1, 0.10000000149011612, 0, 0.37000000476837158, -0.070000000298023224, 0.5, 0, 0.20000000298023224, 0.60000002384185791, 10000, 32, 0, \"small\", \"small\", 0 ] ]', '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('939', '451', 'Koenigsegg', 'CCX', '2007', '996500', '300', '2014-12-25 08:48:42', '1622', '2019-10-11 17:26:47', '1438', '\n', '[ [ 1400, 3000, 2, [ 0, -0.300000011920929, -0.2000000029802322 ], 70, 0.75, 0.8500000238418579, 0.449999988079071, 5, 275, 39, 10, \"awd\", \"petrol\", 11, 0.5, false, 30, 1.200000047683716, 0.1299999952316284, 0, 0.1500000059604645, -0.2000000029802322, 0.5, 0.4000000059604645, 0.1700000017881393, 0.7200000286102295, 95000, 1073750020, 12616705, \"small\", \"small\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('940', '580', 'Maybach', '57 S', '2009', '159995', '175', '2014-12-27 07:32:09', '1622', '2014-12-27 10:37:21', '99', '\n', '[ [ 2735, 6000, 1.5, [ 0, 0, 0 ], 75, 0.64999997615814209, 0.92000001668930054, 0.5, 5, 180, 10, 15, \"rwd\", \"petrol\", 5, 0.60000002384185791, false, 30, 1.1000000238418579, 0.10000000149011612, 0, 0.27000001072883606, -0.20000000298023224, 0.5, 0.30000001192092896, 0.20000000298023224, 0.56000000238418579, 35000, 0, 4194304, \"long\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('941', '560', 'Mercedes-Benz', 'CLA250', '2015', '32000', '50', '2014-12-30 23:29:39', '1260', '2015-01-09 07:35:03', '9736', '\n', '[ [ 1400, 3400, 1.6000000238418579, [ 0, 0.20000000298023224, -0.10000000149011612 ], 75, 0.80000001192092896, 0.80000001192092896, 0.51999998092651367, 5, 190, 9, 5, \"fwd\", \"petrol\", 6.5, 0.69999998807907104, false, 30, 0.89999997615814209, 0.15000000596046448, 0, 0.2800000011920929, -0.20000000298023224, 0.5, 0.30000001192092896, 0.25, 0.60000002384185791, 35000, 10240, 67108866, \"small\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('943', '579', 'Mercedes-Benz', 'ML350', '2015', '48000', '35', '2014-12-30 23:35:56', '1260', '2014-12-31 00:15:16', '1260', '\n', '[ [ 2500, 6000, 0.69999998807907104, [ 0, 0, -0.20000000298023224 ], 80, 0.62000000476837158, 0.88999998569488525, 0.5, 5, 138, 7.5, 25, \"awd\", \"petrol\", 4, 0.40000000596046448, false, 35, 0.69999998807907104, 0.05000000074505806, 0, 0.44999998807907104, -0.20999999344348907, 0.5, 0.30000001192092896, 0.43999999761581421, 0.34999999403953552, 40000, 32, 17412, \"long\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('944', '433', 'AM General', 'M939', '1989', '90000', '100', '2014-12-31 02:07:36', '1624', '0000-00-00 00:00:00', '0', 'Used for military.\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('946', '443', 'Peterbilt', '379 Car Carrier', '2006', '117000', '125', '2015-01-02 06:30:11', '10139', '2015-02-05 03:53:51', '120', '\n', '[ [ 8000, 48273.30078125, 2, [ 0, 0, 0.10000000149011612 ], 90, 0.64999997615814209, 0.85000002384185791, 0.5, 5, 150, 6.9000000953674316, 15, \"awd\", \"diesel\", 4, 0.5, false, 50, 1, 0.10000000149011612, 0, 0.44999998807907104, -0.25, 0.5, 0, 0.56000000238418579, 0.40000000596046448, 20000, 16384, 4456448, \"long\", \"small\", 2 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('947', '560', 'Mercedes-Benz', 'CLA250', '2015', '32000', '50', '2015-01-02 07:03:04', '10139', '0000-00-00 00:00:00', '0', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('948', '507', 'Mercedes-Benz', 'CLS550', '2015', '73200', '40', '2015-01-02 07:04:27', '10139', '2015-01-03 16:33:49', '10139', '\n', '[ [ 2200, 5000, 1.6000000238418579, [ 0, 0.10000000149011612, -0.10000000149011612 ], 75, 0.80000001192092896, 0.80000001192092896, 0.5, 5, 155, 10, 8, \"awd\", \"petrol\", 6, 0.60000002384185791, false, 30, 0.80000001192092896, 0.17499999701976776, 0, 0.34999999403953552, -0.20000000298023224, 0.5, 0.30000001192092896, 0.20000000298023224, 0.30000001192092896, 35000, 1073741824, 272629760, \"long\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('949', '545', 'Legends', 'Ford \'32 Coupe', '2014', '50000', '10', '2015-01-03 02:38:36', '55', '2015-02-06 23:26:15', '1107', '\n', '[ [ 1200, 4000, 2.5, [ 0, 0.10000000149011612, -0.30000001192092896 ], 75, 1, 0.75, 0.47999998927116394, 5, 170, 19, 2, \"rwd\", \"petrol\", 5, 0.69999998807907104, false, 44, 0.60000002384185791, 0.20000000298023224, 0, 0.10000000149011612, -0.0099999997764825821, 0.5, 0.5, 0.18000000715255737, 0.44999998807907104, 20000, 0, 8388608, \"big\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('951', '411', 'Mercedes-Benz', 'SLS AMG', '2015', '221580', '0', '2015-01-03 12:58:35', '10139', '2020-01-03 14:00:39', '1438', '\n', '[ [ 1620, 2725.300048828125, 1.600000023841858, [ 0, 0, -0.25 ], 70, 1.100000023841858, 0.800000011920929, 0.5, 5, 250, 21, 10, \"awd\", \"petrol\", 8.5, 0.6000000238418579, false, 37, 1.200000047683716, 0.1899999976158142, 0, 0.25, -0.1000000014901161, 0.5, 0.4000000059604645, 0.3700000047683716, 0.7200000286102295, 95000, 1073750020, 12599296, \"small\", \"small\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('955', '562', 'Hyundai', 'Genesis Coupe 2.0T', '2014', '26000', '20', '2015-01-03 17:46:39', '9736', '2015-01-03 18:24:03', '9736', '\n', '[ [ 1500, 3500, 2.2000000476837158, [ 0, -0.30000001192092896, -0.15000000596046448 ], 75, 0.80000001192092896, 0.89999997615814209, 0.47999998927116394, 5, 170, 13.899999618530273, 30, \"rwd\", \"petrol\", 6.5, 0.40000000596046448, false, 35, 1, 0.20000000298023224, 0, 0.2800000011920929, -0.079999998211860657, 0.30000001192092896, 0.30000001192092896, 0.25, 0.60000002384185791, 35000, 1073752068, 67108865, \"small\", \"small\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('956', '562', 'Hyundai', 'Genesis Coupe 3.8 V6', '2014', '33000', '20', '2015-01-03 18:11:58', '9736', '2015-01-03 18:33:57', '9736', '\n', '[ [ 1500, 3500, 2, [ 0, -0.30000001192092896, -0.15000000596046448 ], 75, 0.80000001192092896, 0.89999997615814209, 0.47999998927116394, 5, 185, 13, 5, \"rwd\", \"petrol\", 6.3000001907348633, 0.40000000596046448, false, 35, 1, 0.20000000298023224, 0, 0.2800000011920929, -0.10000000149011612, 0.30000001192092896, 0.30000001192092896, 0.25, 0.60000002384185791, 35000, 1073752068, 67108865, \"small\", \"small\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('957', '404', 'Volvo', 'Amazon', '1967', '20000', '15', '2015-01-03 18:59:46', '1260', '2015-01-05 00:18:17', '1260', '\n', '[ [ 1200, 3000, 0.69999998807907104, [ 0, 0.40000000596046448, 0 ], 70, 0.60000002384185791, 0.89999997615814209, 0.47999998927116394, 5, 210, 16, 15, \"rwd\", \"petrol\", 5, 0.80000001192092896, false, 30, 1, 0.10000000149011612, 0, 0.37000000476837158, -0.090000003576278687, 0.5, 0, 0.20000000298023224, 0.60000002384185791, 10000, 32, 0, \"small\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('959', '506', 'Ferrari', 'F355', '1995', '49777', '50', '2015-01-04 07:37:28', '10139', '2015-01-04 07:42:41', '10139', '\n', '[ [ 1350, 2800, 2, [ 0, -0.20000000298023224, -0.23999999463558197 ], 70, 0.75, 0.86000001430511475, 0.47999998927116394, 5, 230, 12, 5, \"rwd\", \"petrol\", 7, 0.60000002384185791, false, 35, 0.80000001192092896, 0.20000000298023224, 0, 0.25, -0.10000000149011612, 0.5, 0.30000001192092896, 0.40000000596046448, 0.54000002145767212, 105000, 1073750020, 2129920, \"long\", \"long\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('961', '506', 'Jaguar', 'XJ220', '1992', '126878', '50', '2015-01-05 10:11:30', '10139', '2015-01-05 10:28:07', '10139', '\n', '[ [ 1470, 2800, 0.10000000149011612, [ 0, -0.20000000298023224, -0.23999999463558197 ], 70, 1.1000000238418579, 0.86000001430511475, 0.44999998807907104, 5, 275, 12, 7.5, \"awd\", \"petrol\", 8, 0.5, false, 30, 1, 0.20000000298023224, 0, 0.25, -0.10000000149011612, 0.5, 0.30000001192092896, 0.40000000596046448, 0.54000002145767212, 105000, 1073750020, 2129920, \"long\", \"long\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('964', '589', 'Lancia ', 'Delta Integrale Evo II', '1995', '1', '25', '2015-01-10 20:54:18', '55', '0000-00-00 00:00:00', '0', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('965', '560', 'Dodge', 'Charger Pursuit', '2016', '1', '0', '2015-01-11 10:54:48', '3496', '2019-10-11 17:28:30', '1438', '\n', '[ [ 2500, 3400, 1, [ 0, 0.2000000029802322, -0.25 ], 75, 0.9599999785423279, 0.800000011920929, 0.4799999892711639, 5, 210, 19, 9, \"awd\", \"petrol\", 8, 0.699999988079071, false, 35, 0.9200000166893005, 0.2000000029802322, 0, 0.2800000011920929, -0.1500000059604645, 0.5, 0.300000011920929, 0.25, 0.6000000238418579, 35000, 10240, 67108866, \"small\", \"small\", 0 ] ]', '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('966', '436', 'BMW', 'E30 M3', '1990', '1', '25', '2015-01-11 21:17:35', '55', '0000-00-00 00:00:00', '0', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('967', '543', 'Datsun', '1200 ute', '1985', '5000', '15', '2015-01-13 09:12:15', '10139', '2015-01-13 13:09:02', '9736', '\n', '[ [ 1500, 4500, 2.7000000476837158, [ 0, 0, -0.05000000074505806 ], 75, 0.75, 0.69999998807907104, 0.5, 5, 120, 7, 15, \"rwd\", \"diesel\", 4.9000000953674316, 0.60000002384185791, false, 35, 0.80000001192092896, 0.20000000298023224, 3, 0.25, -0.15000000596046448, 0.40000000596046448, 0.40000000596046448, 0.25999999046325684, 0.20000000298023224, 26000, 2097216, 1064964, \"long\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('968', '486', 'Liebherr', 'L542', '2011', '115000', '80', '2015-01-13 09:27:12', '10139', '2015-01-13 09:27:49', '10139', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('969', '460', 'Maule', 'M-7 Amphibian', '2006', '180000', '65', '2015-01-13 10:41:03', '10139', '0000-00-00 00:00:00', '0', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('970', '513', 'Pitts', 'Special S1', '1944', '100000', '100', '2015-01-14 01:05:49', '635', '0000-00-00 00:00:00', '0', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('971', '451', 'Ferrari', '458 Italia', '2010', '195000', '210', '2015-01-14 01:50:04', '1260', '2015-02-05 04:02:13', '120', '\n', '[ [ 1400, 3000, 0.69999998807907104, [ 0, -0.30000001192092896, -0.20000000298023224 ], 70, 0.85000002384185791, 0.85000002384185791, 0.47999998927116394, 5, 204, 12, 10, \"awd\", \"petrol\", 11, 0.5, false, 30, 0.89999997615814209, 0.12999999523162842, 0, 0.15000000596046448, -0.17000000178813934, 0.5, 0.40000000596046448, 0.17000000178813934, 0.72000002861022949, 95000, 1073750020, 12616705, \"small\", \"small\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('972', '533', 'BMW', 'E36 M3 Convertible', '1998', '6000', '35', '2015-01-14 02:06:24', '1260', '2015-01-14 02:45:42', '99', '\n', '[ [ 1560, 4500, 0.40000000596046448, [ 0, 0, -0.15000000596046448 ], 75, 0.64999997615814209, 0.89999997615814209, 0.5, 5, 160, 12, 25, \"rwd\", \"petrol\", 5, 0.5, false, 35, 1.1499999761581421, 0.070000000298023224, 0, 0.30000001192092896, -0.10000000149011612, 0.5, 0.30000001192092896, 0.25, 0.60000002384185791, 35000, 1073752064, 0, \"small\", \"small\", 19 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('973', '573', 'International', 'MaxxPro', '2010', '600000', '100', '2015-01-14 04:25:55', '10139', '2015-01-14 04:30:08', '10139', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('974', '402', 'Ford', 'Mustang Cobra Jet', '2014', '325000', '255', '2015-01-14 07:34:47', '10139', '2019-10-23 04:25:13', '1438', '\n', '[ [ 1500, 4000, 2, [ 0, -0.8500000238418579, 0.1000000014901161 ], 85, 1.100000023841858, 0.8999999761581421, 0.4799999892711639, 5, 220, 16, 15, \"rwd\", \"petrol\", 8, 0.6000000238418579, false, 15, 1.399999976158142, 0.1500000059604645, 0, 0.2800000011920929, -0.1000000014901161, 0.2000000029802322, 0.4000000059604645, 0.25, 0.5, 35000, 10240, 270532608, \"small\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('976', '531', 'John Deere', '950', '1987', '8000', '20', '2015-01-17 01:13:41', '1260', '2015-01-17 01:15:51', '1260', '\n', '[ [ 2000, 5000, 3, [ 0, 0, -0.20000000298023224 ], 70, 0.89999997615814209, 0.85000002384185791, 0.5, 4, 80, 8, 30, \"awd\", \"diesel\", 15, 0.20000000298023224, false, 50, 2, 0.11999999731779099, 0, 0.25, -0.05000000074505806, 0.5, 0, 0.25999999046325684, 0.5, 9000, 2102032, 20185093, \"small\", \"small\", 28 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('977', '463', 'Harley-Davidson', 'FXST 1340 Softail', '1985', '6000', '35', '2015-01-17 05:57:56', '10139', '2015-01-20 04:49:49', '9736', '\n', '[ [ 800, 403.29998779296875, 3.5, [ 0, 0.10000000149011612, 0 ], 103, 1.5, 0.81999999284744263, 0.50999999046325684, 4, 130, 17, 5, \"rwd\", \"petrol\", 11, 0.60000002384185791, false, 35, 0.64999997615814209, 0.20000000298023224, 0, 0.090000003576278687, -0.10999999940395355, 0.60000002384185791, 0, 0, 0.23999999463558197, 10000, 16785408, 0, \"small\", \"small\", 6 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('978', '562', 'BMW', 'E46 M3 CSL', '2004', '53000', '35', '2015-01-17 07:05:17', '10139', '2015-01-19 05:42:45', '10139', '\n', '[ [ 1400, 3500, 2.2999999523162842, [ 0, 0.30000001192092896, -0.15000000596046448 ], 75, 0.75, 0.89999997615814209, 0.5, 5, 180, 12.199999809265137, 5, \"rwd\", \"petrol\", 6, 0.60000002384185791, false, 35, 1, 0.20000000298023224, 0, 0.2800000011920929, -0.10000000149011612, 0.5, 0.30000001192092896, 0.25, 0.60000002384185791, 35000, 1073752068, 67108865, \"small\", \"small\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('979', '415', 'Ferrari', 'F12 Berlinetta', '2015', '323745', '200', '2015-01-17 07:30:15', '9736', '2015-01-17 07:45:48', '9736', '\n', '[ [ 1200, 3000, 1.2999999523162842, [ 0, -0.20000000298023224, -0.20000000298023224 ], 70, 0.89999997615814209, 0.89999997615814209, 0.44999998807907104, 5, 215, 15, 7, \"rwd\", \"petrol\", 7, 0.5, false, 35, 1, 0.20000000298023224, 0, 0.10000000149011612, -0.070000000298023224, 0.5, 0.60000002384185791, 0.40000000596046448, 0.54000002145767212, 105000, 3221233664, 2129920, \"long\", \"long\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('980', '441', 'Hasbro', 'Ford Mustang', '2015', '1', '0', '2015-01-17 10:00:37', '9736', '2015-01-17 10:12:33', '9736', 'Testing something with this\n', '[ [ 100, 24.100000381469727, 6, [ 0, 0.05000000074505806, -0.10000000149011612 ], 70, 1, 0.89999997615814209, 0.44999998807907104, 1, 275, 33, 5, \"awd\", \"electric\", 8, 0.5, false, 25, 2, 0.20000000298023224, 0, 0.2800000011920929, -0.15000000596046448, 0.5, 0, 0.20000000298023224, 0.05000000074505806, 500, 4456448, 0, \"long\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('981', '506', 'Ferrari', 'F12 Berlinetta', '2015', '323745', '200', '2015-01-17 12:14:49', '9736', '2015-01-19 05:52:34', '9736', '\n', '[ [ 1400, 2800, 1, [ 0, 0.10000000149011612, -0.23999999463558197 ], 70, 1.1000000238418579, 0.86000001430511475, 0.43000000715255737, 5, 215, 15, 0.10000000149011612, \"rwd\", \"petrol\", 7, 0.60000002384185791, false, 30, 1.2999999523162842, 0.20000000298023224, 0, 0.25, -0.0099999997764825821, 0.5, 0.30000001192092896, 0.40000000596046448, 0.54000002145767212, 105000, 1073750020, 2129920, \"long\", \"long\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('982', '451', 'Ferrari', 'LaFerrari', '2015', '1300000', '375', '2015-01-17 12:42:00', '9736', '2019-10-11 17:36:22', '1438', '\n', '[ [ 1400, 3000, 1, [ 0, -0.4000000059604645, -0.300000011920929 ], 70, 1.299999952316284, 0.8500000238418579, 0.4099999964237213, 5, 221, 18, 5, \"rwd\", \"petrol\", 8, 0.5, false, 40, 1.299999952316284, 0.2000000029802322, 0, 0.1500000059604645, -0.1500000059604645, 0.5, 0.4000000059604645, 0.1700000017881393, 0.7200000286102295, 95000, 1073750020, 12616705, \"small\", \"small\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('983', '451', 'Ferrari', 'LaFerrari', '2014', '1350000', '375', '2015-01-17 17:24:04', '10139', '2015-02-05 03:48:57', '120', '\n', '[ [ 1400, 3000, 1.2000000476837158, [ 0, -0.30000001192092896, -0.20000000298023224 ], 70, 1.1000000238418579, 0.85000002384185791, 0.44999998807907104, 5, 262, 13, 10, \"awd\", \"petrol\", 7.5, 0.60000002384185791, false, 30, 1.5, 0.15000000596046448, 0, 0.15000000596046448, -0.15000000596046448, 0.5, 0.40000000596046448, 0.17000000178813934, 0.72000002861022949, 95000, 1073750020, 12616705, \"small\", \"small\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('984', '482', 'Chevrolet', 'Express 1500', '2012', '20950', '50', '2015-01-17 17:48:55', '10139', '2019-11-17 04:24:25', '1438', '\n', '[ [ 10000, 5000, 1.5, [ 0, 0, -0.2000000029802322 ], 85, 0.75, 0.8700000047683716, 0.5099999904632568, 5, 170, 6.5, 13, \"rwd\", \"petrol\", 5, 0.6000000238418579, false, 30, 1.299999952316284, 0.07000000029802322, 2, 0.4000000059604645, -0.25, 0.4000000059604645, 0.5, 0.2000000029802322, 0.5, 26000, 1, 4194304, \"long\", \"small\", 13 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('985', '411', 'Mercedes-Benz', 'CL65 AMG', '2014', '215000', '150', '2015-01-19 11:34:10', '10139', '2015-01-30 04:28:46', '1107', '\n', '[ [ 1400, 2725.300048828125, 1.25, [ 0, 0, -0.25 ], 70, 0.89999997615814209, 0.80000001192092896, 0.5, 5, 230, 12, 10, \"awd\", \"petrol\", 8, 0.60000002384185791, false, 40, 1, 0.15000000596046448, 0, 0.25, -0.10000000149011612, 0.5, 0.40000000596046448, 0.37000000476837158, 0.72000002861022949, 95000, 1073750020, 12599296, \"small\", \"small\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('986', '443', 'Freightliner', 'C11264ST-CENTURY 112', '2005', '62000', '100', '2015-01-19 21:47:04', '635', '0000-00-00 00:00:00', '0', 'Test\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('987', '507', 'Mercedes-Benz', 'CLS63 AMG', '2015', '106550', '100', '2015-01-22 08:35:08', '10139', '2015-01-26 09:22:30', '9736', '\n', '[ [ 2200, 5000, 1, [ 0, 0.10000000149011612, -0.10000000149011612 ], 75, 0.69999998807907104, 0.80000001192092896, 0.46000000834465027, 5, 131, 12, 10, \"rwd\", \"petrol\", 6, 0.60000002384185791, false, 30, 1, 0.10000000149011612, 0, 0.34999999403953552, -0.15000000596046448, 0.5, 0.30000001192092896, 0.20000000298023224, 0.30000001192092896, 35000, 1073741824, 272629760, \"long\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('988', '482', 'Volkswagen', 'Caddy TDI', '2011', '15000', '35', '2015-01-24 18:50:37', '1260', '2015-01-24 18:53:23', '1260', '\n', '[ [ 1900, 5000, 1.7999999523162842, [ 0, 0, -0.20000000298023224 ], 85, 0.60000002384185791, 0.87000000476837158, 0.50999999046325684, 5, 127, 10, 20, \"rwd\", \"petrol\", 5.5, 0.60000002384185791, false, 30, 1.2999999523162842, 0.070000000298023224, 2, 0.40000000596046448, -0.25, 0.40000000596046448, 0.5, 0.20000000298023224, 0.5, 26000, 1, 4194304, \"long\", \"small\", 13 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('989', '560', 'Audi', 'RS6 ABT', '2010', '52670', '155', '2015-01-25 06:00:24', '9736', '2015-02-05 03:59:33', '120', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('990', '500', 'UAZ', '31512', '1986', '1702', '10', '2015-01-28 03:00:33', '10139', '2015-01-31 05:45:14', '1260', '\n', '[ [ 1300, 1900, 3, [ 0, -0.40000000596046448, -0.30000001192092896 ], 85, 0.69999998807907104, 0.80000001192092896, 0.5, 5, 160, 7, 15, \"awd\", \"diesel\", 5.5, 0.30000001192092896, false, 35, 0.89999997615814209, 0.079999998211860657, 0, 0.31999999284744263, -0.20000000298023224, 0.30000001192092896, 0.40000000596046448, 0.18000000715255737, 0.30000001192092896, 25000, 2099264, 0, \"long\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('993', '579', 'BMW', 'X5 4.8 IS', '2002', '26000', '35', '2015-01-30 03:42:16', '1260', '2015-01-30 03:56:30', '1260', '\n', '[ [ 2500, 6000, 1.7999999523162842, [ 0, 0, -0.20000000298023224 ], 80, 0.69999998807907104, 0.88999998569488525, 0.47999998927116394, 5, 160, 10, 25, \"awd\", \"petrol\", 6, 0.60000002384185791, false, 35, 0.89999997615814209, 0.05000000074505806, 0, 0.44999998807907104, -0.17000000178813934, 0.40000000596046448, 0.30000001192092896, 0.43999999761581421, 0.34999999403953552, 40000, 32, 17412, \"long\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('994', '561', 'Audi', 'RS6 Avant', '2015', '124000', '160', '2015-01-31 05:59:09', '1260', '2015-02-10 23:29:06', '55', '\n', '[ [ 1400, 4500, 0.69999998807907104, [ 0, 0.10000000149011612, -0.10000000149011612 ], 75, 0.60000002384185791, 0.85000002384185791, 0.55000001192092896, 5, 196, 12, 8, \"awd\", \"petrol\", 5.5, 0.69999998807907104, false, 35, 1.1000000238418579, 0.20000000298023224, 0, 0.2800000011920929, -0.10000000149011612, 0.5, 0.30000001192092896, 0.25, 0.60000002384185791, 35000, 10240, 67108864, \"small\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('995', '560', 'Audi', 'RS6 by ABT', '2014', '54980', '150', '2015-02-01 23:17:39', '1107', '2019-11-15 17:46:19', '1438', '\n', '[ [ 1400, 3400, 1.8999999761581421, [ 0, 0.10000000149011612, -0.10000000149011612 ], 75, 1, 0.80000001192092896, 0.47999998927116394, 5, 210, 20, 5, \"awd\", \"petrol\", 7, 0.5, false, 30, 1.2000000476837158, 0.15000000596046448, 0, 0.2800000011920929, -0.10000000149011612, 0.5, 0.30000001192092896, 0.25, 0.60000002384185791, 35000, 10240, 67108866, \"small\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('996', '402', 'Opel', 'Manta', '1988', '21750', '25', '2015-02-02 08:29:07', '1107', '2015-02-02 08:34:07', '1107', '\n', '[ [ 1500, 4000, 2, [ 0, 0, -0.10000000149011612 ], 85, 0.69999998807907104, 0.89999997615814209, 0.5, 5, 135, 9, 5, \"rwd\", \"petrol\", 5, 0.40000000596046448, false, 30, 1.2000000476837158, 0.11999999731779099, 0, 0.2800000011920929, -0.10000000149011612, 0.5, 0.40000000596046448, 0.25, 0.5, 35000, 10240, 270532608, \"small\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('997', '555', 'Jaguar', 'E-Type OTS', '1969', '65000', '15', '2015-02-02 08:42:19', '1107', '2019-11-14 17:51:06', '1438', '\n', '[ [ 1500, 3500, 2, [ 0, 0.05000000074505806, -0.2000000029802322 ], 75, 0.550000011920929, 0.8500000238418579, 0.5, 5, 170, 12, 7, \"awd\", \"petrol\", 8, 0.4000000059604645, false, 30, 0.6499999761581421, 0.07000000029802322, 0, 0.1500000059604645, -0.1000000014901161, 0.5, 0.300000011920929, 0.25, 0.6000000238418579, 35000, 1076373508, 0, \"small\", \"small\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('998', '457', 'Tomberlin', 'E-Merge', '2008', '6800', '10', '2015-02-02 17:46:27', '1107', '2015-02-02 17:46:43', '1107', '\n', '[ [ 1000, 1354.199951171875, 4, [ 0, 0, -0.10000000149011612 ], 70, 0.55000001192092896, 0.85000002384185791, 0.5, 3, 160, 6, 30, \"awd\", \"electric\", 13, 0.5, false, 30, 1, 0.090000003576278687, 0, 0.2800000011920929, -0.12999999523162842, 0.5, 0, 0.25999999046325684, 0.5, 9000, 4352, 34820, \"small\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('999', '522', 'Ducati', 'Superbike Panigale R', '2015', '233000', '120', '2015-02-02 17:52:11', '1107', '2020-04-30 21:42:16', '744', '\n', '[ [ 400, 200, 4, [ 0, 0.07999999821186066, -0.09000000357627869 ], 103, 1.799999952316284, 0.8999999761581421, 0.4799999892711639, 5, 275, 50, 30, \"rwd\", \"petrol\", 15, 0.5, false, 35, 0.8500000238418579, 0.1500000059604645, 0, 0.1500000059604645, -0.1599999964237213, 0.5, 0, 0, 0.1500000059604645, 10000, 16785408, 2, \"small\", \"small\", 4 ] ]', '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('1000', '579', 'Toyota', 'LandCruiser 3.0 TDI', '2015', '58588', '75', '2015-02-02 18:00:36', '1107', '2015-02-02 18:01:36', '1107', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('1001', '463', 'Harley Davidson', 'FLH Hydra Glide', '1955', '11500', '5', '2015-02-02 18:03:54', '1107', '0000-00-00 00:00:00', '0', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('1002', '562', 'BMW', 'E46 330ci', '2003', '17000', '45', '2015-02-02 18:07:28', '1107', '2015-02-02 18:08:28', '1107', '\n', '[ [ 1500, 3500, 2.2000000476837158, [ 0, 0.30000001192092896, -0.15000000596046448 ], 75, 0.64999997615814209, 0.89999997615814209, 0.5, 5, 200, 11.199999809265137, 5, \"rwd\", \"petrol\", 8, 0.5, false, 35, 1, 0.20000000298023224, 0, 0.2800000011920929, -0.10000000149011612, 0.5, 0.30000001192092896, 0.25, 0.60000002384185791, 35000, 1073752068, 67108865, \"small\", \"small\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('1003', '541', 'Spyker', 'C8 Aileron', '2014', '125000', '175', '2015-02-02 18:19:46', '1107', '2015-02-05 03:55:32', '120', '\n', '[ [ 1200, 2500, 1.3999999761581421, [ 0, -0.15000000596046448, -0.20000000298023224 ], 70, 0.75, 0.89999997615814209, 0.47999998927116394, 5, 190, 12, 10, \"rwd\", \"petrol\", 8, 0.60000002384185791, false, 30, 1, 0.12999999523162842, 5, 0.25, -0.10000000149011612, 0.40000000596046448, 0.30000001192092896, 0.15000000596046448, 0.54000002145767212, 105000, 3221233664, 2113536, \"long\", \"long\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('1004', '589', 'Volkswagen', 'Golf II GTI', '1988', '5000', '50', '2015-02-03 04:04:47', '1107', '2019-10-23 01:39:05', '1438', '\n', '[ [ 1400, 3000, 2.799999952316284, [ 0, 0, 0 ], 80, 0.800000011920929, 0.8999999761581421, 0.4799999892711639, 5, 110, 6, 10, \"fwd\", \"petrol\", 5.5, 0.6000000238418579, false, 30, 0.8999999761581421, 0.1000000014901161, 0, 0.2800000011920929, -0.1500000059604645, 0.5, 0, 0.25, 0.5, 35000, 8192, 12582912, \"small\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('1005', '506', 'Chevrolet', 'Corvette Z06 Coupe 3LZ', '2015', '101310', '50', '2015-02-04 07:44:35', '1107', '2015-02-08 17:16:44', '55', '\n', '[ [ 1400, 2800, 1.2000000476837158, [ 0, -0.20000000298023224, -0.23999999463558197 ], 70, 0.80000001192092896, 0.86000001430511475, 0.40000000596046448, 5, 248, 18.5, 5, \"rwd\", \"petrol\", 6, 0.5, false, 30, 1, 0.20000000298023224, 0, 0.25, -0.039999999105930328, 0.40000000596046448, 0.30000001192092896, 0.40000000596046448, 0.54000002145767212, 105000, 1073750020, 2129920, \"long\", \"long\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('1006', '596', 'Ford', 'Mondeo', '2016', '40000', '45', '2015-02-08 21:09:07', '1260', '2021-03-27 11:03:28', '17826', '\n', '[ [ 1600, 4500, 0.69999998807907104, [ 0, 0.60000002384185791, -0.10000000149011612 ], 75, 1, 0.85000002384185791, 0.44999998807907104, 5, 206, 20, 9, \"rwd\", \"petrol\", 8, 0.80000001192092896, false, 35, 1, 0.20000000298023224, 0, 0.2800000011920929, -0.20000000298023224, 0.5, 0, 0.20000000298023224, 0.23999999463558197, 25000, 1073741824, 270532616, \"long\", \"small\", 0 ] ]', '1000', '1', '0', null);
INSERT INTO `vehicles_shop` VALUES ('1007', '562', 'BMW', 'E36 325ci Coupe', '1998', '12000', '20', '2015-02-09 00:48:40', '1107', '2015-02-09 02:24:47', '1107', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('1008', '411', 'Lamborghini', 'Aventador LP700-4', '2014', '1497650', '155', '2015-02-09 01:12:59', '1107', '2019-11-01 15:16:59', '1438', '\n', '[ [ 1400, 2725.300048828125, 1.5, [ 0, 0, -0.25 ], 70, 0.699999988079071, 0.800000011920929, 0.5, 5, 240, 19, 4, \"awd\", \"petrol\", 11, 0.5, false, 30, 1.200000047683716, 0.1899999976158142, 0, 0.25, -0.1000000014901161, 0.5, 0.4000000059604645, 0.3700000047683716, 0.7200000286102295, 95000, 1073750020, 12599296, \"small\", \"small\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('1009', '558', 'Nissan', 'Integra Type-R', '2000', '16000', '25', '2015-02-10 00:59:13', '1107', '2019-10-23 01:33:52', '1438', '\n', '[ [ 1400, 2998.300048828125, 2, [ 0, 0.1000000014901161, -0.300000011920929 ], 75, 0.800000011920929, 0.8500000238418579, 0.4699999988079071, 5, 125, 11, 5, \"fwd\", \"petrol\", 8, 0.4000000059604645, false, 30, 1.299999952316284, 0.1500000059604645, 0, 0.2800000011920929, -0.01999999955296516, 0.5, 0.300000011920929, 0.25, 0.6000000238418579, 35000, 3221235712, 67108865, \"small\", \"small\", 0 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('1010', '490', '[DONATE] Range Rover', 'SPORT 3.0 SDV6', '2015', '999999999', '0', '2015-02-10 03:17:50', '1107', '2021-03-26 16:32:16', '17800', '\n', '[ [ 5540, 11156.2001953125, 2.200000047683716, [ 0, 0, -0.25 ], 80, 0.75, 0.800000011920929, 0.5, 5, 270, 25, 7, \"awd\", \"petrol\", 20, 0.800000011920929, false, 35, 0.800000011920929, 0.07999999821186066, 0, 0.3400000035762787, -0.1000000014901161, 0.5, 0.5, 0.4399999976158142, 0.300000011920929, 40000, 16416, 5242880, \"long\", \"small\", 0 ] ]', '1000', '1', '0', null);
INSERT INTO `vehicles_shop` VALUES ('1012', '435', 'Schimitz', 'Cargobull', '2015', '25000', '250', '2015-03-08 21:10:35', '61', '2019-11-22 20:42:08', '1438', '\n', null, '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('1014', '403', 'Volvo', 'PH16', '2013', '90000', '500', '2015-03-09 14:37:53', '61', '2020-03-13 16:23:56', '745', '\n', null, '1000', '1', '5', '0');
INSERT INTO `vehicles_shop` VALUES ('1015', '432', 'Unknown', 'Tank', '2017', '111111111', '111111', '2019-10-31 15:35:12', '1438', '2019-11-10 17:28:28', '1438', '\n', '[ [ 10000, 250000, 5, [ 0, 0, 0 ], 90, 2.5, 0.800000011920929, 0.5, 4, 275, 75, 0.1000000014901161, \"awd\", \"diesel\", 5, 0.5, false, 35, 0.4000000059604645, 0.01999999955296516, 0, 0.3499999940395355, -0.1000000014901161, 0.5, 0, 0.2199999988079071, 0.09000000357627869, 110000, 1073774600, 3180608, \"long\", \"small\", 24 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('1016', '495', 'test', 'test', '1999', '12312312', '123', '2019-11-15 19:30:13', '1438', '2019-11-15 19:31:52', '1438', 'test aracÄ±\n', '[ [ 2000, 4000, 2.200000047683716, [ 0, 0, -0.6000000238418579 ], 80, 0.75, 0.8500000238418579, 0.5, 5, 170, 11.19999980926514, 10, \"awd\", \"petrol\", 8, 0.5, false, 30, 0.800000011920929, 0.07999999821186066, 0, 0.3499999940395355, -0.3100000023841858, 0.5, 0, 0.3799999952316284, 0.3499999940395355, 40000, 0, 3246080, \"long\", \"small\", 22 ] ]', '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('1017', '455', 'Mercedes-Benz', 'G-Class', '2015', '2147483647', '123', '2019-11-16 01:07:11', '1438', '0000-00-00 00:00:00', '0', '\n', null, '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('1018', '520', 'Fighting Falcon', 'F-16', '2019', '546345345', '123', '2019-11-25 22:17:58', '752', '0000-00-00 00:00:00', '0', '\n', null, '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('1019', '607', 'Mercedes', 'Transport', '1994', '1', '1', '2019-12-23 02:47:27', '1438', '0000-00-00 00:00:00', '0', '\n', null, '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('1020', '571', 'TonyKart', 'Krypton NSK', '2014', '1', '1', '2019-12-28 04:50:31', '1438', '2019-12-28 04:51:50', '1438', '\n', '[ [ 300, 150, 5, [ 0, 0, -0.1500000059604645 ], 110, 0.8999999761581421, 0.8500000238418579, 0.4799999892711639, 4, 275, 75, 30, \"awd\", \"petrol\", 15, 0.2000000029802322, false, 35, 1.5, 0.2000000029802322, 0, 0.25, -0.03999999910593033, 0.5, 0, 0.3799999952316284, 0.4000000059604645, 15000, 1073748736, 3179009, \"small\", \"big\", 18 ] ]', '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('1021', '581', 'Ducati', 'Panigale V4S', '2017', '12312312', '0', '2019-12-29 15:27:47', '1438', '2020-01-04 13:00:27', '745', '\n', '[ [ 400, 200, 0.1000000014901161, [ 0, 0, -0.300000011920929 ], 103, 2.299999952316284, 0.8999999761581421, 0.4799999892711639, 5, 150, 65, 25, \"rwd\", \"petrol\", 50, 0.5, false, 35, 0.8500000238418579, 0.1500000059604645, 0, 0.1500000059604645, -0.2000000029802322, 0.5, 0, 0, 0.1500000059604645, 10000, 16777216, 0, \"small\", \"small\", 4 ] ]', '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('1022', '449', 'Tramvay', 'Ä°STRAM', '2020', '2147483647', '1', '2020-01-30 13:00:56', '1438', '0000-00-00 00:00:00', '0', '\n', null, '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('1024', '476', 'Rustler', 'Rustler', '2020', '5000000', '0', '2020-03-29 05:42:00', '10879', '0000-00-00 00:00:00', '0', '\n', null, '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('1025', '559', 'Mazda ', 'RX-7 Special Edition', '2017', '1200000', '400', '2020-04-02 20:14:57', '1438', '2020-06-13 11:49:26', '744', '\n', '[ [ 1500, 3600, 2.200000047683716, [ 0, 0.300000011920929, -0.009999999776482582 ], 75, 0.699999988079071, 0.800000011920929, 0.5, 5, 201.6999969482422, 21, 30, \"rwd\", \"petrol\", 10, 0.5, false, 30, 2, 0.2000000029802322, 0, 0.2800000011920929, -0.1000000089406967, 0.6000000238418579, 0.300000011920929, 0.25, 0.6000000238418579, 35000, 3221235716, 67108864, \"small\", \"small\", 1 ] ]', '1000', '1', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('1028', '481', 'DENEME', 'pavlov', '2020', '75000', '25', '2020-06-20 02:58:54', '2545', '0000-00-00 00:00:00', '0', '\n', null, '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('1029', '481', 'Charger', 'pavlov', '2020', '750000', '15', '2020-06-20 03:00:23', '2545', '0000-00-00 00:00:00', '0', '\n', null, '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('1030', '481', 'pavlov', 'Charger', '2020', '20000', '15', '2020-06-20 03:02:08', '2545', '0000-00-00 00:00:00', '0', '\n', null, '1000', '0', '0', '0');
INSERT INTO `vehicles_shop` VALUES ('1032', '481', 'pavlov', 'Charge', '2017', '15000', '750', '2020-06-20 03:18:23', '2545', '0000-00-00 00:00:00', '0', '\n', null, '1000', '0', '0', null);
INSERT INTO `vehicles_shop` VALUES ('1033', '503', 'Maserati', 'Ghibli', '2017', '99999999', '0', '2020-06-20 04:38:03', '2545', '0000-00-00 00:00:00', '0', '\n', null, '1000', '0', '0', null);
INSERT INTO `vehicles_shop` VALUES ('1034', '405', '[DONATE] Audi', 'R8 Quattro', '2021', '999999999', '100', '2021-03-26 00:14:20', '17796', '2021-03-26 19:16:14', '17826', '\n', '[ [ 1600, 4000, 2.200000047683716, [ 0, 0, -0.2000000029802322 ], 75, 0.6499999761581421, 0.75, 0.5, 5, 260, 25, 10, \"awd\", \"petrol\", 10, 0.5, false, 27, 1, 0.07999999821186066, 0, 0.300000011920929, -0.1099999994039536, 0.5, 0.300000011920929, 0.2000000029802322, 0.5600000023841858, 35000, 0, 4194304, \"long\", \"small\", 0 ] ]', '1000', '0', '0', null);
INSERT INTO `vehicles_shop` VALUES ('1035', '400', '[DONATE] Cadillac', 'Escalade 6.2 V8', '2013', '999999999', '100', '2021-03-26 00:22:58', '17796', '2021-03-26 16:36:24', '17800', '\n', '[ [ 1800, 5008.2998046875, 2.5, [ 0, 0, -0.300000011920929 ], 85, 0.75, 0.8500000238418579, 0.5, 5, 275, 45, 20, \"awd\", \"diesel\", 15, 0.6000000238418579, false, 35, 2.400000095367432, 0.07999999821186066, 0, 0.2800000011920929, -0.1400000005960464, 0.5, 0.25, 0.2700000107288361, 0.2300000041723251, 25000, 32, 5242882, \"long\", \"small\", 0 ] ]', '1000', '0', '0', null);
INSERT INTO `vehicles_shop` VALUES ('1036', '526', 'BMW', 'M85Ä°', '2020', '350000', '125', '2021-03-26 17:22:26', '17797', '2021-03-27 11:14:59', '17826', '\n', null, '1000', '0', '0', null);
INSERT INTO `vehicles_shop` VALUES ('1037', '445', 'Mercedes-Benz', 'W123', '1986', '24500', '25', '2021-03-26 22:14:28', '17826', '2021-03-27 10:46:55', '17826', '\n', '[ [ 1650, 3851.39990234375, 2, [ 0, 0, -0.05000000074505806 ], 75, 0.6499999761581421, 0.8999999761581421, 0.5099999904632568, 5, 165, 8.800000190734863, 8, \"fwd\", \"petrol\", 8.5, 0.5, false, 30, 1, 0.1500000059604645, 0, 0.2700000107288361, -0.1899999976158142, 0.5, 0.550000011920929, 0.2000000029802322, 0.5600000023841858, 35000, 0, 4194304, \"long\", \"small\", 0 ] ]', '1000', '0', '0', null);
INSERT INTO `vehicles_shop` VALUES ('1038', '445', 'Mercedes-Benz', 'W123', '1984', '22500', '25', '2021-03-26 22:17:34', '17826', '2021-03-27 10:47:26', '17826', '\n', '[ [ 1650, 3851.39990234375, 2, [ 0, 0, -0.05000000074505806 ], 75, 0.6499999761581421, 0.8999999761581421, 0.5099999904632568, 5, 165, 8.800000190734863, 8, \"fwd\", \"petrol\", 8.5, 0.5, false, 30, 1, 0.1500000059604645, 0, 0.2700000107288361, -0.1899999976158142, 0.5, 0.550000011920929, 0.2000000029802322, 0.5600000023841858, 35000, 0, 4194304, \"long\", \"small\", 0 ] ]', '1000', '0', '0', null);
INSERT INTO `vehicles_shop` VALUES ('1039', '445', 'Mercedes-Benz', 'W123', '1985', '22500', '25', '2021-03-26 22:20:57', '17902', '0000-00-00 00:00:00', '0', '\n', null, '1000', '0', '0', null);
INSERT INTO `vehicles_shop` VALUES ('1040', '566', 'Ford', 'FocusRS', '2014', '46000', '60', '2021-03-26 22:23:13', '17902', '2021-03-26 22:24:47', '17826', '\n', null, '1000', '0', '0', null);
INSERT INTO `vehicles_shop` VALUES ('1041', '566', 'Ford', 'FocusRS', '2014', '46500', '60', '2021-03-26 22:23:36', '17826', '0000-00-00 00:00:00', '0', '\n', null, '1000', '0', '0', null);
INSERT INTO `vehicles_shop` VALUES ('1042', '566', 'Ford', 'FocusRS', '2013', '46000', '60', '2021-03-26 22:23:48', '17902', '2021-03-26 22:24:31', '17826', '\n', null, '1000', '0', '0', null);
INSERT INTO `vehicles_shop` VALUES ('1043', '566', 'Ford', 'FocusRS', '2013', '45500', '60', '2021-03-26 22:24:00', '17826', '0000-00-00 00:00:00', '0', '\n', null, '1000', '0', '0', null);
INSERT INTO `vehicles_shop` VALUES ('1044', '551', 'Volkswagen', 'Jetta 1.6 TDI', '2014', '91000', '60', '2021-03-26 22:26:33', '17902', '0000-00-00 00:00:00', '0', '\n', null, '1000', '0', '0', null);
INSERT INTO `vehicles_shop` VALUES ('1045', '551', 'Volkswagen', 'Jetta 1.6 TDI', '2014', '90000', '60', '2021-03-26 22:26:36', '17826', '0000-00-00 00:00:00', '0', '\n', null, '1000', '0', '0', null);
INSERT INTO `vehicles_shop` VALUES ('1046', '551', 'Volkswagen', 'Jetta 1.6 TDI', '2014', '91000', '60', '2021-03-26 22:27:02', '17902', '0000-00-00 00:00:00', '0', '\n', null, '1000', '0', '0', null);
INSERT INTO `vehicles_shop` VALUES ('1047', '551', 'Volkswagen', 'Jetta 1.6 TDI', '2014', '91000', '60', '2021-03-26 22:27:06', '17826', '0000-00-00 00:00:00', '0', '\n', null, '1000', '0', '0', null);
INSERT INTO `vehicles_shop` VALUES ('1048', '527', 'Mercedes-Benz', 'S500 CDI', '2017', '135000', '80', '2021-03-26 22:29:07', '17902', '0000-00-00 00:00:00', '0', '\n', null, '1000', '0', '0', null);
INSERT INTO `vehicles_shop` VALUES ('1049', '527', 'Mercedes-Benz', 'S500 CDI', '2017', '135000', '80', '2021-03-26 22:29:13', '17826', '0000-00-00 00:00:00', '0', '\n', null, '1000', '0', '0', null);
INSERT INTO `vehicles_shop` VALUES ('1050', '527', 'Mercedes-Benz', 'S500 CDI', '2017', '135500', '80', '2021-03-26 22:29:39', '17826', '0000-00-00 00:00:00', '0', '\n', null, '1000', '0', '0', null);
INSERT INTO `vehicles_shop` VALUES ('1051', '527', 'Mercedes-Benz', 'S500 CDI', '2017', '135500', '80', '2021-03-26 22:29:42', '17902', '0000-00-00 00:00:00', '0', '\n', null, '1000', '0', '0', null);
INSERT INTO `vehicles_shop` VALUES ('1052', '527', 'Mercedes-Benz', 'S500 CDI', '2017', '135500', '80', '2021-03-26 22:30:30', '17902', '2021-03-27 10:51:40', '17826', '\n', '[ [ 1200, 2000, 2.200000047683716, [ 0, 0.1500000059604645, -0.1000000014901161 ], 70, 0.699999988079071, 0.8600000143051147, 0.5, 4, 160, 10, 5, \"rwd\", \"petrol\", 8, 0.6000000238418579, false, 30, 1.399999976158142, 0.119999997317791, 0, 0.300000011920929, -0.07999999821186066, 0.5, 0, 0.2599999904632568, 0.5, 9000, 1073741824, 2, \"long\", \"long\", 0 ] ]', '1000', '0', '0', null);
INSERT INTO `vehicles_shop` VALUES ('1053', '527', 'Mercedes-Benz', 'S500 CDI', '2017', '145000', '80', '2021-03-26 23:40:42', '17838', '2021-03-27 10:50:50', '17826', '\n', null, '1000', '0', '0', null);
INSERT INTO `vehicles_shop` VALUES ('1054', '585', 'TofaÅŸ', 'Åžahin 5Vites', '1993', '17800', '35', '2021-03-27 10:53:36', '17826', '0000-00-00 00:00:00', '0', '\n', null, '1000', '0', '0', null);
INSERT INTO `vehicles_shop` VALUES ('1055', '585', 'TofaÅŸ', 'Åžahin 5Vites', '1992', '16800', '35', '2021-03-27 10:53:58', '17826', '0000-00-00 00:00:00', '0', '\n', null, '1000', '0', '0', null);
INSERT INTO `vehicles_shop` VALUES ('1056', '585', 'TofaÅŸ', 'Åžahin 5Vites', '1993', '17900', '35', '2021-03-27 10:54:18', '17826', '0000-00-00 00:00:00', '0', '\n', null, '1000', '0', '0', null);
INSERT INTO `vehicles_shop` VALUES ('1057', '585', 'TofaÅŸ', 'Åžahin 5Vites', '1992', '16500', '35', '2021-03-27 10:54:37', '17826', '0000-00-00 00:00:00', '0', '\n', null, '1000', '0', '0', null);
INSERT INTO `vehicles_shop` VALUES ('1058', '585', 'TofaÅŸ', 'Åžahin 5Vites', '1992', '16650', '35', '2021-03-27 10:55:16', '17826', '0000-00-00 00:00:00', '0', '\n', null, '1000', '0', '0', null);
INSERT INTO `vehicles_shop` VALUES ('1059', '585', 'TofaÅŸ', 'Åžahin 5Vites', '1992', '16500', '35', '2021-03-27 10:55:31', '17826', '0000-00-00 00:00:00', '0', '\n', null, '1000', '0', '0', null);
INSERT INTO `vehicles_shop` VALUES ('1060', '445', 'Mercedes-Benz', 'W123', '1984', '23500', '25', '2021-03-27 10:59:27', '17826', '0000-00-00 00:00:00', '0', '\n', null, '1000', '0', '0', null);
INSERT INTO `vehicles_shop` VALUES ('1061', '445', 'Mercedes-Benz', 'W123', '1985', '22500', '30', '2021-03-27 10:59:52', '17826', '0000-00-00 00:00:00', '0', '\n', null, '1000', '0', '0', null);
INSERT INTO `vehicles_shop` VALUES ('1062', '551', 'Volkswagen', 'Jetta 1.6 TDI', '2014', '91000', '60', '2021-03-27 11:02:05', '17826', '0000-00-00 00:00:00', '0', '\n', null, '1000', '0', '0', null);
INSERT INTO `vehicles_shop` VALUES ('1063', '547', 'Audi ', 'A4', '2014', '42500', '45', '2021-03-27 11:07:19', '17826', '0000-00-00 00:00:00', '0', '\n', null, '1000', '0', '0', null);
INSERT INTO `vehicles_shop` VALUES ('1064', '547', 'Audi', 'A4', '2014', '42500', '45', '2021-03-27 11:07:51', '17826', '0000-00-00 00:00:00', '0', '\n', null, '1000', '0', '0', null);
INSERT INTO `vehicles_shop` VALUES ('1065', '566', 'Ford', 'FocusRS', '2014', '46000', '60', '2021-03-27 11:09:17', '17826', '0000-00-00 00:00:00', '0', '\n', null, '1000', '0', '0', null);
INSERT INTO `vehicles_shop` VALUES ('1066', '566', 'Ford', 'FocusRS', '2014', '46000', '60', '2021-03-27 11:09:33', '17826', '0000-00-00 00:00:00', '0', '\n', null, '1000', '0', '0', null);
INSERT INTO `vehicles_shop` VALUES ('1067', '566', 'Ford', 'FocusRS', '2014', '46000', '60', '2021-03-27 11:09:50', '17826', '0000-00-00 00:00:00', '0', '\n', null, '1000', '0', '0', null);
INSERT INTO `vehicles_shop` VALUES ('1068', '526', 'BMW', 'M85Ä°', '2020', '350000', '120', '2021-03-27 11:14:50', '17826', '0000-00-00 00:00:00', '0', '\n', null, '1000', '0', '0', null);
INSERT INTO `vehicles_shop` VALUES ('1069', '526', 'BMW', 'M85Ä°', '2020', '350000', '120', '2021-03-27 11:15:36', '17826', '0000-00-00 00:00:00', '0', '\n', null, '1000', '0', '0', null);
INSERT INTO `vehicles_shop` VALUES ('1070', '526', 'BMW', 'M85Ä°', '2020', '350000', '120', '2021-03-27 11:15:56', '17826', '0000-00-00 00:00:00', '0', '\n', null, '1000', '0', '0', null);
INSERT INTO `vehicles_shop` VALUES ('1071', '526', 'BMW', 'M85Ä°', '2020', '350000', '120', '2021-03-27 11:16:13', '17826', '0000-00-00 00:00:00', '0', '\n', null, '1000', '0', '0', null);
INSERT INTO `vehicles_shop` VALUES ('1072', '526', 'BMW', 'M85Ä°', '2020', '350000', '120', '2021-03-27 11:16:28', '17826', '0000-00-00 00:00:00', '0', '\n', null, '1000', '0', '0', null);
INSERT INTO `vehicles_shop` VALUES ('1073', '526', 'BMW', 'M85Ä°', '2020', '350000', '120', '2021-03-27 11:16:42', '17826', '0000-00-00 00:00:00', '0', '\n', null, '1000', '0', '0', null);
INSERT INTO `vehicles_shop` VALUES ('1074', '526', 'BMW', 'M85Ä°', '2020', '350000', '120', '2021-03-27 11:16:55', '17826', '0000-00-00 00:00:00', '0', '\n', null, '1000', '0', '0', null);
INSERT INTO `vehicles_shop` VALUES ('1075', '526', 'BMW', 'M85Ä°', '2020', '350000', '120', '2021-03-27 11:17:06', '17826', '0000-00-00 00:00:00', '0', '\n', null, '1000', '0', '0', null);
INSERT INTO `vehicles_shop` VALUES ('1076', '529', 'Audi', 'A7', '2017', '2147483647', '35', '2021-04-11 16:40:09', '17927', '2021-04-11 16:44:11', '17927', '\n', '[ { \"1\": 5000, \"2\": 4350, \"3\": 0.1000000014901161, \"4\": [ 0, 0, -0.5 ], \"5\": 70, \"6\": 1.5, \"7\": 0.800000011920929, \"8\": 0.3899999856948853, \"9\": 4, \"10\": 219, \"11\": 25, \"12\": 15, \"13\": \"awd\", \"14\": \"petrol\", \"15\": 8, \"16\": 0.5, \"17\": false, \"18\": 25, \"19\": 1, \"20\": 0.2000000029802322, \"21\": 0, \"22\": 0.3199999928474426, \"23\": -0.1400000005960464, \"24\": 0.5, \"25\": 0, \"26\": 0.2599999904632568, \"27\": 0.5400000214576721, \"28\": 19000, \"29\": 1073741824, \"30\": 0, \"31\": \"long\", \"33\": 0 } ]', '1000', '1', '0', null);
INSERT INTO `vehicles_shop` VALUES ('1077', '561', 'Tofas', 'Dogan SLX', '1994', '2147483647', '15', '2021-04-11 16:45:19', '17927', '2021-04-11 16:47:36', '17927', '\n', '[ [ 2500, 4500, 0.1000000014901161, [ 0, 0, -0.239999994635582 ], 75, 0.8999999761581421, 0.8500000238418579, 0.5, 5, 186, 18, 30, \"awd\", \"petrol\", 20, 0.5, false, 35, 1, 0.2000000029802322, 0, 0.2800000011920929, -0.1599999964237213, 0.5, 0.300000011920929, 0.25, 0.6000000238418579, 35000, 10240, 67108864, \"small\", \"small\", 0 ] ]', '1000', '1', '0', null);
INSERT INTO `vehicles_shop` VALUES ('1078', '490', 'Land Rover', 'Range Rover', '2016', '2147483647', '25', '2021-04-11 16:49:39', '17927', '2021-04-11 16:53:52', '17927', '\n', '[ [ 2500, 3800, 0.1000000014901161, [ 0, 0, -1 ], 75, 1.100000023841858, 0.8500000238418579, 0.5, 4, 210, 24, 30, \"awd\", \"petrol\", 20, 0.5, false, 35, 1.5, 0.1000000014901161, 0, 0.2700000107288361, -0.1000000089406967, 0.5, 0.2000000029802322, 0.239999994635582, 0.4799999892711639, 18000, 32, 1, \"small\", \"small\", 0 ] ]', '1000', '1', '0', null);
INSERT INTO `vehicles_shop` VALUES ('1079', '602', 'Mercedes ', 'AMG GT-R', '2016', '2147483647', '25', '2021-04-11 16:56:40', '17927', '2021-04-11 16:59:44', '17927', '\n', '[ [ 2500, 3400, 0.1000000014901161, [ 0, 0, -0.300000011920929 ], 85, 1, 0.800000011920929, 0.5, 5, 200, 22.5, 20, \"awd\", \"petrol\", 20, 0.5, false, 35, 2, 0.2000000029802322, 0, 0.300000011920929, -0.07750000059604645, 0.5, 0.4000000059604645, 0.25, 0.5, 35000, 1073752064, 2097152, \"small\", \"small\", 0 ] ]', '1000', '1', '0', null);
INSERT INTO `vehicles_shop` VALUES ('1080', '412', 'BMW', 'M4', '2016', '2147483647', '20', '2021-04-11 17:10:45', '17927', '2021-04-11 17:31:25', '17927', '\n', '[ [ 2500, 4411.5, 0.1000000014901161, [ 0, -0.2000000029802322, -0.239999994635582 ], 70, 0.8999999761581421, 0.800000011920929, 0.5, 5, 202, 20, 30, \"awd\", \"petrol\", 20, 0.5, false, 35, 1, 0.2000000029802322, 0, 0.2000000029802322, -0.1000000014901161, 0.5, 0.6000000238418579, 0.2599999904632568, 0.4099999964237213, 30000, 0, 37814280, \"small\", \"small\", 0 ] ]', '1000', '1', '0', null);
INSERT INTO `vehicles_shop` VALUES ('1081', '402', 'Masserati ', 'GranTourismo MC Stradale', '2020', '2147483647', '20', '2021-04-11 17:33:48', '17927', '2021-04-11 17:37:26', '17927', '\n', '[ [ 2500, 4000, 0.1000000014901161, [ 0, -0.2000000029802322, -0.239999994635582 ], 85, 0.8999999761581421, 0.8999999761581421, 0.5, 5, 190, 19.29999923706055, 30, \"awd\", \"petrol\", 20, 0.300000011920929, false, 35, 1, 0.2000000029802322, 0, 0.2800000011920929, -0.1000000014901161, 0.5, 0.4000000059604645, 0.25, 0.5, 35000, 10240, 270532608, \"small\", \"small\", 0 ] ]', '1000', '1', '0', null);

-- ----------------------------
-- Table structure for `vehicle_logs`
-- ----------------------------
DROP TABLE IF EXISTS `vehicle_logs`;
CREATE TABLE `vehicle_logs` (
  `log_id` int(11) NOT NULL AUTO_INCREMENT,
  `date` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `vehID` int(11) DEFAULT NULL,
  `action` text,
  `actor` int(11) DEFAULT NULL,
  PRIMARY KEY (`log_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=260268 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='Stores all admin actions on vehicles - Monitored by Vehicle ';

-- ----------------------------
-- Records of vehicle_logs
-- ----------------------------

-- ----------------------------
-- Table structure for `vehicle_notes`
-- ----------------------------
DROP TABLE IF EXISTS `vehicle_notes`;
CREATE TABLE `vehicle_notes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `vehid` int(11) NOT NULL,
  `creator` int(11) NOT NULL DEFAULT '0',
  `note` text NOT NULL,
  `date` text,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of vehicle_notes
-- ----------------------------

-- ----------------------------
-- Table structure for `vipplayers`
-- ----------------------------
DROP TABLE IF EXISTS `vipplayers`;
CREATE TABLE `vipplayers` (
  `id` int(11) NOT NULL,
  `char_id` int(11) NOT NULL,
  `vip_type` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `vip_end_tick` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`char_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of vipplayers
-- ----------------------------

-- ----------------------------
-- Table structure for `wearables`
-- ----------------------------
DROP TABLE IF EXISTS `wearables`;
CREATE TABLE `wearables` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bone` int(11) NOT NULL DEFAULT '1',
  `x` float NOT NULL DEFAULT '0',
  `y` float NOT NULL DEFAULT '0',
  `z` float NOT NULL DEFAULT '0',
  `rx` float DEFAULT '0',
  `ry` float NOT NULL DEFAULT '0',
  `rz` float NOT NULL DEFAULT '0',
  `sz` float NOT NULL DEFAULT '1',
  `sy` float NOT NULL DEFAULT '1',
  `sx` float NOT NULL DEFAULT '1',
  `model` int(11) NOT NULL,
  `owner` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=47699 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Records of wearables
-- ----------------------------

-- ----------------------------
-- Table structure for `wiretransfers`
-- ----------------------------
DROP TABLE IF EXISTS `wiretransfers`;
CREATE TABLE `wiretransfers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `from` int(11) DEFAULT '0',
  `to` int(11) DEFAULT '0',
  `amount` int(11) NOT NULL,
  `reason` text,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `type` int(11) NOT NULL,
  `from_card` varchar(45) DEFAULT NULL,
  `to_card` varchar(45) DEFAULT NULL,
  `details` text,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1040020 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of wiretransfers
-- ----------------------------

-- ----------------------------
-- Table structure for `worlditems`
-- ----------------------------
DROP TABLE IF EXISTS `worlditems`;
CREATE TABLE `worlditems` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `itemid` int(11) DEFAULT '0',
  `itemvalue` text,
  `x` float DEFAULT '0',
  `y` float DEFAULT '0',
  `z` float DEFAULT '0',
  `dimension` int(5) DEFAULT '0',
  `interior` int(5) DEFAULT '0',
  `creationdate` datetime DEFAULT NULL,
  `rx` float DEFAULT '0',
  `ry` float DEFAULT '0',
  `rz` float DEFAULT '0',
  `creator` int(10) unsigned DEFAULT '0',
  `protected` int(100) NOT NULL DEFAULT '0',
  `perm_use` int(2) NOT NULL DEFAULT '1',
  `perm_move` int(2) NOT NULL DEFAULT '1',
  `perm_pickup` int(2) NOT NULL DEFAULT '1',
  `perm_use_data` text,
  `perm_move_data` text,
  `perm_pickup_data` text,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of worlditems
-- ----------------------------

-- ----------------------------
-- Table structure for `worlditems_data`
-- ----------------------------
DROP TABLE IF EXISTS `worlditems_data`;
CREATE TABLE `worlditems_data` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `item` int(11) NOT NULL,
  `key` varchar(100) NOT NULL,
  `value` text NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of worlditems_data
-- ----------------------------
