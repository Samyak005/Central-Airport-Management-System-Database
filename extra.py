import datetime
import subprocess as sp
import pymysql
import pymysql.cursors


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
            pprint(tabulate(rows, header, tablefmt = 'grid'))
        
        else:
            print("No rows found!") #length of result is 0

    except Exception as e:
        pprint("Error!")
        con.rollback()
        input("Press any key to continue")

def add_feedback(cur, con):
    print("In Progress\n")

def analysis_passenger_special_services(cor,con):
    print("Inside update_passenger func")

    query_str='''
                        '''

def analysis_big_airlines(cor,con):
    print("Inside analysis_big_airlines")

    
    limit_var=int(input("Enter 'x' in order to display airlines having a flight crew greater than 'x'"))

    query_str='''
                        '''

def analysis_experienced_pilot(cor,con):
    print("Inside analysis_experienced_pilot func")

    query_str='''
                        '''

def analysis_search_name(cor,con):
    print("Inside update_passenger func")

    sought_name=input("Enter substring which needs to be found in names of the passengers")

    query_str='''
                        '''


def analysis_busiest_airports(cor,con):
    print("Inside busiest_airports func")

    ### SHOULD WE TAKE DATE AS INPUT
    query_str='''
                        '''


def analysis_loved_airlines(cor,con):
    print("Inside update_passenger func")


    query_str='''
                        '''

def analysis_feedback_patterns(cor,con):
    print("Inside feedback_passengers")

    query_str='''
                        '''

def analysis_find_tickets(cor,con):
    print("Inside update_passenger func")


    src_iata=input("Enter iata code of src airport")
    dest_iata=input("Enter iata code of dest airport")

    date_sought=input("Enter date when the journey needs to be made")

    query_str='''
                        '''


def analysis_crashed_survivors(cor,con):
    print("Inside update_passenger func")

    crashed_route_id=input("Enter route id of the flight whose passengers need to be displayed")
    query_str='''
                        '''


def analysis_airline_pilots(cor,con):

    iata_airline=input("Enter iata code of airline whose pilots are to be listed")
    query_str='''
                        '''


def analysis_favoured_aircrafts(cor,con):
    print("Inside update_passenger func")

    query_str='''
                        '''
    
    

    