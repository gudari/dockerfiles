IMAGE_NAME := gudari/openjdk
BASE_IMAGE := debian:10.4-slim
BUILD_DATE := `date +"%y.%m.%d"`

ALL_VERSIONS := \
		8.46.0.19-ca-8.0.252 \
		11.39.15-ca-11.0.7

dockerfile:
	mkdir -p build/$(JAVA_VERSION)
	docker run --rm -i -v $(PWD)/Dockerfile.template.erb:/Dockerfile.erb:ro \
		ruby:alpine erb -U -T 0 \
			java_version='$(JAVA_VERSION)' \
			zulu_version='$(ZULU_VERSION)' \
			base_image='$(BASE_IMAGE)' \
		/Dockerfile.erb > build/$(JAVA_VERSION)/Dockerfile

dockerfile-all:
	(set -e ; $(foreach ver, $(ALL_VERSIONS), \
		make dockerfile \
			JAVA_VERSION=$(word 3,$(subst -, ,$(ver))) \
			ZULU_VERSION=$(word 1,$(subst -, ,$(ver))) ; \
	))

image:
	docker build \
		--build-arg JAVA_VERSION=$(JAVA_VERSION) \
		--build-arg ZULU_VERSION=$(ZULU_VERSION) \
		-t $(IMAGE_NAME):$(JAVA_VERSION)-$(BUILD_DATE) \
		-t $(IMAGE_NAME):$(JAVA_VERSION) \
		-t $(IMAGE_NAME):latest \
		build/$(JAVA_VERSION)

image-all:
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make image \
			JAVA_VERSION=$(word 3,$(subst -, ,$(ver)))  \
			ZULU_VERSION=$(word 1,$(subst -, ,$(ver))) ; \
	))

build: dockerfile image

build-all:
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make build \
			JAVA_VERSION=$(word 3,$(subst -, ,$(ver)))  \
			ZULU_VERSION=$(word 1,$(subst -, ,$(ver))) ; \
	))

push:
	echo "$(DOCKER_PASSWORD)" | docker login -u "$(DOCKER_USERNAME)" --password-stdin
	docker push $(IMAGE_NAME):$(JAVA_VERSION)-$(BUILD_DATE)
	docker push $(IMAGE_NAME):$(JAVA_VERSION)
	docker push $(IMAGE_NAME):latest

push-all:
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make push \
			JAVA_VERSION=$(word 3,$(subst -, ,$(ver))) ; \
	))

release: build push

release-all:
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make release \
			JAVA_VERSION=$(word 3,$(subst -, ,$(ver)))  \
			ZULU_VERSION=$(word 1,$(subst -, ,$(ver))) ; \
	))

.PHONY: image image-all \
        push push-all \
		build build-all \
        release release-all \
        src src-all \
        dockerfile dockerfile-all
