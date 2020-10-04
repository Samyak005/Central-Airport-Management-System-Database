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

    tmp= input('Enter 1 if airline is active, 0 otherwise :')
    attr['is_active']=False
    if t==1:
        attr['is_active']=True
     
    
    attr['country_of_ownership'] = input('Enter country of ownership of airline')

    keys_str,values_str=get_query_atoms(attr)
    print(keys_str)
    print(values_str)
    query_str='INSERT INTO '+table_name+" ( "+keys_str+" ) VALUES"+" ( "+values_str+" );"

    print("query str is %s->",query_str)

    cur.execute(query_str)

    con.commit()

def add_aircraft(cur, con):
    print("inside add_airline function")
    table_name="`Aircraft`"

    attr = {}
    print('Enter details of the new airline:')

    attr[`registration_num`] =input("")
    attr[`fk_to_capacity_Manufacturer`]=input("")
    attr[`fk_to_capacity_Model`]=input("")
    attr[`Distance Travelled`]=input("")
    attr[`Flight ID`]=input("")
    attr[`Maintanence check date`]=input("")
    attr[`fk_to_airline_owner_airline_IATA_code`]=input("")
    
    keys_str,values_str=get_query_atoms(attr)
    print(keys_str)
    print(values_str)
    query_str='INSERT INTO '+table_name+" ( "+keys_str+" ) VALUES"+" ( "+values_str+" );"

    print("query str is %s->",query_str)

    cur.execute(query_str)

    con.commit()



def add_passenger(cur, con):
    print("inside add_passenger function")
    table_name="`Passenger`"

    attr = {}
    print('Enter details of the new airline:')

    attr["Aadhar_card_number"]=input("iNPUT THIS ")

    tmp_name=input("Enter name")

    name_list= tmp_name.split(' ')

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



    attr["DOB"]=input("iNPUT THIS ")
    attr["Gender"]=input("iNPUT THIS ")
    attr["House Number"]=input("iNPUT THIS ")
    attr["Building"]=input("iNPUT THIS ")
    attr["City"]=input("iNPUT THIS ")
    attr["Email-ID"]=input("iNPUT THIS ")
    attr["Senior Citizen"]=input("iNPUT THIS ")
    attr["Nationality"]=input("iNPUT THIS ")




    tmp= input('Enter 1 if airline is active, 0 otherwise :')
    attr['is_active']=False
    if t==1:
        attr['is_active']=True
     
    
    attr['country_of_ownership'] = input('Enter country of ownership of airline')

    keys_str,values_str=get_query_atoms(attr)
    print(keys_str)
    print(values_str)
    query_str='INSERT INTO '+table_name+" ( "+keys_str+" ) VALUES"+" ( "+values_str+" );"

    print("query str is %s->",query_str)

    cur.execute(query_str)

    con.commit()


def add_airport(cur, con):
    print("inside add_airport function")
    table_name="`Airport`"

    attr = {}
    print('Enter details of the new airport:')

    attr["IATA airport codes"]=input(" Input 3 character IATA code * ")
    attr["Altitude"]=input(" Input in metres ")

    ######################################################
    attr["Time Zone"]=input(" Input in +hh:mm or -hh:mm format , note mm has to be between 0 and 60 and divisible by 15, hh between +12 and -12 ")
    ########################################################

    attr["Airport Name"]=input(" Input stuff ")
    attr["City"]=input(" Input stuff ")
    attr["Country"]=input(" Input stuff ")

    attr["Latitude"]=input(" Input stuff ")
    if attr['Latitude']>90 or attr['Latitude']<-90:
        print("ERROR : Invalid latitudes")
        return

    attr["Longitude"]=input(" Input stuff ")
    if attr['Longitude']>180 or attr['Longitude']<-180:
        print("ERROR : Invalid longitudes")
        return


    keys_str,values_str=get_query_atoms(attr)
    print(keys_str)
    print(values_str)
    query_str='INSERT INTO '+table_name+" ( "+keys_str+" ) VALUES"+" ( "+values_str+" );"

    print("query str is %s->",query_str)

    cur.execute(query_str)

    con.commit()


def add_runway(cur, con):
    print("inside add_runway function")
    table_name="`Runway`"

    attr = {}
    print('Enter details of the new runway:')

    attr["fk_to_airport_IATA_airport_codes"]=input("Input stuff")
    attr["Runway ID"]=input("Input stuff")
    attr["length_ft"]=input("Input stuff")
    attr["width_ft"]=input("Input stuff")

    ################DISPLAY A MENU HERE########################################
    stat_choice=int(input("Input stuff"))

    attr["Status"]=""
    if stat_choice==1:
        attr["Status"]='Assigned'
    else if stat_choice==2:
        attr["Status"]='Available'
    else if stat_choice==3:
        attr["Status"]='Disfunctional'
    
    ######################################################
        

    keys_str,values_str=get_query_atoms(attr)
    print(keys_str)
    print(values_str)
    query_str='INSERT INTO '+table_name+" ( "+keys_str+" ) VALUES"+" ( "+values_str+" );"

    print("query str is %s->",query_str)

    cur.execute(query_str)

    con.commit()

def add_terminal(cur, con):
    print("inside add_terminal function")
    table_name="`Terminal`"

    attr = {}
    print('Enter details of the new terminal:')

    attr["fk_to_airport_IATA_airport_codes"]=input("Input stuff")
    attr["Terminal ID"]=input("Input stuff")
    attr["Airplane Handling capacity"]=input("Input stuff")
    attr["Floor Area"]=input("Input stuff")

        
    keys_str,values_str=get_query_atoms(attr)
    print(keys_str)
    print(values_str)
    query_str='INSERT INTO '+table_name+" ( "+keys_str+" ) VALUES"+" ( "+values_str+" );"

    print("query str is %s->",query_str)

    cur.execute(query_str)

    con.commit()


def add_route(cur, con,pnr_of_boarding_pass):

    print("inside add_terminal function")
    table_name="`Terminal`"

    attr = {}
    print('Enter details of the new route:')

    attr['Route ID'] = input('Route ID: ')
    attr['fk_to_airport_src_iata_code'] = input('source airport iata code: ')
    attr['fk_to_airport_dest_iata_code'] = input('Destination airport iata code: ')
    attr['Date'] = input('Date: [YYYY-MM-DD] (Press enter for today\'s date')

    if attr['Date'] == '':
        attr['Date'] = datetime.now().strftime('%Y-%m-%d')


    attr['Scheduled arrival'] = empty_to_null(input('Scheduled arrival (Press enter if information not available): [HH:MM]'))
    attr['Scheduled Departure'] = empty_to_null(input('Scheduled Departure: [HH:MM (Press enter if information not available):'))
    attr['Time duration'] = empty_to_null(input('Time duration (Press enter if information not available): [HH:MM]'))
    attr['fk_to_runway_Take off runway id'] = empty_to_null(input('Take off runway id (Press enter if information not available):'))
    attr['Distance Travelled'] = empty_to_null(input('Distance Travelled (Press enter if information not available):'))
    attr['fk_to_runway_Landing runway ID'] = empty_to_null(input('Landing runway ID (Press enter if information not available):'))
    attr['fk_to_aircraft_registration_num'] = empty_to_null(input('aircraft registration number (Press enter if information not available):'))
    attr['Status'] = input('Status: [Departed, Boarding, On_route, Delayed, Arrived, Checking, Not_applicable]')
    
    keys_str,values_str=get_query_atoms(attr)
    print(keys_str)
    print(values_str)
    query_str='INSERT INTO '+table_name+" ( "+keys_str+" ) VALUES"+" ( "+values_str+" );"

    print("query str is %s->",query_str)

    cur.execute(query_str)

    con.commit()

def add_pnr_info_deduction():
    table_name="`PNR info deduction`"

    attr = {}
    print('Enter details of the PNR info deduction:')

    #########################################################################################
    attr["PNR_number"]=pnr_of_boarding_pass
    attr["fk_to_route_Route ID"]=input("Input stuff")
    attr["Scheduled Boarding Time"]=input("Enter schdeuled boarding time allotted to you based \
            on your seat, class of travel, if you are senior citizen/VIP etc.")
    attr["class_of_travel"]=input("Input stuff")
    attr["fk_to_airport_src_iata_code"]=input("Input stuff")

    ########################################################################
    keys_str,values_str=get_query_atoms(attr)
    print(keys_str)
    print(values_str)
    query_str='INSERT INTO '+table_name+" ( "+keys_str+" ) VALUES"+" ( "+values_str+" );"

    print("query str is %s->",query_str)

    cur.execute(query_str)

    con.commit()


def add_boarding_pass_details(cur, con):
    print("inside add_boarding pass function")
    table_name="`boarding_pass`"

    attr = {}
    print('Enter details of the Boarding pass entry:')

    attr["Barcode number"]=input("Enter 12 char boarding pass barcode number")
    attr["fk_PNR_number"]=input("Enter ONR number to which boarding pass belongs")
    attr["Seat"]=input("Input stuff")
    attr["fk_to_passenger_Aadhar_card_number"]=input("Input stuff")

    ##########################################################################################
    add_more_details=int(input('''
    Press 1 if you want to add additional details like class_of_travel, Src airport etc.,
    \n
    Press 0 if you have already added these details for another boarding pass on the same PNR'''))

    if add_more_details==1:
        add_pnr_info_deduction()

    #########################################################################################
        
    keys_str,values_str=get_query_atoms(attr)
    print(keys_str)
    print(values_str)
    query_str='INSERT INTO '+table_name+" ( "+keys_str+" ) VALUES"+" ( "+values_str+" );"

    print("query str is %s->",query_str)

    cur.execute(query_str)

    con.commit()
    

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
 
