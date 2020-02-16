FROM gudari/openjdk:8.0.242

LABEL maintainer "Axier Artola <aartola1986@gmail.com>"
LABEL Description="Apache Ant build-tools docker image" Version="1.10.7"

ARG ANT_VERSION=1.10.7
ENV ANT_HOME=/opt/ant

RUN apt-get update \
    && apt-get install --no-install-recommends -y wget \
    && wget https://archive.apache.org/dist/ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz \
    && mkdir -p ${ANT_HOME} \
    && tar xvf apache-ant-${ANT_VERSION}-bin.tar.gz -C ${ANT_HOME} --strip-components=1 \
    && rm -fr apache-ant-${ANT_VERSION}-bin.tar.gz \
    && apt-get remove -y wget \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

ENV PATH="${ANT_HOME}/bin:${PATH}"

CMD [ "ant", "-version" ]
