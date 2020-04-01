IMAGE_NAME := gudari/zookeeper-rest
BASE_IMAGE := gudari/openjdk:8.0.242
BUILD_IMAGE := gudari/ant:1.10.7
BUILD_DATE := `date +"%y.%m.%d"`

ALL_VERSIONS := \
		3.4.14 \
		3.5.6

dockerfile:
    ifeq ($(findstring 3.4,$(VERSION)),3.4)
	    mkdir -p build/$(VERSION)/scripts
	    cp scripts/bootstrap.sh build/$(VERSION)/scripts/bootstrap.sh
	    cp scripts/zookeeper-rest.sh build/$(VERSION)/scripts/zookeeper-rest.sh
	    docker run --rm -i -v $(PWD)/dockerfile/Dockerfile.3.4.x.template.erb:/Dockerfile.erb:ro \
		    ruby:alpine erb -U -T - \
			    version='$(VERSION)' \
			    base_image='$(BASE_IMAGE)' \
		    /Dockerfile.erb > build/$(VERSION)/Dockerfile
    endif
ifeq ($(findstring 3.5,$(VERSION)),3.5)
	mkdir -p build/$(VERSION)/scripts
	cp scripts/bootstrap.sh build/$(VERSION)/scripts/bootstrap.sh
	cp scripts/zookeeper-rest.sh build/$(VERSION)/scripts/zookeeper-rest.sh
	docker run --rm -i -v $(PWD)/dockerfile/Dockerfile.3.5.x.template.erb:/Dockerfile.erb:ro \
		ruby:alpine erb -U -T - \
			version='$(VERSION)' \
			build_image='$(BUILD_IMAGE)' \
			base_image='$(BASE_IMAGE)' \
		/Dockerfile.erb > build/$(VERSION)/Dockerfile
endif
dockerfile-all:
	(set -e ; $(foreach ver, $(ALL_VERSIONS), \
		make dockerfile \
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

src-all:
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make src \
			VERSION=$(ver) ; \
	))

image:
	docker build \
		--build-arg ZOOKEEPER_REST_VERSION=$(VERSION) \
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