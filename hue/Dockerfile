FROM gudari/java:8u191-b12

ARG HUE_VERSION=4.4.0
ENV HUE_HOME=/opt/hue

RUN yum install -y epel-release which && \
    buildDep="ant gcc gcc-c++ make maven wget which nodejs" && \
    yum install -y $buildDep \
    asciidoc \
    cyrus-sasl-devel \
    cyrus-sasl-gssapi \
    cyrus-sasl-plain \
    krb5-devel \
    libffi-devel \
    libxml2-devel \
    libxslt-devel \
    mariadb-devel \
    openldap-devel \
    python-devel \
    sqlite-devel \
    gmp-devel \
    openssl-devel \
    mysql-connector-java \
    rsync && \
    wget https://github.com/cloudera/hue/archive/release-${HUE_VERSION}.tar.gz && \
    mkdir $HUE_HOME && \
    tar -xvzf release-${HUE_VERSION}.tar.gz -C ${HUE_HOME} --strip-components=1 && \
    rm -fr release-${HUE_VERSION}.tar.gz && \
    cd $HUE_HOME && \
    make apps && \
    groupadd hue && \
    useradd -r -u 1000 -g hue hue && \
    chown hue:hue -R $HUE_HOME && \
    yum remove -y $buildDep && \
    yum autoremove -y && \
    yum clean all -y && \
    rm -rf /var/cache/yum

WORKDIR $HUE_HOME

EXPOSE 8888

COPY scripts/bootstrap.sh /opt/init/bootstrap.sh
COPY scripts/generate_hue_ini_file.py /opt/init/generate_hue_ini_file.py
RUN yum install -y epel-release && \
    yum install -y python-pip && \
    pip install configobj && \
    yum remove -y epel-release python-pip && \
    chmod +x /opt/init/bootstrap.sh

CMD /opt/init/bootstrap.sh