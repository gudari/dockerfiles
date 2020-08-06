FROM openjdk:8u252-jdk-slim-buster

LABEL maintainer "Axier Artola <aartola1986@gmail.com>"
LABEL Description="Apache Zookeeper docker image" Version="3.4.14"

ARG ZOOKEEPER_REST_VERSION=3.4.14
ENV ZOOKEEPER_REST_HOME=/opt/zookeeper-rest
ENV TEMP_DIR=/opt/tmp
ENV INIT_DIR=/opt/init

RUN set -eux; \
    groupadd -r zookeeper-rest --gid=1000; \
    useradd -r -g zookeeper-rest --uid=1000 zookeeper-rest;

RUN apt-get update \
    && apt-get install --no-install-recommends -y wget netcat gosu \
    && wget https://archive.apache.org/dist/zookeeper/zookeeper-${ZOOKEEPER_REST_VERSION}/zookeeper-${ZOOKEEPER_REST_VERSION}.tar.gz \
    && wget https://archive.apache.org/dist/zookeeper/zookeeper-${ZOOKEEPER_REST_VERSION}/zookeeper-${ZOOKEEPER_REST_VERSION}.tar.gz.sha512 \
    && sha512sum -c zookeeper-${ZOOKEEPER_REST_VERSION}.tar.gz.sha512 \
    && mkdir -p ${ZOOKEEPER_REST_HOME} \
    && chown -R zookeeper-rest:zookeeper-rest ${ZOOKEEPER_REST_HOME} \
    && mkdir -p ${TEMP_DIR} \
    && chown -R zookeeper-rest:zookeeper-rest ${TEMP_DIR} \
    && su - zookeeper-rest -c "tar xvf zookeeper-${ZOOKEEPER_REST_VERSION}.tar.gz -C ${TEMP_DIR} --strip-components=1" \
    && su - zookeeper-rest -c "cp -R ${TEMP_DIR}/zookeeper-contrib/zookeeper-contrib-rest/* $ZOOKEEPER_REST_HOME" \
    && su - zookeeper-rest -c "cp ${TEMP_DIR}/zookeeper-${ZOOKEEPER_REST_VERSION}.jar ${ZOOKEEPER_REST_HOME}" \
    && rm -fr zookeeper-${ZOOKEEPER_REST_VERSION}.tar.gz \
    && rm -fr $TEMP_DIR \
    && apt-get remove -y wget \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p ${INIT_DIR}

WORKDIR ${ZOOKEEPER_REST_HOME}

COPY scripts/zookeeper-rest.sh ${ZOOKEEPER_REST_HOME}/zookeeper-rest.sh
COPY scripts/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x ${ZOOKEEPER_REST_HOME}/zookeeper-rest.sh \
    /docker-entrypoint.sh

ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD [ "zookeeper-rest" ]
