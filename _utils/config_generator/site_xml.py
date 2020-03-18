from env import Env

class Site_xml:
    def __init__(self):
        self.variable_dic = {}
        self.header = ""
        self.file = ""
    
    def load_header(self):
        self.header = '''<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<!--
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License. See accompanying LICENSE file.
-->

<!-- Put site-specific property overrides in this file. -->

'''

    def import_variables(self, variables):
      self.variable_dic = variables
      

    def generate_file(self, path):
      self.file = self.header
      self.file = self.file + "<configuration>" + "\n"
      for var in self.variable_dic:
        self.file = self.file + (" " * 2) + "<property>" + "\n"
        self.file = self.file + (" " * 4) + "<name>" + var.replace('___', '-').replace('__', '@').replace('_', '.').replace('@', '_') + "</name>" + "\n"
        self.file = self.file + (" " * 4) + "<value>" + self.variable_dic[var] + "</value>" + "\n"
        self.file = self.file + (" " * 2) + "</property>" + "\n"
      self.file = self.file + "</configuration>" + "\n"
      f = open(path, "w+")
      f.write(self.file)
      f.close()
