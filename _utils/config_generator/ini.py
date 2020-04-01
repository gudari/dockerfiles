from env import Env

class Ini:
    def __init__(self):
        self.variable_dic = {}
        self.header = ""
        self.file = ""
    def load_header(self):
        self.header = '''# Hue configuration file
# ===================================
#
# For complete documentation about the contents of this file, run
#   $ <hue_root>/build/env/bin/hue config_help
#
# All .ini files under the current directory are treated equally.  Their
# contents are merged to form the Hue configuration, which can
# can be viewed on the Hue at
#   http://<hue_host>:<port>/dump_config


###########################################################################
# General configuration for core Desktop features (authentication, etc)
###########################################################################

'''

    def import_variables(self, variables):
      self.variable_dic = variables
      

    def generate_file(self, path):
      self.file = self.header
      f = open(path, "w+")
      f.write(self.file)
      f.close()