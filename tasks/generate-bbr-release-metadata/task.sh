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

export RELEASE_TAR="bbr-${VERSION}.tar"
cp "release/${RELEASE_TAR}" $github_folder/
cp "release/${RELEASE_TAR}" $pivnet_folder/

export LINUX_BINARY=bbr-linux-amd64
create_release_for $LINUX_BINARY

export DARWIN_BINARY=bbr-darwin-amd64
create_release_for $DARWIN_BINARY

erb -T- "template-folder/${TEMPLATE_PATH}" > $pivnet_folder/release.yml
