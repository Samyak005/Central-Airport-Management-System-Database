import datetime
import subprocess as sp
import pymysql
import pymysql.cursors
from tabulate import tabulate # pip install tabulate



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

def display_query_result(cur,con,query):
    try:
        cur.execute(query)
        con.commit()
        result = cur.fetchall()
        
        if len(result) != 0:
            header = result[0].keys()
            rows =  [x.values() for x in result]
            print(tabulate(rows, header, tablefmt = 'psql'))
        
        else:
            print("Alas! -> No rows found!") #length of result is 0

    except Exception as e:
        print(e)
        con.rollback()
        input("Press any key to continue")

def add_feedback(cur, con):
    print("In Progress\n")

# Done
def analysis_passenger_special_services(cur,con):
    print("Inside update_passenger func")

    # iata_airport_code=input("Enter iata code of airport ")

    query_str='''SELECT `First Name`,`Middle Name`,`Last Name`,`Aadhar_card_number` 
                FROM `boarding_pass special services`,`Passenger`,`boarding_pass` 
                WHERE (`Special services`='Wheelchair' OR  `Special services`='Disability Assistance')
                AND (`Barcode number`=`fk_Barcode number`)
                AND (`fk_to_passenger_Aadhar_card_number`=`Aadhar_card_number`);
                        '''
    display_query_result(cur, con, query_str)

# CHECKED
def analysis_big_airlines(cur,con):
    #print("Inside analysis_big_airlines")

    
    limit_var=int(input("Enter 'x' in order to display airlines having a total number of employees greater than 'x': "))

    query_str = '''SELECT `IATA airline designators`, `Company Name`
                FROM `Airline`
                WHERE `IATA airline designators` IN (SELECT `fk_to_airline_employer_IATA_code`
                            FROM `airline_crew`
                            GROUP BY `fk_to_airline_employer_IATA_code`
                            HAVING COUNT(*)>={0});'''.format(str(limit_var))
    
    display_query_result(cur,con,query_str)

# CHECKED
def analysis_experienced_pilot(cur,con):
    print("Inside analysis_experienced_pilot func")

    # SELECT Lname, Fname
    # FROM EMPLOYEE
    # WHERE Salary > ALL ( SELECT Salary
    # FROM EMPLOYEE
    # WHERE Dno = 5 );
    query_str='''SELECT `Pilot license number`,`First Name`,`Last Name`,`Number of flying hours`,`fk_to_airline_employer_IATA_code`
                    AS `Employer Airline`
                    FROM   `Pilot`,   `airline_crew`  
                    WHERE (`Aadhar_card_number`=`fk_to_flight_crew_Aadhar_card_number`) 
                    AND  `Number of flying hours` >= ( SELECT MAX(`Number of flying hours`)
                                                    FROM  `Pilot`);'''

    display_query_result(cur, con, query_str)

#done
def analysis_search_name(cur,con):
    #print("Inside update_passenger func")

        # % replaces an arbitrary number of zero or more characters, and the underscure (_) replaces a single character. 

    sought_name=input("Enter substring which needs to be found in names of the passengers: ")

    query_str='''SELECT `Aadhar_card_number` ,`First Name`,`Middle Name`,`Last Name`
                FROM Passenger
                WHERE (`First Name` LIKE '%{0}%') OR (`Middle Name` LIKE '%{0}%') OR (`Last Name` LIKE '%{0}%');
                        '''.format(sought_name)
    display_query_result(cur, con, query_str)

#done
def analysis_busiest_airports(cur,con):
    print("Inside busiest_airports func")

    ### SHOULD WE TAKE DATE AS INPUT
    query_str='''SELECT `IATA airport codes`,`Airport Name`,`City`,COUNT(*) AS `Number of Scheduled Departures`
                FROM `Route`, `Airport`
                WHERE (`IATA airport codes`=`fk_to_airport_src_iata_code`)
                GROUP BY `fk_to_airport_src_iata_code`  
                ORDER BY COUNT(*)  DESC;
                '''
    display_query_result(cur, con, query_str)

#done
def analysis_loved_airlines(cur,con):
    print("Inside update_passenger func")


    query_str='''SELECT `IATA airline designators`,`Company Name`,COUNT(*) as    `love_quotient`
                FROM `Airline`,`Aircraft`,`boarding_pass`,`Route`
                WHERE (`IATA airline designators`=`fk_to_airline_owner_airline_IATA_code`) AND (`registration_num`=`fk_to_aircraft_registration_num`)
                AND(`fk_to_route_Route ID`=`Route ID`)
                GROUP BY `IATA airline designators`
                ORDER BY COUNT(*) DESC;
                        '''
    display_query_result(cur, con, query_str)


def analysis_feedback_patterns(cur,con):
    print("Inside feedback_passengers")

    query_str='''
                        '''
#done
def analysis_find_tickets(cur,con):
    #print("Inside analysis_find_tickets func")


    src_iata=input("Enter iata code of src airport (Eg:DEL) : ")
    dest_iata=input("Enter iata code of dest airport (Eg:MUM) : ")

    date_sought=input("Enter date when the journey needs to be made [YYYY-MM-DD] Eg:(2020-10-06): ")

    query_str='''SELECT `fk_to_airport_src_iata_code` AS 'Source airport' ,
                        `fk_to_airport_dest_iata_code` AS 'Destination Airport',
                        `Date`,
                        `fk_to_airline_owner_airline_IATA_code` AS 'Airline',
                        `Flight ID`,
                        `Scheduled arrival` 
                FROM `Route`,`Aircraft`
                WHERE (`fk_to_airport_src_iata_code`="{0}")
                AND   (`fk_to_airport_dest_iata_code`="{1}")
                AND (`Date`="{2}")
                AND   (`fk_to_aircraft_registration_num`=registration_num) 
                                    ;
                        '''.format(src_iata,dest_iata,date_sought)
    #print(f"DEBUG: query is {query_str}")
    display_query_result(cur, con, query_str)    

# DONE
def analysis_crashed_survivors(cur,con):
    print("Inside update_passenger func")

    crashed_route_id=input("Enter route id of the flight whose passengers need to be displayed: ")
    query_str='''SELECT `First Name`,`Last Name`, `Aadhar_card_number`,`Barcode number`,`Seat`
                FROM `boarding_pass`,`Passenger`
                WHERE (`fk_to_passenger_Aadhar_card_number`=`Aadhar_card_number`)
                AND(`fk_to_route_Route ID`={0})
                        '''.format(crashed_route_id)

    display_query_result(cur, con, query_str)

# DONE
def analysis_airline_pilots(cur,con):

    iata_airline=input("Enter iata code of airline whose pilots are to be listed: ")
    query_str='''SELECT `Pilot license number`,`First Name`,`Last Name`,`Number of years of Experience`,`Number of flying hours`
                FROM `Pilot`,`airline_crew`
                WHERE (`Aadhar_card_number`= `fk_to_flight_crew_Aadhar_card_number`)
                AND (`fk_to_airline_employer_IATA_code`="{0}" )    

                        '''.format(iata_airline)

    display_query_result(cur, con, query_str)

# DONE
def analysis_favoured_aircrafts(cur,con):
    #print("Inside update_passenger func")
    #https://stackoverflow.com/a/2421441
    query_str='''SELECT `fk_to_capacity_Manufacturer` AS `Manufacturer`,
                        `fk_to_capacity_Model` AS `Model`,
                        COUNT(*) AS `Total occurrences`
                FROM `Aircraft`
                WHERE `fk_to_airline_owner_airline_IATA_code`  IS NOT NULL
                GROUP BY `fk_to_capacity_Manufacturer`,`fk_to_capacity_Model`
                ORDER BY `Total occurrences` DESC;
                        '''
    
    display_query_result(cur, con, query_str)
