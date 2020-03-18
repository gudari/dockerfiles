#!/bin/bash

function generate_storm_yaml() {
  local path=$1
  cat > $path << EOF
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Start
# End
EOF
}

generate_configuration() {
  local path=$1
  cat >> $path << EOF
storm.zookeeper.servers:
  - "${STORM_YAML_storm_zookeeper_servers}"

nimbus.seeds: ["${STORM_YAML_nimbus_seeds}"]

drpc.servers:
  - "${STORM_YAML_drpc_servers}"

storm.local.dir: "/mnt/storm"

supervisor.slots.ports:
    - 6700
    - 6701

EOF
}

generate_storm_yaml $STORM_HOME/conf/storm.yaml
generate_configuration $STORM_HOME/conf/storm.yaml

#debug
cat $STORM_HOME/conf/storm.yaml

if [[ "${HOSTNAME}" =~ "nimbus" ]]; then
  $STORM_HOME/bin/storm nimbus
fi

if [[ "${HOSTNAME}" =~ "supervisor" ]]; then
  $STORM_HOME/bin/storm supervisor
fi

if [[ "${HOSTNAME}" =~ "ui" ]]; then
  $STORM_HOME/bin/storm ui
fi

if [[ "${HOSTNAME}" =~ "drpc" ]]; then
  $STORM_HOME/bin/bin/storm drpc
fi

