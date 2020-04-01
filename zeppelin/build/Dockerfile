FROM gudari/openjdk:8.0.242

ARG ZEPPELIN_VERSION=0.8.2
ARG MINICONDA_VERSION=3-4.7.12.1
ENV ZEPPELIN_HOME=/opt/zeppelin
ENV INIT_DIR=/opt/init

RUN apt-get update \
    && apt-get install --no-install-recommends -y wget \
    && wget http://archive.apache.org/dist/zeppelin/zeppelin-${ZEPPELIN_VERSION}/zeppelin-${ZEPPELIN_VERSION}-bin-all.tgz \
    && mkdir -p $ZEPPELIN_HOME \
    && tar -xvzf zeppelin-${ZEPPELIN_VERSION}-bin-all.tgz -C ${ZEPPELIN_HOME} --strip-components=1 \
    && rm -fr zeppelin-${ZEPPELIN_VERSION}-bin-all.tgz \
    && apt-get remove -y wget \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p ${INIT_DIR}

RUN apt-get update \
    && apt-get install --no-install-recommends -y wget \
    && wget --quiet https://repo.continuum.io/miniconda/Miniconda${MINICONDA_VERSION}-Linux-x86_64.sh -O ~/miniconda.sh \
    && /bin/bash ~/miniconda.sh -b -p /opt/conda \
    && apt-get remove -y wget \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    rm ~/miniconda.sh

ENV PATH /opt/conda/bin:$PATH

COPY requirements.txt /opt/init/requirements.txt
RUN conda install -y -q --file /opt/init/requirements.txt \
    && pip install --no-cache-dir bkzep==0.4.0 ggplot==0.11.5 \
    && conda clean -a -y

RUN apt-get update \
    && apt-get update \
    && apt-get install --no-install-recommends -y r-base r-base-dev \
    && R -e "install.packages('knitr', repos='http://cran.us.r-project.org')" \
    && R -e "install.packages('ggplot2', repos='http://cran.us.r-project.org')" \
    && R -e "install.packages('googleVis', repos='http://cran.us.r-project.org')" \
    && R -e "install.packages('data.table', repos='http://cran.us.r-project.org')" \
    && R -e "install.packages('devtools', repos='http://cran.us.r-project.org')" \
    && R -e "install.packages('Rcpp', repos='http://cran.us.r-project.org')" \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

WORKDIR ${ZEPPELIN_HOME}

COPY scripts/bootstrap.sh /opt/init/bootstrap.sh
RUN chmod 777 /opt/init/bootstrap.sh

EXPOSE 8080
CMD ["/opt/init/bootstrap.sh"]
