#!/usr/bin/env bash

set -euxo pipefail

ROOT_DIR="$PWD"
PIVNET_FOLDER="${ROOT_DIR}/pivnet-release-with-metadata"
REL_PIVNET_FOLDER="pivnet-release-with-metadata"
GITHUB_FOLDER="${ROOT_DIR}/github-release-with-metadata"
REL_GITHUB_FOLDER="github-release-with-metadata"
RELEASE_FOLDER="${ROOT_DIR}/release"
VERSION=$(cat "version-folder/${VERSION_PATH}")

function main {
  create_tarball
  copy_tarball_to_folder "${GITHUB_FOLDER}"
  copy_tarball_to_folder "${PIVNET_FOLDER}"
  delete_sha256_files
  copy_release_files_to_folder "${GITHUB_FOLDER}"
  copy_release_files_to_folder "${PIVNET_FOLDER}"
  export_release_metadata_variables

  erb -T- "template-folder/${TEMPLATE_PATH}" > "${PIVNET_FOLDER}/release.yml"
}

function create_tarball {
  echo "Creating release tarball..."
  export TAR_NAME="bbr-${VERSION}.tar"
  tar -cf "${TAR_NAME}" "${RELEASE_FOLDER}"
}

function copy_tarball_to_folder {
  cp "${TAR_NAME}" "$1"
}

function delete_sha256_files {
  # Why? The previous concourse job has generated shasums for each product,
  # we have bundled this as part of the tar and do no need these extra files.
  rm -f "${RELEASE_FOLDER}/*.sha256"
}

function copy_release_files_to_folder {
  cp -r "${RELEASE_FOLDER}/." "$1"
}

function export_release_metadata_variables {
  export BBR_LINUX_BINARY="${REL_PIVNET_FOLDER}/bbr-${VERSION}-linux-amd64"
  export BBR_DARWIN_BINARY="${REL_PIVNET_FOLDER}/bbr-${VERSION}-darwin-amd64"
  export RELEASE_TAR="${REL_PIVNET_FOLDER}/${TAR_NAME}"
  export BBR_S3_VALIDATOR_BINARY="${REL_PIVNET_FOLDER}/bbr-s3-config-validator-${VERSION}-linux-amd64"
  export BBR_S3_VALIDATOR_README="${REL_PIVNET_FOLDER}/bbr-s3-config-validator-${VERSION}.README.md"
  export VERSION="${VERSION}"
}

main
