set -ex
# SET THE FOLLOWING VARIABLES
# docker hub username
USERNAME=gudari
# image name
IMAGE=activemq

version=`cat VERSION`

docker build --build-arg ACTIVEMQ_VERSION=$version -t $USERNAME/$IMAGE:$version -t $USERNAME/$IMAGE:latest .