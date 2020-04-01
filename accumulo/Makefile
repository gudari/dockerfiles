IMAGE_NAME := gudari/accumulo
BASE_IMAGE := gudari/hadoop:2.7.7
BUILD_DATE:= `date +"%y.%m.%d"`

ZOOKEEPER_VERSION := 3.4.14
HADOOP_VERSION := 2.7.7

ALL_VERSIONS := \
		1.9.3 \
		2.0.0

dockerfile:
	mkdir -p build/$(VERSION)/scripts
	cp scripts/bootstrap.sh build/$(VERSION)/scripts/bootstrap.sh
	docker run --rm -i -v $(PWD)/Dockerfile.template.erb:/Dockerfile.erb:ro \
		ruby:alpine erb -U -T 0 \
			version='$(VERSION)' \
			base_image='$(BASE_IMAGE)' \
			zookeeper_version='$(ZOOKEEPER_VERSION)' \
		/Dockerfile.erb > build/$(VERSION)/Dockerfile

dockerfile-all:
	(set -e ; $(foreach ver, $(ALL_VERSIONS), \
		make dockerfile \
			VERSION=$(ver) ; \
	))

image:
	docker build \
		--build-arg ACCUMULO_VERSION=$(VERSION) \
		--build-arg ZOOKEEPER_VERSION=$(ZOOKEEPER_VERSION) \
		-t $(IMAGE_NAME):$(VERSION)-$(BUILD_DATE) \
		-t $(IMAGE_NAME):$(VERSION) \
		-t $(IMAGE_NAME):latest \
		build/$(VERSION)

image-all:
	(set -e ; $(foreach ver, $(ALL_VERSIONS), \
		make image \
			VERSION=$(ver) ; \
	))

example:
	mkdir -p examples/$(VERSION)/basic
	cp env/accumulo.env examples/$(VERSION)/basic/accumulo.env
	cp env/zookeeper.env examples/$(VERSION)/basic/zookeeper.env
	cp env/hadoop.env examples/$(VERSION)/basic/hadoop.env
	docker run --rm -i -v $(PWD)/docker-compose/docker-compose.yml.erb:/docker-compose.yml.erb:ro \
		ruby:alpine erb -U -T - \
			version='$(VERSION)' \
			hadoop_version='$(HADOOP_VERSION)' \
			zookeeper_version='$(ZOOKEEPER_VERSION)' \
		/docker-compose.yml.erb > examples/$(VERSION)/basic/docker-compose.yml

example-all:
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make example \
			VERSION=$(ver) ; \
	))

src: dockerfile example

src-all:
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make src \
			VERSION=$(ver) \ ; \
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