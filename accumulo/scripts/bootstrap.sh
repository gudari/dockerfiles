#!/bin/bash



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

function generate_accumulo_site() {
  local path=$1
  cat > $path << EOF
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

generate_accumulo_site $ACCUMULO_HOME/conf/accumulo-site.xml
configure $ACCUMULO_HOME/conf/accumulo-site.xml accumulo ACCUMULO_CONF

export LD_LIBRARY_PATH=${HADOOP_PREFIX}/lib/native/${PLATFORM}:${LD_LIBRARY_PATH}

. "$ACCUMULO_HOME"/bin/config.sh

if [[ "${HOSTNAME}" =~ "monitor" ]]; then
  export ACCUMULO_MONITOR_BIND_ALL=true
  $ACCUMULO_HOME/bin/accumulo monitor --address 0.0.0.0
fi

if [[ "${HOSTNAME}" =~ "master" ]]; then
  $ACCUMULO_HOME/bin/accumulo init --instance-name $ACCUMULO_INSTANCE_NAME --password $ACCUMULO_CONF_trace_token_property_password
  $ACCUMULO_HOME/bin/accumulo master --address $(hostname)
fi

if [[ "${HOSTNAME}" =~ "tserver" ]]; then
  $ACCUMULO_HOME/bin/accumulo tserver --address $(hostname)
fi

if [[ "${HOSTNAME}" =~ "gc" ]]; then
  $ACCUMULO_HOME/bin/accumulo gc --address $(hostname)
fi

if [[ "${HOSTNAME}" =~ "tracer" ]]; then
  $ACCUMULO_HOME/bin/accumulo tracer --address $(hostname)
fi
