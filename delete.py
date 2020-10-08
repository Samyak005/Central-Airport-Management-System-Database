import subprocess as sp
import pymysql
import pymysql.cursors
import sys

colors_dict3 = {
    "BLUE": "\033[1;34m",
    "RED": "\033[1;31m",
    "CYAN": "\033[1;36m",
    "GREEN": "\033[0;32m",
    "RESET": "\033[0;0m",
    "BOLD": "\033[;1m",
    "REVERSE": "\033[;7m",
    "ERROR": "\033[;7m"+"\033[1;31m"
}


def decorate3(color_str):
    # print("Decorated")
    sys.stdout.write(colors_dict3[color_str])

def del_print(msg):
    decorate3("GREEN")
    print(msg)
    decorate3("RESET")

def err_print_msg(msg):
    decorate3("ERROR")
    print(msg)
    decorate3("RESET")

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
        query_str +="'" +attr[key_attrs[i]]+"'"
        if type_str[i]=='1':
            query_str+'''"'''

        if i != dict_len-1:
            query_str+" AND "

    return query_str

# DONE
def delete_aircraft(cur,con):
    #print("Inside delete_aircraft func")
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
        res_cnt=cur.rowcount
        if res_cnt == 0:
            del_print("No such aircraft exists")
        ############################################
        else:
            del_print("Deleted aircraft")
        ###########################################


        input("Press any key to continue")

    except Exception as e:
        con.rollback()
        err_print_msg("Failed to delete from database")
        err_print_msg(">>>>>>>>>>>>>", e)
        input("Press any key to continue")
        return

    query_str2 = 'UPDATE Airline, Aircraft SET num_aircrafts_owned = num_aircrafts_owned - 1 WHERE fk_to_airline_owner_airline_IATA_code = `IATA airline designators`'
    try:
        cur.execute(query_str2)
        con.commit()

    except Exception as e:
        err_print_msg('Failed to decrement number of aricrafts owned by airline the database.')
        con.rollback()
        err_print_msg(e)
        input('Press any key to continue.')
        return

# Done
def delete_luggage(cur,con):
    #print("Inside delete_luggage func")
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

        res_cnt=cur.rowcount
        if res_cnt == 0:
            del_print("No such luggage exists")
        ############################################
        else:
            del_print("Deleted luggage")
        ###########################################


        input("Press any key to continue")

    except Exception as e:
        con.rollback()
        err_print_msg("Failed to delete from database")
        err_print_msg(">>>>>>>>>>>>>", e)
        input("Press any key to continue")
    return

#done
def delete_airline_crew(cur,con):
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

        res_cnt=cur.rowcount
        if res_cnt == 0:
            del_print("No such airline employee exists")
        ############################################
        else:
            del_print("Deleted airline employee")
        ###########################################


        input("Press any key to continue")

    except Exception as e:
        con.rollback()
        err_print_msg("Failed to delete from database")
        err_print_msg(">>>>>>>>>>>>>", e)
        input("Press any key to continue")
    return

# DONE
def delete_airport_crew(cur,con):
    #print("Inside delete_airport_crew func")
    table_name="`Airport Employees/CREWS`" 

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
        res_cnt=cur.rowcount
        if res_cnt == 0:
            del_print("No such airport employee exists")
        ############################################
        else:
            del_print("Deleted airport employee")
        ###########################################


        input("Press any key to continue")

    except Exception as e:
        con.rollback()
        err_print_msg("Failed to delete from database")
        err_print_msg(">>>>>>>>>>>>>", e)
        input("Press any key to continue")
    return
#done
def delete_route(cur,con):
    #print("Inside delete_route func")
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

        res_cnt=cur.rowcount
        if res_cnt == 0:
            del_print("No such route exists")
        ############################################
        else:
            del_print("Deleted route")
        ###########################################


        input("Press any key to continue")

    except Exception as e:
        con.rollback()
        err_print_msg("Failed to delete from database")
        err_print_msg(">>>>>>>>>>>>>", e)
        input("Press any key to continue")
    return