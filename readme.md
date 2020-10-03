## to install pymysql

python3 -m pip install PyMySQL

SQL vs mySQL

MySQL (/ˌmaɪˌɛsˌkjuːˈɛl/ "My S-Q-L")[5] is an open-source relational database management system (RDBMS).[5][6]

Connecting to a MySQL server requires a username and password. You may also need to specify the name of the host on which the server is running.

The arguments to mysql include -h localhost to connect to the MySQL server running on the local host, -u root to connect as the MySQL root user, and -p to tell mysql to prompt for a password:

mysql -h 127.0.0.1 -u root --port=5005 -p 
mysql -h 127.0.0.1 -u root --port=5005 -p < samyak.sql


# 1.6. Executing SQL Statements Read from a File or Program