set -ex

# docker hub username
USERNAME=gudari
# image name
IMAGE=h3o

version=`cat VERSION`
buildDate=`date +"%y.%m.%d"`

docker build \
    --build-arg H2O_VERSION=$version \
    -t $USERNAME/$IMAGE:$version-$buildDate \
    -t $USERNAME/$IMAGE:$version \
    -t $USERNAME/$IMAGE:latest .