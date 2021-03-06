FROM gudari/hadoop:2.10.0

ARG TEZ_VERSION=0.9.2
ENV TEZ_HOME=/opt/tez
ENV TOMCAT_VERSION=8.5.9
ENV TOMCAT_HOME=/opt/tomcat
ENV INIT_DIR=/opt/init

RUN apt-get update \
    && apt-get install --no-install-recommends -y wget \
    && wget https://archive.apache.org/dist/tez/${TEZ_VERSION}/apache-tez-${TEZ_VERSION}-bin.tar.gz \
    && wget https://archive.apache.org/dist/tomcat/tomcat-8/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz \
    && mkdir -p ${TEZ_HOME} \
    && mkdir -p ${TOMCAT_HOME} \
    && tar -xvzf apache-tez-${TEZ_VERSION}-bin.tar.gz -C ${TEZ_HOME} --strip-components=1 \
    && tar -xvzf apache-tomcat-${TOMCAT_VERSION}.tar.gz -C ${TOMCAT_HOME} --strip-components=1 \
    && rm -rf apache-tez-${TEZ_VERSION}-bin.tar.gz \
    && rm -rf apache-tomcat-${TOMCAT_VERSION}.tar.gz \
    && mkdir -p ${TOMCAT_HOME}/webapps/tez-ui \
    && cd ${TOMCAT_HOME}/webapps/tez-ui \
    && cp ${TEZ_HOME}/tez-ui-${TEZ_VERSION}.war ./ \
    && jar -xvf tez-ui-${TEZ_VERSION}.war \
    && rm -fr tez-ui-${TEZ_VERSION}.war \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p ${INIT_DIR}

WORKDIR $TEZ_HOME

ENV TEZ_CONF_DIR=${TEZ_HOME}/conf \
    TEZ_JARS=${TEZ_HOME}
ENV HADOOP_CLASSPATH=${TEZ_CONF_DIR}:${TEZ_JARS}/*:${TEZ_JARS}/lib/*


COPY scripts/bootstrap.sh ${INIT_DIR}/bootstrap.sh
RUN chmod +x ${INIT_DIR}/bootstrap.sh

CMD ${INIT_DIR}/bootstrap.sh
