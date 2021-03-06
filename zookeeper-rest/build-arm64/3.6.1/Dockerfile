FROM maven:3.6.3-jdk-8 as BUILD

LABEL maintainer "Axier Artola <aartola1986@gmail.com>"
LABEL Description="Apache Zookeeper docker image" Version="3.6.1"

ARG ZOOKEEPER_REST_VERSION=3.6.1
ENV ZOOKEEPER_REST_BUILD=/opt/zookeeper-rest-build
ENV INIT_DIR=/opt/init

RUN apt-get update \
    && apt-get install --no-install-recommends -y wget netcat \
    && wget https://archive.apache.org/dist/zookeeper/zookeeper-${ZOOKEEPER_REST_VERSION}/apache-zookeeper-${ZOOKEEPER_REST_VERSION}.tar.gz \
    && wget https://archive.apache.org/dist/zookeeper/zookeeper-${ZOOKEEPER_REST_VERSION}/apache-zookeeper-${ZOOKEEPER_REST_VERSION}.tar.gz.sha512 \
    && sha512sum -c apache-zookeeper-${ZOOKEEPER_REST_VERSION}.tar.gz.sha512 \
    && mkdir -p ${ZOOKEEPER_REST_BUILD} \
    && tar xvf apache-zookeeper-${ZOOKEEPER_REST_VERSION}.tar.gz -C ${ZOOKEEPER_REST_BUILD} --strip-components=1 \
    && rm -fr apache-zookeeper-${ZOOKEEPER_REST_VERSION}.tar.gz \
    && apt-get remove -y wget \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p ${INIT_DIR}

WORKDIR ${ZOOKEEPER_REST_BUILD}
RUN mvn clean package -DskipTests

RUN PATCH=" \
        <plugin> \
            <artifactId>maven-dependency-plugin</artifactId> \
            <executions> \
                <execution> \
                    <phase>package</phase> \
                    <goals> \
                        <goal>copy-dependencies</goal> \
                    </goals> \
                    <configuration> \
                        <outputDirectory>\${project.build.directory}/lib</outputDirectory> \
                    </configuration> \
                </execution> \
            </executions> \
        </plugin>" \
    && escapedPatch=$(echo $PATCH | sed 's/\//\\\//g') \
    && sed -i "/<\/plugins>/ s/.*/${escapedPatch}\n&/" $ZOOKEEPER_REST_BUILD/zookeeper-contrib/zookeeper-contrib-rest/pom.xml

WORKDIR ${ZOOKEEPER_REST_BUILD}/zookeeper-contrib/zookeeper-contrib-rest
RUN mvn clean package -DskipTests

FROM arm64v8/adoptopenjdk:8u252-b09-jdk-hotspot-bionic

LABEL maintainer "Axier Artola <aartola1986@gmail.com>"
LABEL Description="Apache Zookeeper docker image" Version="3.6.1"

ARG ZOOKEEPER_REST_VERSION=3.6.1
ENV ZOOKEEPER_REST_HOME=/opt/zookeeper-rest
ENV ZOOKEEPER_REST_BUILD=/opt/zookeeper-rest-build
ENV INIT_DIR=/opt/init

RUN mkdir -p ${ZOOKEEPER_REST_HOME} \
    mkdir -p ${INIT_DIR}

RUN set -eux; \
    groupadd -r zookeeper-rest --gid=1000; \
    useradd -r -g zookeeper-rest --uid=1000 zookeeper-rest;

RUN apt-get update \
    && apt-get install --no-install-recommends -y gosu \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p ${ZOOKEEPER_REST_HOME}

WORKDIR ${ZOOKEEPER_REST_HOME}

COPY --from=BUILD ${ZOOKEEPER_REST_BUILD}/zookeeper-contrib/zookeeper-contrib-rest/conf ./conf
COPY --from=BUILD ${ZOOKEEPER_REST_BUILD}/zookeeper-server/target/zookeeper-${ZOOKEEPER_REST_VERSION}.jar .
COPY --from=BUILD ${ZOOKEEPER_REST_BUILD}/zookeeper-contrib/zookeeper-contrib-rest/target/lib ./lib
COPY --from=BUILD ${ZOOKEEPER_REST_BUILD}/zookeeper-contrib/zookeeper-contrib-rest/target/zookeeper-contrib-rest-${ZOOKEEPER_REST_VERSION}.jar .

COPY scripts/zookeeper-rest.sh ${ZOOKEEPER_REST_HOME}
COPY scripts/docker-entrypoint.sh /docker-entrypoint.sh
RUN chown -R zookeeper-rest:zookeeper-rest ${ZOOKEEPER_REST_HOME} \
    && chmod +x ${ZOOKEEPER_REST_HOME}/zookeeper-rest.sh \
    /docker-entrypoint.sh

ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD [ "zookeeper-rest" ]
