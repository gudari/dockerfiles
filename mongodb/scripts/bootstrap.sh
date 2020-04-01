#!/bin/bash

mkdir -p $MONGODB_HOME/data

bin/mongod --bind_ip_all --dbpath $MONGODB_HOME/data