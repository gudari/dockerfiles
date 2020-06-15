FROM arm64v8/openjdk:11.0.7-jdk-slim-buster

LABEL maintainer "Axier Artola <aartola1986@gmail.com>"
LABEL Description="Cloudera Hue docker image" Version="4.6.0"

ARG HUE_VERSION=4.6.0
ENV HUE_HOME=/opt/hue
ENV HUE_TMP=/opt/tmp
ENV INIT_DIR=/opt/init
ENV TEMPLATES_DIR=/opt/templates

ENV MAVEN_VERSION=3.6.3
ENV MAVEN_HOME=/opt/maven

RUN apt-get update \
    && apt-get install --no-install-recommends -y wget netcat \
    && wget https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    && mkdir -p ${MAVEN_HOME} \
    && tar xvf apache-maven-${MAVEN_VERSION}-bin.tar.gz -C ${MAVEN_HOME} --strip-components=1 \
    && rm -fr apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    && export PATH="${MAVEN_HOME}/bin:${PATH}" \
    && buildDep="gcc g++ make nodejs npm rsync" \
    && apt-get install -y $buildDep \
        libffi-dev \
        libkrb5-dev \
        libsasl2-dev \
        libsasl2-modules-gssapi-mit \
        libmariadb-dev-compat \
        libmariadb-dev \
        libsqlite3-dev \
        libssl-dev \
        libtidy-dev \
        libxml2-dev \
        libxslt-dev \
        libldap2-dev \
        python-dev \
        python-setuptools \
        libgmp3-dev \
        libz-dev \
        libsnappy-dev \
        swig \
        xmlsec1 \
        libxmlsec1-openssl \
    && wget https://github.com/cloudera/hue/archive/release-${HUE_VERSION}.tar.gz \
    && mkdir -p $HUE_HOME $HUE_TMP \
    && tar -xvzf release-${HUE_VERSION}.tar.gz -C ${HUE_TMP} --strip-components=1 \
    && cd $HUE_TMP \
    && rm -rf release-${HUE_VERSION}.tar.gz \
    && cd $HUE_TMP \
    && sed '/st_mysql_options options;/a unsigned int reconnect;' /usr/include/mariadb/mysql.h -i.bkp \
    && make apps \
    && PREFIX=/opt make install \
    && rm -rf $HUE_TMP \
    && apt-get remove -y wget $buildDep \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /root/.npm \
    && rm -rf /root/.m2 \
    && rm -rf $MAVEN_HOME \
    && groupadd hue \
    && useradd -r -u 1000 -g hue hue \
    && chown hue:hue -R $HUE_HOME

WORKDIR $HUE_HOME

RUN mkdir -p ${TEMPLATES_DIR} \
    && mkdir -p ${INIT_DIR}
COPY ./scripts/* ${INIT_DIR}/
COPY ./templates/hue.ini.jinja2 ${TEMPLATES_DIR}
RUN apt-get update \
    && apt-get install -y python-jinja2 python-psycopg2 \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && chmod +x ${INIT_DIR}/*

EXPOSE 8000

CMD ${INIT_DIR}/bootstrap.sh
