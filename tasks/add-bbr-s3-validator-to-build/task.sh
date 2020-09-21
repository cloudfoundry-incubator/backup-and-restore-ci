#!/usr/bin/env bash

set -euxo pipefail

bbr_build="$PWD/bbr-build"

pushd "bbr-s3-config-validator-artifact"
  tar -xf *.tgz
  cp README.md $bbr_build
  cp bbr-s3-config-validator-* $bbr_build
popd
