IMAGE_NAME := gudari/hue
BASE_IMAGE := gudari/maven:3.6.3
BUILD_DATE := `date +"%y.%m.%d"`
HADOOP_VERSION := 3.2.1

ALL_VERSIONS := \
		4.5.0 \
		4.6.0 \
		4.7.0

dockerfile:
	mkdir -p build/$(VERSION)/scripts
	mkdir -p build/$(VERSION)/templates
	cp scripts/* build/$(VERSION)/scripts/
	cp templates/hue.ini.$(VERSION).template build/$(VERSION)/templates/hue.ini.template
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
	cp env/hue.env examples/$(VERSION)/basic/hue.env
	docker run --rm -i -v $(PWD)/docker-compose/docker-compose.yml.erb:/docker-compose.yml.erb:ro \
		ruby:alpine erb -U -T - \
			version='$(VERSION)' \
		/docker-compose.yml.erb > examples/$(VERSION)/basic/docker-compose.yml

example-hadoop:
	mkdir -p examples/$(VERSION)/hadoop
	cp env/hue.env examples/$(VERSION)/hadoop/hue.env
	cp env/hadoop.env examples/$(VERSION)/hadoop/hadoop.env
	docker run --rm -i -v $(PWD)/docker-compose/docker-compose.hadoop.yml.erb:/docker-compose.yml.erb:ro \
		ruby:alpine erb -U -T - \
			version='$(VERSION)' \
			hadoop_version='$(HADOOP_VERSION)' \
		/docker-compose.yml.erb > examples/$(VERSION)/hadoop/docker-compose.yml

example-all:
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make example \
			VERSION=$(ver) ; \
	))
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make example-hadoop \
			VERSION=$(ver) ; \
	))

src: dockerfile example example-hadoop

src-all:
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make src \
			VERSION=$(ver) ; \
	))

image:
	docker build \
		--build-arg HUE_VERSION=$(VERSION) \
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