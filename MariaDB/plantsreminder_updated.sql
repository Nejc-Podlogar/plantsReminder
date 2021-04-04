-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.5.9-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             11.2.0.6213
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- Dumping structure for procedure plantsreminder.loginUser
DROP PROCEDURE IF EXISTS `loginUser`;
DELIMITER //
CREATE PROCEDURE `loginUser`(
	IN `username1` VARCHAR(45),
	IN `password1` VARCHAR(45),
	OUT `uspesnost` INT
)
BEGIN

select count(*) into uspesnost from users where (username=username1 or email=username1) and password=cast(sha2(CONCAT(hash, password1), 256) as char);

END//
DELIMITER ;

-- Dumping structure for table plantsreminder.plants
DROP TABLE IF EXISTS `plants`;
CREATE TABLE IF NOT EXISTS `plants` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(45) COLLATE utf8_unicode_ci NOT NULL,
  `latin_name` varchar(60) COLLATE utf8_unicode_ci NOT NULL,
  `description` varchar(300) COLLATE utf8_unicode_ci NOT NULL,
  `watering_period` smallint(3) unsigned NOT NULL,
  `watering_amount` smallint(5) unsigned NOT NULL,
  `link_wiki` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `link_slika` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Dumping data for table plantsreminder.plants: ~0 rows (approximately)
/*!40000 ALTER TABLE `plants` DISABLE KEYS */;
/*!40000 ALTER TABLE `plants` ENABLE KEYS */;

-- Dumping structure for table plantsreminder.plants_users
DROP TABLE IF EXISTS `plants_users`;
CREATE TABLE IF NOT EXISTS `plants_users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `last_watering` smallint(3) unsigned DEFAULT NULL,
  `fk_plants` int(10) unsigned NOT NULL,
  `fk_users` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_plants` (`fk_plants`),
  KEY `fk_users` (`fk_users`),
  CONSTRAINT `fk_plants` FOREIGN KEY (`fk_plants`) REFERENCES `plants` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_users` FOREIGN KEY (`fk_users`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Dumping data for table plantsreminder.plants_users: ~0 rows (approximately)
/*!40000 ALTER TABLE `plants_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `plants_users` ENABLE KEYS */;

-- Dumping structure for procedure plantsreminder.registerUser
DROP PROCEDURE IF EXISTS `registerUser`;
DELIMITER //
CREATE PROCEDURE `registerUser`(
	IN `email1` VARCHAR(45),
	IN `username1` VARCHAR(45),
	IN `geslo1` VARCHAR(64),
	IN `hash1` VARCHAR(45)
)
BEGIN

INSERT INTO users (username, password, email, hash) VALUES (username1, cast(sha2(CONCAT(hash1, geslo1), 256) as char), email1, hash1);

END//
DELIMITER ;

-- Dumping structure for table plantsreminder.users
DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(45) COLLATE utf8_unicode_ci NOT NULL,
  `password` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `email` varchar(45) COLLATE utf8_unicode_ci NOT NULL,
  `hash` varchar(45) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Dumping data for table plantsreminder.users: ~0 rows (approximately)
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
/*!40000 ALTER TABLE `users` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
