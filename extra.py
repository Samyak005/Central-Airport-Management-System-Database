import datetime
import subprocess as sp
import pymysql
import pymysql.cursors

def prRed(skk): print("\033[91m {}\033[00m" .format(skk)) 
def prGreen(skk): print("\033[92m {}\033[00m" .format(skk)) 
def prYellow(skk): print("\033[93m {}\033[00m" .format(skk)) 
def prLightPurple(skk): print("\033[94m {}\033[00m" .format(skk)) 
def prPurple(skk): print("\033[95m {}\033[00m" .format(skk)) 
def prCyan(skk): print("\033[96m {}\033[00m" .format(skk)) 
def prLightGray(skk): print("\033[97m {}\033[00m" .format(skk)) 
def prBlack(skk): print("\033[98m {}\033[00m" .format(skk)) 


# analysis_funcs_dict = {
#         "1":analysis_passenger_special_services,#
#         "2":analysis_big_airlines,#
#         "3":analysis_experienced_pilot,#
#         "4":analysis_search_name,#
#         "5":analysis_busiest_airports,#
#         "6":analysis_loved_airlines,#
#         "7":analysis_feedback_patterns,
#         "8":analysis_find_tickets,#
#         "9":analysis_crashed_survivors,
#         "10":analysis_airline_pilots,
#         "11":analysis_favoured_aircrafts
# }

# analysis_funcs_msg = {
#         "1":"Names of all passengers who have WHEELCHAIR ASSISTANCE/Disability assisstance as a special service in their BOARDING PASS",#
#         "2":"NAMES OF ALL AIRLINES whose flight crew is >=x where 'x' is to be inputted from user",#
#         "3":"find the pilot with maximum number of flying hrs",#
#         "4":"Search for all PASSENGERS whose name contains a given substring",#
#         "5":"RANK BUSIEST AIRPORTS by number of scheduled flight departures on a particular day",#
#         "6":"RANK most used airline by sorting as per the number of boarding passes issued for that airline since data collection began",
#         "7":"Feedback of flight crew patterns",#
#         "8":"display all flights between two airports on a given date or on any date",
#         "9":"names of all passengers who were travelling on a particular route/Crashed flight/Flight with a COVID infected patient",
#         "10":"Names of all pilots who work for a given airline",
#         "11":"Find most used aircraft across all airlines"
# }

def display_query_result(query):
    try:
        cur.execute(query)
        con.commit()
        result = cur.fetchall()
        
        if len(result) != 0:
            header = result[0].keys()
            rows =  [x.values() for x in result]
            print(tabulate(rows, header, tablefmt = 'grid'))
        
        else:
            prRed("No rows found!") #length of result is 0

    except Exception as e:
        prRed("Error!")
        con.rollback()
        input("Press any key to continue")

def add_feedback(cur, con):
    print("In Progress\n")

def analysis_passenger_special_services(cur,con):
    print("Inside update_passenger func")

    iata_airport_code=input("Enter iata code of airport ")

    query_str='''SELECT `First Name`,`Middle Name`,`Last Name`,`Aadhar_card_number` 
                FROM `boarding_pass special services`,`Passenger`,`boarding_pass` 
                WHERE (`Special services`='Wheelchair' OR  `Special services`='Disability Assistance')
                AND (`Barcode number`=`fk_Barcode number`)
                AND (`fk_to_passenger_Aadhar_card_number`=`Aadhar_card_number`);
                        '''
    display_query_result(query_str)


def analysis_big_airlines(cur,con):
    print("Inside analysis_big_airlines")

    
    limit_var=int(input("Enter 'x' in order to display airlines having a total number of employees greater than 'x'"))

    # select town, count(town) 
    # from user
    # group by town

    # https://www.w3resource.com/sql/aggregate-functions/count-with-group-by.php

    # SELECT working_area, COUNT(*) 
    # FROM agents 
    # GROUP BY working_area 
    # ORDER BY 2 ;

    sub1='''SELECT `IATA airline designators`, `Company Name` ,COUNT(*)
                FROM `Airline`, `airline_crew`
                GROUP BY `fk_to_airline_employer_IATA_code`  
                WHERE (`fk_to_airline_employer_IATA_code`=`IATA airline designators`)
                 AND (COUNT(*) >= '''
    sub2=str(limit_var)
    sub3=''')ORDER BY COUNT(*)
                        '''
    query_str=sub1+sub2+sub3

    # https://www.eversql.com/

    query_str2 = '''SELECT `IATA airline designators`, `Company Name`
                FROM `Airline`
                WHERE `IATA airline designators` IN (SELECT `fk_to_airline_employer_IATA_code`
                            FROM `airline_crew`
                            GROUP BY `fk_to_airline_employer_IATA_code`
                            HAVING COUNT(*)>=10);'''
    
    query_str3='''SELECT `IATA airline designators`, `Company Name`
                FROM `Airline`
                WHERE  EXISTS (SELECT `fk_to_airline_employer_IATA_code`
                            FROM `airline_crew`
                            WHERE `IATA airline designators`=`fk_to_airline_employer_IATA_code`
                            GROUP BY `fk_to_airline_employer_IATA_code`
                            HAVING COUNT(*)>=10);'''


def analysis_experienced_pilot(cur,con):
    print("Inside analysis_experienced_pilot func")

    # SELECT Lname, Fname
    # FROM EMPLOYEE
    # WHERE Salary > ALL ( SELECT Salary
    # FROM EMPLOYEE
    # WHERE Dno = 5 );
    query_str='''SELECT `Pilot license number`,`First Name`,`Last Name`,`Number of flying hours`,`fk_to_airline_employer_IATA_code` AS `EMPLOYER AIRLINE`
                  FROM   `Pilot`,   ``airline_crew``  
                  WHERE (`Aadhar_card_number`=`fk_to_flight_crew_Aadhar_card_number`) 
                  AND  `Number of flying hours` >= ( SELECT MAX(`Number of flying hours`)
                                                    FROM  `Pilot`);
                      '''

def analysis_search_name(cur,con):
    print("Inside update_passenger func")

        # % replaces an arbitrary number of zero or more characters, and the underscure (_) replaces a single character. 

    sought_name=input("Enter substring which needs to be found in names of the passengers")

    query_str='''SELECT `Aadhar_card_number` ,`First Name`,`Middle Name`,`Last Name`
                FROM PASSENGER
                WHERE (`First Name` LIKE '%{0}%') OR (`Middle Name` LIKE '%{0}%') OR (`Last Name` LIKE '%{0}%');
                        '''.format(sought_name)


def analysis_busiest_airports(cur,con):
    print("Inside busiest_airports func")

    ### SHOULD WE TAKE DATE AS INPUT
    query_str='''SELECT `IATA airport codes`,`Airport Name`,`City`,COUNT(*) AS `Number of Scheduled Departures`
                FROM `Route`, `Airport`
                GROUP BY `fk_to_airline_employer_IATA_code`  
                WHERE (`IATA airport codes`=`fk_to_airport_IATA_airport_codes`)
                ORDER BY `Number of Scheduled Departures` DESC;
                '''


def analysis_loved_airlines(cur,con):
    print("Inside update_passenger func")


    query_str='''
                        '''

# def analysis_feedback_patterns(cur,con):
#     print("Inside feedback_passengers")

#     query_str='''
#                         '''

def analysis_find_tickets(cur,con):
    print("Inside update_passenger func")


    src_iata=input("Enter iata code of src airport")
    dest_iata=input("Enter iata code of dest airport")

    date_sought=input("Enter date when the journey needs to be made")

    query_str='''SELECT `fk_to_airport_src_iata_code` AS 'Source airport' ,
                        `fk_to_airport_dest_iata_code` AS 'Destination Airport',
                        `Date`,
                        `fk_to_airline_owner_airline_IATA_code` AS 'Airline',
                        `Flight ID`,
                        `Scheduled arrival` 
                FROM `Route`,`Aircraft`
                WHERE (`fk_to_airport_src_iata_code`={0})
                AND   (`fk_to_airport_dest_iata_code`={1})
                AND   (`Date`={2})
                AND   (`fk_to_aircraft_registration_num`=registration_num) 
                                    ;
                        '''.format(src_iata,dest_iata,date_sought)


def analysis_crashed_survivors(cur,con):
    print("Inside update_passenger func")

    crashed_route_id=input("Enter route id of the flight whose passengers need to be displayed")
    query_str='''SELECT `First Name`,`Last Name`, `Aadhar_card_number`,`Barcode number`,`Seat`
                FROM `boarding_pass`,`Passenger`
                WHERE (`fk_to_passenger_Aadhar_card_number`=`Aadhar_card_number`)
                AND(`fk_to_route_Route ID`={0})
                        '''.format(crashed_route_id)


def analysis_airline_pilots(cur,con):

    iata_airline=input("Enter iata code of airline whose pilots are to be listed")
    query_str='''SELECT `Pilot license number`,`First Name`,`Last Name`,`Number of years of Experience`,`Number of flying hours`
                FROM `Pilot`,`airline_crew`
                WHERE (`Aadhar_card_number`= `fk_to_flight_crew_Aadhar_card_number`)
                AND (`fk_to_airline_employer_IATA_code`={0} )    

                        '''.format(iata_airline)


def analysis_favoured_aircrafts(cur,con):
    print("Inside update_passenger func")
    #https://stackoverflow.com/a/2421441
    query_str='''SELECT `fk_to_capacity_Manufacturer` AS `Manufacturer`,
                        `fk_to_capacity_Model` AS `Model`,
                        COUNT(*) AS `Total occurrences`
                FROM `Aircraft`
                WHERE `fk_to_airline_owner_airline_IATA_code`  IS NOT NULL
                GROUP BY `fk_to_capacity_Manufacturer`,`fk_to_capacity_Model`
                ORDER BY `Total occurrences` DESC;
                        '''
    
    

    