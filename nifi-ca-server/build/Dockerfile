FROM gudari/java:8.0.212

LABEL maintainer "Axier Artola <aartola1986@gmail.com>"
LABEL Description="Apache Nifi toolkit server docker image" Version="1.9.2"


ARG NIFI_TOOLKIT_VERSION=1.9.2
ENV NIFI_TOOLKIT_HOME=/opt/nifi-toolkit

RUN yum install -y wget openssl hostname && \
    wget https://archive.apache.org/dist/nifi/${NIFI_TOOLKIT_VERSION}/nifi-toolkit-${NIFI_TOOLKIT_VERSION}-bin.tar.gz && \
    mkdir -p ${NIFI_TOOLKIT_HOME} && \
    tar xvf nifi-toolkit-${NIFI_TOOLKIT_VERSION}-bin.tar.gz -C ${NIFI_TOOLKIT_HOME} --strip-components=1 && \
    rm -fr nifi-toolkit-${NIFI_TOOLKIT_VERSION}-bin.tar.gz && \
    yum remove -y wget && \
    yum autoremove -y && \
    yum clean all -y && \
    rm -fr /var/cache/yum && \
    mkdir -p /opt/init

WORKDIR ${NIFI_TOOLKIT_HOME}

COPY scripts/bootstrap.sh /opt/init/bootstrap.sh
RUN chmod +x /opt/init/bootstrap.sh

CMD /opt/init/bootstrap.sh
