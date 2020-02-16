IMAGE_NAME := gudari/kafka
BASE_IMAGE := gudari/openjdk:8.0.242
ZOOKEEPER_VERSION := 3.4.14
CMAK_VERSION := 2.0.0.2
BUILD_DATE:= `date +"%y.%m.%d"`

0X_VERSIONS := \
		0.11.0.3
1X_VERSIONS := \
		1.0.2 \
		1.1.1
2X_VERSIONS := \
		2.0.1 \
		2.1.1 \
		2.2.2 \
		2.3.1 \
		2.4.0

ALL_VERSIONS := $(0X_VERSIONS) $(1X_VERSIONS) $(2X_VERSIONS)

dockerfile:
	mkdir -p build/$(VERSION)/scripts
	cp scripts/bootstrap.sh build/$(VERSION)/scripts/bootstrap.sh
	docker run --rm -i -v $(PWD)/Dockerfile.template.erb:/Dockerfile.erb:ro \
		ruby:alpine erb -U -T 0 \
			kafka_version='$(VERSION)' \
			scala_version='$(SCALA_VERSION)' \
			base_image='$(BASE_IMAGE)' \
		/Dockerfile.erb > build/$(VERSION)/Dockerfile

dockerfile-all:
	(set -e ; $(foreach ver, $(0X_VERSIONS) $(1X_VERSIONS), \
		make dockerfile \
			VERSION=$(ver) \
			SCALA_VERSION=2.11 ; \
	))
	(set -e ; $(foreach ver, $(2X_VERSIONS), \
		make dockerfile \
			VERSION=$(ver) \
			SCALA_VERSION=2.12 ; \
	))

image:
	docker build \
		--build-arg KAFKA_VERSION=$(VERSION) \
		--build-arg SCALA_VERSION=$(SCALA_VERSION) \
		-t $(IMAGE_NAME):$(VERSION)-$(BUILD_DATE) \
		-t $(IMAGE_NAME):$(VERSION) \
		-t $(IMAGE_NAME):latest \
		build/$(VERSION)

image-all:
	(set -e ; $(foreach ver, $(0X_VERSIONS) $(1X_VERSIONS), \
		make image \
			VERSION=$(ver) \
			SCALA_VERSION=2.11 ; \
	))
	(set -e ; $(foreach ver, $(2X_VERSIONS), \
		make image \
			VERSION=$(ver) \
			SCALA_VERSION=2.12 ; \
	))

example:
	mkdir -p examples/$(VERSION)/basic
	cp env/kafka.env examples/$(VERSION)/basic/kafka.env
	cp env/zookeeper.env examples/$(VERSION)/basic/zookeeper.env
	docker run --rm -i -v $(PWD)/docker-compose/docker-compose.yml.erb:/docker-compose.yml.erb:ro \
		ruby:alpine erb -U -T - \
			version='$(VERSION)' \
			zookeeper_version='$(ZOOKEEPER_VERSION)' \
		/docker-compose.yml.erb > examples/$(VERSION)/basic/docker-compose.yml

	mkdir -p examples/$(VERSION)/zkui
	cp env/kafka.env examples/$(VERSION)/zkui/kafka.env
	cp env/zookeeper.env examples/$(VERSION)/zkui/zookeeper.env
	cp env/zkui.env examples/$(VERSION)/zkui/zkui.env
	docker run --rm -i -v $(PWD)/docker-compose/docker-compose-zkui.yml.erb:/docker-compose.yml.erb:ro \
		ruby:alpine erb -U -T - \
			version='$(VERSION)' \
			zookeeper_version='$(ZOOKEEPER_VERSION)' \
		/docker-compose.yml.erb > examples/$(VERSION)/zkui/docker-compose.yml

	mkdir -p examples/$(VERSION)/kafka-cluster
	cp env/kafka-cluster.env examples/$(VERSION)/kafka-cluster/kafka-cluster.env
	cp env/zookeeper.env examples/$(VERSION)/kafka-cluster/zookeeper.env
	docker run --rm -i -v $(PWD)/docker-compose/docker-compose-cluster.yml.erb:/docker-compose.yml.erb:ro \
		ruby:alpine erb -U -T - \
			version='$(VERSION)' \
			zookeeper_version='$(ZOOKEEPER_VERSION)' \
		/docker-compose.yml.erb > examples/$(VERSION)/kafka-cluster/docker-compose.yml

	mkdir -p examples/$(VERSION)/cmak
	cp env/kafka-cluster.env examples/$(VERSION)/cmak/kafka-cluster.env
	cp env/zookeeper.env examples/$(VERSION)/cmak/zookeeper.env
	cp env/cmak.env examples/$(VERSION)/cmak/cmak.env
	docker run --rm -i -v $(PWD)/docker-compose/docker-compose-cmak.yml.erb:/docker-compose.yml.erb:ro \
		ruby:alpine erb -U -T - \
			version='$(VERSION)' \
			zookeeper_version='$(ZOOKEEPER_VERSION)' \
			cmak_version='$(CMAK_VERSION)' \
		/docker-compose.yml.erb > examples/$(VERSION)/cmak/docker-compose.yml

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
	(set -e ; $(foreach ver,$(0X_VERSIONS) $(1X_VERSIONS), \
		make build \
			VERSION=$(ver) \
			SCALA_VERSION=2.11 ; \
	))
	(set -e ; $(foreach ver,$(2X_VERSIONS), \
		make build \
			VERSION=$(ver) \
			SCALA_VERSION=2.12 ; \
	))

push:
	echo "$(DOCKER_PASSWORD)" | docker login -u "$(DOCKER_USERNAME)" --password-stdin
	docker push $(IMAGE_NAME):$(VERSION)-$(BUILD_DATE)
	docker push $(IMAGE_NAME):$(VERSION)
	docker push $(IMAGE_NAME):latest

push-all:
	(set -e ; $(foreach ver,$(0X_VERSIONS) $(1X_VERSIONS), \
		make push \
			VERSION=$(ver) \
			SCALA_VERSION=2.11 ; \
	))
	(set -e ; $(foreach ver,$(2X_VERSIONS), \
		make push \
			VERSION=$(ver) \
			SCALA_VERSION=2.12 ; \
	))

release: build push

release-all:
	(set -e ; $(foreach ver,$(0X_VERSIONS) $(1X_VERSIONS), \
		make release \
			VERSION=$(ver) \
			SCALA_VERSION=2.11 ; \
	))
	(set -e ; $(foreach ver,$(2X_VERSIONS), \
		make release \
			VERSION=$(ver) \
			SCALA_VERSION=2.12 ; \
	))

.PHONY: image image-all \
        push push-all \
		build build-all \
        release release-all \
        src src-all \
        dockerfile dockerfile-all \
		example example-all
