FROM debian:10.3-slim

ARG RABBITMQ_VERSION=3.8.3
ARG ERLANG_VERSION=22.3.2
ENV RABBITMQ_HOME=/opt/rabbitmq \
    INIT_DIR=/opt/init

RUN apt-get update \
    && apt-get install -y --no-install-recommends wget xz-utils ca-certificates procps libncurses5 libwxbase3.0-0v5 libwxgtk3.0-0v5 libsctp1 locales \
    && wget https://github.com/rabbitmq/rabbitmq-server/releases/download/v${RABBITMQ_VERSION}/rabbitmq-server-generic-unix-${RABBITMQ_VERSION}.tar.xz \
    && mkdir -p $RABBITMQ_HOME \
    && tar xvf rabbitmq-server-generic-unix-${RABBITMQ_VERSION}.tar.xz -C $RABBITMQ_HOME --strip-components=1 \
    && rm -fr rabbitmq-server-generic-unix-${RABBITMQ_VERSION}.tar.xz \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG=en_US.UTF-8 \
    && wget https://packages.erlang-solutions.com/erlang/debian/pool/esl-erlang_${ERLANG_VERSION}-1~debian~buster_amd64.deb \
    && dpkg -i esl-erlang_${ERLANG_VERSION}-1~debian~buster_amd64.deb \
    && rm -fr esl-erlang_${ERLANG_VERSION}-1~debian~buster_amd64.deb \
    && apt-get remove -y wget \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p ${INIT_DIR}

ENV LANG en_US.UTF-8 

WORKDIR $RABBITMQ_HOME

ENV PATH=$PATH:$RABBITMQ_HOME/sbin

RUN rabbitmq-plugins enable rabbitmq_management

COPY scripts/bootstrap.sh ${INIT_DIR}/bootstrap.sh
RUN chmod +x ${INIT_DIR}/bootstrap.sh

CMD ${INIT_DIR}/bootstrap.sh



