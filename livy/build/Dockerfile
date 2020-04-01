FROM gudari/spark:2.4.5

ARG LIVY_VERSION=0.7.0
ENV LIVY_HOME /opt/livy

RUN apt-get update \
    && apt-get install -y --no-install-recommends wget unzip \
    && wget https://archive.apache.org/dist/incubator/livy/${LIVY_VERSION}-incubating/apache-livy-${LIVY_VERSION}-incubating-bin.zip \
    && unzip apache-livy-${LIVY_VERSION}-incubating-bin.zip \
    && mv apache-livy-${LIVY_VERSION}-incubating-bin ${LIVY_HOME} \
    && apt-get remove -y wget unzip \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir ${LIVY_HOME}/logs \
    && mkdir -p ${INIT_DIR}

WORKDIR $LIVY_HOME

COPY scripts/bootstrap.sh ${INIT_DIR}/bootstrap.sh
RUN chmod +x ${INIT_DIR}/bootstrap.sh

CMD ${INIT_DIR}/bootstrap.sh