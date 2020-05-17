FROM gudari/maven:3.6.3 AS BUILD

ARG OOZIE_VERSION=5.2.0
ENV OOZIE_HOME /opt/oozie
ENV HADOOP_VERSION 2.10.0

RUN apt-get update \
    && apt-get install --no-install-recommends -y wget \
    && wget https://archive.apache.org/dist/oozie/${OOZIE_VERSION}/oozie-${OOZIE_VERSION}.tar.gz \
    && mkdir -p ${OOZIE_HOME} \
    && tar -xzvf oozie-${OOZIE_VERSION}.tar.gz -C ${OOZIE_HOME} --strip-components=1 \
    && rm -rf oozie-${OOZIE_VERSION}.tar.gz \
    && cd ${OOZIE_HOME} \
    && bin/mkdistro.sh -Puber -Pspark-2 -DskipTests -Dhadoop.version=${HADOOP_VERSION}

FROM gudari/hadoop:2.10.0

LABEL maintainer "Axier Artola <aartola1986@gmail.com>"
LABEL Description="Apache Oozie docker image" Version="5.2.0"

ARG OOZIE_VERSION=5.2.0
ENV OOZIE_HOME /opt/oozie

COPY --from=BUILD ${OOZIE_HOME}/distro/target/oozie-${OOZIE_VERSION}-distro.tar.gz /oozie-${OOZIE_VERSION}-distro.tar.gz

RUN apt-get update \
    && apt-get install --no-install-recommends -y wget unzip \
    && mkdir -p ${OOZIE_HOME} \
    && tar -xzvf /oozie-${OOZIE_VERSION}-distro.tar.gz -C ${OOZIE_HOME} --strip-components=1 \
    && rm -rf oozie-${OOZIE_VERSION}-distro.tar.gz \
    && mkdir ${OOZIE_HOME}/libext \
    && wget http://archive.cloudera.com/gplextras/misc/ext-2.2.zip -O ${OOZIE_HOME}/libext/ext-2.2.zip \
    && apt-get remove -y wget \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p ${INIT_DIR}

RUN  rm -fr $OOZIE_HOME/conf/hadoop-conf/* \
     && ln -s $HADOOP_HOME/etc/hadoop/core-site.xml $OOZIE_HOME/conf/hadoop-conf/core-site.xml \
     && ln -s $HADOOP_HOME/etc/hadoop/hdfs-site.xml $OOZIE_HOME/conf/hadoop-conf/hdfs-site.xml \
     && ln -s $HADOOP_HOME/etc/hadoop/mapred-site.xml $OOZIE_HOME/conf/hadoop-conf/mapred-site.xml \
     && ln -s $HADOOP_HOME/etc/hadoop/yarn-site.xml $OOZIE_HOME/conf/hadoop-conf/yarn-site.xml

WORKDIR $OOZIE_HOME

COPY scripts/bootstrap.sh ${INIT_DIR}/bootstrap.sh
RUN chmod +x ${INIT_DIR}/bootstrap.sh

ENV PATH=${PATH}:${OOZIE_HOME}/bin

CMD ${INIT_DIR}/bootstrap.sh
