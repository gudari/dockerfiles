import os

class Env:
    def __init__(self, prefix):

        self.prefix = prefix
        self.variable_dict = {}
    
    def load_from_os_env(self):
        for key in os.environ:
            if key.startswith(self.prefix):
                var = key.replace(self.prefix + '_', '')
                value = os.environ[key]
                self.variable_dict[var] = value
    
    def add_variable(self, line):
        if line.startswith(self.prefix):
            splited_line = line.split('=')
            var = splited_line[0].replace(self.prefix + '_', '')
            value = splited_line[1]
            self.variable_dict[var] = value

    def load_from_file(self, file):
        f = open(file, "r")
        for line in f:
            self.add_variable(line[:-1])
        f.close()

    def get_variables(self):
        return self.variable_dict

    def show(self):
        print( "Used env variables:" )
        for key in self.variable_dict:
            print( " - " + key + '=' + self.variable_dict[key] )
    



