#!/usr/bin/python3

'''
# This script was created to transform the *.properties to *.env file.
# Add parameters to thi script: convert_properties_to_env.py *.properties NIFI_PROPERTIES_ nifi.env
'''

import os, sys

if len(sys.argv) < 4:
    print("This script should have 3 arguments. Example: convert_properties_to_env.py nifi.properties NIFI_PROPERTIES nifi.env")
    exit()

source = sys.argv[1]
prefix = sys.argv[2]
dest = sys.argv[3]

server_properties = open(source)
file_env = open(dest, "w")
property_list = server_properties.readlines()
for prop in property_list:
    if prop[0] != '#' and prop != "\n":
        print(prop)
        variable, value = prop.split('=', 1)
        value = value.replace(" ", "\\ ")
        normaliced_variable = variable.replace(".", "_")
        if len(value) > 0:
            file_env.write(prefix + '_' + normaliced_variable + "=" + value)
file_env.close()