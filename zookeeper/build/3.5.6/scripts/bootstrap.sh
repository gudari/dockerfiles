#!/bin/bash

ZOO_CFG_dataDir=${ZOO_CFG_dataDir:-/var/lib/zookeeper}
ZOO_MYID=${ZOO_MYID:-1}

function generate_zoo_cfg() {
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

function generate_myid() {
  local path=$1
  local module=$2
  local value=$3

  mkdir -p $path
  echo $value > $path/myid
}

generate_zoo_cfg $ZOOKEEPER_HOME/conf/zoo.cfg
configure $ZOOKEEPER_HOME/conf/zoo.cfg zoo ZOO_CFG
generate_myid $ZOO_CFG_dataDir zoo $ZOO_MYID

#debug
cat $ZOOKEEPER_HOME/conf/zoo.cfg
cat $ZOO_CFG_dataDir/myid

if [[ "${HOSTNAME}" =~ "zookeeper" ]]; then
  $ZOOKEEPER_HOME/bin/zkServer.sh start-foreground
fi
