FROM gudari/java:8.0.212

LABEL maintainer "Axier Artola <aartola1986@gmail.com>"
LABEL Description="Apache Nifi docker image" Version="1.8.0"

ARG NIFI_VERSION=1.8.0
ENV NIFI_HOME=/opt/nifi

RUN yum install -y wget nc && \
    wget https://archive.apache.org/dist/nifi/${NIFI_VERSION}/nifi-${NIFI_VERSION}-bin.tar.gz && \
    mkdir -p $NIFI_HOME && \
    tar -xvzf nifi-${NIFI_VERSION}-bin.tar.gz -C ${NIFI_HOME} --strip-components=1 && \
    rm -fr nifi-${NIFI_VERSION}-bin.tar.gz && \
    yum remove -y wget && \
    yum autoremove -y && \
    yum clean all -y && \
    rm -fr /var/cache/yum && \
    mkdir - /opt/init

WORKDIR $NIFI_HOME

COPY scripts/bootstrap.sh /opt/init/bootstrap.sh
RUN chmod +x /opt/init/bootstrap.sh

CMD /opt/init/bootstrap.sh
