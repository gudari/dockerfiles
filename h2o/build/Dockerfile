FROM gudari/openjdk:8.0.242

ARG H2O_VERSION=3.30.0.1
ENV H2O_HOME=/opt/h2o \
    INIT_DIR=/opt/init

RUN apt-get update \
    && apt-get install -y --no-install-recommends wget unzip \
    && wget http://h2o-release.s3.amazonaws.com/h2o/rel-zahradnik/1/h2o-${H2O_VERSION}.zip \
    && unzip h2o-${H2O_VERSION}.zip \
    && mv h2o-${H2O_VERSION} $H2O_HOME \
    && rm -fr ${H2O_HOME}/R \
              ${H2O_HOME}/bindings \
              ${H2O_HOME}/python \
    && apt-get remove -y wget \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p ${INIT_DIR}
    
WORKDIR $H2O_HOME

CMD java -jar $H2O_HOME/h2o.jar -ip $(hostname -I | awk '{print $1}') --port 8080
