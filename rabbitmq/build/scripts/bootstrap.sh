#!/bin/bash

RABBITMQ_ADMIN_PASSWORD=${RABBITMQ_ADMIN_PASSWORD:-admin}
RABBITMQ_ADMIN_PASSWORD=${RABBITMQ_ADMIN_PASSWORD:-admin1234}

rabbitmq-server -detached
sleep 10

# Create admin user nd password
rabbitmqctl add_user $RABBITMQ_ADMIN_USER $RABBITMQ_ADMIN_PASSWORD
rabbitmqctl set_user_tags $RABBITMQ_ADMIN_USER administrator
rabbitmqctl set_permissions -p / $RABBITMQ_ADMIN_USER ".*" ".*" ".*"

# Delete default user
rabbitmqctl delete_user guest
rabbitmqctl stop

sleep 10
rabbitmq-server
