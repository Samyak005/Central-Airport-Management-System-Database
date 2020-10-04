DROP DATABASE IF EXISTS airport_db;

CREATE DATABASE airport_db;

USE airport_db;
-- -- ----------------------------------------------------------

-- ---------------------------------------------------------------------

DROP TABLE IF EXISTS `Airline`;

CREATE TABLE `Airline` (
  `IATA airline designators` char(2) PRIMARY KEY,
  `Company Name` varchar(50) NOT NULL,
  `num_aircrafts_owned` int DEFAULT 0,
  `is_active` Boolean DEFAULT TRUE,
  `country_of_ownership` varchar(255)
);

-- -- ----------------------------------------------------------

-- -- ----------------------------------------------------------

DROP TABLE IF EXISTS `capacity_of_aircraft`;

CREATE TABLE `capacity_of_aircraft` (
  `Manufacturer` varchar(255) NOT NULL,
  `Model` varchar(255) NOT NULL,
  `Capacity` int NOT NULL,
  constraint capacityKey PRIMARY KEY (`Model`,`Manufacturer` )
);
-- -- ----------------------------------------------------------

DROP TABLE IF EXISTS `Aircraft`;

CREATE TABLE `Aircraft` (
  `registration_num` int PRIMARY KEY,
  `fk_to_capacity_Manufacturer` varchar(255) NOT NULL,
  `fk_to_capacity_Model` varchar(255) NOT NULL,
  `Distance Travelled` int DEFAULT 0,
  `Flight ID` varchar(10),
  `Maintanence check date` date,
  `fk_to_airline_owner_airline_IATA_code` char(2),
  -- KEY (`fk_to_capacity_Model`, `fk_to_capacity_Manufacturer` ),

  FOREIGN KEY (`fk_to_capacity_Model`,`fk_to_capacity_Manufacturer`) REFERENCES `capacity_of_aircraft` (`Model`,`Manufacturer`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`fk_to_airline_owner_airline_IATA_code`) REFERENCES `Airline` (`IATA airline designators`) ON DELETE SET NULL ON UPDATE CASCADE

);

-- -- ----------------------------------------------------------
-- ----------------------------------------------------------

DROP TABLE IF EXISTS `Airport`;

CREATE TABLE `Airport` (
  `IATA airport codes` varchar(3) PRIMARY KEY,
  `Altitude` float,
  `Time Zone` time,
  `Airport Name` varchar(255),
  `City` varchar(255),
  `Country` varchar(255),
  `Latitude` float,
  `Longitude` float
);

-- ----------------------------------------------------------

DROP TABLE IF EXISTS `Runway`;

CREATE TABLE `Runway` (
  `fk_to_airport_IATA_airport_codes` char(3),
  `Runway ID` int,
  `length_ft` float,
  `width_ft` float,
  `Status` enum('Assigned', 'Available', 'Disfunctional') DEFAULT 'Available',
  PRIMARY KEY (`fk_to_airport_IATA_airport_codes`, `Runway ID`),

  FOREIGN KEY (`fk_to_airport_IATA_airport_codes`) REFERENCES `Airport` (`IATA airport codes`) ON DELETE CASCADE ON UPDATE CASCADE
);

-- ----------------------------------------------------------

DROP TABLE IF EXISTS `Terminal`;

CREATE TABLE `Terminal` (
  `fk_to_airport_IATA_airport_codes` char(3),
  `Terminal ID` int,
  `Airplane Handling capacity` int,
  `Floor Area` float,
  PRIMARY KEY (`fk_to_airport_IATA_airport_codes`, `Terminal ID`),

  FOREIGN KEY (`fk_to_airport_IATA_airport_codes`) REFERENCES `Airport` (`IATA airport codes`) ON DELETE CASCADE ON UPDATE CASCADE

);

INSERT INTO `airport_db`.`terminal` (`fk_to_airport_IATA_airport_codes`, `Terminal ID`, `Airplane Handling capacity`, `Floor Area`) VALUES ('DEL', '1', '450', '34753');
INSERT INTO `airport_db`.`terminal` (`fk_to_airport_IATA_airport_codes`, `Terminal ID`, `Airplane Handling capacity`, `Floor Area`) VALUES ('DEL', '2', '280', '54320');
INSERT INTO `airport_db`.`terminal` (`fk_to_airport_IATA_airport_codes`, `Terminal ID`, `Airplane Handling capacity`, `Floor Area`) VALUES ('DEL', '3', '800', '76459');
INSERT INTO `airport_db`.`terminal` (`fk_to_airport_IATA_airport_codes`, `Terminal ID`, `Airplane Handling capacity`, `Floor Area`) VALUES ('MUM', '1', '325', '21457');
INSERT INTO `airport_db`.`terminal` (`fk_to_airport_IATA_airport_codes`, `Terminal ID`, `Airplane Handling capacity`, `Floor Area`) VALUES ('MUM', '2', '341', '23574');
INSERT INTO `airport_db`.`terminal` (`fk_to_airport_IATA_airport_codes`, `Terminal ID`, `Airplane Handling capacity`, `Floor Area`) VALUES ('MUM', '3', '560', '87934');
INSERT INTO `airport_db`.`terminal` (`fk_to_airport_IATA_airport_codes`, `Terminal ID`, `Airplane Handling capacity`, `Floor Area`) VALUES ('HYD', '1', '560', '23572');
INSERT INTO `airport_db`.`terminal` (`fk_to_airport_IATA_airport_codes`, `Terminal ID`, `Airplane Handling capacity`, `Floor Area`) VALUES ('HYD', '2', '960', '46973');
INSERT INTO `airport_db`.`terminal` (`fk_to_airport_IATA_airport_codes`, `Terminal ID`, `Airplane Handling capacity`, `Floor Area`) VALUES ('BLR', '1', '650', '23258');
INSERT INTO `airport_db`.`terminal` (`fk_to_airport_IATA_airport_codes`, `Terminal ID`, `Airplane Handling capacity`, `Floor Area`) VALUES ('BLR', '2', '860', '143766');


-- ----------------------------------------------------------

DROP TABLE IF EXISTS `PNR info deduction`;

CREATE TABLE `PNR info deduction` (
  `PNR_number` char(6) PRIMARY KEY,
  `Scheduled Boarding Time` time,
  `fk_terminal_num` int,
  `class_of_travel` enum('Economy', 'Business'),
  `fk_to_airport_src_iata_code` char(3),

  FOREIGN KEY (`fk_to_airport_src_iata_code`,`fk_terminal_num`) REFERENCES `Terminal` (`fk_to_airport_IATA_airport_codes`, `Terminal ID`)  ON DELETE SET NULL ON UPDATE CASCADE

);
-- ----------------------------------------------------------



DROP TABLE IF EXISTS `Route`;

CREATE TABLE `Route` (
  `Route ID` int PRIMARY KEY,
  `fk_to_airport_src_iata_code` char(3) NOT NULL,
  `fk_to_airport_dest_iata_code` char(3) NOT NULL,
  `Date` DATE NOT NULL, 
  `Scheduled arrival` time,  
  `Scheduled Departure` time,
  `Time duration` time,
  `fk_to_runway_Take off runway id` int,
  `Distance Travelled` int,
  `fk_to_runway_Landing runway ID` int,
  `fk_to_aircraft_registration_num` int,
  `Status` enum('Departed', 'Boarding','On_route','Delayed','Arrived','Checking','Not_applicable') NOT NULL DEFAULT 'Not_applicable',

  CONSTRAINT Route_1 FOREIGN KEY (`fk_to_airport_dest_iata_code`) REFERENCES `Airport` (`IATA airport codes`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT Route_2 FOREIGN KEY (`fk_to_airport_src_iata_code`) REFERENCES `Airport` (`IATA airport codes`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT Route_3 FOREIGN KEY (`fk_to_aircraft_registration_num`) REFERENCES `Aircraft` (`registration_num`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT Route_4 FOREIGN KEY (`fk_to_airport_dest_iata_code`,`fk_to_runway_Landing runway ID`) REFERENCES `Runway` (`fk_to_airport_IATA_airport_codes`, `Runway ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT Route_5 FOREIGN KEY (`fk_to_airport_src_iata_code`,`fk_to_runway_Take off runway id`) REFERENCES `Runway` (`fk_to_airport_IATA_airport_codes`, `Runway ID`) ON DELETE CASCADE ON UPDATE CASCADE

);
-- -- ----------------------------------------------------------



DROP TABLE IF EXISTS `Passenger`;

CREATE TABLE `Passenger` (
  `Aadhar_card_number` bigint(12) PRIMARY KEY,
  `First Name` varchar(255) NOT NULL,
  `Middle Name` varchar(255),
  `Last Name` varchar(255),
  `DOB` date,
  `Gender` enum('Male', 'Female', 'Others'),
  `House Number` varchar(10),
  `Building` varchar(255),
  `City` varchar(255),
  `Email-ID` varchar(255) UNIQUE,
  `Senior Citizen` Boolean,
  `Nationality` varchar(255)
);
-- -- ----------------------------------------------------------


DROP TABLE IF EXISTS `boarding_pass`;

CREATE TABLE `boarding_pass` (
  `Barcode number` char(12) PRIMARY KEY,
  `fk_PNR_number` char(6) NOT NULL,
  `Seat` varchar(5),
  `fk_to_passenger_Aadhar_card_number` bigint(12) NOT NULL,
  `fk_to_route_Route ID` int NOT NULL,

  FOREIGN KEY (`fk_to_passenger_Aadhar_card_number`) REFERENCES `Passenger` (`Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`fk_PNR_number`) REFERENCES `PNR info deduction` (`PNR_number`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`fk_to_route_Route ID`) REFERENCES `Route` (`Route ID`) ON DELETE CASCADE ON UPDATE CASCADE
);
-- -- ----------------------------------------------------------


DROP TABLE IF EXISTS `emer_contact`;

CREATE TABLE `emer_contact` (
  `Name` varchar(255),
  `Phone No` int(10) UNIQUE NOT NULL,
  `fk_to_passenger_Aadhar_card_number` bigint(12),
  PRIMARY KEY (`Name`, `fk_to_passenger_Aadhar_card_number`),

  FOREIGN KEY (`fk_to_passenger_Aadhar_card_number`) REFERENCES `Passenger` (`Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE
);
-- -- ----------------------------------------------------------



DROP TABLE IF EXISTS `luggage`;

CREATE TABLE `luggage` (
  `Baggage ID` int PRIMARY KEY,
  `fk_to_Barcode number` char(12),

  FOREIGN KEY (`fk_to_Barcode number`) REFERENCES `boarding_pass` (`Barcode number`) ON DELETE CASCADE ON UPDATE CASCADE
);


-- -----------------------------------------------------------

DROP TABLE IF EXISTS `airline_crew`;

CREATE TABLE `airline_crew` (
  `Aadhar_card_number` bigint(12) PRIMARY KEY,
  `First Name` varchar(255) NOT NULL,
  `Middle Name` varchar(255),
  `Last Name` varchar(255),
  `Number of years of Experience` int DEFAULT 0,
  `Salary` int,
  `Nationality` varchar(255),
  `DOB` date,
  `Gender` enum('Male', 'Female', 'Others'),
  `fk_to_airline_employer_IATA_code` char(2),

  FOREIGN KEY (`fk_to_airline_employer_IATA_code`) REFERENCES `Airline` (`IATA airline designators`) ON DELETE SET NULL ON UPDATE CASCADE
);

-- -- ----------------------------------------------------------

DROP TABLE IF EXISTS `flight_crew`;

CREATE TABLE `flight_crew` (
  `fk_to_airline_crew_Aadhar_card_number` bigint(12) PRIMARY KEY,
  FOREIGN KEY (`fk_to_airline_crew_Aadhar_card_number`) REFERENCES `airline_crew` (`Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE

);

-- -- ----------------------------------------------------------

DROP TABLE IF EXISTS `Pilot`;

CREATE TABLE `Pilot` (
  `fk_to_flight_crew_Aadhar_card_number` bigint(12) PRIMARY KEY NOT NULL,
  `Pilot license number` int(12) UNIQUE NOT NULL,
  `Number of flying hours` int,

  FOREIGN KEY (`fk_to_flight_crew_Aadhar_card_number`) REFERENCES `flight_crew` (`fk_to_airline_crew_Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE
);

-- --------------------------------------------------------

DROP TABLE IF EXISTS `flight_attendant`;

CREATE TABLE `flight_attendant` (
  `fk_to_flight_crew_Aadhar_card_number` bigint(12) PRIMARY KEY,
  `Training/Education` varchar(255),

  FOREIGN KEY (`fk_to_flight_crew_Aadhar_card_number`) REFERENCES `flight_crew` (`fk_to_airline_crew_Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE

);

-- -- ----------------------------------------------------------

DROP TABLE IF EXISTS `flight_engineer`;

CREATE TABLE `flight_engineer` (
  `fk_to_flight_crew_Aadhar_card_number` bigint(12) PRIMARY KEY,
  `Education` varchar(255),
  `Manufacturer` varchar(255),
  `Model` varchar(255),

  FOREIGN KEY (`fk_to_flight_crew_Aadhar_card_number`) REFERENCES `flight_crew` (`fk_to_airline_crew_Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE
);


-- ----------------------------------------------------------

DROP TABLE IF EXISTS `flight_crew_serves_on_route`;

CREATE TABLE `flight_crew_serves_on_route` (
  `fk_to_flight_crew_Aadhar_card_number` bigint(12),
  `fk_to_route_Route ID` int,
  PRIMARY KEY (`fk_to_flight_crew_Aadhar_card_number`, `fk_to_route_Route ID`),

  FOREIGN KEY (`fk_to_flight_crew_Aadhar_card_number`) REFERENCES `flight_crew` (`fk_to_airline_crew_Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`fk_to_route_Route ID`) REFERENCES `Route` (`Route ID`) ON DELETE CASCADE ON UPDATE CASCADE
);

-- ----------------------------------------------------------

DROP TABLE IF EXISTS `On-ground`;

CREATE TABLE `On-ground` (
  `fk_to_airline_crew_Aadhar_card_number` bigint(12) PRIMARY KEY,
  `Job title` varchar(255),
  FOREIGN KEY (`fk_to_airline_crew_Aadhar_card_number`) REFERENCES `airline_crew` (`Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE

);

-- -------------------------------------------------

DROP TABLE IF EXISTS `Airport Employees/CREWS`;

CREATE TABLE `Airport Employees/CREWS` (
  `Aadhar_card_number` bigint(12) PRIMARY KEY,
  `fk_to_airport_IATA_code_of_employing_airport` char(3),
  `First Name` varchar(255) NOT NULL,
  `Middle Name` varchar(255),
  `Last Name` varchar(255),
  `Experience` int DEFAULT 0,
  `Salary` int,
  `Nationality` varchar(255),
  `DOB` date,
  `Gender` enum('Male', 'Female', 'Others'),
  `sup_Aadhar_card_number` bigint(12),


FOREIGN KEY (`fk_to_airport_IATA_code_of_employing_airport`) REFERENCES `Airport` (`IATA airport codes`) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (`sup_Aadhar_card_number`) REFERENCES `Airport Employees/CREWS` (`Aadhar_card_number`) ON DELETE SET NULL ON UPDATE CASCADE

);


-- ----------------------------------------------------------

DROP TABLE IF EXISTS `mo_executives`;

CREATE TABLE `mo_executives` (
  `fk_to_airport_crew_aadhar_card_number` bigint(12) PRIMARY KEY,
  `Job title` varchar(255),

  FOREIGN KEY (`fk_to_airport_crew_aadhar_card_number`) REFERENCES `Airport Employees/CREWS` (`Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE

);


-- ----------------------------------------------------------

DROP TABLE IF EXISTS `Security`;

CREATE TABLE `Security` (
  `fk_to_airport_crew_aadhar_card_number` bigint(12) PRIMARY KEY,
  `Designation` varchar(255),
  `Security ID number` int UNIQUE,

  FOREIGN KEY (`fk_to_airport_crew_aadhar_card_number`) REFERENCES `Airport Employees/CREWS` (`Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE

);


-- ----------------------------------------------------------

DROP TABLE IF EXISTS `air_traffic_controller`;

CREATE TABLE `air_traffic_controller` (
  `fk_to_airport_crew_aadhar_card_number` bigint(12) PRIMARY KEY,
  `Current communication Frequency` float,
  `Training/Education` varchar(255),

  FOREIGN KEY (`fk_to_airport_crew_aadhar_card_number`) REFERENCES `Airport Employees/CREWS` (`Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE

);


-- ----------------------------------------------------------

DROP TABLE IF EXISTS `crew_has_worked_together`;

CREATE TABLE `crew_has_worked_together` (
  `Pilot captain Aadhar_card_number` bigint(12),
  `Pilot first officer Aadhar_card_number` bigint(12),
  `flight_attendant Aadhar_card_number` bigint(12),
  `flight_engineer Aadhar_card_number` bigint(12),
  `Avg_competence_rating` float,
  CHECK (`Avg_competence_rating` >= 0 AND `Avg_competence_rating` <=10),
  `Number of Languages spoken overall` int,
  PRIMARY KEY (`Pilot captain Aadhar_card_number`, `Pilot first officer Aadhar_card_number`, `flight_attendant Aadhar_card_number`, `flight_engineer Aadhar_card_number`),

  FOREIGN KEY(`Pilot captain Aadhar_card_number`) REFERENCES `Pilot` (`fk_to_flight_crew_Aadhar_card_number`)  ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY(`Pilot first officer Aadhar_card_number`) REFERENCES `Pilot` (`fk_to_flight_crew_Aadhar_card_number`)  ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY(`flight_attendant Aadhar_card_number`) REFERENCES `flight_attendant` (`fk_to_flight_crew_Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY(`flight_engineer Aadhar_card_number`) REFERENCES `flight_engineer` (`fk_to_flight_crew_Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE

);


-- ----------------------------------------------------------

DROP TABLE IF EXISTS `flight_crew_feedback`;

CREATE TABLE `flight_crew_feedback` (
  `Pilot captain Aadhar_card_number` int(12),
  `Pilot first officer Aadhar_card_number` int(12),
  `flight_attendant Aadhar_card_number` int(12),
  `flight_engineer Aadhar_card_number` int(12),
  `Feedback given by the passengers for the crew` varchar(255),
  PRIMARY KEY (`Pilot captain Aadhar_card_number`, `Pilot first officer Aadhar_card_number`, `flight_attendant Aadhar_card_number`, `flight_engineer Aadhar_card_number`, `Feedback given by the passengers for the crew`),

  FOREIGN KEY(`Pilot captain Aadhar_card_number`) REFERENCES `Pilot` (`fk_to_flight_crew_Aadhar_card_number`)  ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY(`Pilot first officer Aadhar_card_number`) REFERENCES `Pilot` (`fk_to_flight_crew_Aadhar_card_number`)  ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY(`flight_attendant Aadhar_card_number`) REFERENCES `flight_attendant` (`fk_to_flight_crew_Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY(`flight_engineer Aadhar_card_number`) REFERENCES `flight_engineer` (`fk_to_flight_crew_Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE

);

-- ----------------------------------------------------------

DROP TABLE IF EXISTS `boarding_pass special services`;

CREATE TABLE `boarding_pass special services` (
  `fk_Barcode number` varchar(12),
  `Special services` enum('Wheelchair', 'Disability Assistance', 'XL seats', 'Priority Boarding'),
  PRIMARY KEY (`fk_Barcode number`, `Special services`),
  FOREIGN KEY (`fk_Barcode number`) REFERENCES `boarding_pass` (`Barcode number`) ON DELETE CASCADE ON UPDATE CASCADE

);

-- ----------------------------------------------------------

DROP TABLE IF EXISTS `Languages spoken by airline employee`;

CREATE TABLE `Languages spoken by airline employee` (
  `fk_Aadhar_card_number` int(12),
  `Language_name` varchar(255),
  PRIMARY KEY (`fk_Aadhar_card_number`, `Language_name`),
  FOREIGN KEY (`fk_Aadhar_card_number`) REFERENCES `airline_crew` (`Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE

);

-- ----------------------------------------------------------

DROP TABLE IF EXISTS `stopover_airports_on_route`;

CREATE TABLE `stopover_airports_on_route` (
  `fk_route_id` int,
  `fk_iata_stopover_airport` varchar(3),
  PRIMARY KEY (`fk_route_id`, `fk_iata_stopover_airport`),

  FOREIGN KEY (`fk_route_id`) REFERENCES `Route` (`Route ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`fk_iata_stopover_airport`) REFERENCES `Airport` (`IATA airport codes`) ON DELETE CASCADE ON UPDATE CASCADE

);

INSERT INTO `airport_db`.`airline` (`IATA airline designators`, `Company Name`, `num_aircrafts_owned`, `is_active`, `country_of_ownership`) VALUES ('6E', 'Indigo Airlines Limited', '0', '1', 'India');
INSERT INTO `airport_db`.`airline` (`IATA airline designators`, `Company Name`, `num_aircrafts_owned`, `is_active`, `country_of_ownership`) VALUES ('SG', 'Spicejet Limited', '0', '1', 'India');
INSERT INTO `airport_db`.`airline` (`IATA airline designators`, `Company Name`, `num_aircrafts_owned`, `is_active`, `country_of_ownership`) VALUES ('AI', 'Air India Limited', '0', '1', 'India');
INSERT INTO `airport_db`.`airline` (`IATA airline designators`, `Company Name`, `num_aircrafts_owned`, `is_active`, `country_of_ownership`) VALUES ('UK', 'Air Vistara', '0', '1', 'India');
INSERT INTO `airport_db`.`airline` (`IATA airline designators`, `Company Name`, `num_aircrafts_owned`, `is_active`, `country_of_ownership`) VALUES ('G8', 'Go Airways', '0', '1', 'India');

INSERT INTO `airport_db`.`capacity_of_aircraft` (`Manufacturer`, `Model`, `Capacity`) VALUES ('Boeing', '747', '370');
INSERT INTO `airport_db`.`capacity_of_aircraft` (`Manufacturer`, `Model`, `Capacity`) VALUES ('Boeing', '737', '189');
INSERT INTO `airport_db`.`capacity_of_aircraft` (`Manufacturer`, `Model`, `Capacity`) VALUES ('Airbus', '320', '170');
INSERT INTO `airport_db`.`capacity_of_aircraft` (`Manufacturer`, `Model`, `Capacity`) VALUES ('Airbus', '330', '360');
INSERT INTO `airport_db`.`capacity_of_aircraft` (`Manufacturer`, `Model`, `Capacity`) VALUES ('Airbus', '340', '390');
INSERT INTO `airport_db`.`capacity_of_aircraft` (`Manufacturer`, `Model`, `Capacity`) VALUES ('Boeing', '777', '370');

INSERT INTO `airport_db`.`aircraft` (`registration_num`, `fk_to_capacity_Manufacturer`, `fk_to_capacity_Model`, `Distance Travelled`, `Flight ID`, `Maintanence check date`, `fk_to_airline_owner_airline_IATA_code`) VALUES ('124', 'Boeing', '737', '5465879', '14', '2020-09-24', 'SG');
INSERT INTO `airport_db`.`aircraft` (`registration_num`, `fk_to_capacity_Manufacturer`, `fk_to_capacity_Model`, `Distance Travelled`, `Flight ID`, `Maintanence check date`, `fk_to_airline_owner_airline_IATA_code`) VALUES ('212', 'Airbus', '320', '4576786', '10', '2020-09-28', '6E');
INSERT INTO `airport_db`.`aircraft` (`registration_num`, `fk_to_capacity_Manufacturer`, `fk_to_capacity_Model`, `Distance Travelled`, `Flight ID`, `Maintanence check date`, `fk_to_airline_owner_airline_IATA_code`) VALUES ('232', 'Boeing', '747', '876453', '6', '2020-09-21', 'UK');
INSERT INTO `airport_db`.`aircraft` (`registration_num`, `fk_to_capacity_Manufacturer`, `fk_to_capacity_Model`, `Distance Travelled`, `Flight ID`, `Maintanence check date`, `fk_to_airline_owner_airline_IATA_code`) VALUES ('234', 'Airbus', '320', '986655', '9', '2020-09-21', '6E');
INSERT INTO `airport_db`.`aircraft` (`registration_num`, `fk_to_capacity_Manufacturer`, `fk_to_capacity_Model`, `Distance Travelled`, `Flight ID`, `Maintanence check date`, `fk_to_airline_owner_airline_IATA_code`) VALUES ('235', 'Boeing', '777', '76876', '22', '2020-09-21', 'UK');
INSERT INTO `airport_db`.`aircraft` (`registration_num`, `fk_to_capacity_Manufacturer`, `fk_to_capacity_Model`, `Distance Travelled`, `Flight ID`, `Maintanence check date`, `fk_to_airline_owner_airline_IATA_code`) VALUES ('236', 'Airbus', '330', '4557678', '20', '2020-09-28', '6E');
INSERT INTO `airport_db`.`aircraft` (`registration_num`, `fk_to_capacity_Manufacturer`, `fk_to_capacity_Model`, `Distance Travelled`, `Flight ID`, `Maintanence check date`, `fk_to_airline_owner_airline_IATA_code`) VALUES ('238', 'Airbus', '330', '7978445', '19', '2020-09-21', '6E');
INSERT INTO `airport_db`.`aircraft` (`registration_num`, `fk_to_capacity_Manufacturer`, `fk_to_capacity_Model`, `Distance Travelled`, `Flight ID`, `Maintanence check date`, `fk_to_airline_owner_airline_IATA_code`) VALUES ('242', 'Boeing', '747', '2325437', '4', '2020-09-28', 'AI');
INSERT INTO `airport_db`.`aircraft` (`registration_num`, `fk_to_capacity_Manufacturer`, `fk_to_capacity_Model`, `Distance Travelled`, `Flight ID`, `Maintanence check date`, `fk_to_airline_owner_airline_IATA_code`) VALUES ('274', 'Airbus', '340', '32456', '26', '2020-09-21', '6E');
INSERT INTO `airport_db`.`aircraft` (`registration_num`, `fk_to_capacity_Manufacturer`, `fk_to_capacity_Model`, `Distance Travelled`, `Flight ID`, `Maintanence check date`, `fk_to_airline_owner_airline_IATA_code`) VALUES ('343', 'Airbus', '320', '76335', '13', '2020-09-21', 'AI');
INSERT INTO `airport_db`.`aircraft` (`registration_num`, `fk_to_capacity_Manufacturer`, `fk_to_capacity_Model`, `Distance Travelled`, `Flight ID`, `Maintanence check date`, `fk_to_airline_owner_airline_IATA_code`) VALUES ('345', 'Boeing', '747', '542321', '1', '2020-09-21', 'SG');
INSERT INTO `airport_db`.`aircraft` (`registration_num`, `fk_to_capacity_Manufacturer`, `fk_to_capacity_Model`, `Distance Travelled`, `Flight ID`, `Maintanence check date`, `fk_to_airline_owner_airline_IATA_code`) VALUES ('435', 'Boeing', '747', '23421', '2', '2020-09-21', 'SG');
INSERT INTO `airport_db`.`aircraft` (`registration_num`, `fk_to_capacity_Manufacturer`, `fk_to_capacity_Model`, `Distance Travelled`, `Flight ID`, `Maintanence check date`, `fk_to_airline_owner_airline_IATA_code`) VALUES ('546', 'Airbus', '320', '349876', '11', '2020-09-24', '6E');
INSERT INTO `airport_db`.`aircraft` (`registration_num`, `fk_to_capacity_Manufacturer`, `fk_to_capacity_Model`, `Distance Travelled`, `Flight ID`, `Maintanence check date`, `fk_to_airline_owner_airline_IATA_code`) VALUES ('555', 'Airbus', '330', '65686', '23', '2020-09-28', 'AI');
INSERT INTO `airport_db`.`aircraft` (`registration_num`, `fk_to_capacity_Manufacturer`, `fk_to_capacity_Model`, `Distance Travelled`, `Flight ID`, `Maintanence check date`, `fk_to_airline_owner_airline_IATA_code`) VALUES ('574', 'Airbus', '340', '3453', '24', '2020-09-21', 'AI');
INSERT INTO `airport_db`.`aircraft` (`registration_num`, `fk_to_capacity_Manufacturer`, `fk_to_capacity_Model`, `Distance Travelled`, `Flight ID`, `Maintanence check date`, `fk_to_airline_owner_airline_IATA_code`) VALUES ('589', 'Airbus', '330', '5678', '25', '2020-09-28', '6E');
INSERT INTO `airport_db`.`aircraft` (`registration_num`, `fk_to_capacity_Manufacturer`, `fk_to_capacity_Model`, `Distance Travelled`, `Flight ID`, `Maintanence check date`, `fk_to_airline_owner_airline_IATA_code`) VALUES ('642', 'Boeing', '747', '23878', '7', '2020-09-21', 'UK');
INSERT INTO `airport_db`.`aircraft` (`registration_num`, `fk_to_capacity_Manufacturer`, `fk_to_capacity_Model`, `Distance Travelled`, `Flight ID`, `Maintanence check date`, `fk_to_airline_owner_airline_IATA_code`) VALUES ('645', 'Boeing', '747', '65767', '3', '2020-09-24', 'SG');
INSERT INTO `airport_db`.`aircraft` (`registration_num`, `fk_to_capacity_Manufacturer`, `fk_to_capacity_Model`, `Distance Travelled`, `Flight ID`, `Maintanence check date`, `fk_to_airline_owner_airline_IATA_code`) VALUES ('673', 'Boeing', '777', '345340', '27', '2020-09-29', 'G8');
INSERT INTO `airport_db`.`aircraft` (`registration_num`, `fk_to_capacity_Manufacturer`, `fk_to_capacity_Model`, `Distance Travelled`, `Flight ID`, `Maintanence check date`, `fk_to_airline_owner_airline_IATA_code`) VALUES ('692', 'Boeing', '777', '857323', '28', '2020-09-29', 'G8');
INSERT INTO `airport_db`.`aircraft` (`registration_num`, `fk_to_capacity_Manufacturer`, `fk_to_capacity_Model`, `Distance Travelled`, `Flight ID`, `Maintanence check date`, `fk_to_airline_owner_airline_IATA_code`) VALUES ('734', 'Boeing', '737', '654332', '16', '2020-09-21', 'UK');
INSERT INTO `airport_db`.`aircraft` (`registration_num`, `fk_to_capacity_Manufacturer`, `fk_to_capacity_Model`, `Distance Travelled`, `Flight ID`, `Maintanence check date`, `fk_to_airline_owner_airline_IATA_code`) VALUES ('796', 'Boeing', '737', '34343434', '15', '2020-09-28', 'AI');
INSERT INTO `airport_db`.`aircraft` (`registration_num`, `fk_to_capacity_Manufacturer`, `fk_to_capacity_Model`, `Distance Travelled`, `Flight ID`, `Maintanence check date`, `fk_to_airline_owner_airline_IATA_code`) VALUES ('875', 'Boeing', '777', '8888888', '21', '2020-09-21', 'UK');
INSERT INTO `airport_db`.`aircraft` (`registration_num`, `fk_to_capacity_Manufacturer`, `fk_to_capacity_Model`, `Distance Travelled`, `Flight ID`, `Maintanence check date`, `fk_to_airline_owner_airline_IATA_code`) VALUES ('878', 'Airbus', '320', '3468322', '12', '2020-09-21', '6E');
INSERT INTO `airport_db`.`aircraft` (`registration_num`, `fk_to_capacity_Manufacturer`, `fk_to_capacity_Model`, `Distance Travelled`, `Flight ID`, `Maintanence check date`, `fk_to_airline_owner_airline_IATA_code`) VALUES ('893', 'Airbus', '320', '2199934', '8', '2020-09-24', '6E');
INSERT INTO `airport_db`.`aircraft` (`registration_num`, `fk_to_capacity_Manufacturer`, `fk_to_capacity_Model`, `Distance Travelled`, `Flight ID`, `Maintanence check date`, `fk_to_airline_owner_airline_IATA_code`) VALUES ('974', 'Airbus', '330', '77777777', '18', '2020-09-28', 'AI');
INSERT INTO `airport_db`.`aircraft` (`registration_num`, `fk_to_capacity_Manufacturer`, `fk_to_capacity_Model`, `Distance Travelled`, `Flight ID`, `Maintanence check date`, `fk_to_airline_owner_airline_IATA_code`) VALUES ('975', 'Boeing', '747', '234276', '5', '2020-09-24', 'AI');

INSERT INTO `airport_db`.`airport` (`IATA airport codes`, `Altitude`, `Time Zone`, `Airport Name`, `City`, `Country`, `Latitude`, `Longitude`) VALUES ('DEL', '225', '5.5', 'Indira Gandhi International Airport', 'Delhi', 'India', '28.7041', '77.1025');
INSERT INTO `airport_db`.`airport` (`IATA airport codes`, `Altitude`, `Time Zone`, `Airport Name`, `City`, `Country`, `Latitude`, `Longitude`) VALUES ('HYD', '542', '5.5', 'Rajiv Gandhi International Airport', 'Hyderabad', 'India', '17.385', '78.4867');
INSERT INTO `airport_db`.`airport` (`IATA airport codes`, `Altitude`, `Time Zone`, `Airport Name`, `City`, `Country`, `Latitude`, `Longitude`) VALUES ('MUM', '14', '5.5', 'Chattrapati Shivaji International Airport', 'Mumbai', 'India', '19.076', '72.8777');
INSERT INTO `airport_db`.`airport` (`IATA airport codes`, `Altitude`, `Time Zone`, `Airport Name`, `City`, `Country`, `Latitude`, `Longitude`) VALUES ('BLR', '920', '5.5', 'KempeGowda International Airport', 'Bangaluru', 'India', '12.9716', '77.5946');

INSERT INTO `airport_db`.`runway` (`fk_to_airport_IATA_airport_codes`, `Runway ID`, `length_ft`, `width_ft`, `Status`) VALUES ('DEL', '0', '9229', '150.9', 'Available');
INSERT INTO `airport_db`.`runway` (`fk_to_airport_IATA_airport_codes`, `Runway ID`, `length_ft`, `width_ft`, `Status`) VALUES ('HYD', '0', '12162', '148', 'Available');
INSERT INTO `airport_db`.`runway` (`fk_to_airport_IATA_airport_codes`, `Runway ID`, `length_ft`, `width_ft`, `Status`) VALUES ('MUM', '0', '12008', '200', 'Available');
INSERT INTO `airport_db`.`runway` (`fk_to_airport_IATA_airport_codes`, `Runway ID`, `length_ft`, `width_ft`, `Status`) VALUES ('BLR', '0', '13123', '148', 'Available');
INSERT INTO `airport_db`.`runway` (`fk_to_airport_IATA_airport_codes`, `Runway ID`, `length_ft`, `width_ft`, `Status`) VALUES ('DEL', '1', '12500', '150.92', 'Available');
INSERT INTO `airport_db`.`runway` (`fk_to_airport_IATA_airport_codes`, `Runway ID`, `length_ft`, `width_ft`, `Status`) VALUES ('BLR', '1', '13120', '200', 'Available');
INSERT INTO `airport_db`.`runway` (`fk_to_airport_IATA_airport_codes`, `Runway ID`, `length_ft`, `width_ft`, `Status`) VALUES ('MUM', '1', '9810', '148', 'Available');
INSERT INTO `airport_db`.`runway` (`fk_to_airport_IATA_airport_codes`, `Runway ID`, `length_ft`, `width_ft`, `Status`) VALUES ('HYD', '1', '13980', '200', 'Available');
INSERT INTO `airport_db`.`runway` (`fk_to_airport_IATA_airport_codes`, `Runway ID`, `length_ft`, `width_ft`, `Status`) VALUES ('DEL', '2', '14534.121', '196.85', 'Available');

INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('YV0HA8', '07:40', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('KX9IH3', '08:45', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('PQ0VY2', '11:30', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('OX0FG9', '14:30', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('JX5FO0', '15:50', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('YD7UM4', '16:10', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('RK7LM5', '19:20', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('GO5PQ7', '19:10', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('ZD0NA7', '06:05', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('DH0OY7', '10:03', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('GM3XT3', '12:15', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('HR8IG8', '14:55', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('YM8JU6', '19:55', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('PH3LH7', '05:15', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('DS9AE4', '06:35', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('DK6TA2', '06:40', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('AC1JO0', '13:40', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('GI3KF7', '09:20', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('TB1FT2', '06:50', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('WZ6TF5', '10:02', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('YY1DW4', '14:20', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('XR0KI5', '11:55', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('BA3NF7', '18:05', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('LU0LU7', '19:00', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('TX9HD7', '04:40', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('AF9UJ3', '07:40', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('TW4LB0', '08:45', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('KW4HY7', '11:30', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('FC1IT0', '14:30', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('RT6VG6', '15:50', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('LQ9XI5', '16:10', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('UB3PM9', '19:20', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('YN2GE2', '19:10', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('KX8EM3', '06:05', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('XZ2LM3', '10:03', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('XL1SO9', '12:15', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('MW8VT8', '14:55', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('AT5WN9', '19:55', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('YC1UP3', '05:15', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('WB8DI0', '06:35', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('RL2KS9', '06:40', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('UL1LP5', '13:40', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('WI3JL6', '09:20', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('CB9BF8', '06:50', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('PW3IL6', '10:02', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('GS2TY8', '14:20', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('VN4PF6', '11:55', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('ZN2SV8', '18:05', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('LY7KF6', '19:00', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('GV0AT7', '04:40', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('LC7XI9', '07:40', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('YS3TA2', '08:45', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('GS8MF3', '11:30', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('ZZ3KK8', '14:30', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('FY7YN7', '15:50', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('LP7SE8', '16:10', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('AX3XH5', '19:20', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('YZ6KO7', '19:10', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('BP5ZN0', '06:05', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('XP9ZK4', '10:03', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('PX6XH8', '12:15', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('SM9MZ9', '14:55', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('NE4RW6', '19:55', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('GV7TS2', '05:15', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('RE1DD2', '06:35', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('HL6OE3', '06:40', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('VE9HD4', '13:40', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('HN1JF7', '09:20', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('AX4JN8', '06:50', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('DI9SU9', '10:02', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('QF5NM6', '14:20', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('TE7GR8', '11:55', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('QS6JL0', '18:05', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('VE7NK6', '19:00', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('HQ5FC2', '04:40', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('XE7LH2', '07:40', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('AF3DR4', '08:45', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('RC2UV9', '11:30', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('SN9EU2', '14:30', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('MF9DV5', '15:50', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('ZB5OD5', '16:10', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('WS6GP3', '19:20', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('KR8RG0', '19:10', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('AE2CD6', '06:05', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('YT7KZ0', '10:03', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('SK5QK9', '12:15', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('LR0VQ7', '14:55', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('YQ4MA6', '19:55', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('FV1SJ5', '05:15', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('FW9IA3', '06:35', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('YS0MP7', '06:40', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('YM2TA1', '13:40', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('PI8ZD1', '09:20', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('OD8FV6', '06:50', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('DT9SD5', '10:02', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('NF2UF9', '14:20', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('QG0AK8', '11:55', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('FU8FR6', '18:05', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('BT3RN9', '19:00', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('KL0WV5', '04:40', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('AS3CL1', '07:40', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('LA2DI7', '08:45', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('TV1MR8', '11:30', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('TN7QG1', '14:30', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('VE1PQ7', '15:50', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('QH1SX1', '16:10', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('FF1IJ4', '19:20', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('ON3KX8', '19:10', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('OY0LT7', '06:05', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('BO4BY5', '10:03', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('YJ9XI0', '12:15', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('KY8SW6', '14:55', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('DF5EF0', '19:55', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('VH4TK8', '05:15', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('HL4GJ9', '06:35', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('FS5JY1', '06:40', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('QA5FR8', '13:40', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('IP0WM3', '09:20', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('OZ6JF3', '06:50', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('ZL7AY7', '10:02', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('DS4GI1', '14:20', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('BC6OJ1', '11:55', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('OC9RB5', '18:05', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('HO9NC7', '19:00', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('CQ9NN9', '04:40', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('SD2PJ4', '07:40', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('AP8HP6', '08:45', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('AX4JR7', '11:30', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('OD6VI6', '14:30', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('TF8SF4', '15:50', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('SB0XY6', '16:10', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('RU4YL4', '19:20', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('AR3XR2', '19:10', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('WZ5UE0', '06:05', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('GI8YH9', '10:03', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('GQ7RZ9', '12:15', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('CA2JQ1', '14:55', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('EI2GJ9', '19:55', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('JM6SE3', '05:15', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('YJ5BB3', '06:35', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('QF2RG0', '06:40', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('SY7WK5', '13:40', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('XM2QT6', '09:20', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('HD4TY6', '06:50', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('FQ3PA8', '10:02', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('TU3KB0', '14:20', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('AU7ZO1', '11:55', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('ZS8KO6', '18:05', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('CZ1UK9', '19:00', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('BF2IA1', '04:40', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('CA2ER4', '07:40', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('EP8TS7', '08:45', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('QH4PE0', '11:30', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('US0OD7', '14:30', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('EH2KO6', '15:50', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('OX0OX7', '16:10', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('QZ3PV4', '19:20', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('TH2YJ8', '19:10', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('MU6NH0', '06:05', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('HH5DE2', '10:03', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('HR1AG6', '12:15', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('EK5VZ5', '14:55', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('PO5WB8', '19:55', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('BU6BB3', '05:15', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('EW9BU1', '06:35', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('TN5AG5', '06:40', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('CC6DR3', '13:40', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('PO7ZJ7', '09:20', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('KA8TU9', '06:50', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('AR0AN5', '10:02', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('PL3TE2', '14:20', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('YF3QE3', '11:55', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('CU4RC3', '18:05', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('HH5ZC4', '19:00', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('CO1CZ8', '04:40', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('CC0TY2', '07:40', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('KR1JN1', '08:45', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('LS5BG1', '11:30', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('JY5VS4', '14:30', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('ZD8YN3', '15:50', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('QX6YD9', '16:10', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('CC1SO1', '19:20', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('BN3ND9', '19:10', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('KG3FZ5', '06:05', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('YP0RC4', '10:03', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('CE4WE6', '12:15', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('XK3UL7', '14:55', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('RK1KZ1', '19:55', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('HL2VT6', '05:15', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('ZB8RU5', '06:35', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('JM7EA6', '06:40', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('TC4PB2', '13:40', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('GJ9QL5', '09:20', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('TM3IE1', '06:50', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('ZZ4FH8', '10:02', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('PD5AK9', '14:20', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('IB6KS8', '11:55', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('WF1JI4', '18:05', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('AZ4QY4', '19:00', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('EF2YW5', '04:40', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('RC1AK5', '07:40', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('WW3YC2', '08:45', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('FA1CT3', '11:30', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('JN4LY3', '14:30', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('YX4WB8', '15:50', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('UU2YK8', '16:10', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('RE4WI9', '19:20', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('YN8NQ4', '19:10', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('AA6KE5', '06:05', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('MS0BN5', '10:03', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('XZ6OP8', '12:15', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('CM7FH1', '14:55', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('DP9ES4', '19:55', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('YX7WW7', '05:15', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('CK1OW5', '06:35', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('KY6AR6', '06:40', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('PG3BV0', '13:40', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('AA9JO8', '09:20', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('VE8VJ2', '06:50', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('GV9ZH2', '10:02', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('DD9WK9', '14:20', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('SK6MY2', '11:55', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('XV3IZ8', '18:05', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('ZX5VX6', '19:00', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('UP9XU7', '04:40', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('NV5XD2', '07:40', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('LN7TB4', '08:45', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('IJ2ZR0', '11:30', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('ZN6OZ4', '14:30', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('OU2TY8', '15:50', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('XY9UA8', '16:10', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('BA4IB2', '19:20', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('LO9FA0', '19:10', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('LQ3YU8', '06:05', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('VU9VE3', '10:03', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('VN0JM0', '12:15', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('ZX6UD2', '14:55', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('BU6QI3', '19:55', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('XS1YG2', '05:15', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('RZ9KH0', '06:35', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('FL1OD9', '06:40', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('AE4XE1', '13:40', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('WF4DO6', '09:20', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('EQ4QX5', '06:50', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('IX2VH6', '10:02', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('RB4GM9', '14:20', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('CH1VF3', '11:55', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('OS8KJ8', '18:05', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('IN6ZO5', '19:00', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('CC5NP7', '04:40', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('XO4FW3', '07:40', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('BJ6RQ5', '08:45', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('QO5EH9', '11:30', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('OO5JF1', '14:30', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('VK2ND5', '15:50', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('RG6ZM3', '16:10', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('HB1EM2', '19:20', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('CK6YI8', '19:10', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('XN4FN7', '06:05', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('SA6DV0', '10:03', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('WG4TM4', '12:15', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('OA1OE1', '14:55', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('QK4QX5', '19:55', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('XQ0FA5', '05:15', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('AA7NJ7', '06:35', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('CE3MV7', '06:40', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('SW5YF5', '13:40', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('YU6YW9', '09:20', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('DU3IJ0', '06:50', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('FI3ES5', '10:02', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('DC6QT2', '14:20', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('OH7DV3', '11:55', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('YO1LE4', '18:05', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('TZ3MA0', '19:00', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('VA0UN4', '04:40', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('JX7KN3', '07:40', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('GI8JG4', '08:45', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('CE1HM8', '11:30', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('AP9LT5', '14:30', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('JU3KL0', '15:50', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('RQ2QZ6', '16:10', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('KP6IO8', '19:20', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('OU4CC3', '19:10', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('OM8OJ3', '06:05', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('MP2LN4', '10:03', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('QQ5ID1', '12:15', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('PH6EA5', '14:55', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('LI7WH5', '19:55', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('YD1OI6', '05:15', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('IN3UZ2', '06:35', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('HP4LC0', '06:40', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('IA9LJ1', '13:40', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('SH1TY3', '09:20', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('OD0QK6', '06:50', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('GV2MV5', '10:02', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('GR8JS0', '14:20', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('HY5XN1', '11:55', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('VE3UX7', '18:05', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('MV4KJ0', '19:00', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('PU5CL9', '04:40', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('AY9LU6', '07:40', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('LB1QL4', '08:45', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('FL4EI3', '11:30', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('GM9JB3', '14:30', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('WT9FV5', '15:50', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('LH8PH7', '16:10', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('PD5LQ2', '19:20', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('ZV3LV8', '19:10', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('BG4DX8', '06:05', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('QN4GR5', '10:03', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('NQ3NP4', '12:15', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('JE8DM5', '14:55', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('JP1AR9', '19:55', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('GI1KQ5', '05:15', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('BC6WC4', '06:35', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('ZO4SV3', '06:40', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('UH0ZV9', '13:40', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('IF6GS6', '09:20', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('FJ4CV1', '06:50', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('YT6KX8', '10:02', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('WX9KZ3', '14:20', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('QH7GV3', '11:55', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('CH4TT1', '18:05', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('BX5RV5', '19:00', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('PO0TE3', '04:40', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('KI3VD2', '07:40', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('LI4JY9', '08:45', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('JI6JH8', '11:30', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('IR3WQ1', '14:30', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('DO0PR3', '15:50', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('YA2WP3', '16:10', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('VN6CA0', '19:20', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('ZU0XE1', '19:10', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('KN0LH5', '06:05', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('PU8QP7', '10:03', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('LN4EK7', '12:15', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('UB5OM2', '14:55', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('RN6XW2', '19:55', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('JL1MQ8', '05:15', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('SH1TS3', '06:35', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('ZG2AT7', '06:40', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('DT7LK5', '13:40', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('VB9CM3', '09:20', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('MJ8OG9', '06:50', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('QM7TZ6', '10:02', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('TK1RP3', '14:20', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('ZI4TN5', '11:55', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('XR8CW6', '18:05', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('GU0WJ3', '19:00', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('ID2TN4', '04:40', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('VI1JH0', '07:40', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('WA3QA1', '08:45', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('MT8LO6', '11:30', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('FP4OF7', '14:30', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('DD6GK1', '15:50', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('ST0DI7', '16:10', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('SW4NH7', '19:20', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('UF0YS5', '19:10', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('SA9CH5', '06:05', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('CT6LX2', '10:03', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('BF7WP6', '12:15', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('AD0WI6', '14:55', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('VI1FW0', '19:55', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('SQ3GD0', '05:15', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('NF7SM6', '06:35', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('NW3CN7', '06:40', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('UJ5XE2', '13:40', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('NU3NS2', '09:20', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('IT3JL0', '06:50', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('TH6VB4', '10:02', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('HY0VJ6', '14:20', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('PA2NF3', '11:55', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('OF7AH9', '18:05', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('AV8ZC9', '19:00', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('BE8BF1', '04:40', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('UD7RU9', '07:40', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('GA9BW5', '08:45', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('KZ4AM4', '11:30', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('XG1US4', '14:30', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('WM7IZ8', '15:50', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('AJ2BN6', '16:10', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('DI9RQ7', '19:20', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('QB0JG5', '19:10', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('SY4FF5', '06:05', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('PH4GN1', '10:03', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('OP6UH9', '12:15', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('VN6DE7', '14:55', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('EB4ER3', '19:55', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('YY9EA4', '05:15', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('ZK8SK1', '06:35', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('IT9HT7', '06:40', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('XH2HO4', '13:40', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('TJ6CX4', '09:20', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('EW2VF7', '06:50', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('TR8ZI6', '10:02', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('NG1TF2', '14:20', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('GV9FA8', '11:55', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('QC6UT1', '18:05', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('QO5GO5', '19:00', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('UT3PV0', '04:40', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('YF4FT5', '07:40', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('JJ6VZ5', '08:45', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('ZT4UT0', '11:30', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('ZJ7PC2', '14:30', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('NR2DR0', '15:50', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('PP0ZS9', '16:10', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('UV5UZ9', '19:20', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('SN2PP0', '19:10', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('IO0GO2', '06:05', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('ZF7AZ8', '10:03', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('PB3FR5', '12:15', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('VM5YC3', '14:55', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('LI7XK4', '19:55', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('PX2CB9', '05:15', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('TK5KP3', '06:35', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('UZ7HX7', '06:40', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('ZQ4AH4', '13:40', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('HV6SG8', '09:20', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('ED4CV0', '06:50', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('XI8DQ4', '10:02', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('EE6BQ6', '14:20', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('NN1PE7', '11:55', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('WL5TC2', '18:05', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('HG2ZF3', '19:00', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('MF6ZE6', '04:40', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('IM6UW6', '07:40', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('EP4SR6', '08:45', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('VM0WM0', '11:30', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('PO1DA2', '14:30', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('AN7FT7', '15:50', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('JR4KA5', '16:10', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('NE3QW5', '19:20', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('XD8XX7', '19:10', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('GG4HV9', '06:05', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('MI8ZI8', '10:03', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('PF6OE8', '12:15', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('GG1UT7', '14:55', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('SG9IG3', '19:55', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('PB4PQ5', '05:15', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('OC9GJ0', '06:35', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('NI7FY5', '06:40', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('GB8OX4', '13:40', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('CF5BU9', '09:20', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('TR8AJ2', '06:50', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('AN1DP2', '10:02', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('AB4KF2', '14:20', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('XR7TF6', '11:55', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('IZ8LQ5', '18:05', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('IQ4OX6', '19:00', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('IL1QQ3', '04:40', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('HV6BR7', '07:40', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('CF5FH4', '08:45', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('TR6FO7', '11:30', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('KJ7WC9', '14:30', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('GS5ZO8', '15:50', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('TT1OE6', '16:10', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('MS0HU2', '19:20', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('SA2NB0', '19:10', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('VH8HZ8', '06:05', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('TD1NJ2', '10:03', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('XM9WH9', '12:15', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('HR1BY5', '14:55', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('KC3DJ8', '19:55', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('NA1WR4', '05:15', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('EK8PN6', '06:35', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('CS4OF4', '06:40', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('SW1MA7', '13:40', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('MT7PA4', '09:20', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('MN8GH4', '06:50', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('RV2CE8', '10:02', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('NJ4PO9', '14:20', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('FD6RN8', '11:55', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('FC8UG4', '18:05', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('ME7AC1', '19:00', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('WF5XP1', '04:40', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('CQ0AF8', '07:40', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('RP4XB9', '08:45', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('DC4OZ2', '11:30', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('XN4RZ1', '14:30', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('XN9DC7', '15:50', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('NC1LZ0', '16:10', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('VO5ED9', '19:20', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('MO8QI6', '19:10', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('RS5UH0', '06:05', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('YM0KH6', '10:03', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('VK3VA7', '12:15', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('VD6RK5', '14:55', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('PN5QI5', '19:55', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('TA8XQ9', '05:15', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('CW5CT0', '06:35', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('QK8CY2', '06:40', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('DL9KX7', '13:40', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('CE9AH1', '09:20', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('PK4NA7', '06:50', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('DD8RR3', '10:02', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('YV4FX1', '14:20', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('SW9ER4', '11:55', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('KI7KO9', '18:05', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('VI1NO3', '19:00', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('PM2IC6', '04:40', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('CP5HW4', '07:40', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('FE5FK8', '08:45', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('YF2UR3', '11:30', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('YJ6KE6', '14:30', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('AC7LF6', '15:50', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('EC0AF0', '16:10', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('YI6QE8', '19:20', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('CV9XE1', '19:10', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('BG7VN9', '06:05', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('SV6XR3', '10:03', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('CT2IW4', '12:15', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('UW7KW4', '14:55', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('GY7TT3', '19:55', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('WA0KU2', '05:15', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('ES5JH7', '06:35', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('JA9EM0', '06:40', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('GK9MW5', '13:40', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('QS9RZ5', '09:20', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('PK0SW8', '06:50', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('PI0AX3', '10:02', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('YC5UX9', '14:20', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('GE9YQ0', '11:55', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('WR4FG8', '18:05', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('DD4KS3', '19:00', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('WE7RH7', '04:40', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('IY5FO6', '07:40', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('LB1MV9', '08:45', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('XT3DH9', '11:30', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('WF8ZH0', '14:30', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('BY7EN8', '15:50', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('EU7IY0', '16:10', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('RH4YV5', '19:20', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('BL5QO0', '19:10', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('SQ2XA8', '06:05', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('NG2XN5', '10:03', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('ZE4IY0', '12:15', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('VT2SF1', '14:55', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('MV7VX4', '19:55', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('QH7XG4', '05:15', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('QU8MJ0', '06:35', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('MD6BY7', '06:40', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('BM9YV3', '13:40', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('BH4OH9', '09:20', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('DY0EH5', '06:50', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('HK2WV8', '10:02', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('FS7AL3', '14:20', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('UZ1TA0', '11:55', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('HC7YQ2', '18:05', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('RM2EY7', '19:00', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('VD5JF8', '04:40', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('IY9HJ4', '07:40', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('WT1AH4', '08:45', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('EH7DT0', '11:30', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('PW1HC6', '14:30', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('ZU8GW7', '15:50', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('QW7QA1', '16:10', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('OG2WJ1', '19:20', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('XJ5KB3', '19:10', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('MV8ZN9', '06:05', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('FK9SO7', '10:03', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('ZU6TB6', '12:15', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('HZ1KM8', '14:55', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('AN4RN8', '19:55', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('ER1FG8', '05:15', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('TR5XK9', '06:35', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('XJ5SA8', '06:40', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('MS7NV9', '13:40', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('LS3PX5', '09:20', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('BJ3VM8', '06:50', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('JC1MB4', '10:02', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('RA2VH1', '14:20', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('GF5OQ9', '11:55', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('UZ3HE7', '18:05', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('NF6BY2', '19:00', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('KJ2MM5', '04:40', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('NM3IB3', '07:40', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('QP7QS4', '08:45', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('DS8ZN5', '11:30', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('YW7GB2', '14:30', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('LF8BN1', '15:50', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('DN2GK5', '16:10', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('YK6ID6', '19:20', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('HR3SL0', '19:10', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('DP9VO6', '06:05', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('LR2MR2', '10:03', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('RE3ZA8', '12:15', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('ZV8GC4', '14:55', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('NP4LJ5', '19:55', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('PU5QZ4', '05:15', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('KA8ZK6', '06:35', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('LE0KL1', '06:40', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('UM1SL6', '13:40', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('DA0EN7', '09:20', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('TU7DR9', '06:50', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('TD9LK0', '10:02', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('VE9SU0', '14:20', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('LS6ZC7', '11:55', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('MS2TR5', '18:05', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('OV1UI7', '19:00', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('LX5OU1', '04:40', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('KB4DB0', '07:40', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('WW4FB1', '08:45', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('SN0SO8', '11:30', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('PB5PA4', '14:30', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('CC1TH0', '15:50', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('QT5BV8', '16:10', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('PR8GD2', '19:20', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('ZJ8KS2', '19:10', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('BP2LH6', '06:05', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('SU9KW5', '10:03', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('TT2TY4', '12:15', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('XB5LO3', '14:55', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('IT9HQ6', '19:55', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('RB2EZ1', '05:15', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('GL1QH0', '06:35', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('NH2LG9', '06:40', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('VO3WK0', '13:40', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('MI6YZ3', '09:20', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('JO3EQ6', '06:50', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('OC3FJ7', '10:02', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('UO3NI8', '14:20', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('KR3FK3', '11:55', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('HQ4ZG3', '18:05', '3', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('LT0OL9', '19:00', '1', 'Economy', 'DEL');
INSERT INTO `airport_db`.`pnr info deduction` (`PNR_number`, `Scheduled Boarding Time`, `fk_terminal_num`, `class_of_travel`, `fk_to_airport_src_iata_code`) VALUES ('IG5OZ6', '04:40', '1', 'Economy', 'DEL');

INSERT INTO `airport_db`.`route` (`Route ID`, `fk_to_airport_src_iata_code`, `fk_to_airport_dest_iata_code`, `Date`, `Scheduled arrival`, `Scheduled Departure`, `Time duration`, `fk_to_runway_Take off runway id`, `Distance Travelled`, `fk_to_runway_Landing runway ID`, `fk_to_aircraft_registration_num`, `Status`) VALUES ('1', 'DEL', 'MUM', '1905-06-26', '10:25', '08:20', '02:05', '0', '1350', '0', '345', 'Arrived');
INSERT INTO `airport_db`.`route` (`Route ID`, `fk_to_airport_src_iata_code`, `fk_to_airport_dest_iata_code`, `Date`, `Scheduled arrival`, `Scheduled Departure`, `Time duration`, `fk_to_runway_Take off runway id`, `Distance Travelled`, `fk_to_runway_Landing runway ID`, `fk_to_aircraft_registration_num`, `Status`) VALUES ('2', 'DEL', 'MUM', '2020-10-07', '11:30', '09:25', '02:05', '0', '1350', '0', '232', 'Arrived');
INSERT INTO `airport_db`.`route` (`Route ID`, `fk_to_airport_src_iata_code`, `fk_to_airport_dest_iata_code`, `Date`, `Scheduled arrival`, `Scheduled Departure`, `Time duration`, `fk_to_runway_Take off runway id`, `Distance Travelled`, `fk_to_runway_Landing runway ID`, `fk_to_aircraft_registration_num`, `Status`) VALUES ('3', 'DEL', 'MUM', '2020-10-08', '14:15', '12:10', '02:05', '0', '1350', '0', '642', 'Arrived');
INSERT INTO `airport_db`.`route` (`Route ID`, `fk_to_airport_src_iata_code`, `fk_to_airport_dest_iata_code`, `Date`, `Scheduled arrival`, `Scheduled Departure`, `Time duration`, `fk_to_runway_Take off runway id`, `Distance Travelled`, `fk_to_runway_Landing runway ID`, `fk_to_aircraft_registration_num`, `Status`) VALUES ('4', 'DEL', 'MUM', '2020-10-09', '17:15', '15:10', '02:05', '0', '1350', '0', '734', 'Arrived');
INSERT INTO `airport_db`.`route` (`Route ID`, `fk_to_airport_src_iata_code`, `fk_to_airport_dest_iata_code`, `Date`, `Scheduled arrival`, `Scheduled Departure`, `Time duration`, `fk_to_runway_Take off runway id`, `Distance Travelled`, `fk_to_runway_Landing runway ID`, `fk_to_aircraft_registration_num`, `Status`) VALUES ('5', 'DEL', 'MUM', '2020-10-10', '18:35', '16:30', '02:05', '0', '1350', '0', '875', 'Arrived');
INSERT INTO `airport_db`.`route` (`Route ID`, `fk_to_airport_src_iata_code`, `fk_to_airport_dest_iata_code`, `Date`, `Scheduled arrival`, `Scheduled Departure`, `Time duration`, `fk_to_runway_Take off runway id`, `Distance Travelled`, `fk_to_runway_Landing runway ID`, `fk_to_aircraft_registration_num`, `Status`) VALUES ('6', 'DEL', 'MUM', '2020-10-11', '19:15', '17:00', '02:15', '0', '1350', '0', '242', 'Arrived');
INSERT INTO `airport_db`.`route` (`Route ID`, `fk_to_airport_src_iata_code`, `fk_to_airport_dest_iata_code`, `Date`, `Scheduled arrival`, `Scheduled Departure`, `Time duration`, `fk_to_runway_Take off runway id`, `Distance Travelled`, `fk_to_runway_Landing runway ID`, `fk_to_aircraft_registration_num`, `Status`) VALUES ('7', 'DEL', 'MUM', '2020-10-12', '22:15', '20:00', '02:15', '0', '1350', '0', '435', 'Arrived');
INSERT INTO `airport_db`.`route` (`Route ID`, `fk_to_airport_src_iata_code`, `fk_to_airport_dest_iata_code`, `Date`, `Scheduled arrival`, `Scheduled Departure`, `Time duration`, `fk_to_runway_Take off runway id`, `Distance Travelled`, `fk_to_runway_Landing runway ID`, `fk_to_aircraft_registration_num`, `Status`) VALUES ('8', 'DEL', 'MUM', '2020-10-13', '22:05', '19:50', '02:15', '0', '1350', '0', '975', 'Arrived');
INSERT INTO `airport_db`.`route` (`Route ID`, `fk_to_airport_src_iata_code`, `fk_to_airport_dest_iata_code`, `Date`, `Scheduled arrival`, `Scheduled Departure`, `Time duration`, `fk_to_runway_Take off runway id`, `Distance Travelled`, `fk_to_runway_Landing runway ID`, `fk_to_aircraft_registration_num`, `Status`) VALUES ('9', 'DEL', 'MUM', '2020-10-14', '09:10', '06:45', '02:25', '0', '1350', '0', '645', 'Arrived');
INSERT INTO `airport_db`.`route` (`Route ID`, `fk_to_airport_src_iata_code`, `fk_to_airport_dest_iata_code`, `Date`, `Scheduled arrival`, `Scheduled Departure`, `Time duration`, `fk_to_runway_Take off runway id`, `Distance Travelled`, `fk_to_runway_Landing runway ID`, `fk_to_aircraft_registration_num`, `Status`) VALUES ('10', 'DEL', 'MUM', '2020-10-15', '13:15', '11:10', '02:05', '0', '1350', '0', '893', 'Arrived');
INSERT INTO `airport_db`.`route` (`Route ID`, `fk_to_airport_src_iata_code`, `fk_to_airport_dest_iata_code`, `Date`, `Scheduled arrival`, `Scheduled Departure`, `Time duration`, `fk_to_runway_Take off runway id`, `Distance Travelled`, `fk_to_runway_Landing runway ID`, `fk_to_aircraft_registration_num`, `Status`) VALUES ('11', 'DEL', 'MUM', '2020-10-16', '15:00', '12:55', '02:05', '0', '1350', '0', '234', 'Arrived');
INSERT INTO `airport_db`.`route` (`Route ID`, `fk_to_airport_src_iata_code`, `fk_to_airport_dest_iata_code`, `Date`, `Scheduled arrival`, `Scheduled Departure`, `Time duration`, `fk_to_runway_Take off runway id`, `Distance Travelled`, `fk_to_runway_Landing runway ID`, `fk_to_aircraft_registration_num`, `Status`) VALUES ('12', 'DEL', 'MUM', '2020-10-17', '17:40', '15:35', '02:05', '0', '1350', '0', '212', 'Arrived');
INSERT INTO `airport_db`.`route` (`Route ID`, `fk_to_airport_src_iata_code`, `fk_to_airport_dest_iata_code`, `Date`, `Scheduled arrival`, `Scheduled Departure`, `Time duration`, `fk_to_runway_Take off runway id`, `Distance Travelled`, `fk_to_runway_Landing runway ID`, `fk_to_aircraft_registration_num`, `Status`) VALUES ('13', 'DEL', 'MUM', '2020-10-18', '22:40', '20:35', '02:05', '0', '1350', '0', '673', 'Arrived');
INSERT INTO `airport_db`.`route` (`Route ID`, `fk_to_airport_src_iata_code`, `fk_to_airport_dest_iata_code`, `Date`, `Scheduled arrival`, `Scheduled Departure`, `Time duration`, `fk_to_runway_Take off runway id`, `Distance Travelled`, `fk_to_runway_Landing runway ID`, `fk_to_aircraft_registration_num`, `Status`) VALUES ('14', 'DEL', 'MUM', '2020-10-19', '08:05', '05:55', '02:05', '0', '1350', '0', '546', 'Arrived');
INSERT INTO `airport_db`.`route` (`Route ID`, `fk_to_airport_src_iata_code`, `fk_to_airport_dest_iata_code`, `Date`, `Scheduled arrival`, `Scheduled Departure`, `Time duration`, `fk_to_runway_Take off runway id`, `Distance Travelled`, `fk_to_runway_Landing runway ID`, `fk_to_aircraft_registration_num`, `Status`) VALUES ('15', 'DEL', 'HYD', '2020-10-20', '09:10', '07:15', '01:55', '0', '1023', '0', '343', 'Arrived');
INSERT INTO `airport_db`.`route` (`Route ID`, `fk_to_airport_src_iata_code`, `fk_to_airport_dest_iata_code`, `Date`, `Scheduled arrival`, `Scheduled Departure`, `Time duration`, `fk_to_runway_Take off runway id`, `Distance Travelled`, `fk_to_runway_Landing runway ID`, `fk_to_aircraft_registration_num`, `Status`) VALUES ('16', 'DEL', 'HYD', '2020-10-21', '09:25', '07:20', '02:05', '0', '1023', '0', '235', 'Arrived');
INSERT INTO `airport_db`.`route` (`Route ID`, `fk_to_airport_src_iata_code`, `fk_to_airport_dest_iata_code`, `Date`, `Scheduled arrival`, `Scheduled Departure`, `Time duration`, `fk_to_runway_Take off runway id`, `Distance Travelled`, `fk_to_runway_Landing runway ID`, `fk_to_aircraft_registration_num`, `Status`) VALUES ('17', 'DEL', 'HYD', '2020-10-22', '16:30', '14:20', '02:10', '0', '1023', '0', '232', 'Arrived');
INSERT INTO `airport_db`.`route` (`Route ID`, `fk_to_airport_src_iata_code`, `fk_to_airport_dest_iata_code`, `Date`, `Scheduled arrival`, `Scheduled Departure`, `Time duration`, `fk_to_runway_Take off runway id`, `Distance Travelled`, `fk_to_runway_Landing runway ID`, `fk_to_aircraft_registration_num`, `Status`) VALUES ('18', 'DEL', 'HYD', '2020-10-23', '12:15', '10:00', '02:15', '0', '1023', '0', '796', 'Arrived');
INSERT INTO `airport_db`.`route` (`Route ID`, `fk_to_airport_src_iata_code`, `fk_to_airport_dest_iata_code`, `Date`, `Scheduled arrival`, `Scheduled Departure`, `Time duration`, `fk_to_runway_Take off runway id`, `Distance Travelled`, `fk_to_runway_Landing runway ID`, `fk_to_aircraft_registration_num`, `Status`) VALUES ('19', 'DEL', 'HYD', '2020-10-24', '09:40', '07:30', '02:10', '0', '1023', '0', '878', 'Arrived');
INSERT INTO `airport_db`.`route` (`Route ID`, `fk_to_airport_src_iata_code`, `fk_to_airport_dest_iata_code`, `Date`, `Scheduled arrival`, `Scheduled Departure`, `Time duration`, `fk_to_runway_Take off runway id`, `Distance Travelled`, `fk_to_runway_Landing runway ID`, `fk_to_aircraft_registration_num`, `Status`) VALUES ('20', 'DEL', 'HYD', '2020-10-25', '13:15', '11:00', '02:15', '0', '1023', '0', '238', 'Arrived');
INSERT INTO `airport_db`.`route` (`Route ID`, `fk_to_airport_src_iata_code`, `fk_to_airport_dest_iata_code`, `Date`, `Scheduled arrival`, `Scheduled Departure`, `Time duration`, `fk_to_runway_Take off runway id`, `Distance Travelled`, `fk_to_runway_Landing runway ID`, `fk_to_aircraft_registration_num`, `Status`) VALUES ('21', 'DEL', 'HYD', '2020-10-26', '17:15', '15:00', '02:15', '0', '1023', '0', '124', 'Arrived');
INSERT INTO `airport_db`.`route` (`Route ID`, `fk_to_airport_src_iata_code`, `fk_to_airport_dest_iata_code`, `Date`, `Scheduled arrival`, `Scheduled Departure`, `Time duration`, `fk_to_runway_Take off runway id`, `Distance Travelled`, `fk_to_runway_Landing runway ID`, `fk_to_aircraft_registration_num`, `Status`) VALUES ('22', 'DEL', 'BLR', '2020-10-27', '15:10', '12:35', '02:35', '0', '1530', '0', '974', 'Arrived');
INSERT INTO `airport_db`.`route` (`Route ID`, `fk_to_airport_src_iata_code`, `fk_to_airport_dest_iata_code`, `Date`, `Scheduled arrival`, `Scheduled Departure`, `Time duration`, `fk_to_runway_Take off runway id`, `Distance Travelled`, `fk_to_runway_Landing runway ID`, `fk_to_aircraft_registration_num`, `Status`) VALUES ('23', 'DEL', 'BLR', '2020-10-28', '21:30', '18:45', '02:45', '0', '1530', '0', '642', 'Arrived');
INSERT INTO `airport_db`.`route` (`Route ID`, `fk_to_airport_src_iata_code`, `fk_to_airport_dest_iata_code`, `Date`, `Scheduled arrival`, `Scheduled Departure`, `Time duration`, `fk_to_runway_Take off runway id`, `Distance Travelled`, `fk_to_runway_Landing runway ID`, `fk_to_aircraft_registration_num`, `Status`) VALUES ('24', 'DEL', 'BLR', '2020-10-29', '22:30', '19:40', '02:50', '0', '1530', '0', '234', 'Arrived');
INSERT INTO `airport_db`.`route` (`Route ID`, `fk_to_airport_src_iata_code`, `fk_to_airport_dest_iata_code`, `Date`, `Scheduled arrival`, `Scheduled Departure`, `Time duration`, `fk_to_runway_Take off runway id`, `Distance Travelled`, `fk_to_runway_Landing runway ID`, `fk_to_aircraft_registration_num`, `Status`) VALUES ('25', 'DEL', 'BLR', '2020-10-30', '07:55', '05:20', '02:35', '0', '1530', '0', '236', 'Arrived');

