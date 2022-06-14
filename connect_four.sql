-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 06, 2021 at 02:23 PM
-- Server version: 10.4.17-MariaDB
-- PHP Version: 8.0.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `connect_four`
--

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `clean_board`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `clean_board` ()  BEGIN

UPDATE `players` SET username=NULL, token=NULL ;
UPDATE `game_status` SET `status`='not active', `p_turn`=NULL, `result`=NULL;
	REPLACE INTO board SELECT * FROM board_empty;

END$$

DROP PROCEDURE IF EXISTS `move_piece`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `move_piece` (IN `x1` TINYINT, IN `y1` TINYINT)  BEGIN
	DECLARE p_color,r1,r2,r3,r4,r5,r6 CHAR;
    
	SELECT p_turn INTO p_color
	FROM `game_status` WHERE status='started';
	
    SELECT piece INTO r1
    FROM `board` WHERE X=x1 AND Y=y1;
    
    SELECT piece INTO r2
    FROM `board` WHERE X=x1 AND Y=2;
    
    SELECT piece INTO r3
    FROM `board` WHERE X=x1 AND Y=3;
    
    SELECT piece INTO r4
    FROM `board` WHERE X=x1 AND Y=4;
    
    SELECT piece INTO r5
    FROM `board` WHERE X=x1 AND Y=5;
    
    SELECT piece INTO r6
    FROM `board` WHERE X=x1 AND Y=6;
    
    IF r1 IS NULL THEN
   	UPDATE board 
	SET piece='P',piece_color=p_color
	WHERE X=x1 AND Y=y1; 
    
    ELSEIF r2 IS NULL THEN
    UPDATE board 
	SET piece='P',piece_color=p_color
	WHERE X=x1 AND Y=2;
    
    ELSEIF r3 IS NULL THEN
    UPDATE board 
	SET piece='P',piece_color=p_color
	WHERE X=x1 AND Y=3;
    
    ELSEIF r4 IS NULL THEN
    UPDATE board 
	SET piece='P',piece_color=p_color
	WHERE X=x1 AND Y=4;
    
    ELSEIF r5 IS NULL THEN
    UPDATE board 
	SET piece='P',piece_color=p_color
	WHERE X=x1 AND Y=5;
    
    ELSEIF r6 IS NULL THEN
    UPDATE board 
	SET piece='P',piece_color=p_color
	WHERE X=x1 AND Y=6; 
    
    ELSE
    UPDATE game_status
    SET p_turn=piece_color;
    END IF;
        	
    		IF p_color='R' THEN
    			UPDATE game_status
        		SET p_turn='Y';
    		ELSE 
    			UPDATE game_status
        		SET p_turn='R';
			END IF;  

END$$

DROP PROCEDURE IF EXISTS `show_result`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `show_result` ()  BEGIN
UPDATE `game_status` SET `status`='ended', `p_turn`=NULL, `result`='D';
END$$

DROP PROCEDURE IF EXISTS `show_winner`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `show_winner` ()  BEGIN

DECLARE p_color CHAR;

SELECT p_turn INTO p_color FROM game_status WHERE status='started';

IF p_color = 'R' THEN 
UPDATE `game_status` SET `status`='ended', `p_turn`=NULL, `result`='Y';
ELSE 
UPDATE `game_status` SET `status`='ended', `p_turn`=NULL, `result`='R';
END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `board`
--

DROP TABLE IF EXISTS `board`;
CREATE TABLE `board` (
  `x` tinyint(1) NOT NULL,
  `y` tinyint(1) NOT NULL,
  `piece_color` enum('R','Y') DEFAULT NULL,
  `piece` enum('P') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `board`
--

INSERT INTO `board` (`x`, `y`, `piece_color`, `piece`) VALUES
(1, 1, NULL, NULL),
(1, 2, NULL, NULL),
(1, 3, NULL, NULL),
(1, 4, NULL, NULL),
(1, 5, NULL, NULL),
(1, 6, NULL, NULL),
(2, 1, NULL, NULL),
(2, 2, NULL, NULL),
(2, 3, NULL, NULL),
(2, 4, NULL, NULL),
(2, 5, NULL, NULL),
(2, 6, NULL, NULL),
(3, 1, NULL, NULL),
(3, 2, NULL, NULL),
(3, 3, NULL, NULL),
(3, 4, NULL, NULL),
(3, 5, NULL, NULL),
(3, 6, NULL, NULL),
(4, 1, NULL, NULL),
(4, 2, NULL, NULL),
(4, 3, NULL, NULL),
(4, 4, NULL, NULL),
(4, 5, NULL, NULL),
(4, 6, NULL, NULL),
(5, 1, NULL, NULL),
(5, 2, NULL, NULL),
(5, 3, NULL, NULL),
(5, 4, NULL, NULL),
(5, 5, NULL, NULL),
(5, 6, NULL, NULL),
(6, 1, NULL, NULL),
(6, 2, NULL, NULL),
(6, 3, NULL, NULL),
(6, 4, NULL, NULL),
(6, 5, NULL, NULL),
(6, 6, NULL, NULL),
(7, 1, NULL, NULL),
(7, 2, NULL, NULL),
(7, 3, NULL, NULL),
(7, 4, NULL, NULL),
(7, 5, NULL, NULL),
(7, 6, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `board_empty`
--

DROP TABLE IF EXISTS `board_empty`;
CREATE TABLE `board_empty` (
  `x` tinyint(1) NOT NULL,
  `y` tinyint(1) NOT NULL,
  `piece_color` enum('R','Y') DEFAULT NULL,
  `piece` enum('P') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `board_empty`
--

INSERT INTO `board_empty` (`x`, `y`, `piece_color`, `piece`) VALUES
(1, 1, NULL, NULL),
(1, 2, NULL, NULL),
(1, 3, NULL, NULL),
(1, 4, NULL, NULL),
(1, 5, NULL, NULL),
(1, 6, NULL, NULL),
(2, 1, NULL, NULL),
(2, 2, NULL, NULL),
(2, 3, NULL, NULL),
(2, 4, NULL, NULL),
(2, 5, NULL, NULL),
(2, 6, NULL, NULL),
(3, 1, NULL, NULL),
(3, 2, NULL, NULL),
(3, 3, NULL, NULL),
(3, 4, NULL, NULL),
(3, 5, NULL, NULL),
(3, 6, NULL, NULL),
(4, 1, NULL, NULL),
(4, 2, NULL, NULL),
(4, 3, NULL, NULL),
(4, 4, NULL, NULL),
(4, 5, NULL, NULL),
(4, 6, NULL, NULL),
(5, 1, NULL, NULL),
(5, 2, NULL, NULL),
(5, 3, NULL, NULL),
(5, 4, NULL, NULL),
(5, 5, NULL, NULL),
(5, 6, NULL, NULL),
(6, 1, NULL, NULL),
(6, 2, NULL, NULL),
(6, 3, NULL, NULL),
(6, 4, NULL, NULL),
(6, 5, NULL, NULL),
(6, 6, NULL, NULL),
(7, 1, NULL, NULL),
(7, 2, NULL, NULL),
(7, 3, NULL, NULL),
(7, 4, NULL, NULL),
(7, 5, NULL, NULL),
(7, 6, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `game_status`
--

DROP TABLE IF EXISTS `game_status`;
CREATE TABLE `game_status` (
  `status` enum('not active','initialized','started','ended','aborted') NOT NULL DEFAULT 'not active',
  `p_turn` enum('R','Y') DEFAULT NULL,
  `result` enum('R','Y','D') DEFAULT NULL,
  `last_change` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `game_status`
--

INSERT INTO `game_status` (`status`, `p_turn`, `result`, `last_change`) VALUES
('not active', NULL, NULL, '2021-01-06 12:59:41');

--
-- Triggers `game_status`
--
DROP TRIGGER IF EXISTS `game_status_update`;
DELIMITER $$
CREATE TRIGGER `game_status_update` BEFORE UPDATE ON `game_status` FOR EACH ROW BEGIN
SET NEW.last_change = NOW();
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `players`
--

DROP TABLE IF EXISTS `players`;
CREATE TABLE `players` (
  `username` varchar(20) DEFAULT NULL,
  `piece_color` enum('R','Y') NOT NULL,
  `token` varchar(100) NOT NULL,
  `last_action` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `players`
--

INSERT INTO `players` (`username`, `piece_color`, `token`, `last_action`) VALUES
(NULL, 'R', '', '2021-01-06 12:59:39'),
(NULL, 'Y', '', '2021-01-06 12:14:34');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `board`
--
ALTER TABLE `board`
  ADD PRIMARY KEY (`x`,`y`);

--
-- Indexes for table `board_empty`
--
ALTER TABLE `board_empty`
  ADD PRIMARY KEY (`x`,`y`);

--
-- Indexes for table `players`
--
ALTER TABLE `players`
  ADD PRIMARY KEY (`piece_color`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
