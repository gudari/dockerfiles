#!/bin/bash

MLFLOW_HOST=${MLFLOW_HOST:-"127.0.0.1"}
MLFLOW_PORT=${MLFLOW_PORT:-5000}

MLFLOW_BACKEND_STORE_URI=${MLFLOW_BACKEND_STORE_URI:-file:///$MLFLOW_HOME/mlruns}
MLFLOW_DEFAULT_ARTIFACT_ROOT=${MLFLOW_DEFAULT_ARTIFACT_ROOT:-file:///$MLFLOW_HOME/artifact_root}

if [ "$MLFLOW_BACKEND_STORE_URI" == file://* ]
then
    mkdir -p `echo ${MLFLOW_BACKEND_STORE_URI#file://}`
fi

if [ "$MLFLOW_DEFAULT_ARTIFACT_ROOT" == file://* ]
then
    mkdir -p `echo ${MLFLOW_DEFAULT_ARTIFACT_ROOT#file://}`
fi

mlflow server -h $MLFLOW_HOST \
              -p $MLFLOW_PORT \
              --backend-store-uri $MLFLOW_BACKEND_STORE_URI \
              --default-artifact-root $MLFLOW_DEFAULT_ARTIFACT_ROOT
