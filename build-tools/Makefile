ANT_IMAGE_NAME := gudari/ant
GRADLE_IMAGE_NAME := gudari/gradle
MAVEN_IMAGE_NAME := gudari/maven
BASE_IMAGE := gudari/openjdk:8.0.242
BUILD_DATE := `date +"%y.%m.%d"`

ANT_VERSIONS := \
		1.10.7
GRADLE_VERSIONS := \
		4.8 \
		6.2
MAVEN_VERSIONS := \
		3.6.3

dockerfile-ant:
	mkdir -p build/ant/$(ANT_VERSION)
	docker run --rm -i -v $(PWD)/dockerfile/Dockerfile.ant.template.erb:/Dockerfile.erb:ro \
		ruby:alpine erb -U -T - \
			version='$(ANT_VERSION)' \
			base_image='$(BASE_IMAGE)' \
		/Dockerfile.erb > build/ant/$(ANT_VERSION)/Dockerfile
dockerfile-gradle:
	mkdir -p build/gradle/$(GRADLE_VERSION)
	docker run --rm -i -v $(PWD)/dockerfile/Dockerfile.gradle.template.erb:/Dockerfile.erb:ro \
		ruby:alpine erb -U -T - \
			version='$(GRADLE_VERSION)' \
			base_image='$(BASE_IMAGE)' \
		/Dockerfile.erb > build/gradle/$(GRADLE_VERSION)/Dockerfile
dockerfile-maven:
	mkdir -p build/maven/$(MAVEN_VERSION)
	docker run --rm -i -v $(PWD)/dockerfile/Dockerfile.maven.template.erb:/Dockerfile.erb:ro \
		ruby:alpine erb -U -T - \
			version='$(MAVEN_VERSION)' \
			base_image='$(BASE_IMAGE)' \
		/Dockerfile.erb > build/maven/$(MAVEN_VERSION)/Dockerfile
dockerfile-all:
	(set -e ; $(foreach ver, $(ANT_VERSIONS), \
		make dockerfile-ant \
			ANT_VERSION=$(ver) ; \
	))
	(set -e ; $(foreach ver, $(GRADLE_VERSIONS), \
		make dockerfile-gradle \
			GRADLE_VERSION=$(ver) ; \
	))
	(set -e ; $(foreach ver, $(MAVEN_VERSIONS), \
		make dockerfile-maven \
			MAVEN_VERSION=$(ver) ; \
	))

image-ant:
	docker build \
		--build-arg ANT_VERSION=$(ANT_VERSION) \
		-t $(ANT_IMAGE_NAME):$(ANT_VERSION)-$(BUILD_DATE) \
		-t $(ANT_IMAGE_NAME):$(ANT_VERSION) \
		-t $(ANT_IMAGE_NAME):latest \
		build/ant/$(ANT_VERSION)

image-gradle:
	docker build \
		--build-arg GRADLE_VERSION=$(GRADLE_VERSION) \
		-t $(GRADLE_IMAGE_NAME):$(GRADLE_VERSION)-$(BUILD_DATE) \
		-t $(GRADLE_IMAGE_NAME):$(GRADLE_VERSION) \
		-t $(GRADLE_IMAGE_NAME):latest \
		build/gradle/$(GRADLE_VERSION)

image-maven:
	docker build \
		--build-arg MAVEN_VERSION=$(MAVEN_VERSION) \
		-t $(MAVEN_IMAGE_NAME):$(MAVEN_VERSION)-$(BUILD_DATE) \
		-t $(MAVEN_IMAGE_NAME):$(MAVEN_VERSION) \
		-t $(MAVEN_IMAGE_NAME):latest \
		build/maven/$(MAVEN_VERSION)

image-all:
	(set -e ; $(foreach ver, $(ANT_VERSIONS), \
		make image-ant \
			ANT_VERSION=$(ver) ; \
	))
	(set -e ; $(foreach ver, $(GRADLE_VERSIONS), \
		make image-gradle \
			GRADLE_VERSION=$(ver) ; \
	))
	(set -e ; $(foreach ver, $(MAVEN_VERSIONS), \
		make image-maven \
			MAVEN_VERSION=$(ver) ; \
	))

build-ant : dockerfile-ant image-ant

build-gradle : dockerfile-gradle image-gradle

build-maven : dockerfile-maven image-maven

build-all:
	(set -e ; $(foreach ver,$(ANT_VERSIONS), \
		make build-ant \
			ANT_VERSION=$(ver) ; \
	))

	(set -e ; $(foreach ver,$(GRADLE_VERSIONS), \
		make build-gradle \
			GRADLE_VERSION=$(ver) ; \
	))
	(set -e ; $(foreach ver,$(MAVEN_VERSIONS), \
		make build-maven \
			MAVEN_VERSION=$(ver) ; \
	))

push-ant:
	echo "$(DOCKER_PASSWORD)" | docker login -u "$(DOCKER_USERNAME)" --password-stdin
	docker push $(ANT_IMAGE_NAME):$(ANT_VERSION)-$(BUILD_DATE)
	docker push $(ANT_IMAGE_NAME):$(ANT_VERSION)
	docker push $(ANT_IMAGE_NAME):latest

push-gradle:
	echo "$(DOCKER_PASSWORD)" | docker login -u "$(DOCKER_USERNAME)" --password-stdin
	docker push $(GRADLE_IMAGE_NAME):$(GRADLE_VERSION)-$(BUILD_DATE)
	docker push $(GRADLE_IMAGE_NAME):$(GRADLE_VERSION)
	docker push $(GRADLE_IMAGE_NAME):latest

push-maven:
	echo "$(DOCKER_PASSWORD)" | docker login -u "$(DOCKER_USERNAME)" --password-stdin
	docker push $(MAVEN_IMAGE_NAME):$(MAVEN_VERSION)-$(BUILD_DATE)
	docker push $(MAVEN_IMAGE_NAME):$(MAVEN_VERSION)
	docker push $(MAVEN_IMAGE_NAME):latest

push-all:
	(set -e ; $(foreach ver,$(ANT_VERSIONS), \
		make push-ant \
			ANT_VERSION=$(ver)1 ; \
	))
	(set -e ; $(foreach ver,$(GRADLE_VERSIONS), \
		make push-gradle \
			GRADLE_VERSION=$(ver)1 ; \
	))
	(set -e ; $(foreach ver,$(MAVEN_VERSIONS), \
		make push-maven \
			MAVEN_VERSION=$(ver)1 ; \
	))

release-ant: build-ant push-ant

release-gradle: build-gradle push-gradle

release-maven: build-maven push-maven

release-all:
	(set -e ; $(foreach ver,$(ANT_VERSIONS), \
		make release-ant \
			ANT_VERSION=$(ver) ; \
	))

	(set -e ; $(foreach ver,$(GRADLE_VERSIONS), \
		make release-gradle \
			GRADLE_VERSION=$(ver) ; \
	))
	(set -e ; $(foreach ver,$(MAVEN_VERSIONS), \
		make release-maven \
			MAVEN_VERSION=$(ver) ; \
	))

.PHONY: image-ant image-gradle image-maven image-all \
        push-ant push-gradle push-maven push-all \
		build-ant build-gradle build-maven build-all \
        release-ant release-gradle release-maven release-all \
        dockerfile-ant dockerfile-gradle dockerfile-maven dockerfile-all
