#!/bin/bash

export CORE_CONF_fs_defaultFS=${CORE_CONF_fs_defaultFS:-hdfs://`hostname -f`:8020}



function addProperty() {
  local path=$1
  local name=$2
  local value=$3

  local entry="<property><name>$name</name><value>${value}</value></property>"
  local escapedEntry=$(echo $entry | sed 's/\//\\\//g')
  sed -i "/<\/configuration>/ s/.*/${escapedEntry}\n&/" $path
}

function configure() {
    local path=$1
    local module=$2
    local envPrefix=$3

    local var
    local value
    
    echo "Configuring $module"
    for c in `printenv | grep $envPrefix | sed -e "s/^${envPrefix}_//" -e "s/=.*$//"`; do 
        name=`echo ${c} | sed -e "s/___/-/g" -e "s/__/@/g" -e "s/_/./g" -e "s/@/_/g"`
        var="${envPrefix}_${c}"
        value=${!var}
        echo " - Setting $name=$value"
        addProperty $path $name "$value"
    done
}

function addKylinProperty() {
  local path=$1
  local name=$2
  local value=$3

  local entry="$name=$value"
  local escapedEntry=$(echo $entry | sed 's/\//\\\//g')
  sed -i "/#\ End/ s/.*/${escapedEntry}\n&/" $path
}


function kylinConfigure() {
    local path=$1
    local module=$2
    local envPrefix=$3

    local var
    local value
    
    echo "Configuring $module"
    for c in `printenv | grep $envPrefix | sed -e "s/^${envPrefix}_//" -e "s/=.*$//"`; do 
        name=`echo ${c} | sed -e "s/___/-/g" -e "s/__/@/g" -e "s/_/./g" -e "s/@/_/g"`
        var="${envPrefix}_${c}"
        value=${!var}
        echo " - Setting $name=$value"
        addKylinProperty $path $name "$value"
    done
}

function wait_for_it()
{
    local serviceport=$1
    local service=${serviceport%%:*}
    local port=${serviceport#*:}
    local retry_seconds=5
    local max_try=100
    let i=1

    nc -z $service $port
    result=$?

    until [ $result -eq 0 ]; do
      echo "[$i/$max_try] check for ${service}:${port}..."
      echo "[$i/$max_try] ${service}:${port} is not available yet"
      if (( $i == $max_try )); then
        echo "[$i/$max_try] ${service}:${port} is still not available; giving up after ${max_try} tries. :/"
        exit 1
      fi
      
      echo "[$i/$max_try] try in ${retry_seconds}s once again ..."
      let "i++"
      sleep $retry_seconds

      nc -z $service $port
      result=$?
    done
    echo "[$i/$max_try] $service:${port} is available."
}

function generate_core_site() {
  cat > $HADOOP_HOME/etc/hadoop/core-site.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
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
</configuration>
EOF
}

function generate_hdfs_site() {
  cat > $HADOOP_HOME/etc/hadoop/hdfs-site.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
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
</configuration>
EOF
}

function generate_mapred_site() {
  cat > $HADOOP_HOME/etc/hadoop/mapred-site.xml << EOF
<?xml version="1.0"?>
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
</configuration>
EOF
}

function generate_yarn_site() {
  cat > $HADOOP_HOME/etc/hadoop/yarn-site.xml << EOF
<?xml version="1.0"?>
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
<configuration>
</configuration>
EOF
}

function generate_hbase_site() {
  cat > $HBASE_HOME/conf/hbase-site.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
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
</configuration>
EOF
}

function generate_hive_site() {
  cat > $HIVE_HOME/conf/hive-site.xml << EOF
<?xml version="1.0"?>
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
<configuration>
</configuration>
EOF
}

function generate_kylin_properties() {
  cat > $KYLIN_HOME/conf/kylin.properties << EOF
#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Start
# End
EOF
}

function generate_kylin_hive_conf() {
  cat > $KYLIN_HOME/conf/kylin_hive_conf.xml << EOF
<!--
  Licensed to the Apache Software Foundation (ASF) under one or more
  contributor license agreements.  See the NOTICE file distributed with
  this work for additional information regarding copyright ownership.
  The ASF licenses this file to You under the Apache License, Version 2.0
  (the "License"); you may not use this file except in compliance with
  the License.  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
-->

<!-- Put site-specific property overrides in this file. -->

<configuration>
</configuration>
EOF
}

function generate_kylin_job_conf_inmem() {
  cat > $KYLIN_HOME/conf/kylin_job_conf_inmem.xml << EOF
<!--
  Licensed to the Apache Software Foundation (ASF) under one or more
  contributor license agreements.  See the NOTICE file distributed with
  this work for additional information regarding copyright ownership.
  The ASF licenses this file to You under the Apache License, Version 2.0
  (the "License"); you may not use this file except in compliance with
  the License.  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
-->

<!-- Put site-specific property overrides in this file. -->

<configuration>
</configuration>
EOF
}

function generate_kylin_job_conf() {
  cat > $KYLIN_HOME/conf/kylin_job_conf.xml << EOF
<!--
  Licensed to the Apache Software Foundation (ASF) under one or more
  contributor license agreements.  See the NOTICE file distributed with
  this work for additional information regarding copyright ownership.
  The ASF licenses this file to You under the Apache License, Version 2.0
  (the "License"); you may not use this file except in compliance with
  the License.  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
-->

<!-- Put site-specific property overrides in this file. -->

<configuration>
</configuration>
EOF
}

function generate_kylin_kafka_consumer() {
  cat > $KYLIN_HOME/conf/kylin-kafka-consumer.xml << EOF
<!--
  Licensed to the Apache Software Foundation (ASF) under one or more
  contributor license agreements.  See the NOTICE file distributed with
  this work for additional information regarding copyright ownership.
  The ASF licenses this file to You under the Apache License, Version 2.0
  (the "License"); you may not use this file except in compliance with
  the License.  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
-->

<!-- Put site-specific property overrides in this file. -->

<configuration>
</configuration>
EOF
}

generate_core_site
generate_hdfs_site
generate_mapred_site
generate_yarn_site
generate_hbase_site
generate_hive_site
generate_kylin_properties
generate_kylin_hive_conf
generate_kylin_job_conf_inmem
generate_kylin_job_conf
generate_kylin_kafka_consumer

configure $HADOOP_HOME/etc/hadoop/core-site.xml core CORE_CONF
configure $HADOOP_HOME/etc/hadoop/hdfs-site.xml hdfs HDFS_CONF
configure $HADOOP_HOME/etc/hadoop/yarn-site.xml yarn YARN_CONF
configure $HADOOP_HOME/etc/hadoop/mapred-site.xml mapred MAPRED_CONF
configure $HADOOP_HOME/etc/hadoop/httpfs-site.xml httpfs HTTPFS_CONF
configure $HADOOP_HOME/etc/hadoop/kms-site.xml kms KMS_CONF
configure $HBASE_HOME/conf/hbase-site.xml hbase HBASE_CONF
configure $HIVE_HOME/conf/hive-site.xml hive HIVE_SITE_CONF
kylinConfigure $KYLIN_HOME/conf/kylin.properties kylin KYLIN_PROPERTIES
configure $KYLIN_HOME/conf/kylin_hive_conf.xml kylin KYLIN_HIVE_CONF
configure $KYLIN_HOME/conf/kylin_job_conf_inmem.xml kylin KYLIN_JOB_CONF_INMEM
configure $KYLIN_HOME/conf/kylin_job_conf.xml kylin KYLIN_JOB_CONF
configure $KYLIN_HOME/conf/kylin-kafka-consumer.xml kylin KYLIN_KAFKA_CONSUMER


echo "Configuring for multihomed network"

# HDFS
addProperty $HADOOP_HOME/etc/hadoop/hdfs-site.xml dfs.namenode.rpc-bind-host 0.0.0.0
addProperty $HADOOP_HOME/etc/hadoop/hdfs-site.xml dfs.namenode.servicerpc-bind-host 0.0.0.0
addProperty $HADOOP_HOME/etc/hadoop/hdfs-site.xml dfs.namenode.http-bind-host 0.0.0.0
addProperty $HADOOP_HOME/etc/hadoop/hdfs-site.xml dfs.namenode.https-bind-host 0.0.0.0
addProperty $HADOOP_HOME/etc/hadoop/hdfs-site.xml dfs.client.use.datanode.hostname true
addProperty $HADOOP_HOME/etc/hadoop/hdfs-site.xml dfs.datanode.use.datanode.hostname true

# YARN
addProperty $HADOOP_HOME/etc/hadoop/yarn-site.xml yarn.resourcemanager.bind-host 0.0.0.0
addProperty $HADOOP_HOME/etc/hadoop/yarn-site.xml yarn.nodemanager.bind-host 0.0.0.0
addProperty $HADOOP_HOME/etc/hadoop/yarn-site.xml yarn.nodemanager.bind-host 0.0.0.0
addProperty $HADOOP_HOME/etc/hadoop/yarn-site.xml yarn.timeline-service.bind-host 0.0.0.0

# MAPRED
addProperty $HADOOP_HOME/etc/hadoop/mapred-site.xml yarn.nodemanager.bind-host 0.0.0.0


for i in ${SERVICE_PRECONDITION[@]}
do
    wait_for_it ${i}
done

if [[ "${HOSTNAME}" =~ "kylin" ]]; then
  $KYLIN_HOME/bin/kylin.sh start-foreground
  while true; do
    sleep 60
  done
  
fi