FROM gudari/java:8.0.212

LABEL maintainer "Axier Artola <aartola1986@gmail.com>"
LABEL Description="Hadoop docker image" Version="2.7.7"

ARG HADOOP_VERSION=2.7.7
ENV HADOOP_HOME=/opt/hadoop

RUN yum install -y wget which nc && \
    wget https://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz && \
    mkdir $HADOOP_HOME && \
    tar -xvzf hadoop-${HADOOP_VERSION}.tar.gz -C ${HADOOP_HOME} --strip-components=1 && \
    rm -fr hadoop-${HADOOP_VERSION}.tar.gz && \
    yum remove -y wget && \
    yum autoremove -y && \
    yum clean all -y && \
    rm -fr /var/cache/yum && \
    mkdir -p /opt/init

ENV HADOOP_PREFIX=${HADOOP_HOME} \
    HADOOP_COMMON_HOME=${HADOOP_HOME} \
    HADOOP_HDFS_HOME=${HADOOP_HOME} \
    HADOOP_MAPRED_HOME=${HADOOP_HOME} \
    HADOOP_YARN_HOME=${HADOOP_HOME} \
    HADOOP_CONF_DIR=${HADOOP_HOME}/etc/hadoop \
    YARN_CONF_DIR=${HADOOP_HOME}/etc/hadoop \
    PATH=${PATH}:${HADOOP_HOME}/bin

WORKDIR $HADOOP_PREFIX

COPY scripts/bootstrap.sh /opt/init/bootstrap.sh
RUN chmod +x /opt/init/bootstrap.sh

CMD /opt/init/bootstrap.sh