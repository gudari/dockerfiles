import unittest, os
from mock import patch

from env import Env

class EnvTest(unittest.TestCase):
    def test_load_from_os_env(self):
        with patch.dict('os.environ', {'HADOOP_CORE_SITE_fs_defaultFS': 'hdfs://namenode:8020'}):
            env = Env('HADOOP_CORE_SITE')
            env.load_from_os_env()
            self.assertEqual(env.get_variables(),{'fs.defaultFS': 'hdfs://namenode:8020'})

    def test_add_variable(self):
        env = Env('HADOOP_CORE_SITE')
        env.add_variable('HADOOP_CORE_SITE_fs_defaultFS=hdfs://namenode:8020')
        self.assertEqual(env.get_variables(),{'fs.defaultFS': 'hdfs://namenode:8020'})

    def test_load_from_file(self):
        path=os.path.join(os.path.dirname(__file__), 'resources/tests/hadoop.env')
        env = Env('HADOOP_CORE_SITE')
        env.load_from_file(path)
        self.assertEqual(env.get_variables(),{'fs.defaultFS': 'hdfs://namenode:8020',
                                              'hadoop.http.staticuser.user': 'root',
                                              'hadoop.proxyuser.hue.groups': '*',
                                              'hadoop.proxyuser.hue.hosts': '*'})

if __name__ == '__main__':
    unittest.main()
