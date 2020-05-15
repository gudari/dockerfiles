#!/bin/bash

java -jar $H2O_HOME/h2o.jar -ip $(hostname -I | awk '{print $1}') --port 8080
