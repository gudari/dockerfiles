FROM gudari/spark:2.4.5

ARG JUPYTERLAB_VERSION=2.0.0
ENV JUPYTERLAB_HOME=/opt/jupyterlab
ENV INIT_DIR /opt/init

RUN apt-get update \
    && apt-get install -y --no-install-recommends python3 python3-pip \
    && pip3 install --no-cache-dir --upgrade setuptools pip \
    && pip install --no-cache-dir jupyterlab==${JUPYTERLAB_VERSION} \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p ${INIT_DIR}


COPY scripts/bootstrap.sh ${INIT_DIR}/bootstrap.sh
RUN chmod +x ${INIT_DIR}/bootstrap.sh

CMD ${INIT_DIR}/bootstrap.sh