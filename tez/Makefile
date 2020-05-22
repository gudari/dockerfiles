UI_IMAGE_NAME := gudari/tez-ui
HADOOP_IMAGE_NAME := gudari/tez-hadoop
BASE_IMAGE := gudari/hadoop:2.10.0
BUILD_DATE := `date +"%y.%m.%d"`
HADOOP_VERSION := 2.10.0
TOMCAT_VERSION := 8.5.9

ALL_VERSIONS := \
		0.9.2

dockerfile:
	mkdir -p build/$(VERSION)/ui/scripts
	mkdir -p build/$(VERSION)/hadoop/scripts
	cp scripts/* build/$(VERSION)/ui/scripts/
	cp scripts/* build/$(VERSION)/hadoop/scripts/
	docker run --rm -i -v $(PWD)/dockerfile/Dockerfile.ui.template.erb:/Dockerfile.erb:ro \
		ruby:alpine erb -U -T - \
			version='$(VERSION)' \
			base_image='$(BASE_IMAGE)' \
			tomcat_version='$(TOMCAT_VERSION)' \
		/Dockerfile.erb > build/$(VERSION)/ui/Dockerfile

	docker run --rm -i -v $(PWD)/dockerfile/Dockerfile.hadoop.template.erb:/Dockerfile.erb:ro \
		ruby:alpine erb -U -T - \
			version='$(VERSION)' \
			base_image='$(BASE_IMAGE)' \
		/Dockerfile.erb > build/$(VERSION)/hadoop/Dockerfile
    
dockerfile-all:
	(set -e ; $(foreach ver, $(ALL_VERSIONS), \
		make dockerfile \
			VERSION=$(ver) ; \
	))

example:
	mkdir -p examples/$(VERSION)/basic
	cp env/tez.env examples/$(VERSION)/basic/tez.env
	docker run --rm -i -v $(PWD)/docker-compose/docker-compose.yml.erb:/docker-compose.yml.erb:ro \
		ruby:alpine erb -U -T - \
			version='$(VERSION)' \
		/docker-compose.yml.erb > examples/$(VERSION)/basic/docker-compose.yml

example-hadoop:
	mkdir -p examples/$(VERSION)/hadoop
	cp env/tez.env examples/$(VERSION)/hadoop/tez.env
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
		--build-arg TEZ_VERSION=$(VERSION) \
		--build-arg TOMCAT_VERSION=$(TOMCAT_VERSION) \
		-t $(UI_IMAGE_NAME):$(VERSION)-$(BUILD_DATE) \
		-t $(UI_IMAGE_NAME):$(VERSION) \
		-t $(UI_IMAGE_NAME):latest \
		build/$(VERSION)/ui
	docker build \
		--build-arg TEZ_VERSION=$(VERSION) \
		-t $(HADOOP_IMAGE_NAME):$(VERSION)-$(BUILD_DATE) \
		-t $(HADOOP_IMAGE_NAME):$(VERSION) \
		-t $(HADOOP_IMAGE_NAME):latest \
		build/$(VERSION)/hadoop

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