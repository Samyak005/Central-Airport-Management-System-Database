import subprocess as sp
import pymysql
import pymysql.cursors

from datetime import datetime


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

def add_route(cur, con):
    attr = {}
    print('Enter details of the new route:')

    attr['Route ID'] = input('Route ID: ')
    attr['fk_to_airport_src_iata_code'] = input('fk_to_airport_src_iata_code: ')
    attr['fk_to_airport_dest_iata_code'] = input('fk_to_airport_dest_iata_code: ')
    attr['Date'] = input('Date: ')
    attr['Scheduled arrival'] = input('Scheduled arrival: ')
    attr['Scheduled Departure'] = input('Scheduled Departure: ')
    attr['Time duration'] = input('Time duration: ')
    attr['fk_to_runway_Take off runway id'] = input('fk_to_runway_Take off runway id: ')
    attr['Distance Travelled'] = input('Distance Travelled: ')
    attr['fk_to_runway_Landing runway ID'] = input('fk_to_runway_Landing runway ID: ')
    attr['fk_to_aircraft_registration_num'] = input('fk_to_aircraft_registration_num: ')
    attr['Status'] = input('Status: ')

def add_boarding_pass(cur, con):
    attr['Barcode number'] = input('Barcode number: ')
    attr['PNR number'] = input('PNR number: ')
    attr['Seat'] = input('Seat: ')
    attr['fk_to_passenger_Aadhar_card_number'] = input('fk_to_passenger_Aadhar_card_number: ')
    attr['fk_to_route_Route ID'] = input('fk_to_route_Route ID: ')
    
def add_passenger(cur, con):
    attr['Aadhar_card_number'] = input('Aadhar_card_number: ')
    
    name = input('Name*: ').split(' ')
    if len(name) >= 3:
        attr['first_name'] = name[0]
        attr['middle_name'] = ' '.join(name[1:-1])
        attr['last_name'] = name[-1]
    elif len(name) == 2:
        attr['first_name'] = name[0]
        attr['middle_name'] = ''
        attr['last_name'] = name[1]
    elif len(name) == 1:
        attr['first_name'] = name[0]
        attr['middle_name'] = ''
        attr['last_name'] = ''
    else:
        print('Error: Please enter the prisoner\'s name')
        input('Press any key to continue.')
        return
    
    attr['DOB'] = input('DOB: ')
    attr['Gender'] = input('Gender: ')
    attr['House Number'] = input('House Number: ')
    attr['Building'] = input('Building: ')
    attr['City'] = input('City: ')
    attr['Email-ID'] = input('Email-ID: ')
    attr['Senior Citizen'] = input('Senior Citizen: ')
    attr['Nationality'] = input('Nationality: ')
    
def add_emer_contact(cur, con):

    name = input('Name*: ').split(' ')
    if len(name) >= 3:
        attr['first_name'] = name[0]
        attr['middle_name'] = ' '.join(name[1:-1])
        attr['last_name'] = name[-1]
    elif len(name) == 2:
        attr['first_name'] = name[0]
        attr['middle_name'] = ''
        attr['last_name'] = name[1]
    elif len(name) == 1:
        attr['first_name'] = name[0]
        attr['middle_name'] = ''
        attr['last_name'] = ''
    else:
        print('Error: Please enter the prisoner\'s name')
        input('Press any key to continue.')
        return
    
    attr['Phone No'] = input('Phone No: ')
    attr['fk_to_passenger_Aadhar_card_number'] = input('fk_to_passenger_Aadhar_card_number: ')
 
 def add_luggage(cur, con):
    
    attr['Baggage ID'] = input('Baggage ID: ')
    attr['fk_to_Barcode number'] = input('fk_to_Barcode number: ')
 
 def add_aircraft(cur, con):
    
    attr['registration_num'] = input('registration_num: ')
    attr['fk_to_capacity_Manufacturer'] = input('fk_to_capacity_Manufacturer: ')
    attr['fk_to_capacity_Manufacturer'] = input('fk_to_capacity_Manufacturer: ')
    attr['fk_to_capacity_Manufacturer'] = input('fk_to_capacity_Manufacturer: ')
    attr['fk_to_capacity_Manufacturer'] = input('fk_to_capacity_Manufacturer: ')
    

