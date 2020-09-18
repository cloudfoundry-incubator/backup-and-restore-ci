#!/usr/bin/env bash

set -euxo pipefail

bbr_build="$PWD/bbr-build"

pushd "bbr-s3-config-validator-artifact"
  tar -xf *.tgz
  mv $(ls | grep -v '\.tgz$') $bbr_build
popd
