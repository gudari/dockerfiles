set -ex
# SET THE FOLLOWING VARIABLES
# docker hub username
USERNAME=gudari
# image name
IMAGE=kafka-manager

version=`cat VERSION`
buildDate=`date +"%y.%m.%d"`

docker build \
  --build-arg KAFKAMANAGER_VERSION=$version \
  -t $USERNAME/$IMAGE:$version-$buildDate \
  -t $USERNAME/$IMAGE:$version \
  -t $USERNAME/$IMAGE:latest .
