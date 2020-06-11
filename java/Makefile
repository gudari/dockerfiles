IMAGE_NAME := gudari/openjdk
BASE_IMAGE := debian:10.4-slim
ARM_BASE_IMAGE := arm64v8/debian:10.4-slim
BUILD_DATE := `date +"%y.%m.%d"`

ALL_VERSIONS := \
		8.46.0.19-ca-8.0.252 \
		11.39.15-ca-11.0.7
ALL_ARM64V8_VERSIONS := \
		8.46.0.225-ca-8.0.252 \
		11.39.61-ca-11.0.7

dockerfile:
	mkdir -p build/$(JAVA_VERSION)
	docker run --rm -i -v $(PWD)/Dockerfile.template.amd64.erb:/Dockerfile.erb:ro \
		ruby:alpine erb -U -T 0 \
			java_version='$(JAVA_VERSION)' \
			zulu_version='$(ZULU_VERSION)' \
			base_image='$(BASE_IMAGE)' \
		/Dockerfile.erb > build/$(JAVA_VERSION)/Dockerfile
dockerfile-arm64v8:
	mkdir -p build-arm64v8/$(JAVA_VERSION)
	docker run --rm -i -v $(PWD)/Dockerfile.template.arm64v8.erb:/Dockerfile.erb:ro \
		ruby:alpine erb -U -T 0 \
			java_version='$(JAVA_VERSION)' \
			zulu_version='$(ZULU_VERSION)' \
			base_image='$(ARM_BASE_IMAGE)' \
		/Dockerfile.erb > build-arm64v8/$(JAVA_VERSION)/Dockerfile

dockerfile-all:
	(set -e ; $(foreach ver, $(ALL_VERSIONS), \
		make dockerfile \
			JAVA_VERSION=$(word 3,$(subst -, ,$(ver))) \
			ZULU_VERSION=$(word 1,$(subst -, ,$(ver))) ; \
	))
	(set -e ; $(foreach ver, $(ALL_ARM64V8_VERSIONS), \
		make dockerfile-arm64v8 \
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
image-arm64v8:
	docker build \
		--build-arg JAVA_VERSION=$(JAVA_VERSION) \
		--build-arg ZULU_VERSION=$(ZULU_VERSION) \
		-t $(IMAGE_NAME):$(JAVA_VERSION)-arm64v8-$(BUILD_DATE) \
		-t $(IMAGE_NAME):$(JAVA_VERSION)-arm64v8 \
		build-arm64v8/$(JAVA_VERSION)

image-all:
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make image \
			JAVA_VERSION=$(word 3,$(subst -, ,$(ver)))  \
			ZULU_VERSION=$(word 1,$(subst -, ,$(ver))) ; \
	))
	(set -e ; $(foreach ver,$(ALL_ARM64V8_VERSIONS), \
		make image-arm64v8 \
			JAVA_VERSION=$(word 3,$(subst -, ,$(ver)))  \
			ZULU_VERSION=$(word 1,$(subst -, ,$(ver))) ; \
	))

build: dockerfile image

build-arm64v8: dockerfile-arm64v8 image-arm64v8

build-all:
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make build \
			JAVA_VERSION=$(word 3,$(subst -, ,$(ver)))  \
			ZULU_VERSION=$(word 1,$(subst -, ,$(ver))) ; \
	))

	(set -e ; $(foreach ver,$(ALL_ARM64V8_VERSIONS), \
		make build-arm64v8 \
			JAVA_VERSION=$(word 3,$(subst -, ,$(ver)))  \
			ZULU_VERSION=$(word 1,$(subst -, ,$(ver))) ; \
	))

push:
	echo "$(DOCKER_PASSWORD)" | docker login -u "$(DOCKER_USERNAME)" --password-stdin
	docker push $(IMAGE_NAME):$(JAVA_VERSION)-$(BUILD_DATE)
	docker push $(IMAGE_NAME):$(JAVA_VERSION)
	docker push $(IMAGE_NAME):latest

push-arm64v8:
	echo "$(DOCKER_PASSWORD)" | docker login -u "$(DOCKER_USERNAME)" --password-stdin
	docker push $(IMAGE_NAME):$(JAVA_VERSION)-arm64v8-$(BUILD_DATE)
	docker push $(IMAGE_NAME):$(JAVA_VERSION)-arm64v8

push-all:
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make push \
			JAVA_VERSION=$(word 3,$(subst -, ,$(ver))) ; \
	))
	(set -e ; $(foreach ver,$(ALL_ARM64V8_VERSIONS), \
		make push-arm64v8 \
			JAVA_VERSION=$(word 3,$(subst -, ,$(ver))) ; \
	))

release: build push

release-arm64v8: build-arm64v8 push-arm64v8

release-all:
	(set -e ; $(foreach ver,$(ALL_VERSIONS), \
		make release \
			JAVA_VERSION=$(word 3,$(subst -, ,$(ver)))  \
			ZULU_VERSION=$(word 1,$(subst -, ,$(ver))) ; \
	))

	(set -e ; $(foreach ver,$(ALL_ARM64V8_VERSIONS), \
		make release-arm64v8 \
			JAVA_VERSION=$(word 3,$(subst -, ,$(ver)))  \
			ZULU_VERSION=$(word 1,$(subst -, ,$(ver))) ; \
	))

.PHONY: image image-arm64v8 image-all \
        push push-arm64v8 push-all \
		build build-arm64v8 build-all \
        release release-arm64v8 rele1ase-all \
        dockerfile dockerfile-arm64v8 dockerfile-all
