FROM gudari/openjdk:8.0.242

ARG ELASTICSEARCH_VERSION=7.6.1
ENV ELASTICSEARCH_HOME=/opt/elasticsearch
ENV INIT_DIR=/opt/init

RUN apt-get update \
    && apt-get -y install --no-install-recommends wget \
    && wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ELASTICSEARCH_VERSION}-linux-x86_64.tar.gz \
    && mkdir -p $ELASTICSEARCH_HOME \
    && tar -xvzf elasticsearch-${ELASTICSEARCH_VERSION}-linux-x86_64.tar.gz -C ${ELASTICSEARCH_HOME} --strip-components=1 \
    && rm -fr elasticsearch-${ELASTICSEARCH_VERSION}-linux-x86_64.tar.gz \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p ${INIT_DIR}

RUN groupadd elasticsearch \
    && useradd elasticsearch -g elasticsearch -p elasticsearch \
    && chown -R elasticsearch:elasticsearch ${ELASTICSEARCH_HOME} \
    && chown -R elasticsearch:elasticsearch ${INIT_DIR}

COPY scripts/bootstrap.sh ${INIT_DIR}/bootstrap.sh
RUN chmod +x ${INIT_DIR}/bootstrap.sh

USER elasticsearch

ENV PATH=${PATH}:${ELASTICSEARCH_HOME}/bin

WORKDIR $ELASTICSEARCH_HOME

CMD ${INIT_DIR}/bootstrap.sh