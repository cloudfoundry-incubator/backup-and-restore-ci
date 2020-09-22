#!/usr/bin/env bash

set -euxo pipefail

bbr_build="$PWD/bbr-build"

bbr_version="$(cat bbr-version/number)"

pushd "bbr-s3-config-validator-artifact"
  tar -xf ./*.tgz

  cp README.md "$bbr_build/bbr-s3-config-validator-$bbr_version.README.md"
  cp bbr-s3-config-validator "$bbr_build/bbr-s3-config-validator-$bbr_version-linux-amd64"
  cp bbr-s3-config-validator.sha256 "$bbr_build/bbr-s3-config-validator-$bbr_version-linux-amd64.sha256"
popd
