import subprocess as sp
import pymysql
import pymysql.cursors

from datetime import datetime

def part():
    print("-----------------------------------------------------------------")
    return

def part2():
    print("=====================================================================")
    return
def part3():
    print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
    return

def expand_keys(d):
    s = ''
    for key in d.keys():
        s = s + key + ', '

    if s[-2:] == ', ':
        return s[:-2]
    return s


def quote(s):
    if s == 'NULL':
        return s
    else:
        return '"' + s + '"'


def empty_to_null(s):
    if s == '':
        return 'NULL'
    else:
        return s

def get_query_atoms(attr):
    keys_str=""
    values_str=""
    dict_len=len(attr.keys())
    i=-1

    for key, value in attr.items():

        i+=1
        if value=='' or value=='NULL':
            continue

        keys_str+="`"+key+"`"
        values_str+='"'+value+'" '

        if i!=dict_len-1:
            keys_str+=", "
            values_str+=", "

    return (keys_str,values_str)

def add_airline(cur, con):
    print("inside add_airline function")
    table_name="`Airline`"

    attr = {}
    print('Enter details of the new airline:')

    attr['IATA airline designators'] = input('Enter 2-character IATA airline designator code * :')
    attr['Company Name'] = input('Enter airline name *: ')
    attr['num_aircrafts_owned'] = input('Enter number of aircrafts currently owned by the airline: ')
    attr['is_active'] = input('Enter 1 if airline is active, 0 otherwise :')
    attr['country_of_ownership'] = input('Enter country of ownership of airline')
    keys_str,values_str=get_query_atoms(attr)

    print(keys_str)
    print(values_str)
    query_str='INSERT INTO '+table_name+" ( "+keys_str+" ) VALUES"+" ( "+values_str+" );"

    print("query str is %s->",query_str)

    cur.execute(query_str)

    con.commit()





# def add_route(cur, con):
#     attr = {}
#     print('Enter details of the new route:')

#     attr['Route ID'] = input('Route ID: ')
#     attr['fk_to_airport_src_iata_code'] = input('source airport iata code: ')
#     attr['fk_to_airport_dest_iata_code'] = input('Destination airport iata code: ')
#     attr['Date'] = input('Date: [YYYY-MM-DD] (Press enter for today\'s date')
#     if attr['Date'] == '':
#         attr['Date'] = datetime.now().strftime('%Y-%m-%d')
#     attr['Scheduled arrival'] = empty_to_null(input('Scheduled arrival (Press enter if information not available): [HH:MM]'))
#     attr['Scheduled Departure'] = empty_to_null(input('Scheduled Departure: [HH:MM (Press enter if information not available):'))
#     attr['Time duration'] = empty_to_null(input('Time duration (Press enter if information not available): [HH:MM]'))
#     attr['fk_to_runway_Take off runway id'] = empty_to_null(input('Take off runway id (Press enter if information not available):'))
#     attr['Distance Travelled'] = empty_to_null(input('Distance Travelled (Press enter if information not available):'))
#     attr['fk_to_runway_Landing runway ID'] = empty_to_null(input('Landing runway ID (Press enter if information not available):'))
#     attr['fk_to_aircraft_registration_num'] = empty_to_null(input('aircraft registration number (Press enter if information not available):'))
#     attr['Status'] = input('Status: [Departed, Boarding, On_route, Delayed, Arrived, Checking, Not_applicable]')

# def add_boarding_pass(cur, con):
#     attr['Barcode number'] = input('Barcode number: ')
#     attr['PNR number'] = input('PNR number: ')
#     attr['Seat'] = input('Seat: ')
#     attr['fk_to_passenger_Aadhar_card_number'] = input('fk_to_passenger_Aadhar_card_number: ')
#     attr['fk_to_route_Route ID'] = input('fk_to_route_Route ID: ')
    
# def add_passenger(cur, con):
#     attr['Aadhar_card_number'] = input('Aadhar_card_number: ')
    
#     name = input('Name*: ').split(' ')
#     if len(name) >= 3:
#         attr['first_name'] = name[0]
#         attr['middle_name'] = ' '.join(name[1:-1])
#         attr['last_name'] = name[-1]
#     elif len(name) == 2:
#         attr['first_name'] = name[0]
#         attr['middle_name'] = ''
#         attr['last_name'] = name[1]
#     elif len(name) == 1:
#         attr['first_name'] = name[0]
#         attr['middle_name'] = ''
#         attr['last_name'] = ''
#     else:
#         print('Error: Please enter the prisoner\'s name')
#         input('Press any key to continue.')
#         return
    
#     attr['DOB'] = input('DOB: ')
#     attr['Gender'] = input('Gender: ')
#     attr['House Number'] = input('House Number: ')
#     attr['Building'] = input('Building: ')
#     attr['City'] = input('City: ')
#     attr['Email-ID'] = input('Email-ID: ')
#     attr['Senior Citizen'] = input('Senior Citizen: ')
#     attr['Nationality'] = input('Nationality: ')
    
# def add_emer_contact(cur, con):

#     name = input('Name*: ').split(' ')
#     if len(name) >= 3:
#         attr['first_name'] = name[0]
#         attr['middle_name'] = ' '.join(name[1:-1])
#         attr['last_name'] = name[-1]
#     elif len(name) == 2:
#         attr['first_name'] = name[0]
#         attr['middle_name'] = ''
#         attr['last_name'] = name[1]
#     elif len(name) == 1:
#         attr['first_name'] = name[0]
#         attr['middle_name'] = ''
#         attr['last_name'] = ''
#     else:
#         print('Error: Please enter the prisoner\'s name')
#         input('Press any key to continue.')
#         return
    
#     attr['Phone No'] = input('Phone No: ')
#     attr['fk_to_passenger_Aadhar_card_number'] = \
#         input('Aadhar card number: ')
 
#  def add_luggage(cur, con):
    
#     attr['Baggage ID'] = input('Baggage ID: ')
#     attr['fk_to_Barcode number'] = input('fk_to_Barcode number: ')
 
#  def add_aircraft(cur, con):
    
#     attr['registration_num'] = input('registration_num: ')
#     attr['fk_to_capacity_Manufacturer'] = input('fk_to_capacity_Manufacturer: ')
#     attr['fk_to_capacity_Manufacturer'] = input('fk_to_capacity_Manufacturer: ')
#     attr['fk_to_capacity_Manufacturer'] = input('fk_to_capacity_Manufacturer: ')
#     attr['fk_to_capacity_Manufacturer'] = input('fk_to_capacity_Manufacturer: ')
    