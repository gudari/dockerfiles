#!/bin/bash


function generate_elasticsearch_yml() {
  local path=$1
  cat > $path << EOF
# ======================== Elasticsearch Configuration =========================                                                                                               
#                                                                                                                                                                              
# NOTE: Elasticsearch comes with reasonable defaults for most settings.                                                                                                        
#       Before you set out to tweak and tune the configuration, make sure you                                                                                                  
#       understand what are you trying to accomplish and the consequences.                                                                                                     
#
# The primary way of configuring a node is via this file. This template lists
# the most important settings you may want to configure for a production cluster.
#
# Please consult the documentation for further information on configuration options:
# https://www.elastic.co/guide/en/elasticsearch/reference/index.html
#

# Start
# End
EOF
}

function addConfiguration() {
  local path=$1
  local name=$2
  local value=$3

  local entry="$name: $value"
  local escapedEntry=$(echo $entry | sed 's/\//\\\//g')
  sed -i "/#\ End/ s/.*/${escapedEntry}\n&/" $path
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
        addConfiguration $path $name "$value"
    done
}

generate_elasticsearch_yml $ELASTICSEARCH_HOME/config/elasticsearch.yml
addConfiguration $ELASTICSEARCH_HOME/config/elasticsearch.yml node.name $(hostname)
configure $ELASTICSEARCH_HOME/config/elasticsearch.yml elasticsearch ELASTICSEARCH_YML

if [[ "${HOSTNAME}" =~ "elasticsearch" ]]; then
  $ELASTICSEARCH_HOME/bin/elasticsearch
fi
