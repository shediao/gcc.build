#!/usr/bin/env bash

run() { echo "$*"; "$@"; }

script_dir="$(cd "$(dirname "$0")" && pwd)"

cd $script_dir || exit 1

REALY_DOCKER_CMD=docker
if ! which docker &>/dev/null && which podman &>/dev/null; then
  REALY_DOCKER_CMD=podman
fi

container_image="gcc-builder:ubuntu1404"

if [[ -z "$($REALY_DOCKER_CMD images -q "$container_image" 2>/dev/null)" ]]; then
  $REALY_DOCKER_CMD build -t "$container_image" ./ubuntu-14.04/ || exit 1
fi
if [[ -z "$($REALY_DOCKER_CMD images -q "$container_image" 2>/dev/null)" ]]; then
  exit 1
fi

gcc_version=${1}
if [[ -z "$gcc_version" ]]; then
  gcc_version=13.2.0
fi

run rm -rf ./gcc-${gcc_version}_build ./gcc-${gcc_version}_source/

docker_run_options=(-v $script_dir:$script_dir -w $script_dir --user $(id -u):$(id -g) -e USER=$USER -e HOME=$HOME)
if $REALY_DOCKER_CMD --version | grep -q podman || [[ $REALY_DOCKER_CMD == podman ]] ; then
  docker_run_options+=("--userns" "keep-id")
fi
if [[ -n "$http_proxy" ]]; then
  docker_run_options+=( "-e" "http_proxy=$http_proxy")
fi
if [[ -n "$https_proxy" ]]; then
  docker_run_options+=( "-e" "https_proxy=$https_proxy")
fi

run $REALY_DOCKER_CMD run -it --rm "${docker_run_options[@]}" "$container_image" bash ./build_gcc.sh "$gcc_version"
