# ************************************************************
# Sequel Pro SQL dump
# Version 4541
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: 127.0.0.1 (MySQL 5.7.18-log)
# Database: Railway
# Generation Time: 2024-01-21 15:54:49 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table BerthTypes
# ------------------------------------------------------------

DROP TABLE IF EXISTS `BerthTypes`;

CREATE TABLE `BerthTypes` (
  `berthTypeId` int(255) NOT NULL,
  `berthType` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`berthTypeId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `BerthTypes` WRITE;
/*!40000 ALTER TABLE `BerthTypes` DISABLE KEYS */;

INSERT INTO `BerthTypes` (`berthTypeId`, `berthType`)
VALUES
	(1,'UPPER'),
	(2,'MIDDLE'),
	(3,'SIDEUPPER'),
	(4,'LOWER');

/*!40000 ALTER TABLE `BerthTypes` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table CoachTypes
# ------------------------------------------------------------

DROP TABLE IF EXISTS `CoachTypes`;

CREATE TABLE `CoachTypes` (
  `coachTypeId` int(255) NOT NULL,
  `coachType` varchar(255) NOT NULL,
  `price` int(255) DEFAULT NULL,
  `berths` int(255) DEFAULT NULL,
  `noOfRac` int(255) DEFAULT NULL,
  PRIMARY KEY (`coachTypeId`),
  KEY `trainID->TripsxTrains` (`berths`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `CoachTypes` WRITE;
/*!40000 ALTER TABLE `CoachTypes` DISABLE KEYS */;

INSERT INTO `CoachTypes` (`coachTypeId`, `coachType`, `price`, `berths`, `noOfRac`)
VALUES
	(1,'FIRSTAC',400,21,6),
	(2,'SECONDAC',300,49,14),
	(3,'THIRDAC',200,63,18),
	(4,'SLEEPER',100,63,18),
	(5,'GENERAL',50,100,0);

/*!40000 ALTER TABLE `CoachTypes` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table joined_view
# ------------------------------------------------------------

DROP VIEW IF EXISTS `joined_view`;

CREATE TABLE `joined_view` (
   `locationId` INT(255) NULL DEFAULT NULL,
   `tripId` INT(255) NULL DEFAULT NULL,
   `order` INT(255) NULL DEFAULT NULL,
   `name` VARCHAR(255) NULL DEFAULT ''
) ENGINE=MyISAM;



# Dump of table Locations
# ------------------------------------------------------------

DROP TABLE IF EXISTS `Locations`;

CREATE TABLE `Locations` (
  `locationId` int(255) NOT NULL,
  `name` varchar(255) DEFAULT '',
  PRIMARY KEY (`locationId`),
  KEY `FK_Coaches.coachTypeID_CoachTypes.coachTypeID` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `Locations` WRITE;
/*!40000 ALTER TABLE `Locations` DISABLE KEYS */;

INSERT INTO `Locations` (`locationId`, `name`)
VALUES
	(2,'Chennai'),
	(1,'Coimbatore'),
	(3,'Madurai'),
	(4,'Salem'),
	(5,'Trichy');

/*!40000 ALTER TABLE `Locations` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table Passengers
# ------------------------------------------------------------

DROP TABLE IF EXISTS `Passengers`;

CREATE TABLE `Passengers` (
  `passengerId` int(255) NOT NULL,
  `passengerName` varchar(255) DEFAULT NULL,
  `gender` varchar(255) DEFAULT NULL,
  `age` int(255) DEFAULT '0',
  PRIMARY KEY (`passengerId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `Passengers` WRITE;
/*!40000 ALTER TABLE `Passengers` DISABLE KEYS */;

INSERT INTO `Passengers` (`passengerId`, `passengerName`, `gender`, `age`)
VALUES
	(1,'Dharshan','Male',21);

/*!40000 ALTER TABLE `Passengers` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table Status
# ------------------------------------------------------------

DROP TABLE IF EXISTS `Status`;

CREATE TABLE `Status` (
  `statusId` int(255) NOT NULL,
  `statusName` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`statusId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `Status` WRITE;
/*!40000 ALTER TABLE `Status` DISABLE KEYS */;

INSERT INTO `Status` (`statusId`, `statusName`)
VALUES
	(1,'CONFIRMED'),
	(2,'RAC'),
	(3,'WL'),
	(4,'CANCELLED');

/*!40000 ALTER TABLE `Status` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table TicketPassenger
# ------------------------------------------------------------

DROP TABLE IF EXISTS `TicketPassenger`;

CREATE TABLE `TicketPassenger` (
  `ticketPassengerId` int(255) NOT NULL,
  `ticketId` int(255) DEFAULT NULL,
  `passengerId` int(255) DEFAULT NULL,
  `statusId` int(255) DEFAULT NULL,
  PRIMARY KEY (`ticketPassengerId`),
  KEY `FK_Coaches.coachTypeID_CoachTypes.coachTypeID` (`ticketId`),
  KEY `passengerId -> TicketPass x Passengers` (`passengerId`),
  CONSTRAINT `TicketId -> TicketPassenger x Tickets` FOREIGN KEY (`ticketId`) REFERENCES `Tickets` (`ticketId`),
  CONSTRAINT `passengerId -> TicketPass x Passengers` FOREIGN KEY (`passengerId`) REFERENCES `Passengers` (`passengerId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `TicketPassenger` WRITE;
/*!40000 ALTER TABLE `TicketPassenger` DISABLE KEYS */;

INSERT INTO `TicketPassenger` (`ticketPassengerId`, `ticketId`, `passengerId`, `statusId`)
VALUES
	(1,1,1,4);

/*!40000 ALTER TABLE `TicketPassenger` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table Tickets
# ------------------------------------------------------------

DROP TABLE IF EXISTS `Tickets`;

CREATE TABLE `Tickets` (
  `ticketId` int(255) NOT NULL,
  `from` varchar(255) DEFAULT NULL,
  `to` varchar(255) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `coachTypeId` int(255) DEFAULT NULL,
  `tripId` int(255) DEFAULT NULL,
  PRIMARY KEY (`ticketId`),
  KEY `tripId->Tickets-Trips` (`tripId`),
  KEY `COACHTYPEID` (`coachTypeId`),
  CONSTRAINT `COACHTYPEID` FOREIGN KEY (`coachTypeId`) REFERENCES `CoachTypes` (`coachTypeId`),
  CONSTRAINT `tripId->Tickets-Trips` FOREIGN KEY (`tripId`) REFERENCES `Trips` (`tripId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `Tickets` WRITE;
/*!40000 ALTER TABLE `Tickets` DISABLE KEYS */;

INSERT INTO `Tickets` (`ticketId`, `from`, `to`, `date`, `coachTypeId`, `tripId`)
VALUES
	(1,'Coimbatore','Chennai','2002-05-07',1,1);

/*!40000 ALTER TABLE `Tickets` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table train_view
# ------------------------------------------------------------

DROP VIEW IF EXISTS `train_view`;

CREATE TABLE `train_view` (
   `trainId` INT(255) NOT NULL
) ENGINE=MyISAM;



# Dump of table Trains
# ------------------------------------------------------------

DROP TABLE IF EXISTS `Trains`;

CREATE TABLE `Trains` (
  `trainId` int(255) NOT NULL,
  `trainName` varchar(255) DEFAULT NULL,
  `noOfFirstAC` int(255) DEFAULT NULL,
  `noOfSecondAC` int(255) DEFAULT NULL,
  `noOfThirdAC` int(255) DEFAULT NULL,
  `noOfSleeper` int(255) DEFAULT NULL,
  `noOfGeneral` int(255) DEFAULT NULL,
  PRIMARY KEY (`trainId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `Trains` WRITE;
/*!40000 ALTER TABLE `Trains` DISABLE KEYS */;

INSERT INTO `Trains` (`trainId`, `trainName`, `noOfFirstAC`, `noOfSecondAC`, `noOfThirdAC`, `noOfSleeper`, `noOfGeneral`)
VALUES
	(1,'train-1',1,1,1,1,1),
	(2,'train-2',1,1,1,1,1);

/*!40000 ALTER TABLE `Trains` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table TripBerth
# ------------------------------------------------------------

DROP TABLE IF EXISTS `TripBerth`;

CREATE TABLE `TripBerth` (
  `tripBerthId` int(255) NOT NULL,
  `tripCoachId` int(255) DEFAULT NULL,
  `ticketPassengerId` int(255) DEFAULT NULL,
  `berthTypeId` int(255) DEFAULT NULL,
  KEY `tripCoachId->TripBerthsxTripCoach` (`tripCoachId`),
  KEY `ticketPassengerId->TripBerthsxTicketPassenger` (`ticketPassengerId`),
  CONSTRAINT `tripCoachId->TripBerthsxTripCoach` FOREIGN KEY (`tripCoachId`) REFERENCES `TripCoach` (`tripCoachId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `TripBerth` WRITE;
/*!40000 ALTER TABLE `TripBerth` DISABLE KEYS */;

INSERT INTO `TripBerth` (`tripBerthId`, `tripCoachId`, `ticketPassengerId`, `berthTypeId`)
VALUES
	(1,1,0,1),
	(2,1,0,1),
	(3,1,0,1),
	(4,1,0,1),
	(5,1,0,1),
	(6,1,0,1),
	(7,1,0,2),
	(8,1,0,2),
	(9,1,0,2),
	(10,1,0,2),
	(11,1,0,2),
	(12,1,0,2),
	(13,1,0,3),
	(14,1,0,3),
	(15,1,0,3),
	(16,1,0,4),
	(17,1,0,4),
	(18,1,0,4),
	(19,1,0,4),
	(20,1,0,4),
	(21,1,0,4),
	(1,2,0,1),
	(2,2,0,1),
	(3,2,0,1),
	(4,2,0,1),
	(5,2,0,1),
	(6,2,0,1),
	(7,2,0,1),
	(8,2,0,1),
	(9,2,0,1),
	(10,2,0,1),
	(11,2,0,1),
	(12,2,0,1),
	(13,2,0,1),
	(14,2,0,1),
	(15,2,0,2),
	(16,2,0,2),
	(17,2,0,2),
	(18,2,0,2),
	(19,2,0,2),
	(20,2,0,2),
	(21,2,0,2),
	(22,2,0,2),
	(23,2,0,2),
	(24,2,0,2),
	(25,2,0,2),
	(26,2,0,2),
	(27,2,0,2),
	(28,2,0,2),
	(29,2,0,3),
	(30,2,0,3),
	(31,2,0,3),
	(32,2,0,3),
	(33,2,0,3),
	(34,2,0,3),
	(35,2,0,3),
	(36,2,0,4),
	(37,2,0,4),
	(38,2,0,4),
	(39,2,0,4),
	(40,2,0,4),
	(41,2,0,4),
	(42,2,0,4),
	(43,2,0,4),
	(44,2,0,4),
	(45,2,0,4),
	(46,2,0,4),
	(47,2,0,4),
	(48,2,0,4),
	(49,2,0,4),
	(1,3,0,1),
	(2,3,0,1),
	(3,3,0,1),
	(4,3,0,1),
	(5,3,0,1),
	(6,3,0,1),
	(7,3,0,1),
	(8,3,0,1),
	(9,3,0,1),
	(10,3,0,1),
	(11,3,0,1),
	(12,3,0,1),
	(13,3,0,1),
	(14,3,0,1),
	(15,3,0,1),
	(16,3,0,1),
	(17,3,0,1),
	(18,3,0,1),
	(19,3,0,2),
	(20,3,0,2),
	(21,3,0,2),
	(22,3,0,2),
	(23,3,0,2),
	(24,3,0,2),
	(25,3,0,2),
	(26,3,0,2),
	(27,3,0,2),
	(28,3,0,2),
	(29,3,0,2),
	(30,3,0,2),
	(31,3,0,2),
	(32,3,0,2),
	(33,3,0,2),
	(34,3,0,2),
	(35,3,0,2),
	(36,3,0,2),
	(37,3,0,3),
	(38,3,0,3),
	(39,3,0,3),
	(40,3,0,3),
	(41,3,0,3),
	(42,3,0,3),
	(43,3,0,3),
	(44,3,0,3),
	(45,3,0,3),
	(46,3,0,4),
	(47,3,0,4),
	(48,3,0,4),
	(49,3,0,4),
	(50,3,0,4),
	(51,3,0,4),
	(52,3,0,4),
	(53,3,0,4),
	(54,3,0,4),
	(55,3,0,4),
	(56,3,0,4),
	(57,3,0,4),
	(58,3,0,4),
	(59,3,0,4),
	(60,3,0,4),
	(61,3,0,4),
	(62,3,0,4),
	(63,3,0,4),
	(1,4,0,1),
	(2,4,0,1),
	(3,4,0,1),
	(4,4,0,1),
	(5,4,0,1),
	(6,4,0,1),
	(7,4,0,1),
	(8,4,0,1),
	(9,4,0,1),
	(10,4,0,1),
	(11,4,0,1),
	(12,4,0,1),
	(13,4,0,1),
	(14,4,0,1),
	(15,4,0,1),
	(16,4,0,1),
	(17,4,0,1),
	(18,4,0,1),
	(19,4,0,2),
	(20,4,0,2),
	(21,4,0,2),
	(22,4,0,2),
	(23,4,0,2),
	(24,4,0,2),
	(25,4,0,2),
	(26,4,0,2),
	(27,4,0,2),
	(28,4,0,2),
	(29,4,0,2),
	(30,4,0,2),
	(31,4,0,2),
	(32,4,0,2),
	(33,4,0,2),
	(34,4,0,2),
	(35,4,0,2),
	(36,4,0,2),
	(37,4,0,3),
	(38,4,0,3),
	(39,4,0,3),
	(40,4,0,3),
	(41,4,0,3),
	(42,4,0,3),
	(43,4,0,3),
	(44,4,0,3),
	(45,4,0,3),
	(46,4,0,4),
	(47,4,0,4),
	(48,4,0,4),
	(49,4,0,4),
	(50,4,0,4),
	(51,4,0,4),
	(52,4,0,4),
	(53,4,0,4),
	(54,4,0,4),
	(55,4,0,4),
	(56,4,0,4),
	(57,4,0,4),
	(58,4,0,4),
	(59,4,0,4),
	(60,4,0,4),
	(61,4,0,4),
	(62,4,0,4),
	(63,4,0,4),
	(1,5,0,1),
	(2,5,0,1),
	(3,5,0,1),
	(4,5,0,1),
	(5,5,0,1),
	(6,5,0,1),
	(7,5,0,1),
	(8,5,0,1),
	(9,5,0,1),
	(10,5,0,1),
	(11,5,0,1),
	(12,5,0,1),
	(13,5,0,1),
	(14,5,0,1),
	(15,5,0,1),
	(16,5,0,1),
	(17,5,0,1),
	(18,5,0,1),
	(19,5,0,1),
	(20,5,0,1),
	(21,5,0,1),
	(22,5,0,1),
	(23,5,0,1),
	(24,5,0,1),
	(25,5,0,2),
	(26,5,0,2),
	(27,5,0,2),
	(28,5,0,2),
	(29,5,0,2),
	(30,5,0,2),
	(31,5,0,2),
	(32,5,0,2),
	(33,5,0,2),
	(34,5,0,2),
	(35,5,0,2),
	(36,5,0,2),
	(37,5,0,2),
	(38,5,0,2),
	(39,5,0,2),
	(40,5,0,2),
	(41,5,0,2),
	(42,5,0,2),
	(43,5,0,2),
	(44,5,0,2),
	(45,5,0,2),
	(46,5,0,2),
	(47,5,0,2),
	(48,5,0,2),
	(49,5,0,3),
	(50,5,0,3),
	(51,5,0,3),
	(52,5,0,3),
	(53,5,0,3),
	(54,5,0,3),
	(55,5,0,3),
	(56,5,0,3),
	(57,5,0,3),
	(58,5,0,3),
	(59,5,0,3),
	(60,5,0,3),
	(61,5,0,4),
	(62,5,0,4),
	(63,5,0,4),
	(64,5,0,4),
	(65,5,0,4),
	(66,5,0,4),
	(67,5,0,4),
	(68,5,0,4),
	(69,5,0,4),
	(70,5,0,4),
	(71,5,0,4),
	(72,5,0,4),
	(73,5,0,4),
	(74,5,0,4),
	(75,5,0,4),
	(76,5,0,4),
	(77,5,0,4),
	(78,5,0,4),
	(79,5,0,4),
	(80,5,0,4),
	(81,5,0,4),
	(82,5,0,4),
	(83,5,0,4),
	(84,5,0,4);

/*!40000 ALTER TABLE `TripBerth` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table TripCoach
# ------------------------------------------------------------

DROP TABLE IF EXISTS `TripCoach`;

CREATE TABLE `TripCoach` (
  `tripCoachId` int(255) NOT NULL,
  `tripId` int(255) DEFAULT NULL,
  `coachTypeId` int(255) DEFAULT NULL,
  PRIMARY KEY (`tripCoachId`),
  KEY `FK_Coaches.coachTypeID_CoachTypes.coachTypeID` (`tripId`),
  KEY `coachType->TripCoachxCoachTypes` (`coachTypeId`),
  CONSTRAINT `tripCoachId->TripCoachxTrips` FOREIGN KEY (`tripId`) REFERENCES `Trips` (`tripId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `TripCoach` WRITE;
/*!40000 ALTER TABLE `TripCoach` DISABLE KEYS */;

INSERT INTO `TripCoach` (`tripCoachId`, `tripId`, `coachTypeId`)
VALUES
	(1,1,1),
	(2,1,2),
	(3,1,3),
	(4,1,4),
	(5,1,5);

/*!40000 ALTER TABLE `TripCoach` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table TripLocation
# ------------------------------------------------------------

DROP TABLE IF EXISTS `TripLocation`;

CREATE TABLE `TripLocation` (
  `tripId` int(255) DEFAULT NULL,
  `locationId` int(255) DEFAULT NULL,
  `order` int(255) DEFAULT NULL,
  KEY `FK_Coaches.coachTypeID_CoachTypes.coachTypeID` (`tripId`),
  KEY `locationId->TripLocationxLocaitons` (`locationId`),
  CONSTRAINT `locationId->TripLocationxLocaitons` FOREIGN KEY (`locationId`) REFERENCES `Locations` (`locationId`),
  CONSTRAINT `tripId->TripLocationxTrips` FOREIGN KEY (`tripId`) REFERENCES `Trips` (`tripId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `TripLocation` WRITE;
/*!40000 ALTER TABLE `TripLocation` DISABLE KEYS */;

INSERT INTO `TripLocation` (`tripId`, `locationId`, `order`)
VALUES
	(1,2,1),
	(1,3,2),
	(1,4,3),
	(1,1,4);

/*!40000 ALTER TABLE `TripLocation` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table Trips
# ------------------------------------------------------------

DROP TABLE IF EXISTS `Trips`;

CREATE TABLE `Trips` (
  `tripId` int(255) NOT NULL,
  `date` date DEFAULT NULL,
  `trainId` int(255) DEFAULT NULL,
  PRIMARY KEY (`tripId`),
  KEY `trainID->TripsxTrains` (`trainId`),
  CONSTRAINT `trainID->TripsxTrains` FOREIGN KEY (`trainId`) REFERENCES `Trains` (`trainId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `Trips` WRITE;
/*!40000 ALTER TABLE `Trips` DISABLE KEYS */;

INSERT INTO `Trips` (`tripId`, `date`, `trainId`)
VALUES
	(1,'2002-05-07',1);

/*!40000 ALTER TABLE `Trips` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table User
# ------------------------------------------------------------

DROP TABLE IF EXISTS `User`;

CREATE TABLE `User` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

LOCK TABLES `User` WRITE;
/*!40000 ALTER TABLE `User` DISABLE KEYS */;

INSERT INTO `User` (`id`, `name`, `password`)
VALUES
	(1,'Dharshu','Pass');

/*!40000 ALTER TABLE `User` ENABLE KEYS */;
UNLOCK TABLES;




# Replace placeholder table for joined_view with correct view syntax
# ------------------------------------------------------------

DROP TABLE `joined_view`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `joined_view`
AS SELECT
   `triplocation`.`locationId` AS `locationId`,
   `triplocation`.`tripId` AS `tripId`,
   `triplocation`.`order` AS `order`,
   `locations`.`name` AS `name`
FROM (`triplocation` join `locations` on((`triplocation`.`locationId` = `locations`.`locationId`)));


# Replace placeholder table for train_view with correct view syntax
# ------------------------------------------------------------

DROP TABLE `train_view`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `train_view`
AS SELECT
   `trains`.`trainId` AS `trainId`
FROM `trains`;

/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
