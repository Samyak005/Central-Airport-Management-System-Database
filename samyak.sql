CREATE DATABASE airport_db;

USE airport_db;
----------------------------------------------------------

Criteria
- NULL
- UNIQUENESS
- kEYS
- DEFAULT
- FOREIGN KEy -> on cascade, delete 





DROP TABLE IF EXISTS 'Route';

CREATE TABLE `Route` (
  `Route ID` int PRIMARY KEY,
  `Source Airport IATA code` char(3) NOT NULL,
  `Destination Airport IATA code` char(3) NOT NULL,
  `Date` DATE NOT NULL,
  `Scheduled arrival` timestamp,
  `Scheduled Departure` timestamp,
  `Time duration` time,
  `Take off runway id` int NOT NULL,
  `Distance Travelled` int,
  `Landing runway ID` int,
  `Registration number` int,
  `Status` varchar(255)
);
----------------------------------------------------------

DROP TABLE IF EXISTS 'boarding_pass';

CREATE TABLE `boarding_pass` (
  `Barcode number` varchar(12) PRIMARY KEY,
  `PNR number` varchar(6),
  `Seat` varchar(5),
  `Aadhar_card_number` int(12),
  `Route ID` int
);
----------------------------------------------------------

DROP TABLE IF EXISTS 'Passenger';

CREATE TABLE `Passenger` (
  `First Name` varchar(255),
  `Middle Name` varchar(255),
  `Last Name` varchar(255),
  `Aadhar_card_number` int(12) PRIMARY KEY,
  `Gender` varchar(6),
  `Email-ID` varchar(255),
  `City` varchar(255),
  `Building` varchar(255),
  `House Number` varchar(10),
  `DOB` date,
  `Senior Citizen` Boolean,
  `Nationality` varchar(255)
);
----------------------------------------------------------

DROP TABLE IF EXISTS 'emer_contact';

CREATE TABLE `emer_contact` (
  `Name` int,
  `Phone No` int(10) UNIQUE NOT NULL,
  `Aadhar_card_number` int(12),
  PRIMARY KEY (`Name`, `Aadhar_card_number`)
);
----------------------------------------------------------

DROP TABLE IF EXISTS 'luggage';

CREATE TABLE `luggage` (
  `Baggage ID` int PRIMARY KEY,
  `Barcode number` varchar(12)
);
----------------------------------------------------------

DROP TABLE IF EXISTS 'Aircraft';

CREATE TABLE `Aircraft` (
  `Registration number` int PRIMARY KEY,
  `Manufacturer` varchar(255),
  `Model` varchar(255),
  `Distance Travelled` int,
  `Flight ID` varchar(10),
  `Maintanence check date` date,
  `Owner airline IATA code` varchar(2),
  KEY (`Manufacturer`, `Model`)
);

----------------------------------------------------------

DROP TABLE IF EXISTS 'capacity_of_aircraft';

CREATE TABLE `capacity_of_aircraft` (
  `Manufacturer` varchar(255),
  `Capacity` int,
  `Model` varchar(255),
  PRIMARY KEY (`Manufacturer`, `Model`)
);
----------------------------------------------------------

DROP TABLE IF EXISTS 'Airline';

CREATE TABLE `Airline` (
  `IATA airline designators` varchar(2) PRIMARY KEY,
  `Company Name` varchar(50),
  `Number of aircrafts owned` int,
  `Active` Boolean,
  `Country of Ownership` varchar(255)
);

----------------------------------------------------------

DROP TABLE IF EXISTS 'airline_crew';

CREATE TABLE `airline_crew` (
  `Aadhar_card_number` int(12) PRIMARY KEY,
  `First Name` varchar(255),
  `Middle Name` varchar(255),
  `Last Name` varchar(255),
  `Number of years of Experience` int,
  `Salary` int,
  `Nationality` varchar(255),
  `DOB` date,
  `Gender` varchar(6),
  `Employer IATA airline designators` varchar(2)
);

----------------------------------------------------------

DROP TABLE IF EXISTS 'flight_crew';

CREATE TABLE `flight_crew` (
  `Aadhar_card_number` int(12) PRIMARY KEY
);

----------------------------------------------------------

DROP TABLE IF EXISTS 'Pilot';

CREATE TABLE `Pilot` (
  `Aadhar_card_number` int(12),
  `Pilot license number` int(12),
  `Number of flying hours` int,
  PRIMARY KEY (`Aadhar_card_number`, `Pilot license number`)
);

----------------------------------------------------------

DROP TABLE IF EXISTS 'flight_attendant';

CREATE TABLE `flight_attendant` (
  `Aadhar_card_number` int(12) PRIMARY KEY,
  `Training/Education` varchar(255)
);

----------------------------------------------------------

DROP TABLE IF EXISTS 'flight_engineer';

CREATE TABLE `flight_engineer` (
  `Aadhar_card_number` int(12) PRIMARY KEY,
  `Education` varchar(255),
  `Manufacturer` varchar(255),
  `plane id` int
);


----------------------------------------------------------

DROP TABLE IF EXISTS 'flight_crew_serves_on_route';

CREATE TABLE `flight_crew_serves_on_route` (
  `Aadhar_card_number` int(12),
  `Route ID` int,
  PRIMARY KEY (`Aadhar_card_number`, `Route ID`)
);

----------------------------------------------------------

DROP TABLE IF EXISTS 'On-ground';

CREATE TABLE `On-ground` (
  `Aadhar_card_number` int(12) PRIMARY KEY,
  `Job title` varchar(255)
);

----------------------------------------------------------

DROP TABLE IF EXISTS 'Airport';

CREATE TABLE `Airport` (
  `IATA airport codes` varchar(3) PRIMARY KEY,
  `Altitude` float,
  `Time Zone` float,
  `Airport Name` varchar(255),
  `City` varchar(255),
  `Country` varchar(255),
  `Latitude` float,
  `Longitude` float
);

----------------------------------------------------------

DROP TABLE IF EXISTS 'Runway';

CREATE TABLE `Runway` (
  `IATA airport codes` varchar(3),
  `Runway ID` int,
  `length_ft` float,
  `width_ft` float,
  `Status` varchar(255),
  PRIMARY KEY (`IATA airport codes`, `Runway ID`)
);

----------------------------------------------------------

DROP TABLE IF EXISTS 'Terminal';

CREATE TABLE `Terminal` (
  `IATA airport codes` varchar(3),
  `Terminal ID` int,
  `Airplane Handling capacity` int,
  `Floor Area` float,
  PRIMARY KEY (`IATA airport codes`, `Terminal ID`)
);


----------------------------------------------------------


CREATE TABLE `Airport Employees/CREWS` (
  `IATA airport code of employing airport` varchar(3),
  `Aadhar_card_number` int(12) PRIMARY KEY,
  `First Name` varchar(255),
  `Middle Name` varchar(255),
  `Last Name` varchar(255),
  `Experience` int,
  `Salary` int,
  `Nationality` varchar(255),
  `DOB` date,
  `Gender` varchar(6),
  `Supervisor Aadhar_card_number` int(12)
);


----------------------------------------------------------

CREATE TABLE `mo_executives` (
  `Aadhar_card_number` int(12) PRIMARY KEY,
  `Job title` varchar(255)
);


----------------------------------------------------------

DROP TABLE IF EXISTS 'Security';

CREATE TABLE `Security` (
  `Aadhar_card_number` int(12) PRIMARY KEY,
  `Designation` varchar(255),
  `Security ID number` int
);


----------------------------------------------------------

DROP TABLE IF EXISTS 'air_traffic_controller';

CREATE TABLE `air_traffic_controller` (
  `Aadhar_card_number` int(12) PRIMARY KEY,
  `Current communication Frequency` float,
  `Training/Education` varchar(255)
);


----------------------------------------------------------

CREATE TABLE `crew_has_worked_togther` (
  `Pilot captain Aadhar_card_number` int(12),
  `Pilot first officer Aadhar_card_number` int(12),
  `flight_attendant Aadhar_card_number` int(12),
  `flight_engineer Aadhar_card_number` int(12),
  `Avg competence rating` int,
  `Number of Languages spoken overall` int,
  PRIMARY KEY (`Pilot captain Aadhar_card_number`, `Pilot first officer Aadhar_card_number`, `flight_attendant Aadhar_card_number`, `flight_engineer Aadhar_card_number`)
);


----------------------------------------------------------

CREATE TABLE `flight_crew_feedback` (
  `Pilot captain Aadhar_card_number` int(12),
  `Pilot first officer Aadhar_card_number` int(12),
  `flight_attendant Aadhar_card_number` int(12),
  `flight_engineer Aadhar_card_number` int(12),
  `Feedback given by the passengers for the crew` varchar(255),
  PRIMARY KEY (`Pilot captain Aadhar_card_number`, `Pilot first officer Aadhar_card_number`, `flight_attendant Aadhar_card_number`, `flight_engineer Aadhar_card_number`, `Feedback given by the passengers for the crew`)
);

----------------------------------------------------------

DROP TABLE IF EXISTS 'boarding_pass special services';

CREATE TABLE `boarding_pass special services` (
  `Barcode number` varchar(12),
  `Special services` varchar(255),
  PRIMARY KEY (`Barcode number`, `Special services`)
);

----------------------------------------------------------

DROP TABLE IF EXISTS 'Languages spoken by airline employee';

CREATE TABLE `Languages spoken by airline employee` (
  `Aadhar_card_number` int(12),
  `Language_name` varchar(255),
  PRIMARY KEY (`Aadhar_card_number`, `Language_name`)
);

----------------------------------------------------------

DROP TABLE IF EXISTS 'stopover_airports_on_route';

CREATE TABLE `stopover_airports_on_route` (
  `Route ID` int,
  `IATA code of stopover airport` varchar(3),
  PRIMARY KEY (`Route ID`, `IATA code of stopover airport`)
);

----------------------------------------------------------

DROP TABLE IF EXISTS 'PNR info deduction';

CREATE TABLE `PNR info deduction` (
  `PNR number` varchar(6) PRIMARY KEY,
  `Scheduled Boarding Time` timestamp,
  `Terminal number` int,
  `class of travel` varchar(255)
);

----------------------------------------------------------
----------------------------------------------------------
----------------------------------------------------------
----------------------------------------------------------
----------------------------------------------------------

ALTER TABLE `emer_contact` ADD FOREIGN KEY (`Aadhar_card_number`) REFERENCES `Passenger` (`Aadhar_card_number`);

ALTER TABLE `Runway` ADD FOREIGN KEY (`IATA airport codes`) REFERENCES `Airport` (`IATA airport codes`);

ALTER TABLE `Terminal` ADD FOREIGN KEY (`IATA airport codes`) REFERENCES `Airport` (`IATA airport codes`);

ALTER TABLE `boarding_pass` ADD FOREIGN KEY (`Aadhar_card_number`) REFERENCES `Passenger` (`Aadhar_card_number`);

ALTER TABLE `luggage` ADD FOREIGN KEY (`Barcode number`) REFERENCES `boarding_pass` (`Barcode number`);

ALTER TABLE `Route` ADD FOREIGN KEY (`Destination Airport IATA code`) REFERENCES `Airport` (`IATA airport codes`);

ALTER TABLE `Route` ADD FOREIGN KEY (`Source Airport IATA code`) REFERENCES `Airport` (`IATA airport codes`);

ALTER TABLE `Route` ADD FOREIGN KEY (`Registration number`) REFERENCES `Aircraft` (`Registration number`);

ALTER TABLE `airline_crew` ADD FOREIGN KEY (`Employer IATA airline designators`) REFERENCES `Airline` (`IATA airline designators`);

ALTER TABLE `Aircraft` ADD FOREIGN KEY (`Owner airline IATA code`) REFERENCES `Airline` (`IATA airline designators`);

ALTER TABLE `Airport Employees/CREWS` ADD FOREIGN KEY (`IATA airport code of employing airport`) REFERENCES `Airport` (`IATA airport codes`);

ALTER TABLE `Airport Employees/CREWS` ADD FOREIGN KEY (`Supervisor Aadhar_card_number`) REFERENCES `Airport Employees/CREWS` (`Aadhar_card_number`);

ALTER TABLE `flight_crew_serves_on_route` ADD FOREIGN KEY (`Aadhar_card_number`) REFERENCES `airline_crew` (`Aadhar_card_number`);

ALTER TABLE `flight_crew_serves_on_route` ADD FOREIGN KEY (`Route ID`) REFERENCES `Route` (`Route ID`);

ALTER TABLE `On-ground` ADD FOREIGN KEY (`Aadhar_card_number`) REFERENCES `airline_crew` (`Aadhar_card_number`);

ALTER TABLE `flight_crew` ADD FOREIGN KEY (`Aadhar_card_number`) REFERENCES `airline_crew` (`Aadhar_card_number`);

ALTER TABLE `mo_executives` ADD FOREIGN KEY (`Aadhar_card_number`) REFERENCES `Airport Employees/CREWS` (`Aadhar_card_number`);

ALTER TABLE `Security` ADD FOREIGN KEY (`Aadhar_card_number`) REFERENCES `Airport Employees/CREWS` (`Aadhar_card_number`);

ALTER TABLE `air_traffic_controller` ADD FOREIGN KEY (`Aadhar_card_number`) REFERENCES `Airport Employees/CREWS` (`Aadhar_card_number`);

ALTER TABLE `Pilot` ADD FOREIGN KEY (`Aadhar_card_number`) REFERENCES `flight_crew` (`Aadhar_card_number`);

ALTER TABLE `flight_attendant` ADD FOREIGN KEY (`Aadhar_card_number`) REFERENCES `flight_crew` (`Aadhar_card_number`);

ALTER TABLE `flight_engineer` ADD FOREIGN KEY (`Aadhar_card_number`) REFERENCES `flight_crew` (`Aadhar_card_number`);

ALTER TABLE `crew_has_worked_togther` ADD FOREIGN KEY (`Pilot captain Aadhar_card_number`) REFERENCES `Pilot` (`Aadhar_card_number`);

ALTER TABLE `crew_has_worked_togther` ADD FOREIGN KEY (`Pilot first officer Aadhar_card_number`) REFERENCES `Pilot` (`Aadhar_card_number`);

ALTER TABLE `crew_has_worked_togther` ADD FOREIGN KEY (`flight_attendant Aadhar_card_number`) REFERENCES `flight_attendant` (`Aadhar_card_number`);

ALTER TABLE `crew_has_worked_togther` ADD FOREIGN KEY (`flight_engineer Aadhar_card_number`) REFERENCES `flight_engineer` (`Aadhar_card_number`);

ALTER TABLE `boarding_pass special services` ADD FOREIGN KEY (`Barcode number`) REFERENCES `boarding_pass` (`Barcode number`);

ALTER TABLE `Languages spoken by airline employee` ADD FOREIGN KEY (`Aadhar_card_number`) REFERENCES `airline_crew` (`Aadhar_card_number`);

ALTER TABLE `stopover_airports_on_route` ADD FOREIGN KEY (`Route ID`) REFERENCES `Route` (`Route ID`);

ALTER TABLE `capacity_of_aircraft` ADD FOREIGN KEY (`Model`) REFERENCES `Aircraft` (`Model`);

ALTER TABLE `capacity_of_aircraft` ADD FOREIGN KEY (`Manufacturer`) REFERENCES `Aircraft` (`Manufacturer`);

ALTER TABLE `flight_crew_feedback` ADD FOREIGN KEY (`Pilot captain Aadhar_card_number`) REFERENCES `Pilot` (`Aadhar_card_number`);

ALTER TABLE `flight_crew_feedback` ADD FOREIGN KEY (`Pilot first officer Aadhar_card_number`) REFERENCES `Pilot` (`Aadhar_card_number`);

ALTER TABLE `flight_crew_feedback` ADD FOREIGN KEY (`flight_attendant Aadhar_card_number`) REFERENCES `flight_attendant` (`Aadhar_card_number`);

ALTER TABLE `flight_crew_feedback` ADD FOREIGN KEY (`flight_engineer Aadhar_card_number`) REFERENCES `flight_engineer` (`Aadhar_card_number`);

ALTER TABLE `Route` ADD FOREIGN KEY (`Landing runway ID`) REFERENCES `Runway` (`Runway ID`);

ALTER TABLE `Route` ADD FOREIGN KEY (`Take off runway id`) REFERENCES `Runway` (`Runway ID`);

ALTER TABLE `stopover_airports_on_route` ADD FOREIGN KEY (`IATA code of stopover airport`) REFERENCES `Airport` (`IATA airport codes`);

ALTER TABLE `PNR info deduction` ADD FOREIGN KEY (`PNR number`) REFERENCES `boarding_pass` (`PNR number`);

ALTER TABLE `PNR info deduction` ADD FOREIGN KEY (`Terminal number`) REFERENCES `Terminal` (`Terminal ID`);

ALTER TABLE `boarding_pass` ADD FOREIGN KEY (`Route ID`) REFERENCES `Route` (`Route ID`);

INSERT INTO `airport_management_system`.`airline` (`IATA airline designators`, `Company Name`, `Number of aircrafts owned`, `Active`, `Country of Ownership`) VALUES ('6E', 'Indigo Airlines Limited', '0', '1', 'India');
INSERT INTO `airport_management_system`.`airline` (`IATA airline designators`, `Company Name`, `Number of aircrafts owned`, `Active`, `Country of Ownership`) VALUES ('SG', 'Spicejet Limited', '0', '1', 'India');
INSERT INTO `airport_management_system`.`airline` (`IATA airline designators`, `Company Name`, `Number of aircrafts owned`, `Active`, `Country of Ownership`) VALUES ('AI', 'Air India Limited', '0', '1', 'India');
INSERT INTO `airport_management_system`.`airline` (`IATA airline designators`, `Company Name`, `Number of aircrafts owned`, `Active`, `Country of Ownership`) VALUES ('UK', 'Air Vistara', '0', '1', 'India');
INSERT INTO `airport_management_system`.`airline` (`IATA airline designators`, `Company Name`, `Number of aircrafts owned`, `Active`, `Country of Ownership`) VALUES ('G8', 'Go Airways', '0', '1', 'India');

INSERT INTO `airport_management_system`.`airport` (`IATA airport codes`, `Altitude`, `Time Zone`, `Airport Name`, `City`, `Country`, `Latitude`, `Longitude`) VALUES ('DEL', '225', '5.5', 'Indira Gandhi International Airport', 'Delhi', 'India', '28.7041', '77.1025');
INSERT INTO `airport_management_system`.`airport` (`IATA airport codes`, `Altitude`, `Time Zone`, `Airport Name`, `City`, `Country`, `Latitude`, `Longitude`) VALUES ('HYD', '542', '5.5', 'Rajiv Gandhi International Airport', 'Hyderabad', 'India', '17.385', '78.4867');
INSERT INTO `airport_management_system`.`airport` (`IATA airport codes`, `Altitude`, `Time Zone`, `Airport Name`, `City`, `Country`, `Latitude`, `Longitude`) VALUES ('MUM', '14', '5.5', 'Chattrapati Shivaji International Airport', 'Mumbai', 'India', '19.076', '72.8777');
INSERT INTO `airport_management_system`.`airport` (`IATA airport codes`, `Altitude`, `Time Zone`, `Airport Name`, `City`, `Country`, `Latitude`, `Longitude`) VALUES ('BLR', '920', '5.5', 'KempeGowda International Airport', 'Bangaluru', 'India', '12.9716', '77.5946');

INSERT INTO `airport_management_system`.`runway` (`IATA airport codes`, `Runway ID`, `length_ft`, `width_ft`, `Status`) VALUES ('DEL', '0', '9229', '150.9', 'ACTIVE');
INSERT INTO `airport_management_system`.`runway` (`IATA airport codes`, `Runway ID`, `length_ft`, `width_ft`, `Status`) VALUES ('HYD', '0', '12162', '148', 'ACTIVE');
INSERT INTO `airport_management_system`.`runway` (`IATA airport codes`, `Runway ID`, `length_ft`, `width_ft`, `Status`) VALUES ('MUM', '0', '12008', '200', 'ACTIVE');
INSERT INTO `airport_management_system`.`runway` (`IATA airport codes`, `Runway ID`, `length_ft`, `width_ft`, `Status`) VALUES ('BLR', '0', '13123', '148', 'ACTIVE');
INSERT INTO `airport_management_system`.`runway` (`IATA airport codes`, `Runway ID`, `length_ft`, `width_ft`, `Status`) VALUES ('DEL', '1', '12500', '150.92', 'ACTIVE');
INSERT INTO `airport_management_system`.`runway` (`IATA airport codes`, `Runway ID`, `length_ft`, `width_ft`, `Status`) VALUES ('BLR', '1', '13120', '200', 'ACTIVE');
INSERT INTO `airport_management_system`.`runway` (`IATA airport codes`, `Runway ID`, `length_ft`, `width_ft`, `Status`) VALUES ('MUM', '1', '9810', '148', 'ACTIVE');
INSERT INTO `airport_management_system`.`runway` (`IATA airport codes`, `Runway ID`, `length_ft`, `width_ft`, `Status`) VALUES ('HYD', '1', '13980', '200', 'ACTIVE');
INSERT INTO `airport_management_system`.`runway` (`IATA airport codes`, `Runway ID`, `length_ft`, `width_ft`, `Status`) VALUES ('DEL', '2', '14534.121', '196.85', 'ACTIVE');

INSERT INTO `airport_management_system`.`terminal` (`IATA airport codes`, `Terminal ID`, `Airplane Handling capacity`, `Floor Area`) VALUES ('DEL', '1', '450', '34753');
INSERT INTO `airport_management_system`.`terminal` (`IATA airport codes`, `Terminal ID`, `Airplane Handling capacity`, `Floor Area`) VALUES ('DEL', '2', '280', '54320');
INSERT INTO `airport_management_system`.`terminal` (`IATA airport codes`, `Terminal ID`, `Airplane Handling capacity`, `Floor Area`) VALUES ('DEL', '3', '800', '76459');
INSERT INTO `airport_management_system`.`terminal` (`IATA airport codes`, `Terminal ID`, `Airplane Handling capacity`, `Floor Area`) VALUES ('MUM', '1', '325', '21457');
INSERT INTO `airport_management_system`.`terminal` (`IATA airport codes`, `Terminal ID`, `Airplane Handling capacity`, `Floor Area`) VALUES ('MUM', '2', '341', '23574');
INSERT INTO `airport_management_system`.`terminal` (`IATA airport codes`, `Terminal ID`, `Airplane Handling capacity`, `Floor Area`) VALUES ('MUM', '3', '560', '87934');
INSERT INTO `airport_management_system`.`terminal` (`IATA airport codes`, `Terminal ID`, `Airplane Handling capacity`, `Floor Area`) VALUES ('HYD', '1', '560', '23572');
INSERT INTO `airport_management_system`.`terminal` (`IATA airport codes`, `Terminal ID`, `Airplane Handling capacity`, `Floor Area`) VALUES ('HYD', '2', '960', '46973');
INSERT INTO `airport_management_system`.`terminal` (`IATA airport codes`, `Terminal ID`, `Airplane Handling capacity`, `Floor Area`) VALUES ('BLR', '1', '650', '23258');
INSERT INTO `airport_management_system`.`terminal` (`IATA airport codes`, `Terminal ID`, `Airplane Handling capacity`, `Floor Area`) VALUES ('BLR', '2', '860', '143766');

INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('4.23842E+11', 'Hindi');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('4.87302E+11', 'Hindi');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('8.3938E+11', 'Hindi');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('7.63239E+11', 'Hindi');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('2.67271E+11', 'Hindi');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('7.05118E+11', 'Hindi');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('8.95445E+11', 'Telegu');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('5.7314E+11', 'Telegu');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('1.78902E+11', 'Telegu');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('9.68294E+11', 'Telegu');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('9.87073E+11', 'Telegu');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('4.64487E+11', 'Telegu');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('2.72041E+11', 'Telegu');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('7.74444E+11', 'English');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('4.19649E+11', 'English');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('9.52078E+11', 'English');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('3.65788E+11', 'English');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('5.23365E+11', 'English');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('6.82892E+11', 'English');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('4.36364E+11', 'English');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('6.59472E+11', 'English');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('7.73579E+11', 'English');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('7.88036E+11', 'English');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('4.82861E+11', 'English');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('8.87225E+11', 'English');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('5.39895E+11', 'English');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('6.85851E+11', 'English');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('2.95985E+11', 'English');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('3.87425E+11', 'English');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('7.57545E+11', 'Marathi');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('9.96367E+11', 'Marathi');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('5.59764E+11', 'Marathi');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('5.07987E+11', 'Marathi');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('5.76539E+11', 'Marathi');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('5.17629E+11', 'Kannada');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('3.73431E+11', 'Kannada');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('4.369E+11', 'Kannada');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('1.72125E+11', 'Kannada');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('3.119E+11', 'Kannada');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('1.89012E+11', 'Kannada');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('5.93985E+11', 'Kannada');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('8.23456E+11', 'Kannada');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('2.79413E+11', 'Kannada');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('1.13128E+11', 'Kannada');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('3.92948E+11', 'Kannada');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('5.08613E+11', 'Kannada');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('2.33363E+11', 'Hindi');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('7.49515E+11', 'Hindi');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('1.64713E+11', 'Hindi');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('6.37471E+11', 'Hindi');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('8.74814E+11', 'Hindi');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('7.77211E+11', 'Hindi');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('7.67645E+11', 'Hindi');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('1.20295E+11', 'Hindi');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('4.47585E+11', 'Hindi');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('3.09086E+11', 'Hindi');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('3.41648E+11', 'Hindi');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('4.63263E+11', 'Hindi');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('9.15403E+11', 'Hindi');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('9.47056E+11', 'Hindi');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('8.8253E+11', 'English');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('7.01317E+11', 'English');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('9.40191E+11', 'English');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('9.94163E+11', 'English');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('5.6292E+11', 'English');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('3.57284E+11', 'English');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('8.01202E+11', 'English');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('9.10746E+11', 'English');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('7.27603E+11', 'English');
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('9.84117E+11', 'English');


