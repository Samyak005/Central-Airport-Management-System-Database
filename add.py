import datetime
import subprocess as sp
import pymysql
import pymysql.cursors


def part():
    print("-----------------------------------------------------------------")
    return


def part2():
    print("=====================================================================")
    return


def part3():
    print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
    return

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
    elif state == -1:
        print('The date entered cannot be before current date. Current date: ' + datetime.date.today())

def get_query_atoms(attr):
    keys_str = ""
    values_str = ""
    dict_len = len(attr.keys())
    i = -1

    for key, value in attr.items():

        i += 1
        if value == '' or value == 'NULL':
            continue

        keys_str += "`"+key+"`"
        values_str += '"'+value+'" '

        if i != dict_len-1:
            keys_str += ", "
            values_str += ", "

    return (keys_str, values_str)


def add_luggage(cur, con, barcode_number):
    print("inside luggage")
    table_name = "`luggage`"

    attr = {}
    print('Enter details of the new luggage:')

    attr["Baggage ID"] = input("Baggage ID")
    attr["fk_to_Barcode number"] = barcode_number

    keys_str, values_str = get_query_atoms(attr)
    print(keys_str)
    print(values_str)
    query_str = 'INSERT INTO '+table_name + \
        " ( "+keys_str+" ) VALUES"+" ( "+values_str+" );"

    print("query str is %s->", query_str)

    try:
        cur.execute(query_str)
        return 0

    except Exception as e:
        print('Failed to insert into the database.')
        con.rollback()
        print(e)
        input('Press any key to continue.')
        return -1


def add_emer_contact(cur, con, aadhar_relative):

    print("inside emer_contact_func")
    table_name = "`emer_contact`"

    attr = {}
    print('Enter details of the emer_contact entry:')
    attr['fk_to_passenger_Aadhar_card_number'] = aadhar_relative
    attr["name"] = input('Name*: ')

    attr['Phone No'] = input('Phone No: ')

    keys_str, values_str = get_query_atoms(attr)
    print(keys_str)
    print(values_str)
    query_str = 'INSERT INTO '+table_name + \
        " ( "+keys_str+" ) VALUES"+" ( "+values_str+" );"

    print("query str is %s->", query_str)

    try:
        cur.execute(query_str)
        return 0

    except Exception as e:
        print('Failed to insert into the database.')
        con.rollback()
        print(e)
        input('Press any key to continue.')
        return -1


def add_airline(cur, con):
    print("inside add_airline function")
    table_name = "`Airline`"

    attr = {}
    print('Enter details of the new airline:')

    attr['IATA airline designators'] = input(
        'Enter 2-character IATA airline designator code * :')

    attr['Company Name'] = input('Enter airline name *: ')

    attr['num_aircrafts_owned'] = input(
        'Enter number of aircrafts currently owned by the airline: ')

    tmp = input('Enter 1 if airline is active, 0 otherwise: ')

    if tmp == 1:
        attr['is_active'] = True
    elif tmp == 0:
        attr['is_active'] = False
        

    attr['country_of_ownership'] = input('Enter country of ownership of airline: ')

    keys_str, values_str = get_query_atoms(attr)

    print('Table Name:' + keys_str)
    print(values_str)

    query_str = 'INSERT INTO '+table_name + \
        " ( "+keys_str+" ) VALUES"+" ( "+values_str+" );"

    print("query str is %s->", query_str)

    try:
        cur.execute(query_str)
        con.commit()

    except Exception as e:
        print('Failed to insert into the database.')
        con.rollback()
        print(e)
        input('Press any key to continue.')
        return


def add_aircraft(cur, con):
    print("inside add_aircraft function")
    table_name = "`Aircraft`"

    attr = {}
    print('Enter details of the new aircraft: ')

    attr['registration_num'] = input("Enter registration number of aircraft: ")
    attr['fk_to_capacity_Manufacturer'] = input(
        "Enter manufacturer of aircraft: ")
    attr['fk_to_capacity_Model'] = input("Enter model of aircraft: ")
    attr['Distance Travelled'] = input("Enter distance travelled: ")
    attr['Flight ID'] = input("Enter Flight ID: ")
    attr['Maintanence check date'] = input(
        "Enter maintanence check date: [YYYY-MM-DD]: ")
    if date_more_cur(attr['Maintanence check date']) == 1:
        print_err_date(1)
        con.rollback()
        return
    attr['fk_to_airline_owner_airline_IATA_code'] = input(
        "Enter IATA code of owner airline: ")

    keys_str, values_str = get_query_atoms(attr)
    print(keys_str)
    print(values_str)
    query_str = 'INSERT INTO '+table_name + \
        " ( "+keys_str+" ) VALUES"+" ( "+values_str+" );"

    print("query str is %s->", query_str)

    try:
        cur.execute(query_str)
        con.commit()

    except Exception as e:
        print('Failed to insert into the database.')
        con.rollback()
        print(e)
        input('Press any key to continue.')
        return
    
    query_str2 = 'UPDATE Airline SET num_aircrafts_owned = num_aircrafts_owned + 1 WHERE fk_to_airline_owner_airline_IATA_code = `IATA airline designators`'
    try:
        cur.execute(query_str2)
        con.commit()

    except Exception as e:
        print('Failed to increment number of aricrafts owned by airline the database.')
        con.rollback()
        print(e)
        input('Press any key to continue.')
        return


def add_passenger(cur, con):
    print("inside add_passenger function")
    table_name = "`Passenger`"

    attr = {}
    print('Enter details of the new passenger: ')

    attr["Aadhar_card_number"] = input(
        "Enter aadhar card number 12 digit number: ")

    tmp_name = input("Enter name: ")

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
        print('Error: Incorrect format of name entered')
        input('Press any key to continue.')
        return

    attr["DOB"] = input("Enter Date of birth in format YYYY-MM-DD: ")
    if date_more_cur(attr['DOB']) == 1:
        print_err_date(1)
        con.rollback()
        return

    attr["Gender"] = input("Enter \n1. Male \n2. Female \n3. Others\n")

    if attr['Gender'] == 1:
        attr['Gender'] = 'Male'
    elif attr['Gender'] == 2:
        attr['Gender'] = 'Female'
    elif attr['Gender'] == 3:
        attr['Gender'] = 'Others'
    else:
        print("Invalid number inserted. Please try again")
        con.rollback()
        return

    attr["House Number"] = input("Enter house number of residence: ")
    attr["Building"] = input("Enter building number of residence: ")
    attr["City"] = input("Enter city of residence: ")
    attr["Email-ID"] = input("Enter email-ID: ")
    attr["Senior Citizen"] = input(
        "Enter 0. non senior citizen\n 1. senior citizen\n")
    attr["Nationality"] = input("Enter nationality of passenger eg.Indian: ")

    num_emer_contacts = int(
        input("Enter number of emergency contacts you want to add between 0 and 3: "))
    if num_emer_contacts > 3:
        print("Only upto 3 contacts allowed")
    else:
        for i in range(num_emer_contacts):
            if add_emer_contact(cur, con, attr["Aadhar_card_number"]) == -1:
                return

    keys_str, values_str = get_query_atoms(attr)
    print(keys_str)
    print(values_str)
    query_str = 'INSERT INTO '+table_name + \
        " ( "+keys_str+" ) VALUES"+" ( "+values_str+" );"

    print("query str is %s->", query_str)

    try:
        cur.execute(query_str)
        con.commit()

    except Exception as e:
        print('Failed to insert into the database.')
        con.rollback()
        print(e)
        input('Press any key to continue.')
        return


def add_airport(cur, con):
    print("inside add_airport function")
    table_name = "`Airport`"

    attr = {}
    print('Enter details of the new airport: ')

    attr["IATA airport codes"] = input(" Enter 3 character IATA code * ")
    attr["Altitude"] = input(" Enter in metres: ")

    ######################################################
    attr["Time Zone"] = input(
        " Enter in +hh:mm or -hh:mm format , note mm has to be between 0 and 60 and divisible by 15, hh between +12 and -12 ")
    ########################################################

    attr["Airport Name"] = input("Enter name of airport: ")
    attr["City"] = input("Enter city where airport is situated: ")
    attr["Country"] = input("Enter country where airport is situated: ")

    attr["Latitude"] = input("Enter latitude")
    if float(attr['Latitude']) > 90 or float(attr['Latitude']) < -90:
        print("ERROR : Invalid latitudes")
        return

    attr["Longitude"] = input("Enter longitude")
    if float(attr['Longitude']) > 180 or float(attr['Longitude']) < -180:
        print("ERROR : Invalid longitudes")
        return

    keys_str, values_str = get_query_atoms(attr)
    print(keys_str)
    print(values_str)
    query_str = 'INSERT INTO '+table_name + \
        " ( "+keys_str+" ) VALUES"+" ( "+values_str+" );"

    print("query str is %s->", query_str)

    try:
        cur.execute(query_str)
        con.commit()

    except Exception as e:
        print('Failed to insert into the database.')
        con.rollback()
        print(e)
        input('Press any key to continue.')
        return


def add_runway(cur, con):
    print("inside add_runway function")
    table_name = "`Runway`"

    attr = {}
    print('Enter details of the new runway: ')

    attr["fk_to_airport_IATA_airport_codes"] = input(
        "Enter IATA airport code of corresponding airport: ")
    attr["Runway ID"] = input("Enter runway ID: ")
    attr["length_ft"] = input("Enter length in feet: ")
    attr["width_ft"] = input("Enter width in feet: ")

    ################DISPLAY A MENU HERE########################################
    stat_choice = int(
        input("Enter status 1. assigned\n 2. available\n 3. disfunctional\n"))

    attr["Status"] = ""
    if stat_choice == 1:
        attr["Status"] = 'Assigned'
    elif stat_choice == 2:
        attr["Status"] = 'Available'
    elif stat_choice == 3:
        attr["Status"] = 'Disfunctional'

    ######################################################

    keys_str, values_str = get_query_atoms(attr)
    print(keys_str)
    print(values_str)
    query_str = 'INSERT INTO '+table_name + \
        " ( "+keys_str+" ) VALUES"+" ( "+values_str+" );"

    print("query str is %s->", query_str)

    try:
        cur.execute(query_str)
        con.commit()

    except Exception as e:
        print('Failed to insert into the database.')
        con.rollback()
        print(e)
        input('Press any key to continue.')
        return


def add_terminal(cur, con):
    print("inside add_terminal function")
    table_name = "`Terminal`"

    attr = {}
    print('Enter details of the new terminal: ')

    attr["fk_to_airport_IATA_airport_codes"] = input(
        "Enter IATA code of corresponding airport: ")
    attr["Terminal ID"] = input("Enter Terminal ID: ")
    attr["Airplane Handling capacity"] = input(
        "Enter airplane handling capacity: ")
    attr["Floor Area"] = input("Enter floor area: ")

    keys_str, values_str = get_query_atoms(attr)
    print(keys_str)
    print(values_str)
    query_str = 'INSERT INTO '+table_name + \
        " ( "+keys_str+" ) VALUES"+" ( "+values_str+" );"

    print("query str is %s->", query_str)

    try:
        cur.execute(query_str)
        con.commit()

    except Exception as e:
        print('Failed to insert into the database.')
        con.rollback()
        print(e)
        input('Press any key to continue.')
        return


def add_route(cur, con):

    print("inside add_Route function")
    table_name = "`Route`"

    attr = {}
    print('Enter details of the new route: ')

    attr['Route ID'] = input('Route ID: ')
    attr['fk_to_airport_src_iata_code'] = input('source airport iata code: ')
    attr['fk_to_airport_dest_iata_code'] = input(
        'Destination airport iata code: ')
    attr['Date'] = input('Date: [YYYY-MM-DD] (Press enter for today\'s date: ')

    if attr['Date'] == '':
        attr['Date'] = datetime.now().strftime('%Y-%m-%d')

    if date_less_cur(attr['Date']) == 1:
        print_err_date(-1)
        con.rollback()
        return

    attr['Scheduled arrival'] = input(
        'Scheduled arrival (Press enter if information not available): [HH:MM]: ')
    attr['Scheduled Departure'] = input(
        'Scheduled Departure: [HH:MM (Press enter if information not available): ')
    attr['Time duration'] = input(
        'Time duration (Press enter if information not available): [HH:MM]: ')
    attr['fk_to_runway_Take off runway id'] = input(
        'Take off runway id (Press enter if information not available): ')
    attr['Distance Travelled'] = input(
        'Distance Travelled (Press enter if information not available): ')
    attr['fk_to_runway_Landing runway ID'] = input(
        'Landing runway ID (Press enter if information not available): ')
    attr['fk_to_aircraft_registration_num'] = input(
        'aircraft registration number (Press enter if information not available): ')
    attr['Status'] = input(
        'Current_Status: [Departed, Boarding, On_route, Delayed, Arrived, Check-in, Not_applicable]: ')

    num_stopover = input('Enter number of stopover airports encountered in the route: ')
    for i in range(num_stopover):
        if add_stopover_airports(cur,con,attr['Route ID'])==-1:
            return
        
    ####################################################################

    # ADD CREW

    ###################################################################

    

    keys_str, values_str = get_query_atoms(attr)
    print(keys_str)
    print(values_str)
    query_str = 'INSERT INTO '+table_name + \
        " ( "+keys_str+" ) VALUES"+" ( "+values_str+" );"

    print("query str is %s->", query_str)

    try:
        cur.execute(query_str)
        con.commit()

    except Exception as e:
        print('Failed to insert into the database.')
        con.rollback()
        print(e)
        input('Press any key to continue.')
        return


def add_stopover_airports(cur,con,route_id):
    print("inside stopover_airports function")
    table_name = "`stopover_airports_on_route`"

    attr = {}
    print('Enter details of the new stopover airport: ')

    attr['fk_route_id'] = route_id
    attr['fk_iata_stopover_airport'] = input("Enter iata code of stopover airport: ")


    keys_str, values_str = get_query_atoms(attr)
    print(keys_str)
    print(values_str)
    query_str = 'INSERT INTO '+table_name + \
        " ( "+keys_str+" ) VALUES"+" ( "+values_str+" );"

    print("query str is %s->", query_str)

    try:
        cur.execute(query_str)
        #con.commit()
        return 0


    except Exception as e:
        print('Failed to insert into the database.')
        con.rollback()
        print(e)
        input('Press any key to continue.')
        return -1

#################################################################################################
def add_pnr_info_deduction(cur, con, pnr_of_boarding_pass):
    table_name = "`PNR info deduction`"

    attr = {}
    print('Enter details of the PNR info deduction: ')

    #########################################################################################
    attr["PNR_number"] = pnr_of_boarding_pass
    attr["fk_to_route_Route ID"] = input("Enter Route ID")
    attr["Scheduled Boarding Time"] = input("Enter schdeuled boarding time allotted to you based \
            on your seat, class of travel, if you are senior citizen/VIP etc.")
    attr["class_of_travel"] = input("Enter Travel class business/economy")
    attr["fk_to_airport_src_iata_code"] = input(
        "Enter source airport IATA code")

    ########################################################################
    keys_str, values_str = get_query_atoms(attr)
    print(keys_str)
    print(values_str)
    query_str = 'INSERT INTO '+table_name + \
        " ( "+keys_str+" ) VALUES"+" ( "+values_str+" );"

    print("query str is %s->", query_str)

    try:
        cur.execute(query_str)
        return 0

    except Exception as e:
        print('Failed to insert into the database.')
        con.rollback()
        print(e)
        input('Press any key to continue.')
        return -1


def add_special_services(cur, con, barcode_number, special_service_to_add):
    print("inside special_services")
    table_name = "`special_services`"

    attr = {}
    print('Enter details of the new special_services: ')

    attr["fk_Barcode number"] = barcode_number
    attr["Special services"] = special_service_to_add

    keys_str, values_str = get_query_atoms(attr)
    print(keys_str)
    print(values_str)
    query_str = 'INSERT INTO '+table_name + \
        " ( "+keys_str+" ) VALUES"+" ( "+values_str+" );"

    print("query str is %s->", query_str)

    try:
        cur.execute(query_str)
        return 0

    except Exception as e:
        print('Failed to insert into the database.')
        con.rollback()
        print(e)
        input('Press any key to continue.')
        return -1


def add_boarding_pass_details(cur, con):
    print("inside add_boarding pass function")
    table_name = "`boarding_pass`"

    attr = {}
    print('Enter details of the Boarding pass entry: ')

    attr["Barcode number"] = input(
        "Enter 12 char boarding pass barcode number")
    attr["fk_PNR_number"] = input(
        "Enter PNR number to which boarding pass belongs")
    attr["Seat"] = input("Enter seat")
    attr["fk_to_passenger_Aadhar_card_number"] = input(
        "Enter 12 digit Aadhar Card Number")

    #############################################################################################
    num_luggages = int(
        input("Enter number of luggages you want to link to this boarding pass: "))
    for i in range(num_luggages):
        if add_luggage(cur, con, attr["Barcode number"]) == -1:
            return

    ##########################################################################################
    add_more_details = int(input('''
    Press 1 if you want to add additional details like class_of_travel, Src airport etc.,
    \n
    Press 0 if you have already added these details for another boarding pass on the same PNR'''))

    if add_more_details == 1:
        if add_pnr_info_deduction(cur, con, attr["fk_PNR_number"]) == -1:
            return

    #########################################################################################
    #############################################################################################
    print("List of available special services that can be added are \nA. Wheelchair \nB. Disability Assistance \nC. XL seats \nD. Priority Boarding\n")
    ss_dict = {
        "A": "Wheelchair",
        "B": "Disability Assistance",
        "C": "XL seats",
        "D": "Priority Boarding"
    }
    ss_str = input(
        "Enter special services\nEg: enter AC for Wheelchair and XL seats: ")
    for i in range(len(ss_str)):
        add_ss = ss_dict[ss_str[i]]
        if add_special_services(cur, con, attr["Barcode number"], add_ss) == -1:
            return

    ##########################################################################################

    keys_str, values_str = get_query_atoms(attr)
    print(keys_str)
    print(values_str)
    query_str = 'INSERT INTO '+table_name + \
        " ( "+keys_str+" ) VALUES"+" ( "+values_str+" );"

    print("query str is %s->", query_str)

    try:
        cur.execute(query_str)
        con.commit()

    except Exception as e:
        print('Failed to insert into the database.')
        con.rollback()
        print(e)
        input('Press any key to continue.')
        return


#######################################################################################

def add_on_ground_emp(cur, con, aadhar_num):

    print("inside add_on_ground_emp")
    table_name = "`On-ground`"

    attr = {}
    print('Enter details of the add_on_ground_emp: ')
    attr['fk_to_airline_crew_Aadhar_card_number'] = aadhar_num
    attr['Job title'] = input("Job title: ")

    keys_str, values_str = get_query_atoms(attr)
    print(keys_str)
    print(values_str)
    query_str = 'INSERT INTO '+table_name + \
        " ( "+keys_str+" ) VALUES"+" ( "+values_str+" );"

    print("query str is %s->", query_str)

    try:
        cur.execute(query_str)
        return 0

    except Exception as e:
        print('Failed to insert into the database.')
        con.rollback()
        print(e)
        input('Press any key to continue.')
        return -1


def add_pilot(cur, con, aadhar_num):

    print("inside Pilot")
    table_name = "`Pilot`"

    attr = {}
    print('Enter details of the Pilot: ')
    attr['fk_to_flight_crew_Aadhar_card_number'] = aadhar_num
    attr["Pilot license number"] = input("Enter Pilot license number: ")
    attr["Number of flying hours"] = input("Enter number of flying hours: ")

    #########################################################################
    keys_str, values_str = get_query_atoms(attr)
    print(keys_str)
    print(values_str)
    query_str = 'INSERT INTO '+table_name + \
        " ( "+keys_str+" ) VALUES"+" ( "+values_str+" );"

    print("query str is %s->", query_str)

    try:
        cur.execute(query_str)
        return 0

    except Exception as e:
        print('Failed to insert into the database.')
        con.rollback()
        print(e)
        input('Press any key to continue.')
        return -1


def add_flight_attendant(cur, con, aadhar_num):

    print("inside flight_attendant")
    table_name = "`flight_attendant`"

    attr = {}
    print('Enter details of the flight_attendant: ')
    attr['fk_to_flight_crew_Aadhar_card_number'] = aadhar_num
    attr["Training/Education"] = input("Enter Training: ")

    #########################################################################
    keys_str, values_str = get_query_atoms(attr)
    print(keys_str)
    print(values_str)
    query_str = 'INSERT INTO '+table_name + \
        " ( "+keys_str+" ) VALUES"+" ( "+values_str+" );"

    print("query str is %s->", query_str)

    try:
        cur.execute(query_str)
        return 0

    except Exception as e:
        print('Failed to insert into the database.')
        con.rollback()
        print(e)
        input('Press any key to continue.')
        return -1


def add_flight_engineer(cur, con, aadhar_num):

    print("inside flight_engineer")
    table_name = "`flight_engineer`"

    attr = {}
    print('Enter details of the flight_engineer: ')
    attr['fk_to_flight_crew_Aadhar_card_number'] = aadhar_num
    attr["Education"] = input("Enter Education: ")
    attr["Manufacturer"] = input(
        "Enter manufacturer of plane he specializes in: ")
    attr["Model"] = input("Enter model of plane he specializes in: ")

    #########################################################################
    keys_str, values_str = get_query_atoms(attr)
    print(keys_str)
    print(values_str)
    query_str = 'INSERT INTO '+table_name + \
        " ( "+keys_str+" ) VALUES"+" ( "+values_str+" );"

    print("query str is %s->", query_str)

    try:
        cur.execute(query_str)
        return 0

    except Exception as e:
        print('Failed to insert into the database.')
        con.rollback()
        print(e)
        input('Press any key to continue.')
        return -1


def add_flight_crew(cur, con, aadhar_num):

    print("inside flight_crew")
    table_name = "`flight_crew`"

    attr = {}
    print('Enter details of the flight_crew:')
    attr['fk_to_airline_crew_Aadhar_card_number'] = aadhar_num

    #########################################################################
    print('''
    Press 1 to add pilot
    \n
    Press 2 to add flight attendant
    \n
    Press 3 to add flight engineer''')

    emp_class = int(input())

    if emp_class == 1:
        if add_pilot(cur, con, attr["fk_to_airline_crew_Aadhar_card_number"]) == -1:
            return -1
    elif emp_class == 2:
        if add_flight_attendant(cur, con, attr["fk_to_airline_crew_Aadhar_card_number"]) == -1:
            return -1
    else:
        if add_flight_engineer(cur, con, attr["fk_to_airline_crew_Aadhar_card_number"]) == -1:
            return -1

    #########################################################################
    keys_str, values_str = get_query_atoms(attr)
    print(keys_str)
    print(values_str)
    query_str = 'INSERT INTO '+table_name + \
        " ( "+keys_str+" ) VALUES"+" ( "+values_str+" );"

    print("query str is %s->", query_str)

    try:
        cur.execute(query_str)
        return 0

    except Exception as e:
        print('Failed to insert into the database.')
        con.rollback()
        print(e)
        input('Press any key to continue.')
        return -1


def add_language(cur, con, aadhar_num):
    print("inside Languages spoken by airline employee")
    table_name = "`Languages spoken by airline employee`"

    attr = {}
    attr["fk_Aadhar_card_number"] = aadhar_num
    attr["Language_name"] = input(
        'Enter details of the Language spoken by the airline employee:')

    keys_str, values_str = get_query_atoms(attr)
    print(keys_str)
    print(values_str)
    query_str = 'INSERT INTO '+table_name + \
        " ( "+keys_str+" ) VALUES"+" ( "+values_str+" );"

    try:
        cur.execute(query_str)
        return 0

    except Exception as e:
        print('Failed to insert into the database.')
        con.rollback()
        print(e)
        input('Press any key to continue.')
        return -1


def add_airline_crew(cur, con):

    print("inside airline_crew")
    table_name = "`airline_crew`"

    attr = {}
    print('Enter details of the airline_crew entry:')

    attr["Aadhar_card_number"] = input("Aadhar_card_number: ")

    tmp_name = input("Enter name")

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
        print('Error: Incorrect format of name entered')
        input('Press any key to continue.')
        return

    attr["Number of years of Experience"] = input(
        "Number of years of Experience: ")
    attr["Salary"] = input("Salary: ")
    attr["Nationality"] = input("Nationality: ")
    attr["DOB"] = input("DOB: [YYYY-MM-DD]")
    if date_more_cur(attr['DOB']) == 1:
        print_err_date(1)
        con.rollback()
        return
    attr["Gender"] = input("Gender: [Male, Female, Others]")
    attr["fk_to_airline_employer_IATA_code"] = input(
        "Airline employer IATA code:")

    num_lang = input('Number of languages spoken by the employee: ')
    for i in range(num_lang):
        if add_language(cur, con, attr['Aadhar_card_number']) == -1:
            return

    #############################################################################
    print('''
    Press 1 if employee is part of FLIGHT CREW
    \n
    Press 2 if employee is part of On-ground team''')

    emp_class = int(input())

    if emp_class == 1:
        if add_on_ground_emp(cur, con, attr["Aadhar_card_number"]) == -1:
            return
    else:
        if add_flight_crew(cur, con, attr["Aadhar_card_number"]) == -1:
            return

    #########################################################################

    keys_str, values_str = get_query_atoms(attr)
    print(keys_str)
    print(values_str)
    query_str = 'INSERT INTO '+table_name + \
        " ( "+keys_str+" ) VALUES"+" ( "+values_str+" );"

    print("query str is %s->", query_str)

    try:
        cur.execute(query_str)
        con.commit()

    except Exception as e:
        print('Failed to insert into the database.')
        con.rollback()
        print(e)
        input('Press any key to continue.')
        return


#########################################################################################################

def add_air_traffic_controller(cur, con, aadhar_num):

    print("inside air_traffic_controller")
    table_name = "`air_traffic_controller`"

    attr = {}
    print('Enter details of the air_traffic_controller: ')
    attr['fk_to_airport_crew_aadhar_card_number'] = aadhar_num
    attr['Current communication Frequency'] = input(
        "Current communication Frequency: ")
    attr['Training/Education'] = input("Training/Education: ")

    keys_str, values_str = get_query_atoms(attr)
    print(keys_str)
    print(values_str)
    query_str = 'INSERT INTO '+table_name + \
        " ( "+keys_str+" ) VALUES"+" ( "+values_str+" );"

    print("query str is %s->", query_str)

    try:
        cur.execute(query_str)
        return 0

    except Exception as e:
        print('Failed to insert into the database.')
        con.rollback()
        print(e)
        input('Press any key to continue.')
        return -1


def add_mo_executives(cur, con, aadhar_num):

    print("inside mo_executives")
    table_name = "`mo_executives`"

    attr = {}
    print('Enter details of the mo_executives: ')
    attr['fk_to_airline_crew_Aadhar_card_number'] = aadhar_num
    attr['Job title'] = input("Job title: ")

    keys_str, values_str = get_query_atoms(attr)
    print(keys_str)
    print(values_str)
    query_str = 'INSERT INTO '+table_name + \
        " ( "+keys_str+" ) VALUES"+" ( "+values_str+" );"

    print("query str is %s->", query_str)

    try:
        cur.execute(query_str)
        return 0

    except Exception as e:
        print('Failed to insert into the database.')
        con.rollback()
        print(e)
        input('Press any key to continue.')
        return -1


def add_security(cur, con, aadhar_num):

    print("inside security")
    table_name = "`Security`"

    attr = {}
    print('Enter details of the security: ')
    attr['fk_to_airline_crew_Aadhar_card_number'] = aadhar_num
    attr['Designation'] = input("Designation: ")
    attr['Security ID number'] = input("Security ID number: ")

    keys_str, values_str = get_query_atoms(attr)
    print(keys_str)
    print(values_str)
    query_str = 'INSERT INTO '+table_name + \
        " ( "+keys_str+" ) VALUES"+" ( "+values_str+" );"

    print("query str is %s->", query_str)

    try:
        cur.execute(query_str)
        return 0

    except Exception as e:
        print('Failed to insert into the database.')
        con.rollback()
        print(e)
        input('Press any key to continue.')
        return -1


def add_airport_crew(cur, con):

    print("inside airport_crew")
    table_name = "`Airport Employees/CREWS`"

    attr = {}
    print('Enter details of the airport_crew entry: ')

    attr["Aadhar_card_number"] = input("Aadhar card number: ")

    tmp_name = input("Enter name: ")

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
        print('Error: Incorrect format of name entered')
        input('Press any key to continue.')
        return

    attr["Experience"] = input("Experience")
    attr["Salary"] = input("Salary")
    attr["Nationality"] = input("Nationality")
    attr["DOB"] = input("DOB: [YYYY-MM-DD]")
    if date_more_cur(attr['DOB']) == 1:
        print_err_date(1)
        con.rollback()
        return
    attr["Gender"] = input("Gender")
    attr["fk_to_airport_IATA_code_of_employing_airport"] = input(
        "airport IATA code of employing airport")
    attr["sup_Aadhar_card_number"] = input("Supervisior's Aadhar card number:")

    #############################################################################
    print('''
    Press 1 if employee is Air traffic controller
    \n
    Press 2 if employee is part of Management
    \n
    Press 3 if employee is part of Security''')

    emp_class = int(input())

    if emp_class == 1:
        if add_air_traffic_controller(cur, con, attr["Aadhar_card_number"]) == -1:
            return
    elif emp_class == 2:
        if add_mo_executives(cur, con, attr["Aadhar_card_number"]) == -1:
            return
    else:
        if add_security(cur, con, attr["Aadhar_card_number"]) == -1:
            return

    #########################################################################

    keys_str, values_str = get_query_atoms(attr)
    print(keys_str)
    print(values_str)
    query_str = 'INSERT INTO '+table_name + \
        " ( "+keys_str+" ) VALUES"+" ( "+values_str+" );"

    print("query str is %s->", query_str)

    try:
        cur.execute(query_str)
        con.commit()

    except Exception as e:
        print('Failed to insert into the database.')
        con.rollback()
        print(e)
        input('Press any key to continue.')
        return