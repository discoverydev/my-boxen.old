# add the following exports to your xyz-vm.sh script
# and override any of the defaults below with an environment variable export
#
# export DOCKER_IMAGE=busybox
#
# optional:
# export DOCKER_CONTAINER_DATA_DIR=/var/xyz
# export DOCKER_CONTAINER_PUBLISH="--publish=8080:8080"
# export DOCKER_CONTAINER_ENV="--env XYZ=abc"

: ${DOCKER_CONTAINER="$DOCKER_IMAGE"}
: ${DOCKER_CONTAINER_HOSTS="--add-host jenkins:192.168.8.31 --add-host stash:192.168.8.31 --add-host nexus:192.168.8.31 --add-host confluence:192.168.8.34"}

: ${DOCKER_HOST_DATA_ROOT="/Users/Shared/data"}
: ${DOCKER_HOST_DATA_DIR="$DOCKER_HOST_DATA_ROOT/$DOCKER_CONTAINER"}

: ${DOCKER_VM_NAME=$DOCKER_CONTAINER-vm}
: ${DOCKER_VM_MEMORY=2048}
: ${DOCKER_VM_CPUS=2}
: ${DOCKER_VM_USER=ga-mlsdiscovery}
: ${DOCKER_HOST=tcp://192.168.99.100:2376}
: ${DOCKER_MACHINE_NAME=default}
: ${DOCKER_TLS_VERIFY=1}
: ${DOCKER_CERT_PATH=/Users/ga-mlsdiscovery/.docker/machine/machines/$DOCKER_MACHINE_NAME}
