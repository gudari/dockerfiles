#!/bin/bash

# configure default values
export HUE_INI_desktop_database_engine=${HUE_INI_desktop_database_engine:-sqlite3}
export HUE_INI_desktop_database_name=${HUE_INI_desktop_database_name:-desktop/desktop.db}

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

mkdir -p $HUE_HOME/desktop/conf

rm -fr /opt/hue/desktop/conf/*
$INIT_DIR/fill_template_jinja2.py $TEMPLATES_DIR/hue.ini.jinja2 $HUE_HOME/desktop/conf/hue.ini HUE_INI

for i in ${SERVICE_PRECONDITION[@]}
do
    wait_for_it ${i}
done

if [[ "$HUE_INI_desktop_database_engine" != "sqlite3" ]]; then
  $HUE_HOME/build/env/bin/hue syncdb --noinput
  $HUE_HOME/build/env/bin/hue migrate
fi

$HUE_HOME/build/env/bin/supervisor