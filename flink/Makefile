IMAGE_NAME := gudari/flink
BASE_IMAGE := gudari/openjdk:8.0.242
BUILD_DATE := `date +"%y.%m.%d"`

ZOOKEEPER_VERSION := 3.4.14

ALL_VERSIONS := \
		1.8.3 \
		1.9.2 \
		1.10.0

dockerfile:
	mkdir -p build/$(VERSION)/scripts
	cp scripts/bootstrap.sh build/$(VERSION)/scripts/bootstrap.sh
	docker run --rm -i -v $(PWD)/Dockerfile.template.erb:/Dockerfile.erb:ro \
		ruby:alpine erb -U -T 0 \
			version='$(VERSION)' \
			scala_version='$(SCALA_VERSION)' \
			base_image='$(BASE_IMAGE)' \
		/Dockerfile.erb > build/$(VERSION)/Dockerfile

dockerfile-all:
	(set -e ; $(foreach ver, $(ALL_VERSIONS), \
		make dockerfile \
			VERSION=$(ver) \
			SCALA_VERSION=2.12 ; \
	))

image:
	docker build \
		--build-arg FLINK_VERSION=$(VERSION) \
		--build-arg SCALA_VERSION=2.12 \
		-t $(IMAGE_NAME):$(VERSION)-$(BUILD_DATE) \
		-t $(IMAGE_NAME):$(VERSION) \
		-t $(IMAGE_NAME):latest \
		build/$(VERSION)

image-all:
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make image \
			VERSION=$(ver) \
			SCALA_VERSION=2.12 ; \
	))

example:
	mkdir -p examples/base/$(VERSION)
	cp env/flink.env examples/base/$(VERSION)/flink.env
	cp env/zookeeper.env examples/base/$(VERSION)/zookeeper.env
	docker run --rm -i -v $(PWD)/docker-compose/docker-compose.yml.erb:/docker-compose.yml.erb:ro \
		ruby:alpine erb -U -T - \
			version='$(VERSION)' \
			zookeeper_version='$(ZOOKEEPER_VERSION)' \
		/docker-compose.yml.erb > examples/base/$(VERSION)/docker-compose.yml

example-all:
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make example \
			VERSION=$(ver) ; \
	))

src: dockerfile example

src-all:
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make src \
			VERSION=$(ver) \
			SCALA_VERSION=2.12 ; \
	))

build: src image

build-all:
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
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
