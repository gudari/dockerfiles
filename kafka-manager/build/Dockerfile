FROM gudari/java:8u201-b09 AS build-env

ARG KAFKAMANAGER_VERSION=2.0.0.2
ENV KAFKAMANAGER_BUILD_DIR=/tmp/kafkamanager-build

RUN yum install -y wget && \
    wget https://github.com/yahoo/kafka-manager/archive/${KAFKAMANAGER_VERSION}.tar.gz && \
    mkdir -p ${KAFKAMANAGER_BUILD_DIR} && \
    tar xvf ${KAFKAMANAGER_VERSION}.tar.gz -C ${KAFKAMANAGER_BUILD_DIR} --strip-components=1 && \
    rm -fr ${KAFKAMANAGER_VERSION}.tar.gz

WORKDIR ${KAFKAMANAGER_BUILD_DIR}
RUN ./sbt clean dist

WORKDIR ${KAFKAMANAGER_BUILD_DIR}/target/universal
RUN yum install -y unzip && \
    unzip kafka-manager-${KAFKAMANAGER_VERSION}.zip

FROM gudari/java:8u201-b09

ARG KAFKAMANAGER_VERSION=2.0.0.2
ENV KAFKAMANAGER_HOME=/opt/kafka-manager

RUN mkdir -p ${KAFKAMANAGER_HOME}
WORKDIR ${KAFKAMANAGER_HOME}
COPY --from=build-env /tmp/kafkamanager-build/target/universal/kafka-manager-${KAFKAMANAGER_VERSION} .

CMD bin/kafka-manager -Dconfig.file=${KAFKAMANAGER_HOME}/conf/application.conf

