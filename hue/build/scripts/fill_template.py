#!/usr/bin/python

import os, sys, re

if len(sys.argv) != 4:
    print("Allowed paremeters are 3, the source, destination and environment variable prefix parameters and you are passing %d args" % (len(sys.argv) - 1))
    sys.exit(1)

template_file = sys.argv[1]
config_file = sys.argv[2]
env_prefix = sys.argv[3]

print ("template: " + template_file + ", destination: " + config_file + ", env variable prefix: " + env_prefix)

def getEnvironmentVariables(env_prefix):
    all_env = os.environ
    hue_env = {}
    for key in all_env.keys():
        if env_prefix in key:
            new_key = key.replace(env_prefix + "_", '')
            hue_env[new_key] = all_env[key]
    return hue_env

def remove_duplicates(values):
    output = []
    seen = set()
    for value in values:
        if value not in seen:
            output.append(value)
            seen.add(value)
    return seen

if __name__ == "__main__":

    template = open(template_file,"r")
    template_content = template.read()
    template.close()

    hue_env = getEnvironmentVariables(env_prefix)

    variable_list = re.findall(r"\$\(([\w_]+)\)", template_content)
    variable_list = remove_duplicates(variable_list)

    for variable in variable_list:
        regex = r"\$\({}\)".format(variable)

        template_content = re.sub(regex, hue_env[variable], template_content, 0)

    result = open(config_file,"w")
    result.write(template_content)
    result.close()
