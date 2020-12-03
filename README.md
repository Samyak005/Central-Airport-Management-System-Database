# Airport Management System 


The database is a **CENTRAL AIRPORTS MANAGEMENT DATABASE** and its users are the personnel at the airport, the air travellers and their relatives. This database is well-connected to the rest of the airport modules: airline databases, revenue management, and air traffic management. 

This database has or can be extended to have a lot of functionality like:

* Keeping track of flight status and schedules for the travellers to know about flight cancellation, flight delays
* Supervision of aircraft landing and take off, airport traffic management, runway status management
* Retrieval of information regarding airport finances: staff payrolls, etc
* Baggage tagging from the  time the baggage is loaded and its tracking until the destination is reached and the bag is returned to the owners.
* Keeping a record of a passenger’s journey from passenger processing (check-in, boarding) and baggage handling (dropping and handling) to the moment he boards the aircraft
* Retrieving information for different segments of users: passengers, airport staff, crew, or members of specific departments, authorities, business partners, or police.

File structure : 
* `extra.py` -> contains the non-CRUD functional operations to be performed on the database
* `read.py` -> prints the tables in a tabulated manner
* `update.py` -> performs update operations on the database
* `miniworld.py` -> contains main loop and connections to pymysql. Also contains function headers
* `add.py` -> adds tuples in various tables
* `delete.py` -> deletes tuples in various tables

# Extra details
* According to `sequence.txt` sql queries were divided into 5 phases which have been written in corresponding sql files
* Proper colour coding was done for easy debugging of CLI
* In `miniworld.py`, dictionary or a map was maintained for implementing functions related to addition, deletion, updation (Do check this nice implementation)

## We have broken the .SQL file which was supposed to create the database and populate it into 6 subfiles.
### Instructions to create the database and to populate it with sample data
```
$ mysql -h 127.0.0.1 -u root --port=5005 -p < phase0.sql
$ mysql -h 127.0.0.1 -u root --port=5005 -p < phase1.sql
$ mysql -h 127.0.0.1 -u root --port=5005 -p < phase2.sql
$ mysql -h 127.0.0.1 -u root --port=5005 -p < phase3.sql
$ mysql -h 127.0.0.1 -u root --port=5005 -p < phase4.sql
$ mysql -h 127.0.0.1 -u root --port=5005 -p < phase5.sql

```

### Install pymySql
```
$ python3 -m pip install PyMySQL
```

# Instructions to run
```
$ python3 miniworld.py
```

# User-menu
We have divided the prospective users into three categories and have exposed parts of the database depending on the category of the user. Eg-> A passenger does not have permissions to change the scheduled departure time of a particular flight.

* Airport employees/Employees of The Airports Authority of India or AAI
* Airline employees
* Passengers

# NOTE
Whenever you change the status of a ROUTE as `Flight Arrived`, then automatically the ROUTE hrs are added to `number of flying hrs` of the pilot who piloted the flight. The distance covered in the journey also gets added to the `aircraft's total distance covered`.


## OPERATIONS ON DATABASE
# Retrieval Operations

## SELECTION
* Retrieve complete data tuples of PILOTS who work for a particular AIRLINE.
* Retrieve complete data tuples of PASSENGERS who were travelling on a particular crashed flight
* Display all flights between two airports on a given date

## Projection Query
* Names of all passengers who have WHEELCHAIR ASSISTANCE as a special service in their BOARDING PASS
* NAMES OF ALL AIRLINES whose flight crew is >=x where `x` is inputted by user

## AGGREGATE :
* Find the PILOT who has the maximum number of FLYING HOURS on record.
* Find most used aircraft across all airlines

## SEARCH
* Search for all PASSENGERS whose name contains `user inputted substring`

## ANALYSIS : 
* RANK BUSIEST AIRPORTS by number of scheduled flight departures on a particular day
* RANK most used airline by sorting as per the number of boarding passes issued for that airline since data collection began
* Feedback of flight crew

# Modification Operations

## Insertion Operations(also checking integrity constraint)

* Addition of a new employee [check SSN format]
* Addition of a newly constructed runway [check between 0 and 36]
* Addition of baggage to a particular boarding pass
* Addition of a new aircraft

## Update Operations
* Update flight status information based on time delay
* Update statistics regarding total number of kms travelled by airplane, total number of flying hours of a pilot
* Update status of runway

## Delete Operations
* Deletion of a plane which is no longer active
* Deletion of an inactive/fired employee


### Documentation related to phases 1, 2 and 3 can be found in the adjoining folders.

## Project by `TEAM SEQUEL EXTRACT`
- Anmol Agarwal
- Pratyush Priyadarshi
- Samyak Jain