import datetime
import subprocess as sp
import pymysql
import pymysql.cursors


# analysis_funcs_dict = {
#         "1":analysis_passenger_special_services,#
#         "2":analysis_aircraft,#
#         "3":analysis_airport,#
#         "4":analysis_runway_status,#
#         "5":analysis_airport_crew,#
#         "6":analysis_route_details,#
#         "7":analysis_airline_crew_personal_details,
#         "8":analysis_airline_details,#
#         "9":analysis_atc_freq,
#         "10":,
#         "11":
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

def add_feedback(cur, con):
    print("In Progress\n")

