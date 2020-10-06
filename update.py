import subprocess as sp
import pymysql
import pymysql.cursors
import datetime

def prRed(skk): print("\033[91m {}\033[00m" .format(skk)) 
def prGreen(skk): print("\033[92m {}\033[00m" .format(skk)) 
def prYellow(skk): print("\033[93m {}\033[00m" .format(skk)) 
def prLightPurple(skk): print("\033[94m {}\033[00m" .format(skk)) 
def prPurple(skk): print("\033[95m {}\033[00m" .format(skk)) 
def prCyan(skk): print("\033[96m {}\033[00m" .format(skk)) 
def prLightGray(skk): print("\033[97m {}\033[00m" .format(skk)) 
def prBlack(skk): print("\033[98m {}\033[00m" .format(skk)) 


def date_less_cur(str):
    today_date = datetime.date.today()
    today_date_str = today_date.strftime("%Y-%m-%d")

    if str < today_date_str:
        return 1
    else:
        return 0

def date_more_cur(str):
    today_date = datetime.date.today()
    today_date_str = today_date.strftime("%Y-%m-%d")

    if str > today_date_str:
        return 1
    else:
        return 0

def print_err_date(state):
    if state == 1:
        print('The date entered cannot be after current date. Current date: ' + datetime.date.today())
    else state == -1:
        print('The date entered cannot be before current date. Current date: ' + datetime.date.today())

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

        query_str += key+" = "+value

        if i != dict_len-1:
            query_str += ", "

    return query_str

def get_selection_equation(attr, key_attr):
    
    query_str = ""
    list_len = len(key_attr)
    i = -1

    for key in key_attr:
        i += 1
                
        if value == '':
            return ""

        query_str += key+" = "+attr[key]

        if i != list_len-1:
            query_str += " AND "

    return query_str

def try_except_block(attr, key_attr, cur, con):
    try:
        set_values=get_updation_equation(attr, key_attr)
        if set_values=="":
            print("Some value must be updated")
            print("Failed to update database")
            input("Press any key to continue")
            return
        
        cond_values=get_selection_equation(attr,key_attr)
        if cond_values=="":
            print("Value of the key attributes cannot be NULL")
            print("Failed to update database")
            input("Press any key to continue")
            return

        query_str = "UPDATE "+table_name+" SET "+set_values+" WHERE "+cond_values+" ; "
        print(query_str)
        cur.execute(query_str)
        con.commit()
        print('Updation successful')
        return
    
    except Exception as e:
        print('Failed to update the database.')
        con.rollback()
        print(e)
        input('Press any key to continue.')
        return    


def update_passenger(cur, con):
    print("Inside update_passenger func")
    table_name="Passenger"

    attr={}

    attr["Aadhar_card_number"] = input("Enter Aadhar card number of the passenger you want to update: ")
    print("Press enter without entering any value if you don't want to update a particular value")
    tmp_name = input("Enter new name")

    key_attr = ["Aadhar_card_number"]

    name_list = tmp_name.split(' ')

    if len(tmp_name) >= 3:
        attr['First Name'] = tmp_name[0]
        attr['Middle Name'] = ' '.join(tmp_name[1:-1])
        attr['Last Name'] = tmp_name[-1]
    elif len(tmp_name) == 2:
        attr['First Name'] = tmp_name[0]
        attr['Middle Name'] = ''
        attr['Last Name'] = tmp_name[1]
    elif len(tmp_name) == 1:
        attr['First Name'] = tmp_name[0]
        attr['Middle Name'] = ''
        attr['Last Name'] = ''
    else:
        attr['First Name'] = ''
        attr['Middle Name'] = ''
        attr['Last Name'] = ''
    
    attr["Gender"] = input("Enter Gender \n1. Male \n2. Female \n3. Others\n")

    if attr['Gender'] == 1:
        attr['Gender'] = 'Male'
    elif attr['Gender'] == 2:
        attr['Gender'] = 'Female'
    elif attr['Gender'] == 3:
        attr['Gender'] = 'Others'
    else attr['Gender'] = ''
    
    attr["House Number"] = input("Enter new house number of residence")
    attr["Building"] = input("Enter new building number of residence")
    attr["City"] = input("Enter new city of residence")

    try_except_block(attr, key_attr, cur, con)

def update_aircraft(cur, con):
    print("inside update_aircraft function")
    table_name = "`Aircraft`"

    attr = {}

    key_attr = ["registration_num"]

    attr['registration_num'] = input("Enter registration number of aircraft")
    print("Press enter  without entering any value if you don't want to update a particular value")
    print('Enter updated details of the aircraft:')
    attr['Flight ID'] = input("Enter updated Flight ID")
    attr['Maintanence check date'] = input(
        "Enter maintanence check date: [YYYY-MM-DD]")
    if date_more_cur(attr['Maintanence check date']) == 1:
        print_err_date(1)
        con.rollback()
        return
    attr['fk_to_airline_owner_airline_IATA_code'] = input(
        "Enter IATA code of owner airline")

    try_except_block(attr, key_attr, cur, con)
    
    
    
def update_airport(cur, con):
    print("inside update_airport function")
    table_name = "`Airport`"

    attr = {}

    key_attr = ["IATA airport codes"]
    
    print('Enter details of the new airport:')

    attr["IATA airport codes"] = input(" Enter 3 character IATA code * ")
    print("Press enter  without entering any value if you don't want to update a particular value")
    
    attr["Airport Name"] = input("Enter the new name of airport")

    try_except_block(attr, key_attr, cur, con)
    
    

def update_runway_status(cur, con):
    print("inside update_runway_status function")
    table_name = "`Runway`"

    attr = {}

    key_attr = ["fk_to_airport_IATA_airport_codes", "Runway ID"]
    
    attr["fk_to_airport_IATA_airport_codes"] = input(
        "Enter IATA airport code of corresponding airport")
    attr["Runway ID"] = input("Enter runway ID")
    print("Press enter  without entering any value if you don't want to update a particular value")

    stat_choice = int(
        input("Enter status 1. assigned\n 2. available\n 3. disfunctional\n"))

    attr["Status"] = ""
    if stat_choice == 1:
        attr["Status"] = 'Assigned'
    elif stat_choice == 2:
        attr["Status"] = 'Available'
    elif stat_choice == 3:
        attr["Status"] = 'Disfunctional'
    else:
        attr["Status"] = ''

    try_except_block(attr, key_attr, cur, con)
    
    

def update_airport_crew(cur, con):
    #Name,yrs_exp, salary, nationality,employer, gender
    print("inside update_airport_crew function")
    table_name = "`Airport Employees/CREWS`"

    attr = {}

    key_attr = ["Aadhar_card_number"]

    attr["Aadhar_card_number"] = input("Aadhar card number of the employee you want to update: ")
    print("Press enter without entering any value if you don't want to update a particular value")

    tmp_name = input("Enter new name: ")

    name_list = tmp_name.split(' ')

    if len(tmp_name) >= 3:
        attr['First Name'] = tmp_name[0]
        attr['Middle Name'] = ' '.join(tmp_name[1:-1])
        attr['Last Name'] = tmp_name[-1]
    elif len(tmp_name) == 2:
        attr['First Name'] = tmp_name[0]
        attr['Middle Name'] = ''
        attr['Last Name'] = tmp_name[1]
    elif len(tmp_name) == 1:
        attr['First Name'] = tmp_name[0]
        attr['Middle Name'] = ''
        attr['Last Name'] = ''
    else:
        attr['First Name'] = ''
        attr['Middle Name'] = ''
        attr['Last Name'] = ''

    attr["Experience"] = input("New total number of years of Experience: ")
    attr["Salary"] = input("New Salary: ")
    attr["Nationality"] = input("New Nationality: ")
    attr["Gender"] = input("Enter Gender \n1. Male \n2. Female \n3. Others\n")

    if attr['Gender'] == 1:
        attr['Gender'] = 'Male'
    elif attr['Gender'] == 2:
        attr['Gender'] = 'Female'
    elif attr['Gender'] == 3:
        attr['Gender'] = 'Others'
    else attr['Gender'] = ''
    attr["fk_to_airport_IATA_code_of_employing_airport"] = input(
        "airport IATA code of employing airport: ")
    
    try_except_block(attr, key_attr, cur, con)




##############################################################################################
def update_route_details(cur, con):
    print("Inside update_route_details function")
    # NOTE: distance travelled should be updated in route
    table_name="Route"

    attr={}

    key_attr = ["Route ID"]

    attr["Route ID"]=input("Enter route id for which the information needs to be updated")
    

    print("Press enter without typing any value if you do not want to update value of a particular attribute")
    
    attr['Status']=input("Enter one of 'Departed', 'Boarding','On_route','Delayed','Arrived','Checking','Not_applicable' as the status")
    
    if attr['Status']=='Departed':
        print("Hey, user, don't forget to change status of the take-off runway to unoccupied :)")
        tmp_var=''
        tmp_var=input("Enter actual departure time of the flight in  [HH:MM] format")
        # attr["Actual departure time"]=input("Enter actual departure time of the flight in  [HH:MM] format")
        if tmp_var=='':
            print("ERROR: User failed to enter a non-empty input for ACTUAL FLIGHT departurel time")
            return
        else:
            attr["Actual departure time"]=tmp_var
    elif attr['Status']=='Arrived':
        print("Hey, user, don't forget to change status of the landing runway to unoccupied :)")
        tmp_var=''
        tmp_var=input("Enter actual arrival time of the flight in  [HH:MM] format")
        # attr["Actual departure time"]=input("Enter actual departure time of the flight in  [HH:MM] format")
        if tmp_var=='':
            print("ERROR: User failed to enter a non-empty input for ACTUAL FLIGHT arrival time")
            return
        else:
            attr["Actual arrival time"]=tmp_var
        
        tmp_var=''
        tmp_var=input("Enter total distance travelled by flight")
        # attr["Actual departure time"]=input("Enter actual departure time of the flight in  [HH:MM] format")
        if tmp_var=='':
            print("ERROR: User failed to enter OVERALL distance travelled")
            return
        else:
            attr["Distance Travelled"]=tmp_var

        #################################################################################################
            ## Add distance to aircraft
            ## Add flying hrs to both pilots
        ###############################################################################################
        
    
    attr["fk_to_runway_Take off runway id"]=input("Enter runway id which has been allotted for take_off")
    attr["k_to_runway_Landing runway ID"]=input("Enter runway id which has been allotted for LANDING")

    
    try_except_block(attr, key_attr, cur, con)
    
    
#Name,yrs_exp, salary, nationality,employer, gender

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

    if len(tmp_name) >= 3:
        attr['First Name'] = tmp_name[0]
        attr['Middle Name'] = ' '.join(tmp_name[1:-1])
        attr['Last Name'] = tmp_name[-1]
    elif len(tmp_name) == 2:
        attr['First Name'] = tmp_name[0]
        attr['Middle Name'] = ''
        attr['Last Name'] = tmp_name[1]
    elif len(tmp_name) == 1:
        attr['First Name'] = tmp_name[0]
        attr['Middle Name'] = ''
        attr['Last Name'] = ''
    else:
        attr['First Name'] = ''
        attr['Middle Name'] = ''
        attr['Last Name'] = ''

    attr["Number of years of Experience"] = input(
        "Updated Number of years of Experience: ")
    attr["Salary"] = input("Salary: ")
    attr["Nationality"] = input("Nationality: ")
    attr["Gender"] = input("Enter Gender \n1. Male \n2. Female \n3. Others\n")

    if attr['Gender'] == 1:
        attr['Gender'] = 'Male'
    elif attr['Gender'] == 2:
        attr['Gender'] = 'Female'
    elif attr['Gender'] == 3:
        attr['Gender'] = 'Others'
    else attr['Gender'] = ''
    attr["fk_to_airline_employer_IATA_code"] = input(
        "Airline employer IATA code: ")

    try_except_block(attr, key_attr, cur, con)

def update_airline_details(cur, con):
    #Update num_aircradfts_owned, is_active,country of ownership
    print("inside update_airline_details function")
    table_name = "`Airline`"

    attr = {}

    key_attr = ["IATA airline designators"]

    attr['IATA airline designators'] = input(
        'Enter 2-character IATA airline designator code * :')
    
    print('Enter new details of the airline_crew entry: ')
    print("Press enter without typing any value if you do not want to update value of a particular attribute")

    attr['num_aircrafts_owned'] = input(
        'Enter number of aircrafts currently owned by the airline: ')

    tmp = input('Enter 1 if airline is active, 0 if inactive and press enter if you don\'t want change its value: ')

    if tmp == 1:
        attr['is_active'] = True
    elif tmp == 0:
        attr['is_active'] = False
    else:
        attr['is_active'] = ''
        
    attr['country_of_ownership'] = input('Enter country of ownership of airline: ')

    try_except_block(attr, key_attr, cur, con)

def update_atc_freq(cur, con):
    print("inside update_atc_freq function")
    table_name = "`air_traffic_controller`"

    attr = {}

    key_attr = ["fk_to_airport_crew_aadhar_card_number"]
    attr['fk_to_airport_crew_aadhar_card_number'] = input('Aadhar card number of the employee')
    print('Enter new details of the air_traffic_controller: ')
    print("Press enter without typing any value if you do not want to update value of a particular attribute")
    attr['Current communication Frequency'] = input(
        "Current communication Frequency: ")

    try_except_block(attr, key_attr, cur, con)
