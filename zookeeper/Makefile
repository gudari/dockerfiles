IMAGE_NAME := gudari/zookeeper
BASE_IMAGE := openjdk:8u252-jdk-slim-buster
ARM64_BASE_IMAGE := arm64v8/adoptopenjdk:8u252-b09-jdk-hotspot-bionic
BUILD_DATE := `date +"%y.%m.%d"`
ZKUI_VERSION := 2.0-SNAPSHOT

ALL_VERSIONS := \
		3.4.14 \
		3.5.8 \
		3.6.1

dockerfile:
	mkdir -p build/$(VERSION)/scripts
	cp scripts/docker-entrypoint.sh build/$(VERSION)/scripts/docker-entrypoint.sh
	docker run --rm -i -v $(PWD)/Dockerfile.template.erb:/Dockerfile.erb:ro \
		ruby:alpine erb -U -T - \
			version='$(VERSION)' \
			base_image='$(BASE_IMAGE)' \
		/Dockerfile.erb > build/$(VERSION)/Dockerfile

dockerfile-arm64:
	mkdir -p build-arm64/$(VERSION)/scripts
	cp scripts/docker-entrypoint.sh build-arm64/$(VERSION)/scripts/docker-entrypoint.sh
	docker run --rm -i -v $(PWD)/Dockerfile.template.erb:/Dockerfile.erb:ro \
		ruby:alpine erb -U -T - \
			version='$(VERSION)' \
			base_image='$(ARM64_BASE_IMAGE)' \
		/Dockerfile.erb > build-arm64/$(VERSION)/Dockerfile

dockerfile-all:
	(set -e ; $(foreach ver, $(ALL_VERSIONS), \
		make dockerfile \
			VERSION=$(ver) ; \
	))
	(set -e ; $(foreach ver, $(ALL_VERSIONS), \
		make dockerfile-arm64 \
			VERSION=$(ver) ; \
	))

example:
	mkdir -p examples/$(VERSION)/basic
	cp env/zookeeper.env examples/$(VERSION)/basic/zookeeper.env
	docker run --rm -i -v $(PWD)/docker-compose/docker-compose.yml.erb:/docker-compose.yml.erb:ro \
		ruby:alpine erb -U -T - \
			version='$(VERSION)' \
		/docker-compose.yml.erb > examples/$(VERSION)/basic/docker-compose.yml

	mkdir -p examples/$(VERSION)/zkui
	cp env/zookeeper.env examples/$(VERSION)/zkui/zookeeper.env
	cp env/zkui.env examples/$(VERSION)/zkui/zkui.env
	docker run --rm -i -v $(PWD)/docker-compose/docker-compose-zkui.yml.erb:/docker-compose.yml.erb:ro \
		ruby:alpine erb -U -T - \
			version='$(VERSION)' \
			zkui_version='$(ZKUI_VERSION)' \
		/docker-compose.yml.erb > examples/$(VERSION)/zkui/docker-compose.yml

	mkdir -p examples/$(VERSION)/ensemble
	cp env/zookeeper.env examples/$(VERSION)/ensemble/zookeeper.env
	docker run --rm -i -v $(PWD)/docker-compose/docker-compose-ensemble.yml.erb:/docker-compose.yml.erb:ro \
		ruby:alpine erb -U -T - \
			version='$(VERSION)' \
		/docker-compose.yml.erb > examples/$(VERSION)/ensemble/docker-compose.yml

	mkdir -p examples/$(VERSION)/ensemble-zkui
	cp env/zookeeper.env examples/$(VERSION)/ensemble-zkui/zookeeper.env
	cp env/zkui-ensemble.env examples/$(VERSION)/ensemble-zkui/zkui.env
	docker run --rm -i -v $(PWD)/docker-compose/docker-compose-ensemble-zkui.yml.erb:/docker-compose.yml.erb:ro \
		ruby:alpine erb -U -T - \
			version='$(VERSION)' \
			zkui_version='$(ZKUI_VERSION)' \
		/docker-compose.yml.erb > examples/$(VERSION)/ensemble-zkui/docker-compose.yml

example-all:
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make example \
			VERSION=$(ver) ; \
	))

src: dockerfile example
src-arm64: dockerfile-arm64

src-all:
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make src \
			VERSION=$(ver) ; \
	))
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make src-arm64 \
			VERSION=$(ver) ; \
	))

image:
	docker build \
		--build-arg ZOOKEEPER_VERSION=$(VERSION) \
		-t $(IMAGE_NAME):$(VERSION)-$(BUILD_DATE) \
		-t $(IMAGE_NAME):$(VERSION) \
		-t $(IMAGE_NAME):latest \
		build/$(VERSION)

image-arm64:
	docker build \
		--build-arg ZOOKEEPER_VERSION=$(VERSION) \
		-t $(IMAGE_NAME):$(VERSION)-arm64v8-$(BUILD_DATE) \
		-t $(IMAGE_NAME):$(VERSION)-arm64v8 \
		build-arm64/$(VERSION)

image-all:
	(set -e ; $(foreach ver, $(ALL_VERSIONS), \
		make image \
			VERSION=$(ver) ; \
	))
	(set -e ; $(foreach ver, $(ALL_VERSIONS), \
		make image-arm64 \
			VERSION=$(ver) ; \
	))

build: src image
build-arm64: src-arm64 image-arm64

build-all:
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make build \
			VERSION=$(ver) ; \
	))
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make build-arm64 \
			VERSION=$(ver) ; \
	))

push:
	echo "$(DOCKER_PASSWORD)" | docker login -u "$(DOCKER_USERNAME)" --password-stdin
	docker push $(IMAGE_NAME):$(VERSION)-$(BUILD_DATE)
	docker push $(IMAGE_NAME):$(VERSION)
	docker push $(IMAGE_NAME):latest

push-arm64:
	echo "$(DOCKER_PASSWORD)" | docker login -u "$(DOCKER_USERNAME)" --password-stdin
	docker push $(IMAGE_NAME):$(VERSION)-arm64v8-$(BUILD_DATE)
	docker push $(IMAGE_NAME):$(VERSION)-arm64v8

push-all:
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make push \
			VERSION=$(ver) ; \
	))

	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make push-arm64 \
			VERSION=$(ver) ; \
	))

release: build push
release-arm64: build-arm64 push-arm64

release-all:
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make release \
			VERSION=$(ver) ; \
	))
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make release-arm64 \
			VERSION=$(ver) ; \
	))

.PHONY: image image-all \
        push push-all \
		build build-all \
        release release-all \
        src src-all \
        dockerfile dockerfile-all \
		example example-all