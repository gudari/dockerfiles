FROM centos:7.6.1810

ARG JAVA_VERSION=8.0.212
ARG ZULU_VERSION=8.38.0.13-ca

RUN yum install -y wget && \
    wget https://cdn.azul.com/zulu/bin/zulu${ZULU_VERSION}-jdk${JAVA_VERSION}-linux.x86_64.rpm && \
    yum localinstall -y zulu${ZULU_VERSION}-jdk${JAVA_VERSION}-linux.x86_64.rpm && \
    rm -f zulu${ZULU_VERSION}-jdk${JAVA_VERSION}-linux.x86_64.rpm && \
    rm -rf /usr/lib/jvm/zulu-8/*src.zip && \
    rm -fr /usr/lib/jvm/zulu-8/demo && \
    rm -fr /usr/lib/jvm/zulu-8/sample && \
    yum remove -y wget && \
    yum autoremove -y && \
    yum clean all -y && \
    rm -rf /var/cache/yum

ENV JAVA_HOME /usr/lib/jvm/zulu-8