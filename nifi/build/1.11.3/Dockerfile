FROM gudari/openjdk:8.0.242

LABEL maintainer "Axier Artola <aartola1986@gmail.com>"
LABEL Description="Apache Nifi docker image" Version="1.11.3"

ARG NIFI_VERSION=1.11.3
ENV NIFI_HOME=/opt/nifi
ENV INIT_DIR /opt/init

RUN apt-get update \
    && apt-get install -y --no-install-recommends wget netcat \
    && wget https://archive.apache.org/dist/nifi/${NIFI_VERSION}/nifi-${NIFI_VERSION}-bin.tar.gz \
    && mkdir -p $NIFI_HOME \
    && tar -xvzf nifi-${NIFI_VERSION}-bin.tar.gz -C ${NIFI_HOME} --strip-components=1 \
    && rm -fr nifi-${NIFI_VERSION}-bin.tar.gz \
    && apt-get remove -y wget \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p ${INIT_DIR}

WORKDIR $NIFI_HOME

COPY scripts/bootstrap.sh ${INIT_DIR}/bootstrap.sh
RUN chmod +x ${INIT_DIR}/bootstrap.sh

CMD ${INIT_DIR}/bootstrap.sh