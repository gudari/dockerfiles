FROM gudari/java:8u201-b09 AS BUILD

ARG ZKUI_VERSION=2.0-SNAPSHOT
ENV ZKUI_BUILD_PATH=/opt/zkui-build

RUN buildDep="git maven" && \
    yum install -y $buildDep && \
    git clone https://github.com/DeemOpen/zkui.git ${ZKUI_BUILD_PATH} && \
    cd ${ZKUI_BUILD_PATH} && \
    mvn clean install

FROM gudari/java:8u201-b09

ARG ZKUI_VERSION=2.0-SNAPSHOT
ENV ZKUI_BUILD_PATH=/opt/zkui-build
ENV ZKUI_HOME=/opt/zkui
RUN mkdir -p $ZKUI_HOME \
    mkdir -p /opt/init
COPY --from=BUILD ${ZKUI_BUILD_PATH}/target/zkui-${ZKUI_VERSION}-jar-with-dependencies.jar ${ZKUI_HOME}
COPY scripts/bootstrap.sh /opt/init
RUN chmod +x /opt/init/*
WORKDIR ${ZKUI_HOME}

CMD /opt/init/bootstrap.sh




