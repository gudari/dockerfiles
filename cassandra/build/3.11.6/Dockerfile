FROM gudari/openjdk:8.0.242

LABEL maintainer "Axier Artola <aartola1986@gmail.com>"
LABEL Description="Cassandra docker image" Version="3.11.6"

ARG CASSANDRA_VERSION=3.11.6
ENV CASSANDRA_HOME=/opt/cassandra
ENV INIT_DIR=/opt/init

RUN apt-get update \
    && apt-get install --no-install-recommends -y wget netcat procps libjemalloc-dev \
    && wget https://archive.apache.org/dist/cassandra/${CASSANDRA_VERSION}/apache-cassandra-${CASSANDRA_VERSION}-bin.tar.gz \
    && mkdir -p $CASSANDRA_HOME \
    && tar -xvzf apache-cassandra-${CASSANDRA_VERSION}-bin.tar.gz -C ${CASSANDRA_HOME} --strip-components=1 \
    && rm -fr apache-cassandra-${CASSANDRA_VERSION}-bin.tar.gz \
    && apt-get remove -y wget \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p ${INIT_DIR}

ENV PATH=${PATH}:${CASSANDRA_HOME}/bin

WORKDIR $CASSANDRA_HOME

COPY scripts/bootstrap.sh ${INIT_DIR}/bootstrap.sh
RUN chmod +x ${INIT_DIR}/bootstrap.sh

CMD ${INIT_DIR}/bootstrap.sh
