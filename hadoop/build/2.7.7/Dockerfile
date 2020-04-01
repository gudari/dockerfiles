FROM gudari/openjdk:8.0.242

LABEL maintainer "Axier Artola <aartola1986@gmail.com>"
LABEL Description="Hadoop docker image" Version="2.7.7"

ARG HADOOP_VERSION=2.7.7
ARG ELASTICSEARCH_VERSION=7.6.1
ENV HADOOP_HOME=/opt/hadoop
ENV INIT_DIR=/opt/init

RUN apt-get update \
    && apt-get install --no-install-recommends -y wget netcat \
    && wget https://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz \
    && mkdir -p $HADOOP_HOME \
    && tar -xvzf hadoop-${HADOOP_VERSION}.tar.gz -C ${HADOOP_HOME} --strip-components=1 \
    && mkdir -p $HADOOP_HOME/share/hadoop/elasticsearch \
    && wget https://repo1.maven.org/maven2/org/elasticsearch/elasticsearch-hadoop-mr/${ELASTICSEARCH_VERSION}/elasticsearch-hadoop-mr-${ELASTICSEARCH_VERSION}.jar \
        -O $HADOOP_HOME/share/hadoop/elasticsearch/elasticsearch-hadoop-mr-${ELASTICSEARCH_VERSION}.jar \
    && rm -fr hadoop-${HADOOP_VERSION}.tar.gz \
    && apt-get remove -y wget \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p ${INIT_DIR}

ENV HADOOP_PREFIX=${HADOOP_HOME} \
    HADOOP_COMMON_HOME=${HADOOP_HOME} \
    HADOOP_HDFS_HOME=${HADOOP_HOME} \
    HADOOP_MAPRED_HOME=${HADOOP_HOME} \
    HADOOP_YARN_HOME=${HADOOP_HOME} \
    HADOOP_CONF_DIR=${HADOOP_HOME}/etc/hadoop \
    YARN_CONF_DIR=${HADOOP_HOME}/etc/hadoop \
    PATH=${PATH}:${HADOOP_HOME}/bin \
    HADOOP_CLASSPATH=$HADOOP_HOME/share/hadoop/elasticsearch/*

WORKDIR $HADOOP_PREFIX

COPY scripts/bootstrap.sh ${INIT_DIR}/bootstrap.sh
RUN chmod +x ${INIT_DIR}/bootstrap.sh

CMD ${INIT_DIR}/bootstrap.sh
