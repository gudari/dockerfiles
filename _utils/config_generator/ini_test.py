import unittest, os
from mock import patch
from site_xml import Site_xml

from env import Env
from site_xml import Site_xml


class SiteXmlTest(unittest.TestCase):
    def test_create_core_site(self):
      env_path = os.path.join(os.path.dirname(__file__), 'resources/tests/hadoop.env')
      core_site_xml_path = os.path.join(os.path.dirname(__file__), 'resources/tests/core-site.xml')
      env = Env('HADOOP_CORE_SITE')
      sitexml = Site_xml()
      env.load_from_file(env_path)
      sitexml.import_variables(env.get_variables())
      sitexml.load_header()
      sitexml.generate_file(core_site_xml_path)
      result ='''<?xml version="1.0" encoding="UTF-8"?>
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

<configuration>
  <property>
    <name>hadoop.proxyuser.hue.groups</name>
    <value>*</value>
  </property>
  <property>
    <name>fs.defaultFS</name>
    <value>hdfs://namenode:8020</value>
  </property>
  <property>
    <name>hadoop.proxyuser.hue.hosts</name>
    <value>*</value>
  </property>
  <property>
    <name>hadoop.http.staticuser.user</name>
    <value>root</value>
  </property>
</configuration>
'''
      self.assertEqual(sitexml.file, result)

    def test_create_hdfs_site(self):
      env_path = os.path.join(os.path.dirname(__file__), 'resources/tests/hadoop.env')
      hdfs_site_xml_path = os.path.join(os.path.dirname(__file__), 'resources/tests/hdfs-site.xml')
      env = Env('HADOOP_HDFS_SITE')
      sitexml = Site_xml()
      env.load_from_file(env_path)
      sitexml.import_variables(env.get_variables())
      sitexml.load_header()
      sitexml.generate_file(hdfs_site_xml_path)
      result ='''<?xml version="1.0" encoding="UTF-8"?>
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

<configuration>
  <property>
    <name>dfs.namenode.name.dir</name>
    <value>file:///hadoop/dfs/name</value>
  </property>
  <property>
    <name>dfs.permissions.enabled</name>
    <value>false</value>
  </property>
  <property>
    <name>dfs.webhdfs.enabled</name>
    <value>true</value>
  </property>
  <property>
    <name>dfs.datanode.data.dir</name>
    <value>file:///hadoop/dfs/data</value>
  </property>
</configuration>
'''
      self.assertEqual(sitexml.file, result)

    def test_create_mapred_site(self):
      env_path = os.path.join(os.path.dirname(__file__), 'resources/tests/hadoop.env')
      mapred_site_xml_path = os.path.join(os.path.dirname(__file__), 'resources/tests/mapred-site.xml')
      env = Env('HADOOP_MAPRED_SITE')
      sitexml = Site_xml()
      env.load_from_file(env_path)
      sitexml.import_variables(env.get_variables())
      sitexml.load_header()
      sitexml.generate_file(mapred_site_xml_path)
      result ='''<?xml version="1.0" encoding="UTF-8"?>
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

<configuration>
  <property>
    <name>mapreduce.jobhistory.done-dir</name>
    <value>/mr-history/done</value>
  </property>
  <property>
    <name>mapreduce.map.java.opts</name>
    <value>-Xmx1024M</value>
  </property>
  <property>
    <name>mapreduce.jobhistory.intermediate-done-dir</name>
    <value>/mr-history/tmp</value>
  </property>
  <property>
    <name>mapreduce.reduce.shuffle.parallelcopies</name>
    <value>50</value>
  </property>
  <property>
    <name>mapreduce.task.io.sort.mb</name>
    <value>512</value>
  </property>
  <property>
    <name>mapreduce.jobhistory.address</name>
    <value>historyserver:10020</value>
  </property>
  <property>
    <name>mapreduce.reduce.java.opts</name>
    <value>-Xmx2560M</value>
  </property>
  <property>
    <name>mapreduce.map.memory.mb</name>
    <value>1536</value>
  </property>
  <property>
    <name>mapreduce.framework.name</name>
    <value>yarn</value>
  </property>
  <property>
    <name>mapreduce.jobhistory.webapp.address</name>
    <value>historyserver:19888</value>
  </property>
  <property>
    <name>mapreduce.task.io.sort.factor</name>
    <value>100</value>
  </property>
  <property>
    <name>mapreduce.reduce.memory.mb</name>
    <value>3072</value>
  </property>
</configuration>
'''
      self.assertEqual(sitexml.file, result)

    def test_create_yarn_site(self):
      env_path = os.path.join(os.path.dirname(__file__), 'resources/tests/hadoop.env')
      yarn_site_xml_path = os.path.join(os.path.dirname(__file__), 'resources/tests/yarn-site.xml')
      env = Env('HADOOP_YARN_SITE')
      sitexml = Site_xml()
      env.load_from_file(env_path)
      sitexml.import_variables(env.get_variables())
      sitexml.load_header()
      sitexml.generate_file(yarn_site_xml_path)
      result ='''<?xml version="1.0" encoding="UTF-8"?>
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

<configuration>
  <property>
    <name>yarn.timeline-service.hostname</name>
    <value>historyserver</value>
  </property>
  <property>
    <name>yarn.nodemanager.remote-app-log-dir</name>
    <value>/app-logs</value>
  </property>
  <property>
    <name>yarn.resourcemanager.hostname</name>
    <value>resourcemanager</value>
  </property>
  <property>
    <name>yarn.resourcemanager.recovery.enabled</name>
    <value>true</value>
  </property>
  <property>
    <name>yarn.resourcemanager.store.class</name>
    <value>org.apache.hadoop.yarn.server.resourcemanager.recovery.FileSystemRMStateStore</value>
  </property>
  <property>
    <name>yarn.log-aggregation-enable</name>
    <value>true</value>
  </property>
  <property>
    <name>yarn.resourcemanager.system-metrics-publisher.enabled</name>
    <value>true</value>
  </property>
  <property>
    <name>yarn.resourcemanager.scheduler.address</name>
    <value>resourcemanager:8030</value>
  </property>
  <property>
    <name>yarn.log.server.url</name>
    <value>http://historyserver:8188/applicationhistory/logs/</value>
  </property>
  <property>
    <name>yarn.resourcemanager.resource-tracker.address</name>
    <value>resourcemanager:8031</value>
  </property>
  <property>
    <name>yarn.resourcemanager.address</name>
    <value>resourcemanager:8032</value>
  </property>
  <property>
    <name>yarn.resourcemanager.fs.state-store.uri</name>
    <value>/rmstate</value>
  </property>
  <property>
    <name>yarn.timeline-service.generic-application-history.enabled</name>
    <value>true</value>
  </property>
  <property>
    <name>yarn.timeline-service.enabled</name>
    <value>true</value>
  </property>
</configuration>
'''
      self.assertEqual(sitexml.file, result)

if __name__ == '__main__':
    unittest.main()
