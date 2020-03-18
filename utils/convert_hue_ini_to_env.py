#!/usr/bin/python3

'''
# This script was created to transform the hadoop core-site.xml, hdfs-site.xml, mapred-site.xml, yarn-site.xml to .env files.
# It is also useful for other services like ranger, oozie, hbase and hive.
'''

import os
import re

class ini_to_env:
    configs = {}
    debug = True
    prefix = "HUE_INI"

    def clean_text(self,file):
        hue_ini = open(file)
        prop_list = hue_ini.readlines()
        clean_prop_list = []


        for prop in prop_list:
            prop = prop.strip(' ')
            if prop != None and prop[0] != '#' and prop != '\n':
                clean_prop_list.append(prop[:-1])
        
        if self.debug:
            print( clean_prop_list )

        hue_ini.close()
        
        return clean_prop_list

    def generate_hash(self, props):
        regex1 = '^\[[a-z\_A-Z 0-9]*\]$'
        regex2 = '^\[\[[a-z\_A-Z 0-9]*\]\]$'
        regex3 = '^\[\[\[[a-z\_A-Z 0-9]*\]\]\]$'

        for prop in props:
            if re.search(regex1, prop):
                self.configs[prop[1:-1]] = {}
                level1 = prop[1:-1]
                level = 1
                continue
            if re.search(regex2, prop):
                self.configs[level1].update( { prop[2:-2]: {}} )
                level2 = prop[2:-2]
                level = 2
                continue
            if re.search(regex3, prop):
                self.configs[level1][level2].update({ prop[3:-3]: {}})
                level3 = prop[3:-3]
                level = 3
                continue
            if level == 1:
                spl = prop.split("=")
                key = spl[0]
                if len(spl) < 2:
                    self.configs[level1].update({ key: None } )
                else:
                    value = spl[1]
                    self.configs[level1].update({ key: value } )
            elif level == 2:
                spl = prop.split("=")
                key = spl[0]
                if len(spl) < 2:
                    self.configs[level1][level2].update({ key: None } )
                else:
                    value = spl[1]
                    self.configs[level1][level2].update({ key: value } )
            elif level == 3:
                spl = prop.split("=")
                key = spl[0].rstrip()
                if len(spl) < 2:
                    self.configs[level1][level2][level3].update({ key: None } )
                else:
                    value = spl[1].lstrip()
                    self.configs[level1][level2][level3].update({ key: value } )
        if self.debug:
            print(self.configs)

    def _write_config_env(self, file, prefix, config):
        if type(config) == dict:
            for key, value in config.items():
                if type(value) == dict:
                    env = self._write_config_env(file, prefix + "__" + key, value)
                else:
                    env = prefix + "__" + key + "=" + value + "\n"
                    file.write(env)

    def write_config_env(self):
        hue_env = open("hue.env", "w")
        for key, value in self.configs.items():
            if type(value) == dict:
                env = self._write_config_env(hue_env, self.prefix + "__" + key, value)
            else:
                env = self.prefix + "__" + key + "=" + value + "\n"
                hue_env.write(env)
        hue_env.close()


    


convert = ini_to_env()
props = convert.clean_text("hue.ini")
convert.generate_hash(props)
convert.write_config_env()