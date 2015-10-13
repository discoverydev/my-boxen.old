#!/usr/bin/env bash
: ${DOCKER_IMAGE=busybox}
source docker-vm_lib.sh
_setupvm() { :; }
for arg in "$@"; do $arg; done
