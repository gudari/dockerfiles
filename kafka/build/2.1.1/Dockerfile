FROM gudari/openjdk:8.0.252

LABEL maintainer "Axier Artola <aartola1986@gmail.com>"
LABEL Description="Kafka docker image" Version="2.1.1" Scala_version="2.12"


ARG KAFKA_VERSION=2.1.1
ARG SCALA_VERSION=2.12
ENV KAFKA_HOME=/opt/kafka
ENV INIT_DIR=/opt/init

RUN apt-get update \
    && apt-get install --no-install-recommends -y wget netcat \
    && wget https://archive.apache.org/dist/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz \
    && mkdir -p ${KAFKA_HOME} \
    && tar xvf kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C ${KAFKA_HOME} --strip-components=1 \
    && rm -fr kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz \
    && rm -fr $KAFKA_HOME/site-docs \
    && apt-get remove -y wget \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p ${INIT_DIR}

WORKDIR ${KAFKA_HOME}

COPY scripts/bootstrap.sh ${INIT_DIR}/bootstrap.sh
RUN chmod +x ${INIT_DIR}/bootstrap.sh

CMD ${INIT_DIR}/bootstrap.sh
