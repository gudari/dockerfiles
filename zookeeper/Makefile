IMAGE_NAME := gudari/zookeeper
BASE_IMAGE := gudari/openjdk:8.0.252
BUILD_DATE := `date +"%y.%m.%d"`
ZKUI_VERSION := 2.0-SNAPSHOT

ALL_VERSIONS := \
		3.4.14 \
		3.5.8 \
		3.6.1

dockerfile:
	mkdir -p build/$(VERSION)/scripts
	cp scripts/bootstrap.sh build/$(VERSION)/scripts/bootstrap.sh
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

src-all:
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make src \
			VERSION=$(ver) ; \
	))

image:
	docker build \
		--build-arg ZOOKEEPER_VERSION=$(VERSION) \
		-t $(IMAGE_NAME):$(VERSION)-$(BUILD_DATE) \
		-t $(IMAGE_NAME):$(VERSION) \
		-t $(IMAGE_NAME):latest \
		build/$(VERSION)

image-all:
	(set -e ; $(foreach ver, $(ALL_VERSIONS), \
		make image \
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