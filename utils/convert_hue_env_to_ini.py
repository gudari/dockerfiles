#!/usr/bin/python3

import os
import sys
from configobj import ConfigObj

def getEnvironmentVariables(envPrefix):
    all_env = os.environ
    hue_env = {}
    for key in all_env.keys():
        if envPrefix in key:
            new_key = key.replace(envPrefix, '')
            hue_env[new_key] = all_env[key]
    return hue_env

def generateIniFile(env_list):
    hue_ini = ConfigObj()
    hue_ini.filename = "hue-test.ini"
    for env in env_list.keys():
        value = env_list[env]
        prop = env.split("__")
        if not (prop[0] in hue_ini):
            hue_ini[prop[0]] = {}
        if len(prop) <= 2:
                hue_ini[prop[0]][prop[1]] = value
        elif len(prop) == 3:
            if not (prop[1] in hue_ini[prop[0]]):
                hue_ini[prop[0]][prop[1]] = {}
            hue_ini[prop[0]][prop[1]][prop[2]] = value
        elif len(prop) == 4:
            if not (prop[1] in hue_ini[prop[0]]):
                hue_ini[prop[0]][prop[1]] = {}
            if not (prop[2] in hue_ini[prop[0]][prop[1]]):
                hue_ini[prop[0]][prop[1]][prop[2]] = {}
            hue_ini[prop[0]][prop[1]][prop[2]][prop[3]] = value
    hue_ini.write()

hue_env = getEnvironmentVariables("HUE_INI__")
generateIniFile(hue_env)


