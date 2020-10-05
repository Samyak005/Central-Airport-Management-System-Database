import subprocess as sp
import pymysql
import pymysql.cursors

from add import *

# 0 -> central_airport_authority_of_india
# 1-> airline_employee
# 2-> passenger

#################################################################################################c

expose_add_funcs=[["","","","","",""],
            ["","","","","",""],
            ["","","","","",""]]

add_funcs_dict = {
        "Airline":add_airline,#
        "Passenger":add_passenger,#
        "Aircraft":add_aircraft,#
        "Airport":add_airport,#
        "Runway":add_runway,#
        "Terminal":add_terminal,#
        "Route":add_route,#
        "Boarding Pass":add_boarding_pass_details,#
        "Airline Employees":add_airline_crew,#
        "Airport Employees":add_airport_crew,#
        "Feedback and rating":add_feedback
}


def add_display(cur, con,user_id):
    """
    Function to implement option 1
    """
    print("Add to the table:\n")
    i = 0
    tables_add = [
        "Airline", #
        "Passenger", #
        "Aircraft", #
        "Airport", #
        "Runway", #
        "Terminal", #
        "Route", 
        "Boarding Pass", #
        "Airline Employees",
        "Airport Employees",
        "Feedback and rating"
    ]

    while i < len(tables_add):
        i += 1
        print(str(i) + ". " + tables_add[i - 1])

    choice_to_add=int(input("enter number to add starting from 1"))
    if choice_to_add > 10 or choice_to_add < 1:
        print("Invalid number. Please try again\n")
        return
    else:
        add_funcs_dict[tables_add[choice_to_add-1]](cur, con)

#################################################################################################c

expose_read_funcs=[["","","","","",""],
            ["","","","","",""],
            ["","","","","",""]]

read_funcs_dict = {
        "Airline":read_airline,#
        "Passenger":read_passenger,#
        "Aircraft":read_aircraft,#
        "Airport":read_airport,#
        "Runway":read_runway,#
        "Terminal":read_terminal,#
        "Route":read_route,#
        "Boarding Pass":read_boarding_pass_details,#
        "Airline Employees":read_airline_crew,#
        "Airport Employees":read_airport_crew,#
        "Feedback and rating":read_feedback
}


def read_display(cur, con,user_id):
    """
    Function to implement option 1
    """
    print("Add to the table:\n")
    i = 0
    tables_read = [
        "Airline", #
        "Passenger", #
        "Aircraft", #
        "Airport", #
        "Runway", #
        "Terminal", #
        "Route", 
        "Boarding Pass", #
        "Airline Employees",
        "Airport Employees"
        #"Feedback and rating"
    ]

    while i < len(tables_read):
        i += 1
        print(str(i) + ". " + tables_add[i - 1])

    choice_to_read=int(input("enter number of table to read starting from 1"))
    if choice_to_read > 10 or choice_to_read < 1:
        print("Invalid number. Please try again\n")
        return
    else:
        read_funcs_dict[tables_read[choice_to_read-1]](cur, con)


#################################################################################################


expose_delete_funcs=[["","","","","",""],
            ["","","","","",""],
            ["","","","","",""]]

delete_funcs_dict = {
       # "Airline":delete_airline,#
      #  "Passenger":delete_passenger,#
        "Aircraft":delete_aircraft,#
     #   "Airport":delete_airport,#
    #    "Runway":delete_runway,#
   #     "Terminal":delete_terminal,#
        "Route":delete_route,#
  #      "Boarding Pass":delete_boarding_pass_details,#
        "Airline Employees":delete_airline_crew,#
        "Airport Employees":delete_airport_crew,#
 #       "Feedback and rating":delete_feedback,
        "Luggage":delete_luggage
}


def delete_display(cur, con,user_id):
    """
    Function to implement option 1
    """
    print("delete to the table:\n")
    i = 0
    tables_delete = [
        "Airline", #
        "Passenger", #
        "Aircraft", #
        "Airport", #
        "Runway", #
        "Terminal", #
        "Route", 
        "Boarding Pass", #
        "Airline Employees",
        "Airport Employees"
        #"Feedback and rating"
    ]

    while i < len(tables_delete):
        i += 1
        print(str(i) + ". " + tables_delete[i - 1])

    choice_to_delete=int(input("enter number to delete starting from 1"))
    if choice_to_delete > 10 or choice_to_delete < 1:
        print("Invalid number. Please try again\n")
        return
    else:
        delete_funcs_dict[tables_delete[choice_to_delete-1]](cur, con)


#################################################################################################
#################################################################################################


expose_update_funcs=[["","","","","",""],
            ["","","","","",""],
            ["","","","","",""]]

update_funcs_dict = {
        "1":update_passenger,#
        "2":update_aircraft,#
        "3":update_airport,#
        "4":update_runway_status,#
        "5":update_airport_crew,#
        "6":update_route_details,#
        "7":update_airline_crew_personal_details,
        "8":update_airline_details,#
        "9":update_atc_freq,
}

update_funcs_msg = {
        "1":"for updating name, gender, address of passenger",#
        "2":"for updating flight id, owner airline, last check maintenance date aircraft",#
        "3":"for updating name of airport",#
        "4":"for updating status of runway",#
        "5":"for updating name, years of experiences, salary, nationality, employer, gender of airport crew",#
        "6":"for updating actual arrival time, actual departure time, distance travelled over the route, status of the journey",
        "7":"for updating airline crew personal details like salary, current employer etc.",#
        "8":"for updating active_status of the airline, country of wonership",
        "9":"for updating the frequency at which the air traffic contoller is operating",
}

# in 11, give status change, time change, 


def update_display(cur, con,user_id):
    """
    Function to implement option 1
    """
    print("update to the table:\n")
    i = 0
    tables_update = [
        "Airline", #
        "Passenger", #
        "Aircraft", #
        "Airport", #
        "Runway", #
        "Terminal", #
        "Route", 
        "Boarding Pass", #
        "Airline Employees",
        "Airport Employees"
        #"Feedback and rating"
    ]

    while i < len(tables_update):
        i += 1
        print(str(i) + ". " + tables_update[i - 1])

    choice_to_update=int(input("enter number to update starting from 1"))
    if choice_to_update > 10 or choice_to_update < 1:
        print("Invalid number. Please try again\n")
        return
    else:
        update_funcs_dict[tables_update[choice_to_update-1]](cur, con)


#################################################################################################

expose_analysis_funcs=[["","","","","",""],
            ["","","","","",""],
            ["","","","","",""]]

analysis_funcs_dict = {
        "1":analysis_passenger_special_services,#
        "2":analysis_aircraft,#
        "3":analysis_airport,#
        "4":analysis_runway_status,#
        "5":analysis_airport_crew,#
        "6":analysis_route_details,#
        "7":analysis_airline_crew_personal_details,
        "8":analysis_airline_details,#
        "9":analysis_atc_freq,
        "10":,
        "11":
}

analysis_funcs_msg = {
        "1":"Names of all passengers who have WHEELCHAIR ASSISTANCE/Disability assisstance as a special service in their BOARDING PASS",#
        "2":"NAMES OF ALL AIRLINES whose flight crew is >=x where 'x' is to be inputted from user",#
        "3":"find the pilot with maximum number of flying hrs",#
        "4":"Search for all PASSENGERS whose name contains a given substring",#
        "5":"RANK BUSIEST AIRPORTS by number of scheduled flight departures on a particular day",#
        "6":"RANK most used airline by sorting as per the number of boarding passes issued for that airline since data collection began",
        "7":"Feedback of flight crew patterns",#
        "8":"display all flights between two airports on a given date or on any date",
        "9":"names of all passengers who were travelling on a particular route/Crashed flight/Flight with a COVID infected patient",
        "10":"Names of all pilots who work for a given airline",
        "11":"Find most used aircraft across all airlines"
}

# in 11, give status change, time change, 


def analysis_display(cur, con,user_id):
    """
    Function to implement option 1
    """
    print("analysis to the table:\n")
   
    while i < len(tables_analysis):
        i += 1
        print(str(i) + ". " + tables_analysis[i - 1])

    choice_to_analysis=int(input("enter number to analysis starting from 1"))
    if choice_to_analysis > 10 or choice_to_analysis < 1:
        print("Invalid number. Please try again\n")
        return
    else:
        analysis_funcs_dict[tables_analysis[choice_to_analysis-1]](cur, con)

#########################################################################################

def dispatch(ch,cur, con,user_id):
    """
    Function that maps helper functions to option entered
    """

    if (ch == 1):
        add_display(cur, con,user_id)
    elif (ch == 2):
       # update_display(cur, con,user_id)
    elif (ch == 3):
       # delete_display(cur, con,user_id)
    elif (ch == 4):
        read_display(cur, con,user_id)
    else:
        print("Error: Invalid Option")

def display_menu(user_id):

    print("1. Add new information")  # Hire an Employee
    print("2. Update tables")  # Fire an Employee
    print("3. Delete data")  # Promote Employee
    print("4. Read data")  # Employee Statistics
    print("5. Logout")
    print("6. Exit")
    ch = int(input("Enter choice> "))
    tmp = sp.call('clear', shell=True)
    if ch == 5:
        break
    elif ch == 6:
        raise SystemExit
    else:
        dispatch(ch,cur, con,user_id)
        tmp = input("Enter any key to CONTINUE>")

# Global
while (1):

   #Run the command described by args. Wait for command to complete, then return the returncode attribute.
   #https://stackoverflow.com/a/3172690/6427607
    tmp = sp.call('clear', shell=True)

    # Can be skipped if you want to hard core username and password
    username = input("Username: ")
    password = input("Password: ")

    try:
        # Set db name accordingly which have been create by you
        # Set host to the server's address if you don't want to use local SQL server

        #Establish a connection to the MySQL database. Accepts several arguments:
        #Constructor for creating a connection to the database.

        # # Connect to the database
        con = pymysql.connect(host='localhost', #host – Host where the database server is located
                              user=username,  #Username to log in as
                              password=password, #Password to use.
                              db='airport_db', #Database to use, None to not use a particular one.
                              port=5005, #MySQL port to use
                              cursorclass=pymysql.cursors.DictCursor) # Custom cursor class to use.
       
       
        tmp = sp.call('clear', shell=True)

        '''Return True if the connection is open'''
        if (con.open):
            print("Connected")
        else:
            print("Failed to connect")

        tmp = input("Enter any key to CONTINUE>")

        # If you possess programming skills, you would probably use a
        #  loop like FOR or WHILE to iterate through one item at a time, do something
        #  with the data and the job is done. In T-SQL, a CURSOR
        #   is a similar approach, and might be preferred because it follows the same logic.

        print("Press 0 if you are airport_employee")
        print("Press 1 if you are airline_employee")
        print("Press 2 if you are passenger")

        user_id=int(input())

        with con.cursor() as cur:
            while (1):
                # tmp = sp.call('clear', shell=True)
                # Here taking example of Employee Mini-world

                dispatch(user_id)

                

                

    except Exception as e:
        # tmp = sp.call('clear', shell=True)
        print(
            "Connection Refused: Either username or password is incorrect or user doesn't have access to database"
        )
        print(">>>", e)
        tmp = input("Enter any key to CONTINUE>")




# ### SAMPLE CODE  https://github.com/PyMySQL/PyMySQL
# import pymysql.cursors

# # Connect to the database
# connection = pymysql.connect(host='localhost',
#                              user='user',
#                              password='passwd',
#                              db='db',
#                              charset='utf8mb4',
#                              cursorclass=pymysql.cursors.DictCursor)

# try:
#     with connection.cursor() as cursor:
#         # Create a new record
#         sql = "INSERT INTO `users` (`email`, `password`) VALUES (%s, %s)"
#         cursor.execute(sql, ('webmaster@python.org', 'very-secret'))

#     # connection is not autocommit by default. So you must commit to save
#     # your changes.
#     connection.commit()

#     with connection.cursor() as cursor:
#         # Read a single record
#         sql = "SELECT `id`, `password` FROM `users` WHERE `email`=%s"
#         cursor.execute(sql, ('webmaster@python.org',))
#         result = cursor.fetchone()
#         print(result)
# finally:
#     connection.close()

# # -----------------------------------------------------------------------------

# # sample queries
# import datetime
# import mysql.connector

# cnx = mysql.connector.connect(user='scott', database='employees')
# cursor = cnx.cursor()

# query = ("SELECT first_name, last_name, hire_date FROM employees "
# "WHERE hire_date BETWEEN %s AND %s")

# hire_start = datetime.date(1999, 1, 1)

# hire_end = datetime.date(1999, 12, 31)

# cursor.execute(query, (hire_start, hire_end))

# for (first_name, last_name, hire_date) in cursor:
#     print("{}, {} was hired on {:%d %b %Y}".format(
#         last_name, first_name, hire_date))

# cursor.close()
# cnx.close()