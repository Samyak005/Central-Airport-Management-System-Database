import subprocess as sp
import pymysql
import pymysql.cursors
import datetime
import sys

colors_dict = {
    "BLUE": "\033[1;34m",
    "RED": "\033[1;31m",
    "CYAN": "\033[1;36m",
    "GREEN": "\033[0;32m",
    "RESET": "\033[0;0m",
    "BOLD": "\033[;1m",
    "REVERSE": "\033[;7m",
    "ERROR": "\033[;7m"+"\033[1;31m"
}


def decorate_stuff(color_str):
    # print("Decorated")
    sys.stdout.write(colors_dict[color_str])

def date_less_cur(date_str):
    today_date = datetime.date.today()
    today_date_str = today_date.strftime("%Y-%m-%d")

    if date_str < today_date_str:
        return 1
    else:
        return 0


def date_more_cur(date_str):
    today_date = datetime.date.today()
    today_date_str = today_date.strftime("%Y-%m-%d")

    if date_str > today_date_str:
        return 1
    else:
        return 0


def print_err_date(state):
    decorate_stuff('ERROR')
    if state == 1:
        print('The date entered cannot be after current date. Current date: ' +
              str(datetime.date.today()))
    elif state == -1:
        print('The date entered cannot be before current date. Current date: ' +
              str(datetime.date.today()))
    decorate_stuff('RESET')


def numeric_check(ch):
    if ch >= '0' and ch <= '9':
        return 1
    else:
        return 0


def dep_ahead_arv(arrival_str, depart_str):
    decorate_stuff('ERROR')
    print(f"DEBUG:Arrival is {arrival_str}\nDeparture is {depart_str}")

    if len(arrival_str) != 5 or len(depart_str) != 5:
        print('Invalid format')
        decorate_stuff('RESET')

        return -1

    if numeric_check(arrival_str[0])+numeric_check(arrival_str[1])+numeric_check(arrival_str[3])+numeric_check(arrival_str[4]) != 4:
        print("Enter only digits for mm and hh in arrival time")
        decorate_stuff('RESET')

        return -1

    if numeric_check(depart_str[0])+numeric_check(depart_str[1])+numeric_check(depart_str[3])+numeric_check(depart_str[4]) != 4:
        print("Enter only digits for mm and hh in departure time")
        decorate_stuff('RESET')

        return -1

    arrival_hrs = int(arrival_str[0:2])
    arrival_min = int(arrival_str[3:5])
    depart_hrs = int(depart_str[0:2])
    depart_min = int(depart_str[3:5])

    if depart_hrs > arrival_hrs:
        print('Arrival time can not be ahead of departure time')
        decorate_stuff('RESET')

        return -1

    elif depart_hrs == arrival_hrs and depart_min > arrival_min:
        print('Arrival time can not be ahead of departure time')
        decorate_stuff('RESET')

        return -1

    else:
        return 0


def get_updation_equation(attr, key_attr):

    query_str = ""
    dict_len = len(attr.keys())
    i = -1
    
    for key, value in attr.items():

        i += 1
        if key in key_attr:
            continue
        if value == '' or value == 'NULL':
            continue

        query_str =query_str+ "`"+key+"`"+" = "+'"'+value+'"'

        if i != dict_len-1:
            query_str =query_str+ ", "

    if query_str[-2]==',':
        query_str=query_str[:-2]
    return query_str


def get_selection_equation(attr, key_attr):

    query_str = ""
    list_len = len(key_attr)
    i = -1

    for key in key_attr:
        i += 1

        if attr[key] == '':
            return ""

        query_str += "`"+key+"`"+" = "+'"'+attr[key]+'"'

        if i != list_len-1:
            query_str = query_str+" AND "

    return query_str


def try_except_block(attr, key_attr, cur, con, table_name):
    print('INSIDE try_except_block')
    try:
        set_values = get_updation_equation(attr, key_attr)
        decorate_stuff('ERROR')
        if set_values == "":
            print("ERROR: Some value must be selected for updation")
            print("Failed to update database")
            decorate_stuff('RESET')
            input("Press any key to continue")
            return

        cond_values = get_selection_equation(attr, key_attr)
        if cond_values == "":
            print("ERROR: Value of the key attributes cannot be NULL")
            print("Failed to update database")
            decorate_stuff('RESET')
            input("Press any key to continue")
            return

        query_str = "UPDATE "+table_name+" SET "+set_values+" WHERE "+cond_values+" ; "
        print(f"Query_STR IS ", query_str)
        cur.execute(query_str)
        con.commit()
        res_len = cur.rowcount
        decorate_stuff('BLUE')
        print(f"Number of tuples updated are {res_len}")
        decorate_stuff('GREEN')
        print('Updation successful')

        # display_updated_rows(result)
        decorate_stuff('RESET')

        return

    except Exception as e:
        print('ERROR:Failed to update the database.')
        con.rollback()
        print(e)
        decorate_stuff('RESET')
        input('Press any key to continue.')
        return

# checked

# DONE +++
def update_passenger(cur, con):
    print("Inside update_passenger func")
    table_name = "Passenger"

    attr = {}

    attr["Aadhar_card_number"] = input(
        "Enter Aadhar card number of the passenger you want to update: ")
    print("Press enter without entering any value if you don't want to update a particular value")
    tmp_name = input("Enter new name: ")

    key_attr = ["Aadhar_card_number"]

    name_list = tmp_name.split(' ')

    if len(name_list) >= 3:
        attr['First Name'] = name_list[0]
        attr['Middle Name'] = ' '.join(name_list[1:-1])
        attr['Last Name'] = name_list[-1]
    elif len(name_list) == 2:
        attr['First Name'] = name_list[0]
        attr['Middle Name'] = '-'
        attr['Last Name'] = name_list[1]
    elif len(name_list) == 1:
        attr['First Name'] = name_list[0]
        attr['Middle Name'] = '-'
        attr['Last Name'] = '-'
    else:
        attr['First Name'] = ''
        attr['Middle Name'] = ''
        attr['Last Name'] = ''

    attr["Gender"] = int(
        input("Enter Gender \n1. Male \n2. Female \n3. Others\n 4. Unchanged\n ENTER HERE >"))

    if attr['Gender'] == 1:
        attr['Gender'] = 'Male'
    elif attr['Gender'] == 2:
        attr['Gender'] = 'Female'
    elif attr['Gender'] == 3:
        attr['Gender'] = 'Others'
    else:
        attr['Gender'] = ''

    attr["House Number"] = input("Enter new house number of residence: ")
    attr["Building"] = input("Enter new building number of residence: ")
    attr["City"] = input("Enter new city of residence: ")

    try_except_block(attr, key_attr, cur, con, table_name)


def update_aircraft(cur, con):
    print("inside update_aircraft function")
    table_name = "`Aircraft`"

    attr = {}

    key_attr = ["registration_num"]

    attr['registration_num'] = input("Enter registration number of aircraft: ")
    print("Press enter  without entering any value if you don't want to update a particular value")
    print('Enter updated details of the aircraft: ')
    attr['Flight ID'] = input("Enter updated Flight ID: ")
    attr['Maintanence check date'] = input("Enter maintanence check date: [YYYY-MM-DD]: ")
    if date_more_cur(attr['Maintanence check date']) == 1:
        print_err_date(1)
        con.rollback()
        return
    #attr['fk_to_airline_owner_airline_IATA_code'] = input("Enter IATA code of owner airline: ")

    try_except_block(attr, key_attr, cur, con, table_name)

  # checked

#DONE++
def update_airport(cur, con):
    #print("inside update_airport function")
    table_name = "`Airport`"

    attr = {}

    key_attr = ["IATA airport codes"]

    print('Enter details of the new airport: ')

    attr["IATA airport codes"] = input(" Enter 3 character IATA code * :")
    print("Press enter  without entering any value if you don't want to update a particular value :")

    attr["Airport Name"] = input("Enter the new name of airport: ")

    try_except_block(attr, key_attr, cur, con, table_name)



# checked
def update_runway_status(cur, con):
    print("inside update_runway_status function")
    table_name = "`Runway`"

    attr = {}

    key_attr = ["fk_to_airport_IATA_airport_codes", "Runway ID"]

    attr["fk_to_airport_IATA_airport_codes"] = input(
        "Enter IATA airport code of corresponding airport: ")
    attr["Runway ID"] = input("Enter runway ID: ")
    print("Press enter  without entering any value if you don't want to update a particular value")

    stat_choice = int(
        input("Enter status as\n 1 for assigned\n 2 for available\n 3 for disfunctional\n >"))

    attr["Status"] = ""
    if stat_choice == 1:
        attr["Status"] = 'Assigned'
    elif stat_choice == 2:
        attr["Status"] = 'Available'
    elif stat_choice == 3:
        attr["Status"] = 'Disfunctional'
    else:
        attr["Status"] = ''

    try_except_block(attr, key_attr, cur, con, table_name)

# checked

#DONE++
def update_airport_crew(cur, con):
    #Name,yrs_exp, salary, nationality,employer, gender
    #print("inside update_airport_crew function")
    table_name = "`Airport Employees/CREWS`"

    attr = {}

    key_attr = ["Aadhar_card_number"]

    attr["Aadhar_card_number"] = input(
        "Aadhar card number of the employee you want to update: ")
    print("Press enter without entering any value if you don't want to update a particular value")

    tmp_name = input("Enter new name: ")

    name_list = tmp_name.split(' ')

    if len(name_list) >= 3:
        attr['First Name'] = name_list[0]
        attr['Middle Name'] = ' '.join(name_list[1:-1])
        attr['Last Name'] = name_list[-1]
    elif len(name_list) == 2:
        attr['First Name'] = name_list[0]
        attr['Middle Name'] = '-'
        attr['Last Name'] = name_list[1]
    elif len(name_list) == 1:
        attr['First Name'] = name_list[0]
        attr['Middle Name'] = '-'
        attr['Last Name'] = '-'
    else:
        attr['First Name'] = ''
        attr['Middle Name'] = ''
        attr['Last Name'] = ''

    attr["Experience"] = input("New total number of years of Experience: ")
    attr["Salary"] = input("New Salary: ")
    attr["Nationality"] = input("New Nationality: ")
    attr["Gender"] = input(
        "Enter Gender \n1. Male \n2. Female \n3. Others\n 4. Unchanged\n ENTER HERE >")

    if attr['Gender'] == 1:
        attr['Gender'] = 'Male'
    elif attr['Gender'] == 2:
        attr['Gender'] = 'Female'
    elif attr['Gender'] == 3:
        attr['Gender'] = 'Others'
    else:
        attr['Gender'] = ''
    attr["fk_to_airport_IATA_code_of_employing_airport"] = input(
        "airport IATA code of employing airport: ")

    try_except_block(attr, key_attr, cur, con, table_name)


##############################################################################################
def update_route_details(cur, con):
    print("Inside update_route_details function")
    # NOTE: distance travelled should be updated in route
    table_name = "Route"

    attr = {}

    key_attr = ["Route ID"]

    attr["Route ID"] = input("Enter route id for which the information needs to be updated: ")

    decorate_stuff('BLUE')
    print("Press enter without typing any value if you do not want to update value of a particular attribute")
    decorate_stuff("RESET")

    #############################################################################################
    
    attr['Status'] = input("Enter one of 'Departed', 'Boarding','On_route','Delayed','Arrived','Checking','Not_applicable' as the status: ")

    if attr['Status'] == 'Departed':
        decorate_stuff('BLUE')
        print("Also updating the status of the Take OFF Runway as `Available`")
        decorate_stuff('RESET')

        query_update = f'''UPDATE Route ,Runway SET Runway.`Status`="Available" WHERE `Runway ID`=`fk_to_runway_Take off runway id`
        AND `Route ID`={attr["Route ID"]}
        AND `fk_to_airport_src_iata_code`=`fk_to_airport_IATA_airport_codes`;'''

        cur.execute(query_update)
        tmp_var = ''
        tmp_var = input("Enter actual departure time of the flight in  [HH:MM] format: ")
        # attr["Actual departure time"]=input("Enter actual departure time of the flight in  [HH:MM] format")
        if tmp_var == '':
            print("ERROR: User failed to enter a non-empty input for ACTUAL FLIGHT departure time")
            return
        else:
            attr["Actual departure time"] = tmp_var

    elif attr['Status'] == 'Arrived':
        decorate_stuff('BLUE')
        print("Also updating the status of the LANDING Runway as `Available`")
        decorate_stuff('RESET')
        query_update = f'''UPDATE Route ,Runway SET Runway.`Status`="Available" WHERE `Runway ID`=`fk_to_runway_Landing runway ID`
                        AND `Route ID`={attr["Route ID"]}
                        AND `fk_to_airport_dest_iata_code`=`fk_to_airport_IATA_airport_codes`;'''

        cur.execute(query_update)

        tmp_var = ''
        tmp_var = input(
            "Enter actual arrival time of the flight in  [HH:MM] format: ")
        # attr["Actual departure time"]=input("Enter actual departure time of the flight in  [HH:MM] format")
        if tmp_var == '':
            print("ERROR: User failed to enter a non-empty input for ACTUAL FLIGHT arrival time")
            return
        else:
            attr["Actual arrival time"] = tmp_var


        ####################################################################################    
        # job 2
        depart_query = '''SELECT `Actual departure time` FROM Route WHERE `Route ID` = {0};'''.format(
            attr["Route ID"])
        cur.execute(depart_query)
        temp = cur.fetchall()
        str_delta = str(temp)
        seconds = int(str_delta[-8:-3])
        hours = int(seconds / 3600)
        minutes = int((seconds % 3600) / 60)
        attr["Actual departure time"] = "{0}:{1:0=2d}".format(hours, minutes)

        if dep_ahead_arv(attr["Actual arrival time"], attr["Actual departure time"]) == -1:
            return

        tmp_var = input("Enter total distance travelled by flight: ")
        # attr["Actual departure time"]=input("Enter actual departure time of the flight in  [HH:MM] format")
        if tmp_var == '':
            print("ERROR: User failed to enter OVERALL distance travelled")
            return
        # Job 1
        else:
            attr["Distance Travelled"] = tmp_var
            query_str = '''UPDATE Aircraft, Route 
                            SET Aircraft.`Distance Travelled` = Aircraft.`Distance Travelled` + {0} 
                            WHERE `Route ID` = {1} AND fk_to_aircraft_registration_num = registration_num;'''.format(attr["Distance Travelled"], attr["Route ID"])
            
            query_str2 = '''UPDATE `Route`, `Pilot`
                            SET Pilot.`Number of flying hours` = Pilot.`Number of flying hours`  + 2
                            WHERE (`Route ID` = {1})
                            AND  (`fk_to_flight_crew_Aadhar_card_number`=`Pilot captain Aadhar_card_number`); '''.format(0, attr["Route ID"])
            try:
                cur.execute(query_str)
                cur.execute(query_str2)
                con.commit()

            except Exception as e:
                print("Failed to update the database.")
                con.rollback()
                print(e)
                input('Press any key to continue.')
                return

        #################################################################################################
            # Add distance to aircraft
            # Add flying hrs to both pilots
        ###############################################################################################

    attr["fk_to_runway_Take off runway id"] = input("Enter NEW runway id (if there was a change) which has been allotted for take_off: ")
    attr["fk_to_runway_Landing runway ID"] = input("Enter NEW runway id (if there was a change) which has been allotted for LANDING: ")

    try_except_block(attr, key_attr, cur, con, table_name)

#Name,yrs_exp, salary, nationality,employer, gender

#DONE+++++
def update_airline_crew_personal_details(cur, con):
    print("inside update_airline_crew_personal_details function")
    table_name = "`airline_crew`"

    attr = {}

    key_attr = ["Aadhar_card_number"]

    attr["Aadhar_card_number"] = input("Aadhar_card_number: ")
    print('Enter new details of the airline_crew entry: ')
    print("Press enter without typing any value if you do not want to update value of a particular attribute")

    tmp_name = input("Enter new name: ")

    name_list = tmp_name.split(' ')

    if len(name_list) >= 3:
        attr['First Name'] = name_list[0]
        attr['Middle Name'] = ' '.join(name_list[1:-1])
        attr['Last Name'] = name_list[-1]
    elif len(name_list) == 2:
        attr['First Name'] = name_list[0]
        attr['Middle Name'] = '-'
        attr['Last Name'] = name_list[1]
    elif len(name_list) == 1:
        attr['First Name'] = name_list[0]
        attr['Middle Name'] = '-'
        attr['Last Name'] = '-'
    else:
        attr['First Name'] = ''
        attr['Middle Name'] = ''
        attr['Last Name'] = ''

    attr["Number of years of Experience"] = input(
        "Updated Number of years of Experience: ")
    attr["Salary"] = input("Salary: ")
    attr["Nationality"] = input("Nationality: ")
    attr["Gender"] = int(
        input("Enter Gender \n1 for Male \n2 for Female \n3 for Others\n4 for Unchanged\n ENTER HERE > "))

    if attr['Gender'] == 1:
        attr['Gender'] = 'Male'
    elif attr['Gender'] == 2:
        attr['Gender'] = 'Female'
    elif attr['Gender'] == 3:
        attr['Gender'] = 'Others'
    else:
        attr['Gender'] = ''
    attr["fk_to_airline_employer_IATA_code"] = input(
        "Airline employer IATA code: ")

    try_except_block(attr, key_attr, cur, con, table_name)

#done+++++
def update_airline_details(cur, con):
    # Update num_aircradfts_owned, is_active,country of ownership
    #print("inside update_airline_details function")
    table_name = "`Airline`"

    attr = {}

    key_attr = ["IATA airline designators"]

    attr['IATA airline designators'] = input('Enter 2-character IATA airline designator code * : ')

    print('Enter new details of the airline_crew entry: ')
    print("Press enter without typing any value if you do not want to update value of a particular attribute")

  

    tmp = int(input('Enter 1 if airline is active, 0 if inactive, 2 for unchanged\n ENTER HERE > '))

    if tmp == 1:
        attr['is_active'] = "1"
    elif tmp == 0:
        attr['is_active'] = "0"
    else:
        attr['is_active'] = ''

    attr['country_of_ownership'] = input(
        'Enter country of ownership of airline: ')

    try_except_block(attr, key_attr, cur, con, table_name)

#done++++++
def update_atc_freq(cur, con):
    #print("inside update_atc_freq function")
    table_name = "`air_traffic_controller`"

    attr = {}

    key_attr = ["fk_to_airport_crew_aadhar_card_number"]
    attr['fk_to_airport_crew_aadhar_card_number'] = input(
        'Aadhar card number of the employee: ')
    print('Enter new details of the air_traffic_controller: ')
    print("Press enter without typing any value if you do not want to update value of a particular attribute")
    attr['Current communication Frequency'] = input(
        "Current communication Frequency: ")

    try_except_block(attr, key_attr, cur, con, table_name)
