FROM openjdk:8u252-jdk-slim-buster

LABEL maintainer "Axier Artola <aartola1986@gmail.com>"
LABEL Description="Apache Zookeeper docker image" Version="3.5.8"

ARG ZOOKEEPER_VERSION=3.5.8
ENV ZOOKEEPER_HOME=/opt/zookeeper
ENV INIT_DIR=/opt/init


RUN set -eux; \
    groupadd -r zookeeper --gid=1000; \
    useradd -r -g zookeeper --uid=1000 zookeeper;

RUN apt-get update \
    && apt-get install --no-install-recommends -y wget netcat gosu \
    && wget https://archive.apache.org/dist/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz \
    && wget https://archive.apache.org/dist/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz.sha512 \
    && sha512sum -c apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz.sha512 \
    && mkdir -p ${ZOOKEEPER_HOME} \
    && chown -R zookeeper:zookeeper ${ZOOKEEPER_HOME} \
    && su - zookeeper -c "tar xvf apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz -C ${ZOOKEEPER_HOME} --strip-components=1" \
    && rm -fr apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz \
    && rm -fr apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz.sha512 \
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
