#!/usr/bin/env bash

run() { echo "$*"; "$@"; }

script_dir="$(cd "$(dirname "$0")" && pwd)"

cd $script_dir || exit 1

if [[ -z "$(docker images -q "gcc-builder:ubuntu1404" 2>/dev/null)" ]]; then
  docker build -t gcc-builder:ubuntu1404 ./ubuntu-14.04/ || exit 1
fi
if [[ -z "$(docker images -q "gcc-builder:ubuntu1404" 2>/dev/null)" ]]; then
  exit 1
fi

gcc_version=${1}
if [[ -z "$gcc_version" ]]; then
  gcc_version=13.2.0
fi

run rm -rf ./gcc-${gcc_version}_build ./gcc-${gcc_version}_source/
export http_proxy=http://30.210.168.111:8118
export https_proxy=http://30.210.168.111:8118

docker_run_options=(-v $script_dir:$script_dir -w $script_dir --user $(id -u):$(id -g) -e USER=$USER -e HOME=$HOME)
if [[ -n "$http_proxy" ]]; then
  docker_run_options+=( "-e" "http_proxy=$http_proxy")
fi
if [[ -n "$https_proxy" ]]; then
  docker_run_options+=( "-e" "https_proxy=$https_proxy")
fi

run docker run -it --rm "${docker_run_options[@]}" gcc-builder:ubuntu1404 bash ./build_gcc.sh "$gcc_version"
