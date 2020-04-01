#!/bin/bash

ADMIN_USER=${ADMIN_USER:-admin}
ADMIN_FIRSTNAME=${ADMIN_FIRSTNAME:-admin}
ADMIN_LASTNAME=${ADMIN_LASTNAME:-user}
ADMIN_EMAIL=${ADMIN_EMAIL:-admin@fab.org}
ADMIN_PASSWORD=${ADMIN_PASSWORD:-admin}


export FLASK_APP=superset
flask fab create-admin \
    --username $ADMIN_USER \
    --firstname $ADMIN_FIRSTNAME \
    --lastname $ADMIN_LASTNAME \
    --email $ADMIN_EMAIL \
    --password $ADMIN_PASSWORD

superset load_examples
superset init
superset run -p 8088 -h 0.0.0.0 --with-threads