FROM debian:10.3-slim

ARG AIRFLOW_VERSION=1.10.9
ENV AIRFLOW_HOME /opt/airflow
ENV INIT_DIR /opt/init

RUN apt-get update \
    && mkdir -p $AIRFLOW_HOME \
    && apt-get install -y --no-install-recommends build-essential python3 python3-pip python3-dev \
    && pip3 install --no-cache-dir --upgrade setuptools pip \
    && pip3 install --no-cache-dir apache-airflow==${AIRFLOW_VERSION} \
    && airflow initdb

COPY scripts/bootstrap.sh ${INIT_DIR}/bootstrap.sh
RUN chmod +x ${INIT_DIR}/bootstrap.sh

CMD ${INIT_DIR}/bootstrap.sh
