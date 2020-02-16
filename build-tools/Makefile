ANT_IMAGE_NAME := gudari/ant
BASE_IMAGE := gudari/openjdk:8.0.242
BUILD_DATE := `date +"%y.%m.%d"`

ANT_VERSIONS := \
		1.10.7

dockerfile:
	mkdir -p build/ant/$(ANT_VERSION)
	docker run --rm -i -v $(PWD)/dockerfile/Dockerfile.ant.template.erb:/Dockerfile.erb:ro \
		ruby:alpine erb -U -T - \
			version='$(ANT_VERSION)' \
			base_image='$(BASE_IMAGE)' \
		/Dockerfile.erb > build/ant/$(ANT_VERSION)/Dockerfile
dockerfile-all:
	(set -e ; $(foreach ver, $(ANT_VERSIONS), \
		make dockerfile \
			ANT_VERSION=$(ver) ; \
	))

src: dockerfile

src-all:
	(set -e ; $(foreach ver,$(ANT_VERSIONS), \
		make src \
			ANT_VERSION=$(ver) ; \
	))

image:
	docker build \
		--build-arg ANT_VERSION=$(ANT_VERSION) \
		-t $(ANT_IMAGE_NAME):$(ANT_VERSION)-$(BUILD_DATE) \
		-t $(ANT_IMAGE_NAME):$(ANT_VERSION) \
		-t $(ANT_IMAGE_NAME):latest \
		build/ant/$(ANT_VERSION)

image-all:
	(set -e ; $(foreach ver, $(ANT_VERSIONS), \
		make image \
			ANT_VERSION=$(ver) ; \
	))

build: src image

build-all:
	(set -e ; $(foreach ver,$(ANT_VERSIONS), \
		make build \
			ANT_VERSION=$(ver) ; \
	))

push:
	echo "$(DOCKER_PASSWORD)" | docker login -u "$(DOCKER_USERNAME)" --password-stdin
	docker push $(ANT_IMAGE_NAME):$(ANT_VERSION)-$(BUILD_DATE)
	docker push $(ANT_IMAGE_NAME):$(ANT_VERSION)
	docker push $(ANT_IMAGE_NAME):latest

push-all:
	(set -e ; $(foreach ver,$(ANT_VERSIONS), \
		make push \
			ANT_VERSION=$(ver)1 ; \
	))

release: build push

release-all:
	(set -e ; $(foreach ver,$(ANT_VERSIONS), \
		make release \
			ANT_VERSION=$(ver) ; \
	))

.PHONY: image image-all \
        push push-all \
		build build-all \
        release release-all \
        src src-all \
        dockerfile dockerfile-all
