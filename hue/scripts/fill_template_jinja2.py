#!/usr/bin/python

import os, sys
from jinja2 import Template

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

if __name__ == "__main__":

    template = open(template_file,"r")
    template_content = template.read()
    template.close()

    hue_env = getEnvironmentVariables(env_prefix)
    result_content = Template(template_content).render(hue_env)

    result = open(config_file,"w")
    result.write(result_content)
    result.close()
