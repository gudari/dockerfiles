FROM gudari/openjdk:8.0.242 AS BUILD

ARG ZKUI_VERSION=2.0-SNAPSHOT
ENV ZKUI_BUILD_PATH=/opt/zkui-build

RUN buildDep="git maven" \
    && apt-get update \
    && apt-get install --no-install-recommends -y $buildDep \
    && git clone https://github.com/DeemOpen/zkui.git ${ZKUI_BUILD_PATH} \
    && cd ${ZKUI_BUILD_PATH} \
    && mvn clean install

FROM gudari/openjdk:8.0.242

LABEL maintainer "Axier Artola <aartola1986@gmail.com>"
LABEL Description="zkui docker image"

ARG ZKUI_VERSION=2.0-SNAPSHOT
ENV ZKUI_BUILD_PATH=/opt/zkui-build
ENV ZKUI_HOME=/opt/zkui
ENV INIT_DIR=/opt/init

RUN mkdir -p $ZKUI_HOME \
    mkdir -p ${INIT_DIR}
COPY --from=BUILD ${ZKUI_BUILD_PATH}/target/zkui-${ZKUI_VERSION}-jar-with-dependencies.jar ${ZKUI_HOME}
COPY scripts/bootstrap.sh ${INIT_DIR}
RUN chmod +x ${INIT_DIR}/*
WORKDIR ${ZKUI_HOME}

CMD ${INIT_DIR}/bootstrap.sh




