import subprocess as sp
import pymysql
import pymysql.cursors

from add import *

# 0 -> airport_employee
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
        "Airport Employees"
        #"Feedback and rating"
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
        "Airline":delete_airline,#
        "Passenger":delete_passenger,#
        "Aircraft":delete_aircraft,#
        "Airport":delete_airport,#
        "Runway":delete_runway,#
        "Terminal":delete_terminal,#
        "Route":delete_route,#
        "Boarding Pass":delete_boarding_pass_details,#
        "Airline Employees":delete_airline_crew,#
        "Airport Employees":delete_airport_crew,#
        "Feedback and rating":delete_feedback
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

        with con.cursor() as cur:
            while (1):
                # tmp = sp.call('clear', shell=True)
                # Here taking example of Employee Mini-world
                

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