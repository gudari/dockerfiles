FROM gudari/openjdk:8.0.242

ARG ACTIVEMQ_VERSION=5.15.12
ENV ACTIVEMQ_HOME=/opt/activemq \
    INIT_DIR=/opt/init

RUN apt-get update \
    && apt-get install -y --no-install-recommends wget procps \
    && wget http://archive.apache.org/dist/activemq/${ACTIVEMQ_VERSION}/apache-activemq-${ACTIVEMQ_VERSION}-bin.tar.gz \
    && mkdir $ACTIVEMQ_HOME \
    && tar -xvzf apache-activemq-${ACTIVEMQ_VERSION}-bin.tar.gz -C ${ACTIVEMQ_HOME} --strip-components=1 \
    && rm -fr apache-activemq-${ACTIVEMQ_VERSION}-bin.tar.gz \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p ${INIT_DIR}

ENV PATH=$PATH:$ACTIVEMQ_HOME/bin

WORKDIR $ACTIVEMQ_HOME

CMD bin/activemq console
