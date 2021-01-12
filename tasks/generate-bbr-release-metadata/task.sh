#!/usr/bin/env bash

set -euo pipefail

pivnet_folder="pivnet-release-with-metadata"
github_folder="github-release-with-metadata"

function create_release_for {
  cp release/"$1"* $github_folder/
  cp release/"$1" $pivnet_folder/
}

version=$(cat "version-folder/${VERSION_PATH}")
export VERSION="$version"

echo "Creating release tarball..."
release_tar="bbr-${VERSION}.tar"
tar -C release -cf "${release_tar}"

cp "release/${release_tar}" $github_folder/
cp "release/${release_tar}" $pivnet_folder/

linux_binary="bbr-${VERSION}-linux-amd64"
create_release_for "$linux_binary"

darwin_binary="bbr-${VERSION}-darwin-amd64"
create_release_for "$darwin_binary"

cp "release/bbr-s3-config-validator"* $github_folder/
cp "release/bbr-s3-config-validator-${VERSION}-linux-amd64" $pivnet_folder/
cp "release/bbr-s3-config-validator-${VERSION}.README.md" $pivnet_folder/

export BBR_LINUX_BINARY="${pivnet_folder}/${linux_binary}"
export BBR_DARWIN_BINARY="${pivnet_folder}/${darwin_binary}"
export RELEASE_TAR="${pivnet_folder}/${release_tar}"
export BBR_S3_VALIDATOR_BINARY="${pivnet_folder}/bbr-s3-config-validator-${VERSION}-linux-amd64"
export BBR_S3_VALIDATOR_README="${pivnet_folder}/bbr-s3-config-validator-${VERSION}.README.md"

erb -T- "template-folder/${TEMPLATE_PATH}" > $pivnet_folder/release.yml
