IMAGE_NAME := gudari/oozie
BUILD_IMAGE := gudari/maven:3.6.3
BASE_IMAGE := gudari/hadoop:2.10.0
BUILD_DATE := `date +"%y.%m.%d"`
HADOOP_VERSION := 2.10.0
HUE_VERSION := 4.7.0

ALL_VERSIONS := \
		5.2.0

dockerfile:
	mkdir -p build/$(VERSION)/scripts
	cp scripts/* build/$(VERSION)/scripts/
	docker run --rm -i -v $(PWD)/Dockerfile.template.erb:/Dockerfile.erb:ro \
		ruby:alpine erb -U -T - \
			version='$(VERSION)' \
			base_image='$(BASE_IMAGE)' \
			build_image='$(BUILD_IMAGE)' \
			hadoop_version='$(HADOOP_VERSION)' \
		/Dockerfile.erb > build/$(VERSION)/Dockerfile
    
dockerfile-all:
	(set -e ; $(foreach ver, $(ALL_VERSIONS), \
		make dockerfile \
			VERSION=$(ver) ; \
	))

example:
	mkdir -p examples/$(VERSION)/basic
	cp env/oozie.env examples/$(VERSION)/basic/oozie.env
	docker run --rm -i -v $(PWD)/docker-compose/docker-compose.yml.erb:/docker-compose.yml.erb:ro \
		ruby:alpine erb -U -T - \
			version='$(VERSION)' \
		/docker-compose.yml.erb > examples/$(VERSION)/basic/docker-compose.yml

example-hadoop:
	mkdir -p examples/$(VERSION)/hadoop
	cp env/oozie.env examples/$(VERSION)/hadoop/oozie.env
	cp env/hadoop.env examples/$(VERSION)/hadoop/hadoop.env
	docker run --rm -i -v $(PWD)/docker-compose/docker-compose.hadoop.yml.erb:/docker-compose.yml.erb:ro \
		ruby:alpine erb -U -T - \
			version='$(VERSION)' \
			hadoop_version='$(HADOOP_VERSION)' \
		/docker-compose.yml.erb > examples/$(VERSION)/hadoop/docker-compose.yml

example-hue:
	mkdir -p examples/$(VERSION)/hue
	cp env/oozie.env examples/$(VERSION)/hue/oozie.env
	cp env/hadoop.env examples/$(VERSION)/hue/hadoop.env
	cp env/hue.env examples/$(VERSION)/hue/hue.env
	docker run --rm -i -v $(PWD)/docker-compose/docker-compose.hue.yml.erb:/docker-compose.yml.erb:ro \
		ruby:alpine erb -U -T - \
			version='$(VERSION)' \
			hadoop_version='$(HADOOP_VERSION)' \
			hue_version='$(HUE_VERSION)' \
		/docker-compose.yml.erb > examples/$(VERSION)/hue/docker-compose.yml

example-all:
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make example \
			VERSION=$(ver) ; \
	))
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make example-hadoop \
			VERSION=$(ver) ; \
	))
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make example-hue \
			VERSION=$(ver) ; \
	))

src: dockerfile example example-hadoop example-hue

src-all:
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make src \
			VERSION=$(ver) ; \
	))

image:
	docker build \
		--build-arg OOZIE_VERSION=$(VERSION) \
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