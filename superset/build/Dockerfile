FROM debian:10.3-slim

ARG SUPERSET_VERSION=0.35.2
ENV INIT_DIR /opt/init

RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential libssl-dev libffi-dev python3-dev python3 python3-pip libsasl2-dev libldap2-dev \
    && pip3 install --no-cache-dir --upgrade setuptools pip \
    && pip install --no-cache-dir apache-superset==${SUPERSET_VERSION} \
    && superset db upgrade \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p ${INIT_DIR}

COPY scripts/bootstrap.sh ${INIT_DIR}/bootstrap.sh
RUN chmod +x ${INIT_DIR}/bootstrap.sh

CMD ${INIT_DIR}/bootstrap.sh
