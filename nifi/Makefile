IMAGE_NAME := gudari/nifi
BASE_IMAGE := gudari/java:8.0.212
ZOOKEEPER_VERSION := 3.4.14
BUILD_DATE:= `date +"%y.%m.%d"`

1X_VERSIONS := \
    1.7.1 \
    1.8.0 \
    1.9.2

ALL_VERSIONS := $(1X_VERSIONS)

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
		--build-arg NIFI_VERSION=$(VERSION) \
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
	cp env/nifi.env examples/$(VERSION)/basic/nifi.env
	docker run --rm -i -v $(PWD)/docker-compose/docker-compose.yml.erb:/docker-compose.yml.erb:ro \
		ruby:alpine erb -U -T - \
			version='$(VERSION)' \
		/docker-compose.yml.erb > examples/$(VERSION)/basic/docker-compose.yml

example-cluster:
	mkdir -p examples/$(VERSION)/cluster
	cp env/zookeeper.env examples/$(VERSION)/cluster/zookeeper.env
	cp env/nifi-cluster.env examples/$(VERSION)/cluster/nifi.env
	docker run --rm -i -v $(PWD)/docker-compose/docker-compose-cluster.yml.erb:/docker-compose.yml.erb:ro \
		ruby:alpine erb -U -T - \
			version='$(VERSION)' \
			zookeeper_version='$(ZOOKEEPER_VERSION)' \
		/docker-compose.yml.erb > examples/$(VERSION)/cluster/docker-compose.yml


example-all:
	(set -e ; $(foreach ver, $(ALL_VERSIONS), \
 		make example \
			VERSION=$(ver) ; \
	))
	(set -e ; $(foreach ver, $(ALL_VERSIONS), \
 		make example-cluster \
			VERSION=$(ver) ; \
	))

src: dockerfile example example-cluster

src-all:
	(set -e ; $(foreach ver, $(ALL_VERSIONS), \
		make src \
			VERSION=$(ver) ; \
	))

build: src image

build-all:
	(set -e ; $(foreach ver, $(ALL_VERSIONS), \
		make build \
			VERSION=$(ver) ; \
	))

.PHONY: dockerfile dockerfile-all \
		example example-all \
		src src-all \
		image image-all \
		build build-all \
		push push-all \
		release release-all
