#!/usr/bin/env bash

set -euo pipefail

PIVNET_FOLDER="pivnet-release-with-metadata"
GITHUB_FOLDER="github-release-with-metadata"

version=$(cat "version-folder/${VERSION_PATH}")
export VERSION="$version"

echo "Creating release tarball..."
release_tar="bbr-${VERSION}.tar"
tar  -cf "${release_tar}" release

cp -r "release/." $GITHUB_FOLDER/
cp -r "release/." $PIVNET_FOLDER/

LINUX_BINARY="bbr-${VERSION}-linux-amd64"
DARWIN_BINARY="bbr-${VERSION}-darwin-amd64"

export BBR_LINUX_BINARY="${PIVNET_FOLDER}/${LINUX_BINARY}"
export BBR_DARWIN_BINARY="${PIVNET_FOLDER}/${DARWIN_BINARY}"
export RELEASE_TAR="${PIVNET_FOLDER}/${release_tar}"
export BBR_S3_VALIDATOR_BINARY="${PIVNET_FOLDER}/bbr-s3-config-validator-${VERSION}-linux-amd64"
export BBR_S3_VALIDATOR_README="${PIVNET_FOLDER}/bbr-s3-config-validator-${VERSION}.README.md"

erb -T- "template-folder/${TEMPLATE_PATH}" > $pivnet_folder/release.yml
