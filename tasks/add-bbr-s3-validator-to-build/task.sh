#!/usr/bin/env bash

set -euxo pipefail

bbr_build="$PWD/bbr-build"
bbr_release="$PWD/bbr-release"

bbr_version="$(cat bbr-version/number)"

pushd "bbr-s3-config-validator-artifact"
  tar -xf ./*.tgz

  cp README.md "$bbr_build/bbr-s3-config-validator-$bbr_version.README.md"
  cp bbr-s3-config-validator "$bbr_build/bbr-s3-config-validator-$bbr_version-linux-amd64"
  cp bbr-s3-config-validator.sha256 "$bbr_build/bbr-s3-config-validator-$bbr_version-linux-amd64.sha256"

  echo "$(cat bbr-s3-config-validator.sha256)  bbr-s3-config-validator" >> "$bbr_release/releases/checksum.sha256"
  cp bbr-s3-config-validator "$bbr_release/releases"
  cp README.md "$bbr_release/releases/bbr-s3-config-validator.README.md"

  tar -cvf "bbr-$bbr_version.tar" "$bbr_release/releases/"*
  mv "bbr-$bbr_version.tar" "$bbr_build"
popd
