FROM gudari/openjdk:8.0.252

LABEL maintainer "Axier Artola <aartola1986@gmail.com>"
LABEL Description="Apache Zookeeper docker image" Version="3.5.8"

ARG ZOOKEEPER_VERSION=3.5.8
ENV ZOOKEEPER_HOME=/opt/zookeeper
ENV INIT_DIR=/opt/init


RUN apt-get update \
    && apt-get install --no-install-recommends -y wget netcat \
    && wget https://archive.apache.org/dist/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz \
    && mkdir -p ${ZOOKEEPER_HOME} \
    && tar xvf apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz -C ${ZOOKEEPER_HOME} --strip-components=1 \
    && rm -fr apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz \
    && rm -fr $ZOOKEEPER_HOME/src \
    $ZOOKEEPER_HOME/recipes \
    $ZOOKEEPER_HOME/docs \
    $ZOOKEEPER_HOME/contrib \
    $ZOOKEEPER_HOME/dist-maven \
    $ZOOKEEPER_HOME/zoopeeker-recipes \
    $ZOOKEEPER_HOME/zoopeeker-docs \
    $ZOOKEEPER_HOME/zoopeeker-recipes \
    $ZOOKEEPER_HOME/zoopeeker-contrib \
    && apt-get remove -y wget \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p ${INIT_DIR}

WORKDIR ${ZOOKEEPER_HOME}

COPY scripts/bootstrap.sh ${INIT_DIR}/bootstrap.sh
RUN chmod +x ${INIT_DIR}/bootstrap.sh

CMD ${INIT_DIR}/bootstrap.sh
