set -ex
# SET THE FOLLOWING VARIABLES
# docker hub username
USERNAME=gudari
# image name
IMAGE=cruise-control

version=`cat VERSION`
buildDate=`date +"%y.%m.%d"`

docker build \
  --build-arg CRUISE_CONTROL_VERSION=$version \
  -t $USERNAME/$IMAGE:$version-$buildDate \
  -t $USERNAME/$IMAGE:$version \
  -t $USERNAME/$IMAGE:latest .
