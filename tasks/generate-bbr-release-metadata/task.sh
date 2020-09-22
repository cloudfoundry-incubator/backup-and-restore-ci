#!/usr/bin/env bash

set -eu
set -o pipefail

pivnet_folder="pivnet-release-with-metadata"
github_folder="github-release-with-metadata"

function create_release_for {
  cp release/"$1"* $github_folder/
  cp release/"$1" $pivnet_folder/
}

version=$(cat "version-folder/${VERSION_PATH}")
export VERSION="$version"

release_tar="bbr-${VERSION}.tar"
cp "release/${release_tar}" $github_folder/
cp "release/${release_tar}" $pivnet_folder/

linux_binary="bbr-${VERSION}-linux-amd64"
create_release_for "$linux_binary"

darwin_binary="bbr-${VERSION}-darwin-amd64"
create_release_for "$darwin_binary"

#Add BBR s3 Validator
cp "release/bbr-s3-config-validator"* $github_folder

export LINUX_BINARY="${pivnet_folder}/${linux_binary}"
export DARWIN_BINARY="${pivnet_folder}/${darwin_binary}"
export RELEASE_TAR="${pivnet_folder}/${release_tar}"

erb -T- "template-folder/${TEMPLATE_PATH}" > $pivnet_folder/release.yml
