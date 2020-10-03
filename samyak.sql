-- Creating the database
CREATE DATABASE AIRPORT_MANAGEMENT_SYSTEM;

-- Selecting AIRPORT MANAGEMNT SYSTEM As the default database
USE AIRPORT_MANAGEMENT_SYSTEM;

CREATE TABLE `Route` (
  `Route ID` int PRIMARY KEY,
  `Source Airport IATA code` varchar(3),
  `Take off runway id` int,
  `Scheduled arrival` timestamp,
  `Scheduled Departure` timestamp,
  `Date` DATE,
  `Time duration` time,
  `Distance Travelled` int,
  `Landing runway ID` int,
  `Registration number` int,
  `Destination Airport IATA code` varchar(3),
  `Status` varchar(255)
);

CREATE TABLE `Boarding Pass` (
  `Barcode number` varchar(12) PRIMARY KEY,
  `PNR number` varchar(6),
  `Seat` varchar(5),
  `Aadhar_card_number` int(12),
  `Route ID` int
);

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

CREATE TABLE `Emergency Contact` (
  `Name` int,
  `Phone No` int(10) UNIQUE NOT NULL,
  `Aadhar_card_number` int(12),
  PRIMARY KEY (`Name`, `Aadhar_card_number`)
);

CREATE TABLE `Luggage` (
  `Baggage ID` int PRIMARY KEY,
  `Barcode number` varchar(12)
);

CREATE TABLE `Aircraft` (
  `Registration number` int PRIMARY KEY,
  `Manufacturer` varchar(255),
  `Model` varchar(255),
  `Distance Travelled` int,
  `Flight ID` varchar(10),
  `Maintanence check date` date,
  `Owner airline IATA code` varchar(2)
);

CREATE TABLE `Capacity of aircraft` (
  `Manufacturer` varchar(255),
  `Capacity` int,
  `Model` varchar(255),
  PRIMARY KEY (`Manufacturer`, `Model`)
);

CREATE TABLE `Airline` (
  `IATA airline designators` varchar(2) PRIMARY KEY,
  `Company Name` varchar(50),
  `Number of aircrafts owned` int,
  `Active` Boolean,
  `Country of Ownership` varchar(255)
);

CREATE TABLE `Airline Employees/CREW` (
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

CREATE TABLE `Flight Crew` (
  `Aadhar_card_number` int(12) PRIMARY KEY
);

CREATE TABLE `Pilot` (
  `Aadhar_card_number` int(12),
  `Pilot license number` int(12),
  `Number of flying hours` int,
  PRIMARY KEY (`Aadhar_card_number`, `Pilot license number`)
);

CREATE TABLE `Flight attendant` (
  `Aadhar_card_number` int(12) PRIMARY KEY,
  `Training/Education` varchar(255)
);

CREATE TABLE `Flight engineer` (
  `Aadhar_card_number` int(12) PRIMARY KEY,
  `Education` varchar(255),
  `Manufacturer` varchar(255),
  `plane id` int
);

CREATE TABLE `Flight crew Serves on the route` (
  `Aadhar_card_number` int(12),
  `Route ID` int,
  PRIMARY KEY (`Aadhar_card_number`, `Route ID`)
);

CREATE TABLE `On-ground` (
  `Aadhar_card_number` int(12) PRIMARY KEY,
  `Job title` varchar(255)
);

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

CREATE TABLE `Runway` (
  `IATA airport codes` varchar(3),
  `Runway ID` int,
  `length_ft` float,
  `width_ft` float,
  `Status` varchar(255),
  PRIMARY KEY (`IATA airport codes`, `Runway ID`)
);

CREATE TABLE `Terminal` (
  `IATA airport codes` varchar(3),
  `Terminal ID` int,
  `Airplane Handling capacity` int,
  `Floor Area` float,
  PRIMARY KEY (`IATA airport codes`, `Terminal ID`)
);

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

CREATE TABLE `Management and operations executives` (
  `Aadhar_card_number` int(12) PRIMARY KEY,
  `Job title` varchar(255)
);

CREATE TABLE `Security` (
  `Aadhar_card_number` int(12) PRIMARY KEY,
  `Designation` varchar(255),
  `Security ID number` int
);

CREATE TABLE `Air traffic controller` (
  `Aadhar_card_number` int(12) PRIMARY KEY,
  `Current communication Frequency` float,
  `Training/Education` varchar(255)
);

CREATE TABLE `crew_has_worked_togther` (
  `Pilot captain Aadhar_card_number` int(12),
  `Pilot first officer Aadhar_card_number` int(12),
  `Flight attendant Aadhar_card_number` int(12),
  `Flight engineer Aadhar_card_number` int(12),
  `Avg competence rating` int,
  `Number of Languages spoken overall` int,
  PRIMARY KEY (`Pilot captain Aadhar_card_number`, `Pilot first officer Aadhar_card_number`, `Flight attendant Aadhar_card_number`, `Flight engineer Aadhar_card_number`)
);

CREATE TABLE `Flight Crew Feedback` (
  `Pilot captain Aadhar_card_number` int(12),
  `Pilot first officer Aadhar_card_number` int(12),
  `Flight attendant Aadhar_card_number` int(12),
  `Flight engineer Aadhar_card_number` int(12),
  `Feedback given by the passengers for the crew` varchar(255) PRIMARY KEY,
  PRIMARY KEY (`Pilot captain Aadhar_card_number`, `Pilot first officer Aadhar_card_number`, `Flight attendant Aadhar_card_number`, `Flight engineer Aadhar_card_number`)
);

CREATE TABLE `Boarding Pass special services` (
  `Barcode number` varchar(12),
  `Special services` varchar(255),
  PRIMARY KEY (`Barcode number`, `Special services`)
);

CREATE TABLE `Languages spoken by airline employee` (
  `Aadhar_card_number` int(12),
  `Language_name` varchar(255),
  PRIMARY KEY (`Aadhar_card_number`, `Language_name`)
);

CREATE TABLE `Stopover airports of route` (
  `Route ID` int,
  `IATA code of stopover airport` varchar(3),
  PRIMARY KEY (`Route ID`, `IATA code of stopover airport`)
);

CREATE TABLE `PNR info deduction` (
  `PNR number` varchar(6) PRIMARY KEY,
  `Scheduled Boarding Time` timestamp,
  `Terminal number` int,
  `class of travel` varchar(255)
);

ALTER TABLE `Emergency Contact` ADD FOREIGN KEY (`Aadhar_card_number`) REFERENCES `Passenger` (`Aadhar_card_number`);

ALTER TABLE `Runway` ADD FOREIGN KEY (`IATA airport codes`) REFERENCES `Airport` (`IATA airport codes`);

ALTER TABLE `Terminal` ADD FOREIGN KEY (`IATA airport codes`) REFERENCES `Airport` (`IATA airport codes`);

ALTER TABLE `Boarding Pass` ADD FOREIGN KEY (`Aadhar_card_number`) REFERENCES `Passenger` (`Aadhar_card_number`);

ALTER TABLE `Luggage` ADD FOREIGN KEY (`Barcode number`) REFERENCES `Boarding Pass` (`Barcode number`);

ALTER TABLE `Route` ADD FOREIGN KEY (`Destination Airport IATA code`) REFERENCES `Airport` (`IATA airport codes`);

ALTER TABLE `Route` ADD FOREIGN KEY (`Source Airport IATA code`) REFERENCES `Airport` (`IATA airport codes`);

ALTER TABLE `Route` ADD FOREIGN KEY (`Registration number`) REFERENCES `Aircraft` (`Registration number`);

ALTER TABLE `Airline Employees/CREW` ADD FOREIGN KEY (`Employer IATA airline designators`) REFERENCES `Airline` (`IATA airline designators`);

ALTER TABLE `Aircraft` ADD FOREIGN KEY (`Owner airline IATA code`) REFERENCES `Airline` (`IATA airline designators`);

ALTER TABLE `Airport Employees/CREWS` ADD FOREIGN KEY (`IATA airport code of employing airport`) REFERENCES `Airport` (`IATA airport codes`);

ALTER TABLE `Airport Employees/CREWS` ADD FOREIGN KEY (`Supervisor Aadhar_card_number`) REFERENCES `Airport Employees/CREWS` (`Aadhar_card_number`);

ALTER TABLE `Flight crew Serves on the route` ADD FOREIGN KEY (`Aadhar_card_number`) REFERENCES `Airline Employees/CREW` (`Aadhar_card_number`);

ALTER TABLE `Flight crew Serves on the route` ADD FOREIGN KEY (`Route ID`) REFERENCES `Route` (`Route ID`);

ALTER TABLE `On-ground` ADD FOREIGN KEY (`Aadhar_card_number`) REFERENCES `Airline Employees/CREW` (`Aadhar_card_number`);

ALTER TABLE `Flight Crew` ADD FOREIGN KEY (`Aadhar_card_number`) REFERENCES `Airline Employees/CREW` (`Aadhar_card_number`);

ALTER TABLE `Management and operations executives` ADD FOREIGN KEY (`Aadhar_card_number`) REFERENCES `Airport Employees/CREWS` (`Aadhar_card_number`);

ALTER TABLE `Security` ADD FOREIGN KEY (`Aadhar_card_number`) REFERENCES `Airport Employees/CREWS` (`Aadhar_card_number`);

ALTER TABLE `Air traffic controller` ADD FOREIGN KEY (`Aadhar_card_number`) REFERENCES `Airport Employees/CREWS` (`Aadhar_card_number`);

ALTER TABLE `Pilot` ADD FOREIGN KEY (`Aadhar_card_number`) REFERENCES `Flight Crew` (`Aadhar_card_number`);

ALTER TABLE `Flight attendant` ADD FOREIGN KEY (`Aadhar_card_number`) REFERENCES `Flight Crew` (`Aadhar_card_number`);

ALTER TABLE `Flight engineer` ADD FOREIGN KEY (`Aadhar_card_number`) REFERENCES `Flight Crew` (`Aadhar_card_number`);

ALTER TABLE `crew_has_worked_togther` ADD FOREIGN KEY (`Pilot captain Aadhar_card_number`) REFERENCES `Pilot` (`Aadhar_card_number`);

ALTER TABLE `crew_has_worked_togther` ADD FOREIGN KEY (`Pilot first officer Aadhar_card_number`) REFERENCES `Pilot` (`Aadhar_card_number`);

ALTER TABLE `crew_has_worked_togther` ADD FOREIGN KEY (`Flight attendant Aadhar_card_number`) REFERENCES `Flight attendant` (`Aadhar_card_number`);

ALTER TABLE `crew_has_worked_togther` ADD FOREIGN KEY (`Flight engineer Aadhar_card_number`) REFERENCES `Flight engineer` (`Aadhar_card_number`);

ALTER TABLE `Boarding Pass special services` ADD FOREIGN KEY (`Barcode number`) REFERENCES `Boarding Pass` (`Barcode number`);

ALTER TABLE `Languages spoken by airline employee` ADD FOREIGN KEY (`Aadhar_card_number`) REFERENCES `Airline Employees/CREW` (`Aadhar_card_number`);

ALTER TABLE `Stopover airports of route` ADD FOREIGN KEY (`Route ID`) REFERENCES `Route` (`Route ID`);

ALTER TABLE `Capacity of aircraft` ADD FOREIGN KEY (`Model`) REFERENCES `Aircraft` (`Model`);

ALTER TABLE `Capacity of aircraft` ADD FOREIGN KEY (`Manufacturer`) REFERENCES `Aircraft` (`Manufacturer`);

ALTER TABLE `Flight Crew Feedback` ADD FOREIGN KEY (`Pilot captain Aadhar_card_number`) REFERENCES `Pilot` (`Aadhar_card_number`);

ALTER TABLE `Flight Crew Feedback` ADD FOREIGN KEY (`Pilot first officer Aadhar_card_number`) REFERENCES `Pilot` (`Aadhar_card_number`);

ALTER TABLE `Flight Crew Feedback` ADD FOREIGN KEY (`Flight attendant Aadhar_card_number`) REFERENCES `Flight attendant` (`Aadhar_card_number`);

ALTER TABLE `Flight Crew Feedback` ADD FOREIGN KEY (`Flight engineer Aadhar_card_number`) REFERENCES `Flight engineer` (`Aadhar_card_number`);

ALTER TABLE `Route` ADD FOREIGN KEY (`Landing runway ID`) REFERENCES `Runway` (`Runway ID`);

ALTER TABLE `Route` ADD FOREIGN KEY (`Take off runway id`) REFERENCES `Runway` (`Runway ID`);

ALTER TABLE `Stopover airports of route` ADD FOREIGN KEY (`IATA code of stopover airport`) REFERENCES `Airport` (`IATA airport codes`);

ALTER TABLE `PNR info deduction` ADD FOREIGN KEY (`PNR number`) REFERENCES `Boarding Pass` (`PNR number`);

ALTER TABLE `PNR info deduction` ADD FOREIGN KEY (`Terminal number`) REFERENCES `Terminal` (`Terminal ID`);

ALTER TABLE `Boarding Pass` ADD FOREIGN KEY (`Route ID`) REFERENCES `Route` (`Route ID`);

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

