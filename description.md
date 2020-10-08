# Airport Management System
The database is a CENTRAL AIRPORTS MANAGEMENT DATABASE and its users are the personnel at the airport, the air travellers and their relatives. This database is well-connected to the rest of the airport modules: airline databases, revenue management, and air traffic management. 


### Instructions to create the database and to populate it with sample data
```
$ mysql -h 127.0.0.1 -u root --port=5005 -p < phase0.sql
$ mysql -h 127.0.0.1 -u root --port=5005 -p < phase1.sql
$ mysql -h 127.0.0.1 -u root --port=5005 -p < phase2.sql
$ mysql -h 127.0.0.1 -u root --port=5005 -p < phase3.sql
$ mysql -h 127.0.0.1 -u root --port=5005 -p < phase4.sql
$ mysql -h 127.0.0.1 -u root --port=5005 -p < phase5.sql

```
### Instructions to run
```
$ python3 miniworld.py
```

# User-menu
We have divided the prospective users into three categories and have exposed parts of the database depending on the category of the user. Eg-> A pssenger does not have permissions to change the scheduled departure time of a particular flight.
* Airport employees/Employees of The Airports Authority of India or AAI
* Airline employees
* Passengers

## OPERATIONS ON DATABASE
# Retrieval Operations

## SELECTION
* Retrieve complete data tuples of PILOTS who work for a particular AIRLINE.
* Retrieve complete data tuples of PASSENGERS who were travelling on a particular crashed flight

## Projection Query
* Names of all passengers who have WHEELCHAIR ASSISTANCE as a special service in their BOARDING PASS
* NAMES OF ALL AIRLINES whose flight crew is >=50

## AGGREGATE :
* Find the PILOT who has the maximum number of FLYING HOURS on record.

## SEARCH
* Search for all PASSENGERS whose name contains “Kumar”

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

