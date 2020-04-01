FROM gudari/spark:2.4.5

ARG JUPYTERLAB_VERSION=2.0.1
ENV JUPYTERLAB_HOME=/opt/jupyterlab
ENV INIT_DIR /opt/init

RUN apt-get update \
    && apt-get install -y --no-install-recommends python3-pip \
    && pip3 install --no-cache-dir --upgrade setuptools pip \
    && pip3 install --no-cache-dir ipython jupyterlab==${JUPYTERLAB_VERSION} \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p ${INIT_DIR}

COPY requirements.txt ${INIT_DIR}/requirements.txt
RUN pip3 install --no-cache-dir -r ${INIT_DIR}/requirements.txt

WORKDIR $JUPYTERLAB_HOME

COPY scripts/bootstrap.sh ${INIT_DIR}/bootstrap.sh
RUN echo "export PATH=$PATH" >> ~/.bashrc \
    && chmod +x ${INIT_DIR}/bootstrap.sh

ENV SHELL=/bin/bash

CMD ${INIT_DIR}/bootstrap.sh
