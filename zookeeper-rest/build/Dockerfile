FROM gudari/java:8.0.212

ARG ZOOKEEPER_REST_VERSION=3.4.14
ENV ZOOKEEPER_REST_HOME=/opt/zookeeper-rest
ENV TEMP_DIR=/opt/tmp 

RUN yum install -y wget && \
    wget https://archive.apache.org/dist/zookeeper/zookeeper-${ZOOKEEPER_REST_VERSION}/zookeeper-${ZOOKEEPER_REST_VERSION}.tar.gz && \
    mkdir -p ${ZOOKEEPER_REST_HOME} && \
    mkdir -p /opt/tmp && \
    tar xvf zookeeper-${ZOOKEEPER_REST_VERSION}.tar.gz -C ${TEMP_DIR} --strip-components=1 && \
    cp -R ${TEMP_DIR}/zookeeper-contrib/zookeeper-contrib-rest/* $ZOOKEEPER_REST_HOME && \
    cp ${TEMP_DIR}/zookeeper-${ZOOKEEPER_REST_VERSION}.jar ${ZOOKEEPER_REST_HOME} && \
    rm -fr zookeeper-${ZOOKEEPER_REST_VERSION}.tar.gz && \
    rm -fr $TEMP_DIR && \
    yum remove -y wget && \
    yum autoremove -y && \
    yum clean all -y && \
    rm -rf /var/cache/yum && \
    mkdir /opt/init

WORKDIR ${ZOOKEEPER_REST_HOME}

COPY scripts/zookeeper-rest.sh ${ZOOKEEPER_REST_HOME}
COPY scripts/bootstrap.sh /opt/init
RUN chmod +x ${ZOOKEEPER_REST_HOME}/zookeeper-rest.sh \
    /opt/init/bootstrap.sh

CMD /opt/init/bootstrap.sh
