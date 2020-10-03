CREATE DATABASE airport_db;

USE airport_db;
----------------------------------------------------------

DROP TABLE IF EXISTS 'Route';

CREATE TABLE `Route` (
  `Route ID` int PRIMARY KEY,
  `fk_to_airport_src_iata_code` char(3) NOT NULL,
  `fk_to_airport_dest_iata_code` char(3) NOT NULL,
  `Date` DATE NOT NULL, --YYYY-MM-DD

  `Scheduled arrival` time,  --hh:mm:ss
  `Scheduled Departure` time,
  `Time duration` time,
  `fk_to_runway_Take off runway id` int,
  `Distance Travelled` int,
  `fk_to_runway_Landing runway ID` int,
  `fk_to_aircraft_registration_num` int,
  `Status` enum('Departed', 'Boarding','On_route','Delayed','Arrived','Checking','Not_applicable') NOT NULL DEFAULT 'Not_applicable',

  FOREIGN KEY (`fk_to_airport_dest_iata_code`) REFERENCES `Airport` (`IATA airport codes`) ON DELETE SET CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`fk_to_airport_src_iata_code`) REFERENCES `Airport` (`IATA airport codes`) ON DELETE SET CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`fk_to_aircraft_registration_num`) REFERENCES `Aircraft` (`registration_num`) ON DELETE SET NULL ON UPDATE CASCADE,
  FOREIGN KEY (`fk_to_runway_Landing runway ID`) REFERENCES `Runway` (`Runway ID`) ON DELETE SET NULL ON UPDATE CASCADE,
  FOREIGN KEY (`fk_to_runway_Take off runway id`) REFERENCES `Runway` (`Runway ID`) ON DELETE SET NULL ON UPDATE CASCADE,

);
----------------------------------------------------------




DROP TABLE IF EXISTS 'boarding_pass';

CREATE TABLE `boarding_pass` (
  `Barcode number` char(12) PRIMARY KEY,
  `PNR number` char(6) NOT NULL,
  `Seat` varchar(5),
  `fk_to_passenger_Aadhar_card_number` int(12) NOT NULL,
  `fk_to_route_Route ID` int NOT NULL,

  FOREIGN KEY (`fk_to_passenger_Aadhar_card_number`) REFERENCES `Passenger` (`Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`fk_to_route_Route ID`) REFERENCES `Route` (`Route ID`) ON DELETE CASCADE ON UPDATE CASCADE,
);
----------------------------------------------------------


DROP TABLE IF EXISTS 'Passenger';

CREATE TABLE `Passenger` (
  `Aadhar_card_number` int(12) PRIMARY KEY,
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
  `Nationality` varchar(255),
);
----------------------------------------------------------

DROP TABLE IF EXISTS 'emer_contact';

CREATE TABLE `emer_contact` (
  `Name` varchar(255),
  `Phone No` int(10) UNIQUE NOT NULL,
  `fk_to_passenger_Aadhar_card_number` int(12),
  PRIMARY KEY (`Name`, `fk_to_Aadhar_card_number`),

  FOREIGN KEY (`fk_to_passenger_Aadhar_card_number`) REFERENCES `Passenger` (`Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE,
);
----------------------------------------------------------



DROP TABLE IF EXISTS 'luggage';

CREATE TABLE `luggage` (
  `Baggage ID` int PRIMARY KEY,
  `fk_to_Barcode number` char(12),

  FOREIGN KEY (`fk_to_Barcode_number`) REFERENCES `boarding_pass` (`Barcode number`) ON DELETE CASCADE ON UPDATE CASCADE,
);
----------------------------------------------------------

DROP TABLE IF EXISTS 'Aircraft';

CREATE TABLE `Aircraft` (
  `registration_num` int PRIMARY KEY,
  `fk_to_capacity_Manufacturer` varchar(255) NOT NULL,
  `fk_to_capacity_Model` varchar(255) NOT NULL,
  `Distance Travelled` int DEFAULT 0,
  `Flight ID` varchar(10),
  `Maintanence check date` date,
  `fk_to_airline_owner_airline_IATA_code` char(2),
  KEY (`Manufacturer`, `Model`),

  FOREIGN KEY (`fk_to_airline_owner_airline_IATA_code`) REFERENCES `Airline` (`IATA airline designators`) ON DELETE SET NULL ON UPDATE CASCADE,
  FOREIGN KEY (`fk_to_capacity_Model`) REFERENCES `capacity_of_aircraft` (`Model`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`fk_to_capacity_Manufacturer`) REFERENCES `capacity_of_aircraft` (`Manufacturer`) ON DELETE CASCADE ON UPDATE CASCADE,

);

----------------------------------------------------------

DROP TABLE IF EXISTS 'capacity_of_aircraft';

CREATE TABLE `capacity_of_aircraft` (
  `Manufacturer` varchar(255) NOT NULL,
  `Capacity` int NOT NULL,
  `Model` varchar(255) NOT NULL,
  PRIMARY KEY (`Manufacturer`, `Model`),

);
----------------------------------------------------------

DROP TABLE IF EXISTS 'Airline';

CREATE TABLE `Airline` (
  `IATA airline designators` char(2) PRIMARY KEY,
  `Company Name` varchar(50) NOT NULL,
  `num_aircrafts_owned` int DEFAULT 0,
  `is_active` Boolean DEFAULT TRUE,
  `country_of_ownership` varchar(255)
);

----------------------------------------------------------

DROP TABLE IF EXISTS 'airline_crew';

CREATE TABLE `airline_crew` (
  `Aadhar_card_number` int(12) PRIMARY KEY,
  `First Name` varchar(255) NOT NULL,
  `Middle Name` varchar(255),
  `Last Name` varchar(255),
  `Number of years of Experience` int DEFAULT 0,
  `Salary` int,
  `Nationality` varchar(255),
  `DOB` date,
  `Gender` enum('Male', 'Female', 'Others'),
  `fk_to_airline_employer_IATA_code` char(2)

  FOREIGN KEY (`fk_to_airline_employer_IATA_code`) REFERENCES `Airline` (`IATA airline designators`) ON DELETE SET NULL ON UPDATE CASCADE,
);

----------------------------------------------------------

DROP TABLE IF EXISTS 'flight_crew';

CREATE TABLE `flight_crew` (
  `fk_to_airline_crew_Aadhar_card_number` int(12) PRIMARY KEY,
  FOREIGN KEY (`fk_to_airline_crew_Aadhar_card_number`) REFERENCES `airline_crew` (`Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE,

);

----------------------------------------------------------

DROP TABLE IF EXISTS 'Pilot';

CREATE TABLE `Pilot` (
  `fk_to_flight_crew_Aadhar_card_number` int(12) PRIMARY KEY NOT NULL,
  `Pilot license number` int(12) UNIQUE NOT NULL,
  `Number of flying hours` int,

  FOREIGN KEY (`fk_to_flight_crew_Aadhar_card_number`) REFERENCES `filght_crew` (`fk_to_airline_crew_Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE,
);

----------------------------------------------------------

DROP TABLE IF EXISTS 'flight_attendant';

CREATE TABLE `flight_attendant` (
  `fk_to_flight_crew_Aadhar_card_number` int(12) PRIMARY KEY,
  `Training/Education` varchar(255),

  FOREIGN KEY (`fk_to_flight_crew_Aadhar_card_number`) REFERENCES `filght_crew` (`fk_to_airline_crew_Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE,

);

----------------------------------------------------------

DROP TABLE IF EXISTS 'flight_engineer';

CREATE TABLE `flight_engineer` (
  `fk_to_flight_crew_Aadhar_card_number` int(12) PRIMARY KEY,
  `Education` varchar(255),
  `Manufacturer` varchar(255),
  `Model` varchar(255),

  FOREIGN KEY (`fk_to_flight_crew_Aadhar_card_number`) REFERENCES `filght_crew` (`fk_to_airline_crew_Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE,
);


----------------------------------------------------------

DROP TABLE IF EXISTS 'flight_crew_serves_on_route';

CREATE TABLE `flight_crew_serves_on_route` (
  `fk_to_flight_crew_Aadhar_card_number` int(12),
  `fk_to_route_Route ID` int,
  PRIMARY KEY (`Aadhar_card_number`, `Route ID`)

  FOREIGN KEY (`fk_to_flight_crew_Aadhar_card_number`) REFERENCES `filght_crew` (`fk_to_airline_crew_Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`fk_to_route_Route ID`) REFERENCES `Route` (`Route ID`) ON DELETE CASCADE ON UPDATE CASCADE,
);

----------------------------------------------------------

DROP TABLE IF EXISTS 'On-ground';

CREATE TABLE `On-ground` (
  `fk_to_airline_crew_Aadhar_card_number` int(12) PRIMARY KEY,
  `Job title` varchar(255),
  FOREIGN KEY (`fk_to_airline_crew_Aadhar_card_number`) REFERENCES `airline_crew` (`Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE,

);

----------------------------------------------------------

DROP TABLE IF EXISTS 'Airport';

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

----------------------------------------------------------

DROP TABLE IF EXISTS 'Runway';

CREATE TABLE `Runway` (
  `fk_to_airport_IATA_airport_codes` char(3),
  `Runway ID` int,
  `length_ft` float,
  `width_ft` float,
  `Status` enum('Assigned', 'Available', 'Disfunctional') DEFAULT 'Available',
  PRIMARY KEY (`fk_to_airport_IATA_airport_codes`, `Runway ID`),

  FOREIGN KEY (`fk_to_airport_IATA_airport_codes`) REFERENCES `Airport` (`IATA airport codes`) ON DELETE CASCADE ON UPDATE CASCADE,
);

----------------------------------------------------------

DROP TABLE IF EXISTS 'Terminal';

CREATE TABLE `Terminal` (
  `fk_to_airport_IATA_airport_codes` char(3),
  `Terminal ID` int,
  `Airplane Handling capacity` int,
  `Floor Area` float,
  PRIMARY KEY (`fk_to_airport_IATA_airport_codes`, `Terminal ID`),

  FOREIGN KEY (`fk_to_airport_IATA_airport_codes`) REFERENCES `Airport` (`IATA airport codes`) ON DELETE CASCADE ON UPDATE CASCADE,

);


----------------------------------------------------------

DROP TABLE IF EXISTS 'Airport Employees/CREWS';

CREATE TABLE `Airport Employees/CREWS` (
  `Aadhar_card_number` int(12) PRIMARY KEY,
  `fk_to_airport_IATA_code_of_employing_airport` char(3),
  `First Name` varchar(255) NOT NULL,
  `Middle Name` varchar(255),
  `Last Name` varchar(255),
  `Experience` int DEFAULT 0,
  `Salary` int,
  `Nationality` varchar(255),
  `DOB` date,
  `Gender` enum('Male', 'Female', 'Others'),
  `sup_Aadhar_card_number` int(12),


FOREIGN KEY (`fk_to_airport_IATA_code_of_employing_airport`) REFERENCES `Airport` (`IATA airport codes`) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (`sup_Aadhar_card_number`) REFERENCES `Airport Employees/CREWS` (`Aadhar_card_number`) ON DELETE SET NULL ON UPDATE CASCADE,

);


----------------------------------------------------------

DROP TABLE IF EXISTS 'mo_executives';

CREATE TABLE `mo_executives` (
  `fk_to_airport_crew_aadhar_card_number` int(12) PRIMARY KEY,
  `Job title` varchar(255),

  FOREIGN KEY (`fk_to_airport_crew_aadhar_card_number`) REFERENCES `Airport Employees/CREWS` (`Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE,

);


----------------------------------------------------------

DROP TABLE IF EXISTS 'Security';

CREATE TABLE `Security` (
  `fk_to_airport_crew_aadhar_card_number` int(12) PRIMARY KEY,
  `Designation` varchar(255),
  `Security ID number` int UNIQUE,

  FOREIGN KEY (`fk_to_airport_crew_aadhar_card_number`) REFERENCES `Airport Employees/CREWS` (`Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE,

);


----------------------------------------------------------

DROP TABLE IF EXISTS 'air_traffic_controller';

CREATE TABLE `air_traffic_controller` (
  `fk_to_airport_crew_aadhar_card_number` int(12) PRIMARY KEY,
  `Current communication Frequency` float,
  `Training/Education` varchar(255),

  FOREIGN KEY (`fk_to_airport_crew_aadhar_card_number`) REFERENCES `Airport Employees/CREWS` (`Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE,

);


----------------------------------------------------------

DROP TABLE IF EXISTS 'crew_has_worked_together';

CREATE TABLE `crew_has_worked_together` (
  `Pilot captain Aadhar_card_number` int(12),
  `Pilot first officer Aadhar_card_number` int(12),
  `flight_attendant Aadhar_card_number` int(12),
  `flight_engineer Aadhar_card_number` int(12),
  `Avg_competence_rating` float,
  CHECK (`Avg_competence_rating` >= 0 AND `Avg_competence_rating` <=10),
  `Number of Languages spoken overall` int,
  PRIMARY KEY (`Pilot captain Aadhar_card_number`, `Pilot first officer Aadhar_card_number`, `flight_attendant Aadhar_card_number`, `flight_engineer Aadhar_card_number`)

  FOREIGN KEY(`Pilot captain Aadhar_card_number`) REFERENCES `Pilot` (`fk_to_flight_crew_Aadhar_card_number`)  ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY(`Pilot first officer Aadhar_card_number`) REFERENCES `Pilot` (`fk_to_flight_crew_Aadhar_card_number`)  ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY(`flight_attendant Aadhar_card_number`) REFERENCES `flight_attendant` (`fk_to_flight_crew_Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY(`flight_engineer Aadhar_card_number`) REFERENCES `flight_engineer` (`fk_to_flight_crew_Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE,

);


----------------------------------------------------------

DROP TABLE IF EXISTS 'filght_crew_feedback';

CREATE TABLE `flight_crew_feedback` (
  `Pilot captain Aadhar_card_number` int(12),
  `Pilot first officer Aadhar_card_number` int(12),
  `flight_attendant Aadhar_card_number` int(12),
  `flight_engineer Aadhar_card_number` int(12),
  `Feedback given by the passengers for the crew` varchar(255),
  PRIMARY KEY (`Pilot captain Aadhar_card_number`, `Pilot first officer Aadhar_card_number`, `flight_attendant Aadhar_card_number`, `flight_engineer Aadhar_card_number`, `Feedback given by the passengers for the crew`)

  FOREIGN KEY(`Pilot captain Aadhar_card_number`) REFERENCES `Pilot` (`fk_to_flight_crew_Aadhar_card_number`)  ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY(`Pilot first officer Aadhar_card_number`) REFERENCES `Pilot` (`fk_to_flight_crew_Aadhar_card_number`)  ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY(`flight_attendant Aadhar_card_number`) REFERENCES `flight_attendant` (`fk_to_flight_crew_Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY(`flight_engineer Aadhar_card_number`) REFERENCES `flight_engineer` (`fk_to_flight_crew_Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE,

);

----------------------------------------------------------

DROP TABLE IF EXISTS 'boarding_pass special services';

CREATE TABLE `boarding_pass special services` (
  `fk_Barcode number` varchar(12),
  `Special services` enum('Wheelchair', 'Disability Assistance', 'XL seats', 'Priority Boarding'),
  PRIMARY KEY (`Barcode number`, `Special services`),
  FOREIGN KEY (`fk_Barcode number`) REFERENCES `boarding_pass` (`Barcode number`) ON DELETE CASCADE ON UPDATE CASCADE,

);

----------------------------------------------------------

DROP TABLE IF EXISTS 'Languages spoken by airline employee';

CREATE TABLE `Languages spoken by airline employee` (
  `fk_Aadhar_card_number` int(12),
  `Language_name` varchar(255),
  PRIMARY KEY (`fk_Aadhar_card_number`, `Language_name`),
  FOREIGN KEY (`fk_Aadhar_card_number`) REFERENCES `airline_crew` (`Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE,

);

----------------------------------------------------------

DROP TABLE IF EXISTS 'stopover_airports_on_route';

CREATE TABLE `stopover_airports_on_route` (
  `fk_route_id` int,
  `fk_iata_stopover_airport` varchar(3),
  PRIMARY KEY (`Route ID`, `IATA code of stopover airport`),

  FOREIGN KEY (`fk_route_id`) REFERENCES `Route` (`Route ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`fk_iata_stopover_airport`) REFERENCES `Airport` (`IATA airport codes`) ON DELETE CASCADE ON UPDATE CASCADE,

);

----------------------------------------------------------

DROP TABLE IF EXISTS 'PNR info deduction';

CREATE TABLE `PNR info deduction` (
  `fk_PNR_number` char(6) PRIMARY KEY,
  `Scheduled Boarding Time` time,
  `fk_terminal_num` int,
  `class_of_travel` enum('Economy', 'Business'),

  FOREIGN KEY (`fk_PNR_number`) REFERENCES `boarding_pass` (`PNR number`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`fk_terminal_num`) REFERENCES `Terminal` (`Terminal ID`)  ON DELETE SET NULL ON UPDATE CASCADE,

);

----------------------------------------------------------
----------------------------------------------------------
----------------------------------------------------------
----------------------------------------------------------
----------------------------------------------------------

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
INSERT INTO `airport_management_system`.`languages spoken by airline employee` (`Aadhar_card_number`, `Language_name`) VALUES ('9.84117E+11', 'English'); DEFAULT 'NA' NOT NULL NOT NULL  


