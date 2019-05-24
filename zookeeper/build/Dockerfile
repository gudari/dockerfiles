FROM gudari/java:8u201-b09

ARG ZOOKEEPER_VERSION=3.4.14
ENV ZOOKEEPER_HOME=/opt/zookeeper

RUN yum install -y wget && \
    wget https://archive.apache.org/dist/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/zookeeper-${ZOOKEEPER_VERSION}.tar.gz && \
    mkdir -p ${ZOOKEEPER_HOME} && \
    tar xvf zookeeper-${ZOOKEEPER_VERSION}.tar.gz -C ${ZOOKEEPER_HOME} --strip-components=1 && \
    rm -fr zookeeper-${ZOOKEEPER_VERSION}.tar.gz && \
    rm -fr $ZOOKEEPER_HOME/src \
    $ZOOKEEPER_HOME/recipes \
    $ZOOKEEPER_HOME/docs \
    $ZOOKEEPER_HOME/contrib && \
    yum remove -y wget && \
    yum autoremove -y && \
    yum clean all -y && \
    rm -rf /var/cache/yum && \
    mkdir /opt/init

WORKDIR ${ZOOKEEPER_HOME}

COPY scritps/bootstrap.sh /opt/init/bootstrap.sh
RUN chmod +x /opt/init/bootstrap.sh

CMD /opt/init/bootstrap.sh
