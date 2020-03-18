FROM gudari/hadoop:2.7.7

ARG HBASE_VERSION=2.1.9
ENV HBASE_HOME /opt/hbase
ENV INIT_DIR=/opt/init

LABEL maintainer "Axier Artola <aartola1986@gmail.com>"
LABEL Description="Hbase docker image" Version="2.1.9"

RUN apt-get update \
    && apt-get install -y --no-install-recommends wget netcat \
    && wget https://archive.apache.org/dist/hbase/${HBASE_VERSION}/hbase-${HBASE_VERSION}-bin.tar.gz \
    && mkdir -p $HBASE_HOME \
    && tar -xvzf hbase-${HBASE_VERSION}-bin.tar.gz -C ${HBASE_HOME} --strip-components=1 \
    && rm -fr hbase-${HBASE_VERSION}-bin.tar.gz \
    && apt-get remove -y wget \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p ${INIT_DIR}

ENV PATH=${PATH}:${HBASE_HOME}/bin

WORKDIR $HBASE_HOME

COPY scripts/bootstrap.sh ${INIT_DIR}/bootstrap.sh
COPY conf $HBASE_HOME/conf
RUN chmod +x ${INIT_DIR}/bootstrap.sh

CMD ${INIT_DIR}/bootstrap.sh
