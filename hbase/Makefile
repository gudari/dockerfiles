IMAGE_NAME := gudari/hbase
BASE_IMAGE := gudari/hadoop:2.7.7
HADOOP_VERSION := 2.7.7
ZOOKEEPER_VERSION := 3.4.14
BUILD_DATE := `date +"%y.%m.%d"`

1X_VERSIONS := 1.2.12 \
			   1.3.5 \
			   1.4.10

2X_VERSIONS := 2.0.5 \
		       2.1.5 \
			   2.2.0

ALL_VERSIONS := $(1X_VERSIONS) $(2X_VERSIONS)

dockerfile:
	mkdir -p build/$(VERSION)/scripts
	mkdir -p build/$(VERSION)/conf
	cp scripts/bootstrap.sh build/$(VERSION)/scripts/bootstrap.sh
	cp conf/* build/$(VERSION)/conf
	docker run --rm -i -v $(PWD)/Dockerfile.template.erb:/Dockerfile.erb:ro \
		ruby:alpine erb -U -T - \
			version='$(VERSION)' \
			base_image='$(BASE_IMAGE)' \
		/Dockerfile.erb > build/$(VERSION)/Dockerfile

dockerfile-all:
	(set -e ; $(foreach ver, $(ALL_VERSIONS), \
		make dockerfile \
			VERSION=$(ver) ; \
	))

image:
	docker build \
		--build-arg HBASE_VERSION=$(VERSION) \
		-t $(IMAGE_NAME):$(VERSION)-$(BUILD_DATE) \
		-t $(IMAGE_NAME):$(VERSION) \
		-t $(IMAGE_NAME):latest \
		build/$(VERSION)

image-all:
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make image \
			VERSION=$(ver) ; \
	))

example:
	mkdir -p examples/$(VERSION)/basic
	cp env/hadoop.env examples/$(VERSION)/basic/hadoop.env
	cp env/hbase.env examples/$(VERSION)/basic/hbase.env
	cp env/zookeeper.env examples/$(VERSION)/basic/zookeeper.env
	docker run --rm -i -v $(PWD)/docker-compose/docker-compose.yml.erb:/docker-compose.yml.erb:ro \
		ruby:alpine erb -U -T - \
			version='$(VERSION)' \
			zookeeper_version='$(ZOOKEEPER_VERSION)' \
			hadoop_version='$(HADOOP_VERSION)' \
		/docker-compose.yml.erb > examples/$(VERSION)/basic/docker-compose.yml

	mkdir -p examples/$(VERSION)/thrift
	cp env/hadoop.env examples/$(VERSION)/thrift/hadoop.env
	cp env/hbase.env examples/$(VERSION)/thrift/hbase.env
	cp env/zookeeper.env examples/$(VERSION)/thrift/zookeeper.env
	docker run --rm -i -v $(PWD)/docker-compose/docker-compose-thrift.yml.erb:/docker-compose.yml.erb:ro \
		ruby:alpine erb -U -T - \
			version='$(VERSION)' \
			zookeeper_version='$(ZOOKEEPER_VERSION)' \
			hadoop_version='$(HADOOP_VERSION)' \
		/docker-compose.yml.erb > examples/$(VERSION)/thrift/docker-compose.yml

	mkdir -p examples/$(VERSION)/thrift2
	cp env/hadoop.env examples/$(VERSION)/thrift2/hadoop.env
	cp env/hbase.env examples/$(VERSION)/thrift2/hbase.env
	cp env/zookeeper.env examples/$(VERSION)/thrift2/zookeeper.env
	docker run --rm -i -v $(PWD)/docker-compose/docker-compose-thrift2.yml.erb:/docker-compose.yml.erb:ro \
		ruby:alpine erb -U -T - \
			version='$(VERSION)' \
			zookeeper_version='$(ZOOKEEPER_VERSION)' \
			hadoop_version='$(HADOOP_VERSION)' \
		/docker-compose.yml.erb > examples/$(VERSION)/thrift2/docker-compose.yml

	mkdir -p examples/$(VERSION)/rest
	cp env/hadoop.env examples/$(VERSION)/rest/hadoop.env
	cp env/hbase.env examples/$(VERSION)/rest/hbase.env
	cp env/zookeeper.env examples/$(VERSION)/rest/zookeeper.env
	docker run --rm -i -v $(PWD)/docker-compose/docker-compose-rest.yml.erb:/docker-compose.yml.erb:ro \
		ruby:alpine erb -U -T - \
			version='$(VERSION)' \
			zookeeper_version='$(ZOOKEEPER_VERSION)' \
			hadoop_version='$(HADOOP_VERSION)' \
		/docker-compose.yml.erb > examples/$(VERSION)/rest/docker-compose.yml

example-all:
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make example \
			VERSION=$(ver) ; \
	))

src: dockerfile example

src-all:
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make src \
			VERSION=$(ver) ; \
	))

build: src image

build-all:
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make build \
			VERSION=$(ver) ; \
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