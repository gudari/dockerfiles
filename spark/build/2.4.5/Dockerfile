FROM gudari/hadoop:2.7.7

LABEL maintainer "Axier Artola <aartola1986@gmail.com>"
LABEL Description="Spark docker image" Version="2.4.5"

ARG SPARK_VERSION=2.4.5
ENV SPARK_HOME=/opt/spark
ENV INIT_DIR=/opt/init

RUN apt-get update \
    && apt-get install --no-install-recommends -y wget netcat procps python3 r-base \
    && wget https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-without-hadoop.tgz \
    && mkdir -p $SPARK_HOME \
    && tar -xvzf spark-${SPARK_VERSION}-bin-without-hadoop.tgz -C ${SPARK_HOME} --strip-components=1 \
    && rm -fr spark-${SPARK_VERSION}-bin-without-hadoop.tgz \
    && apt-get remove -y wget \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p ${INIT_DIR}

ENV PYSPARK_PYTHON=python3
ENV PATH=${PATH}:${SPARK_HOME}/bin

WORKDIR $SPARK_HOME

COPY scripts/bootstrap.sh ${INIT_DIR}/bootstrap.sh
RUN chmod +x ${INIT_DIR}/bootstrap.sh

CMD ${INIT_DIR}/bootstrap.sh
