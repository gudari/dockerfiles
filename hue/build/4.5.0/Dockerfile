FROM gudari/maven:3.6.3

LABEL maintainer "Axier Artola <aartola1986@gmail.com>"
LABEL Description="Apache Zookeeper docker image" Version="4.5.0"

ARG HUE_VERSION=4.5.0
ENV HUE_HOME=/opt/hue
ENV HUE_TMP=/opt/tmp
ENV INIT_DIR=/opt/init
ENV TEMPLATES_DIR=/opt/templates

RUN apt-get update \
    && apt-get install --no-install-recommends -y wget netcat \
    && wget https://downloads.mysql.com/archives/get/p/23/file/libmysqlclient20_5.7.28-1debian10_amd64.deb \
    && wget https://downloads.mysql.com/archives/get/p/23/file/libmysqlclient-dev_5.7.28-1debian10_amd64.deb \
    && apt-get install -y ./libmysqlclient20_5.7.28-1debian10_amd64.deb \
    && apt-get install -y ./libmysqlclient-dev_5.7.28-1debian10_amd64.deb \
    && rm -rf libmysqlclient20_5.7.28-1debian10_amd64.deb \
    && rm -rf libmysqlclient-dev_5.7.28-1debian10_amd64.deb \
    && apt-get update \
    && buildDep="gcc g++ make nodejs npm rsync" \
    && apt-get install -y $buildDep \
        libffi-dev \
        libkrb5-dev \
        libsasl2-dev \
        libsasl2-modules-gssapi-mit \
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
    && wget https://github.com/cloudera/hue/archive/release-${HUE_VERSION}.tar.gz \
    && mkdir -p $HUE_HOME $HUE_TMP \
    && tar -xvzf release-${HUE_VERSION}.tar.gz -C ${HUE_TMP} --strip-components=1 \
    && cd $HUE_TMP \
    && rm -rf release-${HUE_VERSION}.tar.gz \
    && cd $HUE_TMP \
    && make apps \
    && PREFIX=/opt make install \
    && rm -rf $HUE_TMP \
    && apt-get remove -y wget $buildDep \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /root/.npm \
    && rm -rf /root/.m2 \
    && groupadd hue \
    && useradd -r -u 1000 -g hue hue \
    && chown hue:hue -R $HUE_HOME

WORKDIR $HUE_HOME

RUN mkdir -p ${TEMPLATES_DIR} \
    && mkdir -p ${INIT_DIR}
COPY ./scripts/* ${INIT_DIR}/
COPY ./templates/hue.ini.template ${TEMPLATES_DIR}
RUN chmod +x ${INIT_DIR}/*

EXPOSE 8000

CMD ${INIT_DIR}/bootstrap.sh
