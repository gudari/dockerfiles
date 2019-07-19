IMAGE_NAME := gudari/kylin
BASE_IMAGE := gudari/hadoop:2.7.7
ZOOKEEPER_VERSION := 3.4.14
SPARK_VERSION := 2.3.1
HIVE_VERSION:= 1.2.2
HBASE_VERSION := 1.2.12
MYSQL_VERSION := 5.6.40
HADOOP_VERSION := 2.7.7

BUILD_DATE:= `date +"%y.%m.%d"`

ALL_VERSIONS := 2.4.1

dockerfile:
	mkdir -p build/$(VERSION)/scripts
	cp scripts/* build/$(VERSION)/scripts/
	docker run --rm -i -v $(PWD)/Dockerfile.template.erb:/Dockerfile.erb:ro \
		ruby:alpine erb -U -T 0 \
			version='$(VERSION)' \
			base_image='$(BASE_IMAGE)' \
			spark_version='$(SPARK_VERSION)' \
			hive_version='$(HIVE_VERSION)' \
			hbase_version='$(HBASE_VERSION)' \
		/Dockerfile.erb > build/$(VERSION)/Dockerfile

dockerfile-all:
	(set -e ; $(foreach ver, $(ALL_VERSIONS), \
		make dockerfile \
			VERSION=$(ver) \
			SPARK_VERSION=$(SPARK_VERSION) \
			HIVE_VERSION=$(HIVE_VERSION) \
			HBASE_VERSION=$(HBASE_VERSION) ; \
	))

image:
	docker build \
		--build-arg KYLIN_VERSION=$(VERSION) \
		--build-arg SPARK_VERSION=$(SPARK_VERSION) \
		--build-arg HIVE_VERSION=$(HIVE_VERSION) \
		--build-arg HBASE_VERSION=$(HBASE_VERSION) \
		-t $(IMAGE_NAME):$(VERSION)-$(BUILD_DATE) \
		-t $(IMAGE_NAME):$(VERSION) \
		-t $(IMAGE_NAME):latest \
		build/$(VERSION)

image-all:
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make image \
			VERSION=$(ver) \
			SPARK_VERSION=$(SPARK_VERSION) \
			HIVE_VERSION=$(HIVE_VERSION) \
			HBASE_VERSION=$(HBASE_VERSION) ; \
	))

example:
	mkdir -p examples/base/$(VERSION)
	cp env/hadoop.env examples/base/$(VERSION)/hadoop.env
	cp env/mysql.env examples/base/$(VERSION)/mysql.env
	cp env/hive.env examples/base/$(VERSION)/hive.env
	cp env/hbase.env examples/base/$(VERSION)/hbase.env
	cp env/kylin.env examples/base/$(VERSION)/kylin.env
	cp env/zookeeper.env examples/base/$(VERSION)/zookeeper.env
	docker run --rm -i -v $(PWD)/docker-compose/docker-compose.yml.erb:/docker-compose.yml.erb:ro \
		ruby:alpine erb -U -T - \
			version='$(VERSION)' \
			spark_version='$(SPARK_VERSION)' \
			hive_version='$(HIVE_VERSION)' \
			hbase_version='$(HBASE_VERSION)' \
			zookeeper_version='$(ZOOKEEPER_VERSION)' \
			mysql_version='$(MYSQL_VERSION)' \
			hadoop_version='$(HADOOP_VERSION)' \
		/docker-compose.yml.erb > examples/base/$(VERSION)/docker-compose.yml

example-all:
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make example \
			VERSION=$(ver) \
			SPARK_VERSION=$(SPARK_VERSION) \
			HIVE_VERSION=$(HIVE_VERSION) \
			HBASE_VERSION=$(HBASE_VERSION) \
			ZOOKEEPER_VERSION=$(ZOOKEEPER_VERSION) \
			MYSQL_VERSION=$(MYSQL_VERSION) \
			HADOOP_VERSION=$(HADOOP_VERSION) ; \
	))

src: dockerfile example

src-all:
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make src \
			VERSION=$(ver) \
			SPARK_VERSION=$(SPARK_VERSION) \
			HIVE_VERSION=$(HIVE_VERSION) \
			HBASE_VERSION=$(HBASE_VERSION) \
			ZOOKEEPER_VERSION=$(ZOOKEEPER_VERSION) \
			MYSQL_VERSION=$(MYSQL_VERSION) \
			HADOOP_VERSION=$(HADOOP_VERSION) ; \
	))

build: src image

build-all:
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make build \
			VERSION=$(ver) \
			SPARK_VERSION=$(SPARK_VERSION) \
			HIVE_VERSION=$(HIVE_VERSION) \
			HBASE_VERSION=$(HBASE_VERSION) ; \
	))

push:
	echo "$(DOCKER_PASSWORD)" | docker login -u "$(DOCKER_USERNAME)" --password-stdin
	docker push $(IMAGE_NAME):$(VERSION)-$(BUILD_DATE)
	docker push $(IMAGE_NAME):$(VERSION)
	docker push $(IMAGE_NAME):latest

push-all:
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make push \
			VERSION=$(ver) ; \
	))

release: build push

release-all:
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make release \
			VERSION=$(ver) ; \
	))

.PHONY: image image-all \
        push push-all \
		build build-all \
        release release-all \
        src src-all \
        dockerfile dockerfile-all \
		example example-all
