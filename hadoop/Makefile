IMAGE_NAME := gudari/hadoop
BASE_IMAGE := gudari/java:8.0.212
BUILD_DATE:= `date +"%y.%m.%d"`

2X_VERSIONS := \
		2.7.7 \
		2.8.5 \
		2.9.2
3X_VERSIONS := \
		3.0.3 \
		3.1.2 \
		3.2.0

ALL_VERSIONS := $(2X_VERSIONS) $(3X_VERSIONS)

dockerfile:
	mkdir -p build/$(VERSION)/scripts
	cp scripts/bootstrap.sh build/$(VERSION)/scripts/bootstrap.sh
	docker run --rm -i -v $(PWD)/Dockerfile.template.erb:/Dockerfile.erb:ro \
		ruby:alpine erb -U -T 0 \
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
		--build-arg KAFKA_VERSION=$(VERSION) \
		--build-arg SCALA_VERSION=$(SCALA_VERSION) \
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
	docker run --rm -i -v $(PWD)/docker-compose/docker-compose-hue.yml.erb:/docker-compose.yml.erb:ro \
		ruby:alpine erb -U -T - \
			version='$(VERSION)' \
		/docker-compose.yml.erb > examples/hue/$(VERSION)/docker-compose.yml

example-all:
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make example \
			VERSION=$(ver) ; \
	))
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make example-hue \
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
