FROM gudari/hadoop:2.7.7

LABEL maintainer "Axier Artola <aartola1986@gmail.com>"
LABEL Description="Hive docker image" Version="3.1.1"

ARG HIVE_VERSION=3.1.1
ARG HIVE_HOME=/opt/hive

RUN yum install -y wget which nc && \
    wget https://archive.apache.org/dist/hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz && \
    mkdir $HIVE_HOME && \
    tar -xvzf apache-hive-${HIVE_VERSION}-bin.tar.gz -C ${HIVE_HOME} --strip-components=1 && \
    rm -fr apache-hive-${HIVE_VERSION}-bin.tar.gz && \
    yum remove -y wget && \
    yum autoremove -y && \
    yum clean all -y && \
    rm -fr /var/cache/yum && \
    mkdir -p /opt/init

RUN yum install -y mysql-connector-java && \
    ln -s /usr/share/java/mysql-connector-java.jar $HIVE_HOME/lib/mysql-connector-java.jar

ENV PATH=${PATH}:${HIVE_HOME}/bin
WORKDIR $HIVE_HOME

COPY scripts/bootstrap.sh /opt/init/bootstrap.sh
RUN chmod +x /opt/init/bootstrap.sh

CMD /opt/init/bootstrap.sh
