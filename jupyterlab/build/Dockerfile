FROM gudari/spark:2.4.5

ARG JUPYTERLAB_VERSION=2.0.1
ARG ELASTICSEARCH_VERSION=7.6.1
ARG MONGO_VERSION=3.12.2
ENV JUPYTERLAB_HOME=/opt/jupyterlab
ENV JUPYTERLAB_LIB=/opt/lib
ENV INIT_DIR /opt/init

RUN apt-get update \
    && apt-get install -y --no-install-recommends wget python3-pip \
    && pip3 install --no-cache-dir --upgrade setuptools pip \
    && pip3 install --no-cache-dir ipython jupyterlab==${JUPYTERLAB_VERSION} \
    && mkdir -p $JUPYTERLAB_LIB \
    && wget https://repo1.maven.org/maven2/org/elasticsearch/elasticsearch-hadoop-mr/${ELASTICSEARCH_VERSION}/elasticsearch-hadoop-mr-${ELASTICSEARCH_VERSION}.jar \
        -O $JUPYTERLAB_LIB/elasticsearch-hadoop-mr-${ELASTICSEARCH_VERSION}.jar \
    && wget https://repo1.maven.org/maven2/org/mongodb/spark/mongo-spark-connector_2.11/2.4.1/mongo-spark-connector_2.11-2.4.1.jar \
        -O $JUPYTERLAB_LIB/mongo-spark-connector_2.11-2.4.1.jar \
    && wget https://repo1.maven.org/maven2/org/mongodb/mongo-java-driver/${MONGO_VERSION}/mongo-java-driver-${MONGO_VERSION}.jar \
        -O $JUPYTERLAB_LIB/mongo-java-driver-${MONGO_VERSION}.jar \
    && wget https://search.maven.org/remotecontent?filepath=org/apache/spark/spark-streaming-kafka-0-8-assembly_2.11/2.4.5/spark-streaming-kafka-0-8-assembly_2.11-2.4.5.jar \
        -O $JUPYTERLAB_LIB/spark-streaming-kafka-0-8-assembly_2.11-2.4.5.jar \
    && apt-get remove -y wget \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p ${INIT_DIR}

COPY requirements.txt ${INIT_DIR}/requirements.txt
RUN pip3 install --no-cache-dir -r ${INIT_DIR}/requirements.txt

WORKDIR $JUPYTERLAB_HOME

COPY scripts/bootstrap.sh ${INIT_DIR}/bootstrap.sh
RUN echo "export PATH=$PATH" >> ~/.bashrc \
    && chmod +x ${INIT_DIR}/bootstrap.sh

ENV SHELL=/bin/bash

CMD ${INIT_DIR}/bootstrap.sh
