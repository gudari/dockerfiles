FROM gudari/openjdk:8.0.242

LABEL maintainer "Axier Artola <aartola1986@gmail.com>"
LABEL Description="Apache Maven build-tool docker image" Version="3.6.3"

ARG MAVEN_VERSION=3.6.3
ENV MAVEN_HOME=/opt/maven

RUN apt-get update \
    && apt-get install --no-install-recommends -y wget \
    && wget https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    && mkdir -p ${MAVEN_HOME} \
    && tar xvf apache-maven-${MAVEN_VERSION}-bin.tar.gz -C ${MAVEN_HOME} --strip-components=1 \
    && rm -fr apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    && apt-get remove -y wget \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

ENV PATH="${MAVEN_HOME}/bin:${PATH}"

CMD [ "mvn", "-version" ]
