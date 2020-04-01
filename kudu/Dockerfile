FROM gudari/openjdk:8.0.242

ARG KUDU_VERSION=1.11.1
ENV KUDU_HOME=/opt/kudu
ENV KUDU_BUILD_DIR=/opt/kudu-build

RUN apt-get update \
    && apt-get -y install --no-install-recommends autoconf automake curl flex g++ gcc gdb git \
       krb5-admin-server krb5-kdc krb5-user libkrb5-dev libsasl2-dev libsasl2-modules \
       libsasl2-modules-gssapi-mit libssl-dev libtool lsb-release make ntp \
       openssl patch pkg-config python rsync unzip vim-common wget \
    && mkdir -p $KUDU_BUILD_DIR \
    && wget https://archive.apache.org/dist/kudu/${KUDU_VERSION}/apache-kudu-${KUDU_VERSION}.tar.gz \
    && tar -xvzf apache-kudu-${KUDU_VERSION}.tar.gz -C ${KUDU_BUILD_DIR} --strip-components=1 \
    && cd $KUDU_BUILD_DIR \
    && thirdparty/build-if-necessary.sh \
    && mkdir -p build/release \
    && cd build/release \
    && ../../thirdparty/installed/common/bin/cmake -DCMAKE_BUILD_TYPE=release ../.. \
    && 
