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
    attr['Source Airport IATA code'] = input('Source Airport IATA code: ')
    attr['Take off runway id'] = input('Take off runway id: ')