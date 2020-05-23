FROM debian:10.4-slim

LABEL maintainer "Axier Artola <aartola1986@gmail.com>"
LABEL Description="Zulu Community OpenJDK docker image" Version="11.0.7" zulu_version="11.39.15"

ARG JAVA_VERSION=11.0.7
ARG ZULU_VERSION=11.39.15

ENV JAVA_HOME /opt/java

RUN apt-get update \
    && apt-get install --no-install-recommends -y wget ca-certificates \
    && wget https://cdn.azul.com/zulu/bin/zulu${ZULU_VERSION}-ca-jdk${JAVA_VERSION}-linux_x64.tar.gz \
    && mkdir -p ${JAVA_HOME} \
    && tar -xvzf zulu${ZULU_VERSION}-ca-jdk${JAVA_VERSION}-linux_x64.tar.gz -C ${JAVA_HOME} --strip-components=1 \
    && rm -fr zulu${ZULU_VERSION}-ca-jdk${JAVA_VERSION}-linux_x64.tar.gz \
    && rm -fr ${JAVA_HOME}/src.zip \
       ${JAVA_HOME}/sample \
       ${JAVA_HOME}/demo \
       ${JAVA_HOME}/man \
    && apt-get remove -y wget \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

ENV PATH=$PATH:$JAVA_HOME/bin

CMD [ "java", "-version" ]
