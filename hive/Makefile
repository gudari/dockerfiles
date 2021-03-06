IMAGE_NAME := gudari/hive
BASE_IMAGE := gudari/hadoop:2.10.0
BUILD_DATE := `date +"%y.%m.%d"`
HADOOP_VERSION := 2.10.0
HUE_VERSION := 4.7.0
OOZIE_VERSION := 5.2.0

ALL_VERSIONS := \
		1.2.2 \
		2.3.7 \
		3.1.2

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
		--build-arg HIVE_VERSION=$(VERSION) \
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
	cp env/mysql.env examples/base/$(VERSION)/mysql.env
	cp env/hive.env examples/base/$(VERSION)/hive.env
	docker run --rm -i -v $(PWD)/docker-compose/docker-compose.yml.erb:/docker-compose.yml.erb:ro \
		ruby:alpine erb -U -T - \
			version='$(VERSION)' \
			hadoop_version='$(HADOOP_VERSION)' \
		/docker-compose.yml.erb > examples/base/$(VERSION)/docker-compose.yml

example-oozie:
	mkdir -p examples/oozie/$(VERSION)
	cp env/hadoop.env examples/oozie/$(VERSION)/hadoop.env
	cp env/mysql.env examples/oozie/$(VERSION)/mysql.env
	cp env/hive.env examples/oozie/$(VERSION)/hive.env
	cp env/oozie.env examples/oozie/$(VERSION)/oozie.env
	docker run --rm -i -v $(PWD)/docker-compose/docker-compose.oozie.yml.erb:/docker-compose.yml.erb:ro \
		ruby:alpine erb -U -T - \
			version='$(VERSION)' \
			hadoop_version='$(HADOOP_VERSION)' \
			oozie_version='$(OOZIE_VERSION)' \
		/docker-compose.yml.erb > examples/oozie/$(VERSION)/docker-compose.yml

example-hue:
	mkdir -p examples/hue/$(VERSION)
	cp env/hadoop.env examples/hue/$(VERSION)/hadoop.env
	cp env/mysql.env examples/hue/$(VERSION)/mysql.env
	cp env/hive.env examples/hue/$(VERSION)/hive.env
	cp env/oozie.env examples/hue/$(VERSION)/oozie.env
	cp env/hue.env examples/hue/$(VERSION)/hue.env
	docker run --rm -i -v $(PWD)/docker-compose/docker-compose.hue.yml.erb:/docker-compose.yml.erb:ro \
		ruby:alpine erb -U -T - \
			version='$(VERSION)' \
			hadoop_version='$(HADOOP_VERSION)' \
			oozie_version='$(OOZIE_VERSION)' \
			hue_version='$(HUE_VERSION)' \
		/docker-compose.yml.erb > examples/hue/$(VERSION)/docker-compose.yml

example-all:
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make example \
			VERSION=$(ver) ; \
	))
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make example-oozie \
			VERSION=$(ver) ; \
	))
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make example-hue \
			VERSION=$(ver) ; \
	))

src: dockerfile example example-oozie example-hue

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
