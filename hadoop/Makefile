IMAGE_NAME := gudari/hadoop
BASE_IMAGE := openjdk:11.0.7-jdk-slim-buster
ARM64V8_BASE_IMAGE := arm64v8/openjdk:11.0.7-jdk-slim-buster
BUILD_DATE := `date +"%y.%m.%d"`
HUE_VERSION := 4.7.1
POSTGRES_VERSION := 12.3
ZOOKEEPER_VERSION := 3.4.14

2X_VERSIONS := \
		2.10.0
3X_VERSIONS := \
		3.1.3 \
		3.2.1

ALL_VERSIONS := $(2X_VERSIONS) $(3X_VERSIONS)

ARM64V8_VERSION := 3.2.1

dockerfile:
	mkdir -p build/$(VERSION)/scripts
	cp scripts/bootstrap.sh build/$(VERSION)/scripts/bootstrap.sh
	docker run --rm -i -v $(PWD)/Dockerfile.template.amd64.erb:/Dockerfile.erb:ro \
		ruby:alpine erb -U -T 0 \
			version='$(VERSION)' \
			base_image='$(BASE_IMAGE)' \
		/Dockerfile.erb > build/$(VERSION)/Dockerfile

dockerfile-arm64v8:
	mkdir -p build-arm64v8/$(ARM64V8_VERSION)/scripts
	cp scripts/bootstrap.sh build-arm64v8/$(ARM64V8_VERSION)/scripts/bootstrap.sh
	docker run --rm -i -v $(PWD)/Dockerfile.template.arm64v8.erb:/Dockerfile.erb:ro \
		ruby:alpine erb -U -T 0 \
			version='$(ARM64V8_VERSION)' \
			base_image='$(ARM64V8_BASE_IMAGE)' \
		/Dockerfile.erb > build-arm64v8/$(ARM64V8_VERSION)/Dockerfile

dockerfile-all:
	(set -e ; $(foreach ver, $(ALL_VERSIONS), \
		make dockerfile \
			VERSION=$(ver) ; \
	))
	(set -e ; make dockerfile-arm64v8 \
			VERSION=$(ARM64V8_VERSION) ; \
	)

image:
	docker build \
		--build-arg HADOOP_VERSION=$(VERSION) \
		-t $(IMAGE_NAME):$(VERSION)-$(BUILD_DATE) \
		-t $(IMAGE_NAME):$(VERSION) \
		-t $(IMAGE_NAME):latest \
		build/$(VERSION)

image-arm64v8:
	docker build \
		--build-arg HADOOP_VERSION=$(ARM64V8_VERSION) \
		-t $(IMAGE_NAME):$(ARM64V8_VERSION)-arm64v8-$(BUILD_DATE) \
		-t $(IMAGE_NAME):$(ARM64V8_VERSION)-arm64v8 \
		build-arm64v8/$(ARM64V8_VERSION)

image-all:
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make image \
			VERSION=$(ver) ; \
	))
	(set -e ; make image-arm64v8 \
			VERSION=$(ARM64V8_VERSION) ; \
	)

example:
	mkdir -p examples/base/$(VERSION)
	cp env/hadoop.env examples/base/$(VERSION)/hadoop.env
	docker run --rm -i -v $(PWD)/docker-compose/docker-compose.yml.erb:/docker-compose.yml.erb:ro \
		ruby:alpine erb -U -T - \
			version='$(VERSION)' \
		/docker-compose.yml.erb > examples/base/$(VERSION)/docker-compose.yml

example-hue:
	mkdir -p examples/hue/$(VERSION)
	cp env/hadoop.env examples/hue/$(VERSION)/hadoop.env
	cp env/hue.env examples/hue/$(VERSION)/hue.env
	cp env/hue-postgres.env examples/hue/$(VERSION)/hue-postgres.env
	docker run --rm -i -v $(PWD)/docker-compose/docker-compose.hue.yml.erb:/docker-compose.yml.erb:ro \
		ruby:alpine erb -U -T - \
			version='$(VERSION)' \
			hue_version='$(HUE_VERSION)' \
			postgres_version='$(POSTGRES_VERSION)' \
		/docker-compose.yml.erb > examples/hue/$(VERSION)/docker-compose.yml

example-ha:
	mkdir -p examples/ha/$(VERSION)
	cp env/hadoop-ha.env examples/ha/$(VERSION)/hadoop-ha.env
	cp env/zookeeper.env examples/ha/$(VERSION)/zookeeper.env
	docker run --rm -i -v $(PWD)/docker-compose/docker-compose.ha.yml.erb:/docker-compose.yml.erb:ro \
		ruby:alpine erb -U -T - \
			version='$(VERSION)' \
			zookeeper_version='$(ZOOKEEPER_VERSION)' \
		/docker-compose.yml.erb > examples/ha/$(VERSION)/docker-compose.yml

example-all:
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make example \
			VERSION=$(ver) ; \
	))
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make example-ha \
			VERSION=$(ver) ; \
	))

src: dockerfile example example-hue example-ha

src-arm64v8: dockerfile-arm64v8

src-all:
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make src \
			VERSION=$(ver) ; \
	))

	(set -e ; make src-arm64v8 \
			VERSION=$(ARM64V8_VERSION) ; \
	)

build: src image

build-arm64v8: src-arm64v8 image-arm64v8

build-all:
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make build \
			VERSION=$(ver) ; \
	))
	(set -e ; make build-arm64v8 \
			VERSION=$(ARM64V8_VERSION) ; \
	)

push:
	echo "$(DOCKER_PASSWORD)" | docker login -u "$(DOCKER_USERNAME)" --password-stdin
	docker push $(IMAGE_NAME):$(VERSION)-$(BUILD_DATE)
	docker push $(IMAGE_NAME):$(VERSION)
	docker push $(IMAGE_NAME):latest

push-arm64v8:
	echo "$(DOCKER_PASSWORD)" | docker login -u "$(DOCKER_USERNAME)" --password-stdin
	docker push $(IMAGE_NAME):$(ARM64V8_VERSION)-arm64v8-$(BUILD_DATE)
	docker push $(IMAGE_NAME):$(ARM64V8_VERSION)-arm64v8

push-all:
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make push \
			VERSION=$(ver) ; \
	))
	(set -e ; make push-arm64v8 \
			VERSION=$(ARM64V8_VERSION) ; \
	)

release: build push

release-arm64v8: build-arm64v8 push-arm64v8

release-all:
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make release \
			VERSION=$(ver) ; \
	))
	(set -e ; make release-arm64v8 \
			VERSION=$(ARM64V8_VERSION) ; \
	)

.PHONY: image image-all \
        push push-all \
		build build-all \
        release release-all \
        src src-all \
        dockerfile dockerfile-all \
		example example-all
