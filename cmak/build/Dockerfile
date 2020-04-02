FROM gudari/openjdk:11.0.6 AS BUILD

ARG CMAK_VERSION=3.0.0.4
ENV CMAK_BUILD_DIR=/tmp/cmak-build

RUN apt-get update \
    && apt-get install --no-install-recommends -y wget \
    && wget https://github.com/yahoo/CMAK/archive/${CMAK_VERSION}.tar.gz \
    && mkdir -p ${CMAK_BUILD_DIR} \
    && tar xvf ${CMAK_VERSION}.tar.gz -C ${CMAK_BUILD_DIR} --strip-components=1 \
    && rm -fr ${CMAK_VERSION}.tar.gz

WORKDIR ${CMAK_BUILD_DIR}
RUN ./sbt clean dist

WORKDIR ${CMAK_BUILD_DIR}/target/universal
RUN apt-get update \
    && apt-get install --no-install-recommends -y unzip \
    && unzip cmak-${CMAK_VERSION}.zip

FROM gudari/openjdk:11.0.6

LABEL maintainer "Axier Artola <aartola1986@gmail.com>"
LABEL Description="CMAK docker image" Version=3.0.0.4

ARG CMAK_VERSION=3.0.0.4
ENV CMAK_HOME=/opt/cmak

RUN mkdir -p ${CMAK_HOME}
WORKDIR ${CMAK_HOME}
COPY --from=BUILD /tmp/cmak-build/target/universal/cmak-${CMAK_VERSION} .

CMD bin/cmak -Dconfig.file=${CMAK_HOME}/conf/application.conf
