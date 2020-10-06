import subprocess as sp
import pymysql
import pymysql.cursors

def get_deletion_equation(attr,key_attrs,type_str):
    
    query_str = ""
    dict_len = len(attr.keys())

    for i in range(dict_len):

        #i += 1
        if attr[key_attrs[i]] == '':
            return ""

        query_str += "`"+key_attrs[i]+"`"+" = "

        if type_str[i]=='1':
            query_str+'''"'''
        query_str += attr[key_attrs[i]]
        if type_str[i]=='1':
            query_str+'''"'''

        if i != dict_len-1:
            query_str+" AND "

    return query_str

def delete_aircraft(cur,con):
    print("Inside delete_aircraft func")
    table_name="Aircraft"

    attr={}

    key_attrs=["registration_num"]

    attr[key_attrs[0]]=input("Enter reg num of aircraft you wish to delete: ")



    try:
        ans=get_deletion_equation(attr,key_attrs,"0") # non-int - pass 1 else pass 0
        if ans=="":
            print("Key attribute value cannot be left empty")
            print("Failed to delete from database")
            input("Press any key to continue")
            return
        query_str = "DELETE FROM "+table_name+" WHERE "+ans+" ; "
        cur.execute(query_str)
        con.commit()

        ############################################
        print("Deleted aircraft")
        ###########################################


        input("Press any key to continue")

    except Exception as e:
        con.rollback()
        print("Failed to delete from database")
        print(">>>>>>>>>>>>>", e)
        input("Press any key to continue")
        return

    query_str2 = 'UPDATE Airline SET num_aircrafts_owned = num_aircrafts_owned - 1 WHERE fk_to_airline_owner_airline_IATA_code = `IATA airline designators`'
    try:
        cur.execute(query_str2)
        con.commit()

    except Exception as e:
        print('Failed to decrement number of aricrafts owned by airline the database.')
        con.rollback()
        print(e)
        input('Press any key to continue.')
        return

def delete_luggage(cur,con):
    print("Inside delete_luggage func")
    table_name="luggage" 

    attr={}

    key_attrs=["Baggage ID"]

    attr[key_attrs[0]]=input("Enter Baggage ID of luggage you wish to delete: ")



    try:
        ans=get_deletion_equation(attr,key_attrs,"0") # non-int - pass 1 else pass 0
        if ans=="":
            print("Key attribute value cannot be left empty")
            print("Failed to delete from database")
            input("Press any key to continue")
            return
        query_str = "DELETE FROM "+table_name+" WHERE "+ans+" ; "
        cur.execute(query_str)
        con.commit()

        ############################################
        print("Deleted luggage")
        ###########################################


        input("Press any key to continue")

    except Exception as e:
        con.rollback()
        print("Failed to delete from database")
        print(">>>>>>>>>>>>>", e)
        input("Press any key to continue")
    return

def delete_airline_crew(cur,con):
    print("Inside delete_airline_crew func")
    table_name="airline_crew" 

    attr={}

    key_attrs=["Aadhar_card_number"]

    attr[key_attrs[0]]=input("Enter Aadhar card number of airline employee you wish to delete: ")



    try:
        ans=get_deletion_equation(attr,key_attrs,"0") # non-int - pass 1 else pass 0
        if ans=="":
            print("Key attribute value cannot be left empty")
            print("Failed to delete from database")
            input("Press any key to continue")
            return
        query_str = "DELETE FROM "+table_name+" WHERE "+ans+" ; "
        cur.execute(query_str)
        con.commit()

        ############################################
        print("Deleted airline employee")
        ###########################################


        input("Press any key to continue")

    except Exception as e:
        con.rollback()
        print("Failed to delete from database")
        print(">>>>>>>>>>>>>", e)
        input("Press any key to continue")
    return

def delete_airport_crew(cur,con):
    print("Inside delete_airport_crew func")
    table_name="airport_crew" 

    attr={}

    key_attrs=["Aadhar_card_number"]

    attr[key_attrs[0]]=input("Enter Aadhar card number of airport employee you wish to delete: ")



    try:
        ans=get_deletion_equation(attr,key_attrs,"0") # non-int - pass 1 else pass 0
        if ans=="":
            print("Key attribute value cannot be left empty")
            print("Failed to delete from database")
            input("Press any key to continue")
            return
        query_str = "DELETE FROM "+table_name+" WHERE "+ans+" ; "
        cur.execute(query_str)
        con.commit()

        ############################################
        print("Deleted airport employee")
        ###########################################


        input("Press any key to continue")

    except Exception as e:
        con.rollback()
        print("Failed to delete from database")
        print(">>>>>>>>>>>>>", e)
        input("Press any key to continue")
    return

def delete_route(cur,con):
    print("Inside delete_route func")
    table_name="Route" 

    attr={}

    key_attrs=["Route ID"]

    attr[key_attrs[0]]=input("Enter route ID of route you wish to delete: ")



    try:
        ans=get_deletion_equation(attr,key_attrs,"0") # non-int - pass 1 else pass 0
        if ans=="":
            print("Key attribute value cannot be left empty")
            print("Failed to delete from database")
            input("Press any key to continue")
            return
        query_str = "DELETE FROM "+table_name+" WHERE "+ans+" ; "
        cur.execute(query_str)
        con.commit()

        ############################################
        print("Deleted route")
        ###########################################


        input("Press any key to continue")

    except Exception as e:
        con.rollback()
        print("Failed to delete from database")
        print(">>>>>>>>>>>>>", e)
        input("Press any key to continue")
    return