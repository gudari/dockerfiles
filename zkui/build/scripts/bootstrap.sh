#!/bin/bash

function generate_config_cfg() {
  local path=$1
  cat > $path << EOF
# This is a zoo.cfg config file created at startup.
# Start
# End
EOF
}

function addConfiguration() {
  local path=$1
  local name=$2
  local value=$3

  local entry="$name=$value"
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

generate_config_cfg $ZKUI_HOME/config.cfg
configure $ZKUI_HOME/config.cfg zkui ZKUI_CONFIG_CFG

#debug
cat $ZKUI_HOME/config.cfg

if [[ "${HOSTNAME}" =~ "zkui" ]]; then
  java -jar zkui-2.0-SNAPSHOT-jar-with-dependencies.jar
fi
