## to install pymysql

python3 -m pip install PyMySQL

SQL vs mySQL

MySQL (/ˌmaɪˌɛsˌkjuːˈɛl/ "My S-Q-L")[5] is an open-source relational database management system (RDBMS).[5][6]

Connecting to a MySQL server requires a username and password. You may also need to specify the name of the host on which the server is running.

The arguments to mysql include -h localhost to connect to the MySQL server running on the local host, -u root to connect as the MySQL root user, and -p to tell mysql to prompt for a password:

mysql -h 127.0.0.1 -u root --port=5005 -p 
mysql -h 127.0.0.1 -u root --port=5005 -p < samyak.sql

# show tables;

https://dba.stackexchange.com/a/42541

# 1.6. Executing SQL Statements Read from a File or Program


***fetchone()*** retrieves a single item, when you know the result set contains a single row. 
***fetchall()*** retrieves all the items, when you know the result set contains a limited number of rows that can fit comfortably into memory. 
***fetchmany()*** is the general-purpose method when you cannot predict the size of the result set: you keep calling it and looping through the returned items, until there are no more results to process


# iterating over the result of a query
https://stackoverflow.com/questions/28530508/select-query-in-pymysql


#
https://stackoverflow.com/questions/39163776/how-to-get-rows-affected-in-a-update-statement-by-pymsql

# Using tabulate
```
python3 -m pip install tabulate
```

# Viewing all tables in database
select table_name from information_schema.tables where table_schema = 'airport_db';

Select AVG(Aadhar_card_number) from Passenger where Gender='Male';
SELECT fk_to_capacity_Manufacturer,COUNT(*) from Aircraft Group By fk_to_capacity_Manufacturer;
SELECT fk_to_capacity_Model,COUNT(*) from Aircraft Group By fk_to_capacity_Model;
SELECT fk_to_capacity_Model,COUNT(*) from Aircraft Group By fk_to_capacity_Model ORDER BY COUNT(*);

SELECT fk_to_capacity_Model,COUNT( fk_to_airline_owner_airline_IATA_code) from Aircraft Group By fk_to_capacity_Model ORDER BY COUNT(*);
SELECT fk_to_capacity_Model,COUNT(DISTINCT fk_to_airline_owner_airline_IATA_code) from Aircraft Group By fk_to_capacity_Model ORDER BY COUNT(*);

Select * FROM Aircraft ORDER BY `Flight ID` desc;

UPDATE Route ,Runway SET Runway.`Status`="Assigned" WHERE `Runway ID`=`fk_to_runway_Take off runway id`
        AND `Route ID`=6
        AND `fk_to_airport_src_iata_code`=`fk_to_airport_IATA_airport_codes`;

SELECT fk_to_airline_employer_IATA_code,COUNT(*) FROM airline_crew GROUP BY fk_to_airline_employer_IATA_code;


SELECT `IATA airline designators`,`Company Name`,COUNT(*) as    `love_quotient`
FROM `Airline`,`Aircraft`,`boarding_pass`,`Route`
WHERE (`IATA airline designators`=`fk_to_airline_owner_airline_IATA_code`) AND (`registration_num`=`fk_to_aircraft_registration_num`)
AND(`fk_to_route_Route ID`=`Route ID`)
GROUP BY `IATA airline designators`
ORDER BY COUNT(*) DESC;

SELECT `fk_to_airport_src_iata_code` AS 'Source airport' ,
                        `fk_to_airport_dest_iata_code` AS 'Destination Airport',
                        `Date`,
                        `fk_to_airline_owner_airline_IATA_code` AS 'Airline',
                        `Flight ID`,
                        `Scheduled arrival` 
                FROM `Route`,`Aircraft`
                WHERE (`fk_to_airport_src_iata_code`="DEL")
                AND   (`fk_to_airport_dest_iata_code`="MUM")
                AND   (`fk_to_aircraft_registration_num`=registration_num) 
                                    ;

# checking simultaneous updation
Update Route SET Status='Delayed' WHERE `Route ID`=1;
Update Runway SET Status='Assigned' WHERE `Runway ID`=0 AND `fk_to_airport_IATA_airport_codes`=BLR ;
Update Runway SET Status='Assigned' WHERE `Runway ID`=0 AND `fk_to_airport_IATA_airport_codes`=DEL ;


SELECT * FROM Route WHERE `Route ID`=1;
SELECT * FROM Aircraft WHERE `registration_num`=345;
SELECT * FROM Pilot WHERE  `fk_to_flight_crew_Aadhar_card_number`=427691459617;
SELECT * FROM Runway WHERE `Runway ID`=0;

##### Captain -> 139446154652 
##### Attendant->341648440548
##### Pilot  -> 271274517218,723531887630
##### Engineer-> 186480088941
##### Another flight attendant ->996366605513
##### air_reg=124

##### Route-26
SELECT * FROM Route where `Route ID`=26;
SELECT * FROM `flight_crew_serves_on_route` WHERE `fk_to_route_Route ID`=26;
SELECT * FROM stopover_airports_on_route;
