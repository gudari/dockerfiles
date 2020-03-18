#!/bin/bash

function generate_hue_ini() {
  local path=$1
  cat > $path << EOF
# Hue configuration file
# ===================================
#
# For complete documentation about the contents of this file, run
#   $ <hue_root>/build/env/bin/hue config_help
#
# All .ini files under the current directory are treated equally.  Their
# contents are merged to form the Hue configuration, which can
# can be viewed on the Hue at
#   http://<hue_host>:<port>/dump_config
# Start
# End
EOF
}

function addProperty() {
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
        addProperty $path $name "$value"
    done
}

#generate_hue_ini $HUE_HOME/desktop/conf/hue.ini
#configure $HUE_HOME/desktop/conf/hue.ini hue HUE_INI

#generate_hue_ini hue.ini
#configure hue.ini hue HUE_INI
#python /opt/init/generate_hue_ini_file.py /opt/hue/desktop/conf/hue.ini
#rm -fr /opt/hue/desktop/conf/pseudo-distributed.ini.tmpl
#rm -fr /opt/hue/desktop/conf/pseudo-distributed.ini

build/env/bin/supervisor