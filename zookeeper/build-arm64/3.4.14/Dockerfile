FROM arm64v8/adoptopenjdk:8u252-b09-jdk-hotspot-bionic

LABEL maintainer "Axier Artola <aartola1986@gmail.com>"
LABEL Description="Apache Zookeeper docker image" Version="3.4.14"

ARG ZOOKEEPER_VERSION=3.4.14
ENV ZOOKEEPER_HOME=/opt/zookeeper
ENV INIT_DIR=/opt/init


RUN set -eux; \
    groupadd -r zookeeper --gid=1000; \
    useradd -r -g zookeeper --uid=1000 zookeeper;

RUN apt-get update \
    && apt-get install --no-install-recommends -y wget netcat gosu \
    && wget https://archive.apache.org/dist/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/zookeeper-${ZOOKEEPER_VERSION}.tar.gz \
    && wget https://archive.apache.org/dist/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/zookeeper-${ZOOKEEPER_VERSION}.tar.gz.sha512 \
    && sha512sum -c zookeeper-${ZOOKEEPER_VERSION}.tar.gz.sha512 \
    && mkdir -p ${ZOOKEEPER_HOME} \
    && chown -R zookeeper:zookeeper ${ZOOKEEPER_HOME} \
    && su - zookeeper -c "tar xvf zookeeper-${ZOOKEEPER_VERSION}.tar.gz -C ${ZOOKEEPER_HOME} --strip-components=1" \
    && rm -fr zookeeper-${ZOOKEEPER_VERSION}.tar.gz \
    && rm -fr zookeeper-${ZOOKEEPER_VERSION}.tar.gz.sha512 \
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

ENV PATH=${PATH}:${ZOOKEEPER_HOME}/bin

EXPOSE 2181 2888 3888 8080

COPY scripts/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD [ "zkServer.sh", "start-foreground" ]
