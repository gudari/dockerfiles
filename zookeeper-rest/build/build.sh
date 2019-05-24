set -ex
# SET THE FOLLOWING VARIABLES
# docker hub username
USERNAME=gudari
# image name
IMAGE=zookeeper-rest

version=`cat VERSION`
buildDate=`date +"%y.%m.%d"`

docker build \
  --build-arg ZOOKEEPER_REST_VERSION=$version \
  -t $USERNAME/$IMAGE:$version-$buildDate \
  -t $USERNAME/$IMAGE:$version \
  -t $USERNAME/$IMAGE:latest .
