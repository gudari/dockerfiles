FROM gudari/openjdk:8.0.242

LABEL maintainer "Axier Artola <aartola1986@gmail.com>"
LABEL Description="Apache Zookeeper docker image" Version="3.4.14"

ARG ZOOKEEPER_REST_VERSION=3.4.14
ENV ZOOKEEPER_REST_HOME=/opt/zookeeper-rest
ENV TEMP_DIR=/opt/tmp
ENV INIT_DIR=/opt/init

RUN apt-get update \
    && apt-get install --no-install-recommends -y wget netcat \
    && wget https://archive.apache.org/dist/zookeeper/zookeeper-${ZOOKEEPER_REST_VERSION}/zookeeper-${ZOOKEEPER_REST_VERSION}.tar.gz \
    && mkdir -p ${ZOOKEEPER_REST_HOME} \
    && mkdir -p ${TEMP_DIR} \
    && tar xvf zookeeper-${ZOOKEEPER_REST_VERSION}.tar.gz -C ${TEMP_DIR} --strip-components=1 \
    && cp -R ${TEMP_DIR}/zookeeper-contrib/zookeeper-contrib-rest/* $ZOOKEEPER_REST_HOME \
    && cp ${TEMP_DIR}/zookeeper-${ZOOKEEPER_REST_VERSION}.jar ${ZOOKEEPER_REST_HOME} \
    && rm -fr zookeeper-${ZOOKEEPER_REST_VERSION}.tar.gz \
    && rm -fr $TEMP_DIR \
    && apt-get remove -y wget \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p ${INIT_DIR}

WORKDIR ${ZOOKEEPER_REST_HOME}

COPY scripts/zookeeper-rest.sh ${ZOOKEEPER_REST_HOME}
COPY scripts/bootstrap.sh ${INIT_DIR}
RUN chmod +x ${ZOOKEEPER_REST_HOME}/zookeeper-rest.sh \
    ${INIT_DIR}/bootstrap.sh

CMD ${INIT_DIR}/bootstrap.sh
