#!/usr/bin/env bash

set -e

pushd "$(dirname "$0")"
  docker pull ruby:2.2.0
  docker build -t cloudfoundrylondon/cfops-docs .
  docker push cloudfoundrylondon/cfops-docs:latest
popd
