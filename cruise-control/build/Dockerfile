FROM gudari/gradle:4.8 AS BUILD

ARG VERSION=2.0.90
ARG UI_VERSION=0.3.4
ENV GRADLE_VERSION 4.8
ENV GRADLE_HOME /opt/gradle

RUN apt-get update \
    && apt-get install --no-install-recommends -y git curl unzip \
    && git clone -b ${VERSION} https://github.com/linkedin/cruise-control.git /opt/cruise-control \
    && git clone -b v${UI_VERSION} https://github.com/linkedin/cruise-control-ui.git /opt/cruise-control-ui \
    && curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt-get install -y nodejs

WORKDIR /opt/cruise-control
RUN gradle jar copyDependantLibs

WORKDIR /opt/cruise-control-ui
RUN npm install && npm run build

FROM gudari/openjdk:8.0.242

ARG VERSION=2.0.90
ENV CRUISE_CONTROL_HOME /opt/cruise-control

RUN mkdir -p ${CRUISE_CONTROL_HOME} ${CRUISE_CONTROL_HOME}/cruise-control-ui
COPY --from=BUILD /opt/cruise-control/cruise-control/build/libs/cruise-control-${VERSION}.jar ${CRUISE_CONTROL_HOME}/cruise-control/build/libs/cruise-control.jar
COPY --from=BUILD /opt/cruise-control/config ${CRUISE_CONTROL_HOME}/config
COPY --from=BUILD /opt/cruise-control/kafka-cruise-control-start.sh ${CRUISE_CONTROL_HOME}
COPY --from=BUILD /opt/cruise-control/cruise-control/build/dependant-libs ${CRUISE_CONTROL_HOME}/cruise-control/build/dependant-libs
COPY --from=BUILD /opt/cruise-control-ui/dist ${CRUISE_CONTROL_HOME}/cruise-control-ui/dist

RUN echo "local,localhost,/kafkacruisecontrol" > ${CRUISE_CONTROL_HOME}/cruise-control-ui/dist/static/config.csv

EXPOSE 8090

WORKDIR ${CRUISE_CONTROL_HOME}

CMD [ "${CRUISE_CONTROL_HOME}/kafka-cruise-control-start.sh" "${CRUISE_CONTROL_HOME}/config/cruisecontrol.properties" ]
