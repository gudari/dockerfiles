set -ex

# docker hub username
USERNAME=gudari
# image name
IMAGE=zookeeper-rest

version=`cat VERSION`
buildDate=`date +"%y.%m.%d"`

# login dockerhub

echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

# push it
docker push $USERNAME/$IMAGE:latest
docker push $USERNAME/$IMAGE:$version
docker push $USERNAME/$IMAGE:$version-$buildDate
