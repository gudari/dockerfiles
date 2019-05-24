set -ex
# SET THE FOLLOWING VARIABLES
# docker hub username
USERNAME=gudari
# image name
IMAGE=java

version=`cat VERSION`
zulu_version=`cat ZULU_VERSION`

buildDate=`date +"%y.%m.%d"`


docker build \
  --build-arg JAVA_VERSION=$version \
  --build-arg ZULU_VERSION=$zulu_version \
  -t $USERNAME/$IMAGE:$version-$buildDate \
  -t $USERNAME/$IMAGE:$version \
  -t $USERNAME/$IMAGE:latest .
