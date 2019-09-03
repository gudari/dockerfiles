FROM gudari/java:8.0.212

LABEL maintainer "Axier Artola <aartola1986@gmail.com>"
LABEL Description="Kafka docker image" Version="2.1.1" Scala_version="2.12"


ARG KAFKA_VERSION=2.1.1
ARG SCALA_VERSION=2.12
ENV KAFKA_HOME=/opt/kafka

RUN yum install -y wget && \
    wget https://archive.apache.org/dist/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz && \
    mkdir -p ${KAFKA_HOME} && \
    tar xvf kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C ${KAFKA_HOME} --strip-components=1 && \
    rm -fr kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz && \
    yum remove -y wget && \
    yum autoremove -y && \
    yum clean all -y && \
    rm -fr /var/cache/yum && \
    mkdir -p /opt/init

WORKDIR ${KAFKA_HOME}

COPY scripts/bootstrap.sh /opt/init/bootstrap.sh
RUN chmod +x /opt/init/bootstrap.sh

CMD /opt/init/bootstrap.sh
