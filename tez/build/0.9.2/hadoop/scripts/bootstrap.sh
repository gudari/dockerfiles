#!/bin/bash

export TIMELINE_SERVER=${TIMELINE_SERVER:-http://localhost:8188}
export RESOURCE_MANAGER=${RESOURCE_MANAGER:-http://localhost:8088}
export RESOURCE_MANAGER_WEB_PROXY=${RESOURCE_MANAGER_WEB_PROXY:-http://localhost:8088}
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

function generate_tez_site() {
  cat > $TEZ_HOME/conf/tez-site.xml << EOF
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

cat > $TOMCAT_HOME/webapps/tez-ui/config/configs.env << EOF
/**
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

ENV = {
  hosts: {
    /*
     * Timeline Server Address:
     * By default TEZ UI looks for timeline server at http://localhost:8188, uncomment and change
     * the following value for pointing to a different address.
     */
    timeline: "${TEZ_UI_TIMELINE_SERVER}",

    /*
     * Resource Manager Address:
     * By default RM REST APIs are expected to be at http://localhost:8088, uncomment and change
     * the following value to point to a different address.
     */
    rm: "${TEZ_UI_RESOURCE_MANAGER}",

    /*
     * Resource Manager Web Proxy Address:
     * Optional - By default, value configured as RM host will be taken as proxy address
     * Use this configuration when RM web proxy is configured at a different address than RM.
     */
    rmProxy: "${TEZ_UI_RESOURCE_MANAGER_WEB_PROXY}",
  },

  /*
   * Time Zone in which dates are displayed in the UI:
   * If not set, local time zone will be used.
   * Refer http://momentjs.com/timezone/docs/ for valid entries.
   */
  //timeZone: "UTC",

  /*
   * yarnProtocol:
   * If specified, this protocol would be used to construct node manager log links.
   * Possible values: http, https
   * Default value: If not specified, protocol of hosts.rm will be used
   */
  //yarnProtocol: "<value>",
};
EOF

generate_core_site
generate_hdfs_site
generate_mapred_site
generate_yarn_site
generate_tez_site

configure $HADOOP_HOME/etc/hadoop/core-site.xml core CORE_CONF
configure $HADOOP_HOME/etc/hadoop/hdfs-site.xml hdfs HDFS_CONF
configure $HADOOP_HOME/etc/hadoop/yarn-site.xml yarn YARN_CONF
configure $HADOOP_HOME/etc/hadoop/mapred-site.xml mapred MAPRED_CONF
configure $HADOOP_HOME/etc/hadoop/httpfs-site.xml httpfs HTTPFS_CONF
configure $HADOOP_HOME/etc/hadoop/kms-site.xml kms KMS_CONF
configure $TEZ_HOME/conf/tez-site.xml tez TEZ_SITE


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

if [[ "${HOSTNAME}" =~ "namenode" ]]; then
  namedir=`echo $HDFS_CONF_dfs_namenode_name_dir | sed -e 's#file://##'`
  mkdir -p $namedir
  if [ ! -d $namedir ]; then
    echo "Namenode name directory not found: $namedir"
    exit 2
  fi

  if [ -z "$CLUSTER_NAME" ]; then
    echo "Cluster name not specified"
    exit 2
  fi

  if [ "`ls -A $namedir`" == "" ]; then
    echo "Formatting namenode name directory: $namedir"
    $HADOOP_PREFIX/bin/hdfs --config $HADOOP_CONF_DIR namenode -format $CLUSTER_NAME 
  fi

  $HADOOP_PREFIX/bin/hdfs --config $HADOOP_CONF_DIR namenode
fi

if [[ "${HOSTNAME}" =~ "datanode" ]]; then
  datadir=`echo $HDFS_CONF_dfs_datanode_data_dir | sed -e 's#file://##'`
  mkdir -p $datadir
  if [ ! -d $datadir ]; then
    echo "Datanode data directory not found: $datadir"
    exit 2
  fi

  $HADOOP_PREFIX/bin/hdfs --config $HADOOP_CONF_DIR datanode
fi

if [[ "${HOSTNAME}" =~ "resourcemanager" ]]; then

  hdfs_status=`hdfs dfsadmin -safemode get`
  while [[ $hdfs_status == *"ON"* ]]; do
    sleep 5
    hdfs_status=`hdfs dfsadmin -safemode get`
    echo "HDFS status in safe mode!!!!"
  done

  $HADOOP_PREFIX/bin/yarn --config $HADOOP_CONF_DIR resourcemanager
fi

if [[ "${HOSTNAME}" =~ "nodemanager" ]]; then

  hdfs_status=`hdfs dfsadmin -safemode get`
  while [[ $hdfs_status == *"ON"* ]]; do
    sleep 5
    hdfs_status=`hdfs dfsadmin -safemode get`
    echo "HDFS status in safe mode!!!!"
  done

  $HADOOP_PREFIX/bin/yarn --config $HADOOP_CONF_DIR nodemanager
fi

if [[ "${HOSTNAME}" =~ "historyserver" ]]; then

  hdfs_status=`hdfs dfsadmin -safemode get`
  while [[ $hdfs_status == *"ON"* ]]; do
    sleep 5
    hdfs_status=`hdfs dfsadmin -safemode get`
    echo "HDFS status in safe mode!!!!"
  done

  $HADOOP_PREFIX/bin/mapred --config $HADOOP_CONF_DIR historyserver
fi

if [[ "${HOSTNAME}" =~ "timelineserver" ]]; then

  hdfs_status=`hdfs dfsadmin -safemode get`
  while [[ $hdfs_status == *"ON"* ]]; do
    sleep 5
    hdfs_status=`hdfs dfsadmin -safemode get`
    echo "HDFS status in safe mode!!!!"
  done

  $HADOOP_PREFIX/bin/yarn --config $HADOOP_CONF_DIR timelineserver
fi

if [[ "${HOSTNAME}" =~ "tez-ui" ]]; then

  hdfs_status=`hdfs dfsadmin -safemode get`
  while [[ $hdfs_status == *"ON"* ]]; do
    sleep 5
    hdfs_status=`hdfs dfsadmin -safemode get`
    echo "HDFS status in safe mode!!!!"
  done

  hadoop fs -mkdir -p /apps/tez-$TEZ_VERSION
  hadoop fs -copyFromLocal share/tez.tar.gz /apps/$TEZ_VERSION

  ${TOMCAT_HOME}/bin/catalina.sh run

fi
