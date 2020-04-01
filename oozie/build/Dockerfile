FROM gudari/maven:3.6.3 AS BUILD

ARG OOZIE_VERSION=5.2.0
ENV OOZIE_HOME /opt/oozie
ENV HADOOP_VERSION 2.7.7

RUN apt-get update \
    && apt-get install --no-install-recommends -y wget \
    && wget https://archive.apache.org/dist/oozie/${OOZIE_VERSION}/oozie-${OOZIE_VERSION}.tar.gz \
    && mkdir -p ${OOZIE_HOME} \
    && tar -xzvf oozie-${OOZIE_VERSION}.tar.gz -C ${OOZIE_HOME} --strip-components=1 \
    && rm -rf oozie-${OOZIE_VERSION}.tar.gz \
    && cd ${OOZIE_HOME} \
    && bin/mkdistro.sh -DskipTests -Dhadoop.version=${HADOOP_VERSION}

FROM gudari/hadoop:2.7.7

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
    && cp ${HADOOP_HOME}/share/hadoop/common/hadoop-common-2.7.7.jar ${OOZIE_HOME}/embedded-oozie-server/webapp/WEB-INF/lib/ \
    && cp ${HADOOP_HOME}/share/hadoop/common/lib/commons-configuration-1.6.jar ${OOZIE_HOME}/embedded-oozie-server/webapp/WEB-INF/lib/ \
    && cp ${HADOOP_HOME}/share/hadoop/mapreduce/*.jar ${OOZIE_HOME}/embedded-oozie-server/webapp/WEB-INF/lib/ \
    && cp ${HADOOP_HOME}/share/hadoop/hdfs/hadoop-hdfs-2.7.7.jar ${OOZIE_HOME}/embedded-oozie-server/webapp/WEB-INF/lib/

WORKDIR $OOZIE_HOME

CMD bin/oozied.sh run