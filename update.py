import subprocess as sp
import pymysql
import pymysql.cursors

def get_condition_equation(attr,key_attrs,type_str):
    
    query_str = ""
    dict_len = len(attr.keys())

    for i in range(dict_len):
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

def get_updation_equation(attr):
    
    query_str = ""
    dict_len = len(attr.keys())
    i = -1

    for key, value in attr.items():

        i += 1
        if value == '' or value == 'NULL':
            continue

        query_str += key+" = "+value

        if i != dict_len-1:
            query_str += ", "

    return query_str

def update_passenger(cur, con):
    print("Inside update_passenger func")
    table_name="Passenger"

    attr={}

    attr["Aadhar_card_number"] = input("Enter Aadhar card number of the passenger you want to update: ")
    tmp_name = input("Enter new name")

    key_attr = [""]

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

    try:
        set_values=get_updation_equation(attr)
        if ans=="":
            print("Some value must be updated")
            print("Failed to update database")
            input("Press any key to continue")
            return
        query_str = "UPDATE "+table_name+" SET "+ans+" WHERE Aadhar_card_number = "+attr["Aadhar_card_number"]+" ; "
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