#!/bin/bash

export SPARK_DIST_CLASSPATH=$(hadoop classpath)

bin/livy-server