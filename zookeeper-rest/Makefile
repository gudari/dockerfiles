IMAGE_NAME := gudari/zookeeper-rest
BASE_IMAGE := openjdk:8u252-jdk-slim-buster
ARM64_BASE_IMAGE := arm64v8/adoptopenjdk:8u252-b09-jdk-hotspot-bionic
ANT_BUILD_IMAGE := gudari/ant:1.10.7
MAVEN_BUILD_IMAGE := maven:3.6.3-jdk-8
BUILD_DATE := `date +"%y.%m.%d"`

ALL_VERSIONS := \
		3.4.14 \
		3.5.8 \
		3.6.1

dockerfile:
ifeq ($(findstring 3.4,$(VERSION)),3.4)
	mkdir -p build/$(VERSION)/scripts
	cp scripts/docker-entrypoint.sh build/$(VERSION)/scripts/docker-entrypoint.sh
	cp scripts/zookeeper-rest.sh build/$(VERSION)/scripts/zookeeper-rest.sh
	docker run --rm -i -v $(PWD)/dockerfile/Dockerfile.3.4.x.template.erb:/Dockerfile.erb:ro \
		ruby:alpine erb -U -T - \
			version='$(VERSION)' \
			base_image='$(BASE_IMAGE)' \
		/Dockerfile.erb > build/$(VERSION)/Dockerfile
endif
ifeq ($(findstring 3.5,$(VERSION)),3.5)
	mkdir -p build/$(VERSION)/scripts
	cp scripts/docker-entrypoint.sh build/$(VERSION)/scripts/docker-entrypoint.sh
	cp scripts/zookeeper-rest.sh build/$(VERSION)/scripts/zookeeper-rest.sh
	docker run --rm -i -v $(PWD)/dockerfile/Dockerfile.3.5.x.template.erb:/Dockerfile.erb:ro \
		ruby:alpine erb -U -T - \
			version='$(VERSION)' \
			ant_build_image='$(ANT_BUILD_IMAGE)' \
			base_image='$(BASE_IMAGE)' \
		/Dockerfile.erb > build/$(VERSION)/Dockerfile
endif
ifeq ($(findstring 3.6,$(VERSION)),3.6)
	mkdir -p build/$(VERSION)/scripts
	cp scripts/docker-entrypoint.sh build/$(VERSION)/scripts/docker-entrypoint.sh
	cp scripts/zookeeper-rest.sh build/$(VERSION)/scripts/zookeeper-rest.sh
	docker run --rm -i -v $(PWD)/dockerfile/Dockerfile.3.6.x.template.erb:/Dockerfile.erb:ro \
		ruby:alpine erb -U -T - \
			version='$(VERSION)' \
			maven_build_image='$(MAVEN_BUILD_IMAGE)' \
			base_image='$(BASE_IMAGE)' \
		/Dockerfile.erb > build/$(VERSION)/Dockerfile
endif

dockerfile-arm64:
ifeq ($(findstring 3.4,$(VERSION)),3.4)
	mkdir -p build-arm64/$(VERSION)/scripts
	cp scripts/docker-entrypoint.sh build-arm64/$(VERSION)/scripts/docker-entrypoint.sh
	cp scripts/zookeeper-rest.sh build-arm64/$(VERSION)/scripts/zookeeper-rest.sh
	docker run --rm -i -v $(PWD)/dockerfile/Dockerfile.3.4.x.template.erb:/Dockerfile.erb:ro \
		ruby:alpine erb -U -T - \
		version='$(VERSION)' \
		base_image='$(ARM64_BASE_IMAGE)' \
	/Dockerfile.erb > build-arm64/$(VERSION)/Dockerfile
endif
ifeq ($(findstring 3.5,$(VERSION)),3.5)
	mkdir -p build-arm64/$(VERSION)/scripts
	cp scripts/docker-entrypoint.sh build-arm64/$(VERSION)/scripts/docker-entrypoint.sh
	cp scripts/zookeeper-rest.sh build-arm64/$(VERSION)/scripts/zookeeper-rest.sh
	docker run --rm -i -v $(PWD)/dockerfile/Dockerfile.3.5.x.template.erb:/Dockerfile.erb:ro \
		ruby:alpine erb -U -T - \
			version='$(VERSION)' \
			ant_build_image='$(ANT_BUILD_IMAGE)' \
			base_image='$(ARM64_BASE_IMAGE)' \
		/Dockerfile.erb > build-arm64/$(VERSION)/Dockerfile
endif
ifeq ($(findstring 3.6,$(VERSION)),3.6)
	mkdir -p build-arm64/$(VERSION)/scripts
	cp scripts/docker-entrypoint.sh build-arm64/$(VERSION)/scripts/docker-entrypoint.sh
	cp scripts/zookeeper-rest.sh build-arm64/$(VERSION)/scripts/zookeeper-rest.sh
	docker run --rm -i -v $(PWD)/dockerfile/Dockerfile.3.6.x.template.erb:/Dockerfile.erb:ro \
		ruby:alpine erb -U -T - \
			version='$(VERSION)' \
			maven_build_image='$(MAVEN_BUILD_IMAGE)' \
			base_image='$(ARM64_BASE_IMAGE)' \
		/Dockerfile.erb > build-arm64/$(VERSION)/Dockerfile
endif

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
	cp env/zookeeper-rest.env examples/$(VERSION)/basic/zookeeper-rest.env
	docker run --rm -i -v $(PWD)/docker-compose/docker-compose.yml.erb:/docker-compose.yml.erb:ro \
		ruby:alpine erb -U -T - \
			version='$(VERSION)' \
		/docker-compose.yml.erb > examples/$(VERSION)/basic/docker-compose.yml

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
		--build-arg ZOOKEEPER_REST_VERSION=$(VERSION) \
		-t $(IMAGE_NAME):$(VERSION)-$(BUILD_DATE) \
		-t $(IMAGE_NAME):$(VERSION) \
		-t $(IMAGE_NAME):latest \
		build/$(VERSION)

image-arm64:
	docker build \
		--build-arg ZOOKEEPER_REST_VERSION=$(VERSION) \
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

push-all:
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make push \
			VERSION=$(ver)1 ; \
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