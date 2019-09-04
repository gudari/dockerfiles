FROM gudari/java:8.0.212

LABEL maintainer "Axier Artola <aartola1986@gmail.com>"
LABEL Description="Apache Zookeeper docker image" Version="3.5.5"

ARG ZOOKEEPER_VERSION=3.5.5
ENV ZOOKEEPER_HOME=/opt/zookeeper

RUN yum install -y wget && \
    wget https://archive.apache.org/dist/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz && \
    mkdir -p ${ZOOKEEPER_HOME} && \
    tar xvf apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz -C ${ZOOKEEPER_HOME} --strip-components=1 && \
    rm -fr apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz && \
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

COPY scripts/bootstrap.sh /opt/init/bootstrap.sh
RUN chmod +x /opt/init/bootstrap.sh

CMD /opt/init/bootstrap.sh
