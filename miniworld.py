import subprocess as sp
import pymysql
import pymysql.cursors

from add import add_airline



add_funcs_dict = {
        "Airline":add_airline
        # "Passenger":add_passenger,
        # "Aircraft":add_aircraft,
        # "Airport":add_airport,
        # "Runway":add_runway,
        # "Terminal":add_terminal,
        # "Route":add_route,
        # "Boarding Pass":add_boarding_pass,
        # "Airline Employees":add_airline_employee,
        # "Airport Employees":add_airport_employee,
        # "Feedback and rating":add_feedback
}




def add_display(cur, con):
    """
    Function to implement option 1
    """
    print("Add to the table:")
    i = 0
    tables_add = [
        "Airline",
        "Passenger", 
        "Aircraft",
        "Airport",
        "Runway",
        "Terminal",
        "Route",
        "Boarding Pass",
        "Airline Employees",
        "Airport Employees",
        "Feedback and rating"
    ]

    while i < len(tables_add):
        i += 1
        print(str(i) + ". " + tables_add[i - 1])

    choice_to_add=int(input("enter number to add starting from 1"))
    add_funcs_dict[tables_add[choice_to_add-1]](cur, con)



def hireAnEmployee():
    """
    This is a sample function implemented for the refrence.
    This example is related to the Employee Database.
    In addition to taking input, you are required to handle domain errors as well
    For example: the SSN should be only 9 characters long
    Sex should be only M or F
    If you choose to take Super_SSN, you need to make sure the foreign key constraint is satisfied
    HINT: Instead of handling all these errors yourself, you can make use of except clause to print the error returned to you by MySQL
    """
    try:
        # Takes emplyee details as input
        row = {}
        print("Enter new employee's details: ")
        name = (input("Name (Fname Minit Lname): ")).split(' ')
        row["Fname"] = name[0]
        row["Minit"] = name[1]
        row["Lname"] = name[2]
        row["Ssn"] = input("SSN: ")
        row["Bdate"] = input("Birth Date (YYYY-MM-DD): ")
        row["Address"] = input("Address: ")
        row["Sex"] = input("Sex: ")
        row["Salary"] = float(input("Salary: "))
        row["Dno"] = int(input("Dno: "))

        query = "INSERT INTO EMPLOYEE(Fname, Minit, Lname, Ssn, Bdate, Address, Sex, Salary, Dno) VALUES('%s', '%c', '%s', '%s', '%s', '%s', '%c', %f, %d)" % (
            row["Fname"], row["Minit"], row["Lname"], row["Ssn"], row["Bdate"],
            row["Address"], row["Sex"], row["Salary"], row["Dno"])

        print(query)
        cur.execute(query)
        con.commit()

        print("Inserted Into Database")

    except Exception as e:
        con.rollback()
        print("Failed to insert into database")
        print(">>>>>>>>>>>>>", e)

    return


def dispatch(ch,cur, con):
    """
    Function that maps helper functions to option entered
    """

    if (ch == 1):
        add_display(cur, con)
    elif (ch == 2):
        option3()
    elif (ch == 3):
        option3()
    elif (ch == 4):
        option4()
    else:
        print("Error: Invalid Option")


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
                print("1. Add new information")  # Hire an Employee
                print("2. Option 2")  # Fire an Employee
                print("3. Option 3")  # Promote Employee
                print("4. Option 4")  # Employee Statistics
                print("5. Logout")
                print("6. Exit")
                ch = int(input("Enter choice> "))
                tmp = sp.call('clear', shell=True)
                if ch == 5:
                    break
                elif ch == 6:
                    raise SystemExit
                else:
                    dispatch(ch,cur, con)
                    tmp = input("Enter any key to CONTINUE>")

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