FROM gudari/hadoop:2.10.0

LABEL maintainer "Axier Artola <aartola1986@gmail.com>"
LABEL Description="Hive docker image" Version="2.3.7"

ARG HIVE_VERSION=2.3.7
ENV HIVE_HOME=/opt/hive
ENV INIT_DIR=/opt/init

RUN apt-get update \
    && apt-get install -y --no-install-recommends -y wget netcat libmariadb-java \
    && wget https://archive.apache.org/dist/hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz \
    && mkdir -p $HIVE_HOME \
    && tar -xvzf apache-hive-${HIVE_VERSION}-bin.tar.gz -C ${HIVE_HOME} --strip-components=1 \
    && rm -fr apache-hive-${HIVE_VERSION}-bin.tar.gz \
    && wget https://downloads.mysql.com/archives/get/p/3/file/mysql-connector-java-5.1.46.tar.gz \
    && tar -xvzf mysql-connector-java-5.1.46.tar.gz \
    && cp mysql-connector-java-5.1.46/mysql-connector-java-5.1.46.jar $HIVE_HOME/lib/mysql-connector-java-5.1.46.jar \
    && rm -fr /mysql-connector-java-5.1.46 \
    && apt-get remove -y wget \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p ${INIT_DIR}

ENV PATH=${PATH}:${HIVE_HOME}/bin
WORKDIR $HIVE_HOME

COPY scripts/bootstrap.sh ${INIT_DIR}/bootstrap.sh
RUN chmod +x ${INIT_DIR}/bootstrap.sh

CMD ${INIT_DIR}/bootstrap.sh
