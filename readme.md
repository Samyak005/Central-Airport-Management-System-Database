## to install pymysql

python3 -m pip install PyMySQL

SQL vs mySQL

MySQL (/ˌmaɪˌɛsˌkjuːˈɛl/ "My S-Q-L")[5] is an open-source relational database management system (RDBMS).[5][6]

Connecting to a MySQL server requires a username and password. You may also need to specify the name of the host on which the server is running.

The arguments to mysql include -h localhost to connect to the MySQL server running on the local host, -u root to connect as the MySQL root user, and -p to tell mysql to prompt for a password:

mysql -h 127.0.0.1 -u root --port=5005 -p 
mysql -h 127.0.0.1 -u root --port=5005 -p < samyak.sql

# show tables;

https://dba.stackexchange.com/a/42541

# 1.6. Executing SQL Statements Read from a File or Program


***fetchone()*** retrieves a single item, when you know the result set contains a single row. 
***fetchall()*** retrieves all the items, when you know the result set contains a limited number of rows that can fit comfortably into memory. 
***fetchmany()*** is the general-purpose method when you cannot predict the size of the result set: you keep calling it and looping through the returned items, until there are no more results to process


# iterating over the result of a query
https://stackoverflow.com/questions/28530508/select-query-in-pymysql

# incorporating pandas
https://stackoverflow.com/questions/47328402/how-to-store-mysql-query-result-into-pandas-dataframe-with-pymysql

#
https://stackoverflow.com/questions/39163776/how-to-get-rows-affected-in-a-update-statement-by-pymsql

# Using tabulate
python3 -m pip install tabulate