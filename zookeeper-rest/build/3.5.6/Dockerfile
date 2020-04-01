FROM gudari/ant:1.10.7 as dev

LABEL maintainer "Axier Artola <aartola1986@gmail.com>"
LABEL Description="Apache Zookeeper docker image" Version="3.5.6"

ARG ZOOKEEPER_REST_VERSION=3.5.6
ENV ZOOKEEPER_REST_BUILD=/opt/zookeeper-rest-build
ENV INIT_DIR=/opt/init

RUN apt-get update \
    && apt-get install --no-install-recommends -y wget netcat \
    && wget https://archive.apache.org/dist/zookeeper/zookeeper-${ZOOKEEPER_REST_VERSION}/apache-zookeeper-${ZOOKEEPER_REST_VERSION}.tar.gz \
    && mkdir -p ${ZOOKEEPER_REST_BUILD} \
    && tar xvf apache-zookeeper-${ZOOKEEPER_REST_VERSION}.tar.gz -C ${ZOOKEEPER_REST_BUILD} --strip-components=1 \
    && rm -fr apache-zookeeper-${ZOOKEEPER_REST_VERSION}.tar.gz \
    && apt-get remove -y wget \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p ${INIT_DIR}

WORKDIR ${ZOOKEEPER_REST_BUILD}
RUN ant -Dversion=3.5.6

WORKDIR ${ZOOKEEPER_REST_BUILD}/zookeeper-contrib/zookeeper-contrib-rest
RUN ant -Dversion=3.5.6

FROM gudari/openjdk:8.0.242

LABEL maintainer "Axier Artola <aartola1986@gmail.com>"
LABEL Description="Apache Zookeeper docker image" Version="3.5.6"

ARG ZOOKEEPER_REST_VERSION=3.5.6
ENV ZOOKEEPER_REST_HOME=/opt/zookeeper-rest
ENV ZOOKEEPER_REST_BUILD=/opt/zookeeper-rest-build
ENV INIT_DIR=/opt/init

RUN mkdir -p ${ZOOKEEPER_REST_HOME} \
    mkdir -p ${INIT_DIR}

WORKDIR ${ZOOKEEPER_REST_HOME}

COPY --from=dev ${ZOOKEEPER_REST_BUILD}/zookeeper-contrib/zookeeper-contrib-rest/conf ./conf
COPY --from=dev ${ZOOKEEPER_REST_BUILD}/build/zookeeper-3.5.6.jar .
COPY --from=dev ${ZOOKEEPER_REST_BUILD}/build/zookeeper-contrib/zookeeper-contrib-rest/lib ./lib
COPY --from=dev ${ZOOKEEPER_REST_BUILD}/build/zookeeper-contrib/zookeeper-contrib-rest/zookeeper-3.5.6-rest.jar .

COPY scripts/zookeeper-rest.sh ${ZOOKEEPER_REST_HOME}
COPY scripts/bootstrap.sh ${INIT_DIR}
RUN chmod +x ${ZOOKEEPER_REST_HOME}/zookeeper-rest.sh \
    ${INIT_DIR}/bootstrap.sh

CMD ${INIT_DIR}/bootstrap.sh
