IMAGE_NAME := gudari/hue
BASE_IMAGE := openjdk:11.0.7-jdk-slim-buster
ARM64V8_BASE_IMAGE := arm64v8/openjdk:11.0.7-jdk-slim-buster
BUILD_DATE := `date +"%y.%m.%d"`
HADOOP_VERSION := 2.10.0
MARIADB_VERSION := 10.5.3
POSTGRES_VERSION := 12.3

ALL_VERSIONS := \
		4.6.0 \
		4.7.1

dockerfile:
	mkdir -p build/$(VERSION)/scripts
	mkdir -p build/$(VERSION)/templates
	cp scripts/* build/$(VERSION)/scripts/
	cp templates/hue.ini.$(VERSION).jinja2 build/$(VERSION)/templates/hue.ini.jinja2
	docker run --rm -i -v $(PWD)/Dockerfile.template.amd64.erb:/Dockerfile.erb:ro \
		ruby:alpine erb -U -T - \
			version='$(VERSION)' \
			base_image='$(BASE_IMAGE)' \
		/Dockerfile.erb > build/$(VERSION)/Dockerfile

dockerfile-arm64v8:
	mkdir -p build-arm64v8/$(VERSION)/scripts
	mkdir -p build-arm64v8/$(VERSION)/templates
	cp scripts/* build-arm64v8/$(VERSION)/scripts/
	cp templates/hue.ini.$(VERSION).jinja2 build-arm64v8/$(VERSION)/templates/hue.ini.jinja2
	docker run --rm -i -v $(PWD)/Dockerfile.template.arm64v8.erb:/Dockerfile.erb:ro \
		ruby:alpine erb -U -T - \
			version='$(VERSION)' \
			base_image='$(ARM64V8_BASE_IMAGE)' \
		/Dockerfile.erb > build-arm64v8/$(VERSION)/Dockerfile
    
dockerfile-all:
	(set -e ; $(foreach ver, $(ALL_VERSIONS), \
		make dockerfile \
			VERSION=$(ver) ; \
	))
	(set -e ; $(foreach ver, $(ALL_VERSIONS), \
		make dockerfile-arm64v8 \
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

example-mariadb:
	mkdir -p examples/$(VERSION)/mariadb
	cp env/hue-mariadb.env examples/$(VERSION)/mariadb/hue-mariadb.env
	cp env/mariadb.env examples/$(VERSION)/mariadb/mariadb.env
	docker run --rm -i -v $(PWD)/docker-compose/docker-compose.mariadb.yml.erb:/docker-compose.yml.erb:ro \
		ruby:alpine erb -U -T - \
			version='$(VERSION)' \
			mariadb_version='$(MARIADB_VERSION)' \
		/docker-compose.yml.erb > examples/$(VERSION)/mariadb/docker-compose.yml

example-postgres:
	mkdir -p examples/$(VERSION)/postgres
	cp env/hue-postgres.env examples/$(VERSION)/postgres/hue-postgres.env
	cp env/postgres.env examples/$(VERSION)/postgres/postgres.env
	docker run --rm -i -v $(PWD)/docker-compose/docker-compose.postgres.yml.erb:/docker-compose.yml.erb:ro \
		ruby:alpine erb -U -T - \
			version='$(VERSION)' \
			postgres_version='$(POSTGRES_VERSION)' \
		/docker-compose.yml.erb > examples/$(VERSION)/postgres/docker-compose.yml

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
		make example-mariadb \
			VERSION=$(ver) ; \
	))
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make example-postgres \
			VERSION=$(ver) ; \
	))

src: dockerfile example example-hadoop example-mariadb example-postgres

src-arm64v8: dockerfile-arm64v8

src-all:
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make src \
			VERSION=$(ver) ; \
	))
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make src-arm64v8 \
			VERSION=$(ver) ; \
	))

image:
	docker build \
		--build-arg HUE_VERSION=$(VERSION) \
		-t $(IMAGE_NAME):$(VERSION)-$(BUILD_DATE) \
		-t $(IMAGE_NAME):$(VERSION) \
		-t $(IMAGE_NAME):latest \
		build/$(VERSION)
image-arm64v8:
	docker build \
		--build-arg HUE_VERSION=$(VERSION) \
		-t $(IMAGE_NAME):$(VERSION)-arm64v8-$(BUILD_DATE) \
		-t $(IMAGE_NAME):$(VERSION)-arm64v8 \
		build-arm64v8/$(VERSION)

image-all:
	(set -e ; $(foreach ver, $(ALL_VERSIONS), \
		make image \
			VERSION=$(ver) ; \
	))
	(set -e ; $(foreach ver, $(ALL_VERSIONS), \
		make image-arm64v8 \
			VERSION=$(ver) ; \
	))

build: src image
build-arm64v8: src-arm64v8 image-arm64v8

build-all:
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make build \
			VERSION=$(ver) ; \
	))
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make build-arm64v8 \
			VERSION=$(ver) ; \
	))

push:
	echo "$(DOCKER_PASSWORD)" | docker login -u "$(DOCKER_USERNAME)" --password-stdin
	docker push $(IMAGE_NAME):$(VERSION)-$(BUILD_DATE)
	docker push $(IMAGE_NAME):$(VERSION)
	docker push $(IMAGE_NAME):latest

push-arm64v8:
	echo "$(DOCKER_PASSWORD)" | docker login -u "$(DOCKER_USERNAME)" --password-stdin
	docker push $(IMAGE_NAME):$(VERSION)-arm64v8-$(BUILD_DATE)
	docker push $(IMAGE_NAME):$(VERSION)-arm64v8

push-all:
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make push \
			VERSION=$(ver) ; \
	))
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make push-arm64v8 \
			VERSION=$(ver) ; \
	))

release: build push

release-arm64v8: build-arm64v8 push-arm64v8

release-all:
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make release \
			VERSION=$(ver) ; \
	))
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make release-arm64v8 \
			VERSION=$(ver) ; \
	))

.PHONY: image image-all \
        push push-all \
		build build-all \
        release release-all \
        src src-all \
        dockerfile dockerfile-all \
		example example-all