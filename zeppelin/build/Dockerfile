FROM gudari/java:8.0.212

ARG ZEPPELIN_VERSION=0.8.2
ARG MINICONDA_VERSION=3-4.7.12.1
ENV ZEPPELIN_HOME=/opt/zeppelin
ENV LOG_TAG="[ZEPPELIN_${ZEPPELIN_VERSION}]:"

RUN yum install -y wget && \
    wget http://archive.apache.org/dist/zeppelin/zeppelin-${ZEPPELIN_VERSION}/zeppelin-${ZEPPELIN_VERSION}-bin-all.tgz && \
    mkdir $ZEPPELIN_HOME && \
    tar -xvzf zeppelin-${ZEPPELIN_VERSION}-bin-all.tgz -C ${ZEPPELIN_HOME} --strip-components=1 && \
    rm -fr zeppelin-${ZEPPELIN_VERSION}-bin-all.tgz && \
    yum remove -y wget && \
    yum autoremove -y && \
    yum clean all -y && \
    rm -rf /var/cache/yum && \
    mkdir -p /opt/init

RUN echo "$LOG_TAG Install miniconda3 related packages" && \
    yum install -y wget && \
    echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda${MINICONDA_VERSION}-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    yum remove -y wget && \
    yum autoremove -y && \
    yum clean all -y && \
    rm -rf /var/cache/yum && \
    rm ~/miniconda.sh
ENV PATH /opt/conda/bin:$PATH

COPY requirements.txt /opt/init/requirements.txt
RUN echo "$LOG_TAG Install python related packages" && \
    conda install -y -q --file /opt/init/requirements.txt && \
    pip install bkzep==0.4.0 ggplot==0.11.5

RUN echo "$LOG_TAG Install R related packages" && \
    yum install -y epel-release && \
    yum install -y R && \
    R -e "install.packages('knitr', repos='http://cran.us.r-project.org')" && \
    R -e "install.packages('ggplot2', repos='http://cran.us.r-project.org')" && \
    R -e "install.packages('googleVis', repos='http://cran.us.r-project.org')" && \
    R -e "install.packages('data.table', repos='http://cran.us.r-project.org')" && \
    R -e "install.packages('devtools', repos='http://cran.us.r-project.org')" && \
    R -e "install.packages('Rcpp', repos='http://cran.us.r-project.org')" && \
    Rscript -e "library('devtools'); library('Rcpp'); install_github('ramnathv/rCharts')" && \
    yum remove -y epel-release && \
    yum autoremove -y && \
    yum clean all -y && \
    rm -rf /var/cache/yum

WORKDIR ${ZEPPELIN_HOME}

COPY scripts/bootstrap.sh /opt/init/bootstrap.sh
RUN chmod 777 /opt/init/bootstrap.sh

CMD ["/opt/init/bootstrap.sh"]
