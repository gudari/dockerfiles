FROM gudari/hadoop:2.7.7

ARG HBASE_VERSION=2.1.5
ARG HBASE_HOME=/opt/hbase

LABEL maintainer "Axier Artola <aartola1986@gmail.com>"
LABEL Description="Hbase docker image" Version="2.1.5"

RUN yum install -y wget which nc && \
    wget https://archive.apache.org/dist/hbase/${HBASE_VERSION}/hbase-${HBASE_VERSION}-bin.tar.gz && \
    mkdir $HBASE_HOME && \
    tar -xvzf hbase-${HBASE_VERSION}-bin.tar.gz -C ${HBASE_HOME} --strip-components=1 && \
    rm -fr hbase-${HBASE_VERSION}-bin.tar.gz && \
    yum remove -y wget && \
    yum autoremove -y && \
    yum clean all -y && \
    rm -fr /var/cache/yum && \
    mkdir -p /opt/init

ENV PATH=${PATH}:${HBASE_HOME}/bin

WORKDIR $HBASE_HOME

COPY scripts/bootstrap.sh /opt/init/bootstrap.sh
COPY conf $HBASE_HOME/conf
RUN chmod +x /opt/init/bootstrap.sh

CMD /opt/init/bootstrap.sh
