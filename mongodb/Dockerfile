FROM debian:10.3-slim

ARG MONGODB_VERSION=4.2.5
ENV MONGODB_HOME=/opt/mongodb
ENV INIT_DIR=/opt/init

RUN apt-get update \
    && apt-get install -y --no-install-recommends wget ca-certificates libcurl4 openssl \
    && wget https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-debian10-${MONGODB_VERSION}.tgz \
    && mkdir -p ${MONGODB_HOME} \
    && tar -xvzf mongodb-linux-x86_64-debian10-${MONGODB_VERSION}.tgz -C ${MONGODB_HOME} --strip-components=1 \
    && rm -fr mongodb-linux-x86_64-debian10-${MONGODB_VERSION}.tgz \
    && apt-get remove -y wget \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p ${INIT_DIR}

WORKDIR ${MONGODB_HOME}
RUN PATH=${PATH}:${MONGODB_HOME}/bin

COPY scripts/bootstrap.sh ${INIT_DIR}/bootstrap.sh
RUN chmod +x ${INIT_DIR}/bootstrap.sh

CMD ${INIT_DIR}/bootstrap.sh