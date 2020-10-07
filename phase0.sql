DROP DATABASE IF EXISTS airport_db;

CREATE DATABASE airport_db;

USE airport_db;


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
  `Time Zone` char(6),
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
-- ----------------------------------------------------------

DROP TABLE IF EXISTS `PNR info deduction`;

CREATE TABLE `PNR info deduction` (
  `PNR_number` char(6) PRIMARY KEY,
  `Scheduled Boarding Time` time,
  `fk_terminal_num` int,
  `class_of_travel` enum('Economy', 'Business') DEFAULT 'Economy',
  `fk_to_airport_src_iata_code` char(3),

  FOREIGN KEY (`fk_to_airport_src_iata_code`,`fk_terminal_num`) REFERENCES `Terminal` (`fk_to_airport_IATA_airport_codes`, `Terminal ID`)  ON DELETE SET NULL ON UPDATE CASCADE

);
-- ----------------------------------------------------------

-- -----------------------------------------------------------

DROP TABLE IF EXISTS `airline_crew`;

CREATE TABLE `airline_crew` (
  `Aadhar_card_number` char(12) PRIMARY KEY,
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

-- ----------------------------------------------------------

DROP TABLE IF EXISTS `Route`;

CREATE TABLE `Route` (
  `Route ID` int PRIMARY KEY,
  `fk_to_airport_src_iata_code` char(3) NOT NULL,
  `fk_to_airport_dest_iata_code` char(3) NOT NULL,
  `Date` DATE NOT NULL, 
  `Scheduled arrival` time,  
  `Scheduled Departure` time,
  `Actual arrival time` time,
  `Actual departure time` time,
  `Time duration` time,
  `fk_to_runway_Take off runway id` int,
  `Distance Travelled` int,
  `fk_to_runway_Landing runway ID` int,
  `fk_to_aircraft_registration_num` int,
  `Status` enum('Departed', 'Boarding','On_route','Delayed','Arrived','Check-in','Not_applicable') NOT NULL DEFAULT 'Not_applicable',
  `Pilot captain Aadhar_card_number` char(12) NOT NULL,
  `Chief_flight_attendant Aadhar_card_number` char(12) NOT NULL,

  CONSTRAINT Route_1 FOREIGN KEY (`fk_to_airport_dest_iata_code`) REFERENCES `Airport` (`IATA airport codes`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT Route_2 FOREIGN KEY (`fk_to_airport_src_iata_code`) REFERENCES `Airport` (`IATA airport codes`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT Route_3 FOREIGN KEY (`fk_to_aircraft_registration_num`) REFERENCES `Aircraft` (`registration_num`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT Route_4 FOREIGN KEY (`fk_to_airport_dest_iata_code`,`fk_to_runway_Landing runway ID`) REFERENCES `Runway` (`fk_to_airport_IATA_airport_codes`, `Runway ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT Route_5 FOREIGN KEY (`fk_to_airport_src_iata_code`,`fk_to_runway_Take off runway id`) REFERENCES `Runway` (`fk_to_airport_IATA_airport_codes`, `Runway ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT Route_6 FOREIGN KEY (`Pilot captain Aadhar_card_number`) REFERENCES `airline_crew` (`Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT Route_7 FOREIGN KEY (`Chief_flight_attendant Aadhar_card_number`) REFERENCES `airline_crew` (`Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE

);
-- -- ----------------------------------------------------------



DROP TABLE IF EXISTS `Passenger`;

CREATE TABLE `Passenger` (
  `Aadhar_card_number` char(12) PRIMARY KEY,
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
  `Seat` varchar(5) NOT NULL,
  `fk_to_passenger_Aadhar_card_number` char(12) NOT NULL,
  `fk_to_route_Route ID` int NOT NULL,

  FOREIGN KEY (`fk_to_passenger_Aadhar_card_number`) REFERENCES `Passenger` (`Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`fk_PNR_number`) REFERENCES `PNR info deduction` (`PNR_number`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`fk_to_route_Route ID`) REFERENCES `Route` (`Route ID`) ON DELETE CASCADE ON UPDATE CASCADE
);
-- -- ----------------------------------------------------------


DROP TABLE IF EXISTS `emer_contact`;

CREATE TABLE `emer_contact` (
  `Name` varchar(255),
  `Phone No` bigint(10) UNIQUE NOT NULL,
  `fk_to_passenger_Aadhar_card_number` char(12),
  PRIMARY KEY (`Name`, `fk_to_passenger_Aadhar_card_number`),

  FOREIGN KEY (`fk_to_passenger_Aadhar_card_number`) REFERENCES `Passenger` (`Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE
);
-- -- ----------------------------------------------------------



DROP TABLE IF EXISTS `luggage`;

CREATE TABLE `luggage` (
  `Baggage ID` bigint(10) PRIMARY KEY,
  `fk_to_Barcode number` char(12),

  FOREIGN KEY (`fk_to_Barcode number`) REFERENCES `boarding_pass` (`Barcode number`) ON DELETE CASCADE ON UPDATE CASCADE
);



-- -- ----------------------------------------------------------

DROP TABLE IF EXISTS `flight_crew`;

CREATE TABLE `flight_crew` (
  `fk_to_airline_crew_Aadhar_card_number` char(12) PRIMARY KEY,
  FOREIGN KEY (`fk_to_airline_crew_Aadhar_card_number`) REFERENCES `airline_crew` (`Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE

);

-- -- ----------------------------------------------------------

DROP TABLE IF EXISTS `Pilot`;

CREATE TABLE `Pilot` (
  `fk_to_flight_crew_Aadhar_card_number` char(12) PRIMARY KEY NOT NULL,
  `Pilot license number` char(12) UNIQUE NOT NULL,
  `Number of flying hours` int,

  FOREIGN KEY (`fk_to_flight_crew_Aadhar_card_number`) REFERENCES `flight_crew` (`fk_to_airline_crew_Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE
);

-- --------------------------------------------------------

DROP TABLE IF EXISTS `flight_attendant`;

CREATE TABLE `flight_attendant` (
  `fk_to_flight_crew_Aadhar_card_number` char(12) PRIMARY KEY,
  `Training/Education` varchar(255),

  FOREIGN KEY (`fk_to_flight_crew_Aadhar_card_number`) REFERENCES `flight_crew` (`fk_to_airline_crew_Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE

);

-- -- ----------------------------------------------------------

DROP TABLE IF EXISTS `flight_engineer`;

CREATE TABLE `flight_engineer` (
  `fk_to_flight_crew_Aadhar_card_number` char(12) PRIMARY KEY,
  `Education` varchar(255),
  `Manufacturer` varchar(255),
  `Model` varchar(255),

  FOREIGN KEY (`fk_to_flight_crew_Aadhar_card_number`) REFERENCES `flight_crew` (`fk_to_airline_crew_Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE
);



DROP TABLE IF EXISTS `flight_crew_serves_on_route`;

CREATE TABLE `flight_crew_serves_on_route` (
  `fk_to_flight_crew_Aadhar_card_number` char(12),
  `fk_to_route_Route ID` int,
  PRIMARY KEY (`fk_to_flight_crew_Aadhar_card_number`, `fk_to_route_Route ID`),

  FOREIGN KEY (`fk_to_flight_crew_Aadhar_card_number`) REFERENCES `flight_crew` (`fk_to_airline_crew_Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`fk_to_route_Route ID`) REFERENCES `Route` (`Route ID`) ON DELETE CASCADE ON UPDATE CASCADE
);

-- ----------------------------------------------------------

DROP TABLE IF EXISTS `On_ground`;

CREATE TABLE `On_ground` (
  `fk_to_airline_crew_Aadhar_card_number` char(12) PRIMARY KEY,
  `Job title` varchar(255),
  FOREIGN KEY (`fk_to_airline_crew_Aadhar_card_number`) REFERENCES `airline_crew` (`Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE

);

-- -------------------------------------------------

DROP TABLE IF EXISTS `Airport Employees/CREWS`;

CREATE TABLE `Airport Employees/CREWS` (
  `Aadhar_card_number` char(12) PRIMARY KEY,
  `fk_to_airport_IATA_code_of_employing_airport` char(3),
  `First Name` varchar(255) NOT NULL,
  `Middle Name` varchar(255),
  `Last Name` varchar(255),
  `Experience` int DEFAULT 0,
  `Salary` int,
  `Nationality` varchar(255),
  `DOB` date,
  `Gender` enum('Male', 'Female', 'Others'),
  `sup_Aadhar_card_number` char(12),


FOREIGN KEY (`fk_to_airport_IATA_code_of_employing_airport`) REFERENCES `Airport` (`IATA airport codes`) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (`sup_Aadhar_card_number`) REFERENCES `Airport Employees/CREWS` (`Aadhar_card_number`) ON DELETE SET NULL ON UPDATE CASCADE

);


-- ----------------------------------------------------------

DROP TABLE IF EXISTS `mo_executives`;

CREATE TABLE `mo_executives` (
  `fk_to_airport_crew_aadhar_card_number` char(12) PRIMARY KEY,
  `Job title` varchar(255),

  FOREIGN KEY (`fk_to_airport_crew_aadhar_card_number`) REFERENCES `Airport Employees/CREWS` (`Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE

);


-- ----------------------------------------------------------

DROP TABLE IF EXISTS `Security`;

CREATE TABLE `Security` (
  `fk_to_airport_crew_aadhar_card_number` char(12) PRIMARY KEY,
  `Designation` varchar(255),
  `Security ID number` int UNIQUE,

  FOREIGN KEY (`fk_to_airport_crew_aadhar_card_number`) REFERENCES `Airport Employees/CREWS` (`Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE

);


-- ----------------------------------------------------------

DROP TABLE IF EXISTS `air_traffic_controller`;

CREATE TABLE `air_traffic_controller` (
  `fk_to_airport_crew_aadhar_card_number` char(12) PRIMARY KEY,
  `Current communication Frequency` float,
  `Training/Education` varchar(255),

  FOREIGN KEY (`fk_to_airport_crew_aadhar_card_number`) REFERENCES `Airport Employees/CREWS` (`Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE

);


-- ----------------------------------------------------------

DROP TABLE IF EXISTS `crew_has_worked_together`;

CREATE TABLE `crew_has_worked_together` (
  `Pilot captain Aadhar_card_number` char(12),
  `Pilot first officer Aadhar_card_number` char(12),
  `flight_attendant Aadhar_card_number` char(12),
  `flight_engineer Aadhar_card_number` char(12),
  `Avg_competence_rating` float,
  CHECK (`Avg_competence_rating` >= 0 AND `Avg_competence_rating` <=10),
  `Number of Languages spoken overall` int,
  PRIMARY KEY (`Pilot captain Aadhar_card_number`, `Pilot first officer Aadhar_card_number`, `flight_attendant Aadhar_card_number`, `flight_engineer Aadhar_card_number`),

  FOREIGN KEY(`Pilot captain Aadhar_card_number`) REFERENCES `Pilot` (`fk_to_flight_crew_Aadhar_card_number`)  ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY(`Pilot first officer Aadhar_card_number`) REFERENCES `Pilot` (`fk_to_flight_crew_Aadhar_card_number`)  ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY(`flight_attendant Aadhar_card_number`) REFERENCES `flight_attendant` (`fk_to_flight_crew_Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY(`flight_engineer Aadhar_card_number`) REFERENCES `flight_engineer` (`fk_to_flight_crew_Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE

);

-- ALTER TABLE `crew_has_worked_together`  ADD  `Avg_competence_rating`  float CHECK (`Avg_competence_rating` >= 0 AND `Avg_competence_rating` <=10) ; 


-- ----------------------------------------------------------

DROP TABLE IF EXISTS `flight_crew_feedback`;

CREATE TABLE `flight_crew_feedback` (
  `Pilot captain Aadhar_card_number` char(12),
  `Pilot first officer Aadhar_card_number` char(12),
  `flight_attendant Aadhar_card_number` char(12),
  `flight_engineer Aadhar_card_number` char(12),
  `Feedback given by the passengers for the crew` varchar(255),
  -- `Rating_given` int(2),
  -- CHECK (`Rating_given` >= 0 AND `Rating_given` <=10),
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
  `fk_Aadhar_card_number` char(12),
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