FROM gudari/hadoop:2.10.0

ARG TEZ_VERSION=0.9.2
ENV INIT_DIR=/opt/init

RUN apt-get update \
    && apt-get install --no-install-recommends -y wget \
    && wget https://repo1.maven.org/maven2/org/apache/tez/tez-aux-services/${TEZ_VERSION}/tez-aux-services-${TEZ_VERSION}.jar \
            -O ${HADOOP_HOME}/share/hadoop/mapreduce/tez-aux-services-${TEZ_VERSION}.jar \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

CMD ${INIT_DIR}/bootstrap.sh
