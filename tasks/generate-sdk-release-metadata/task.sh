#!/usr/bin/env bash

set -eu
set -o pipefail

cp release/*.tgz release-with-metadata/
release_tar=$(ls release-with-metadata/*.tgz)
export RELEASE_TAR=$release_tar

version=$(cat "version-folder/${VERSION_PATH}")
export VERSION=$version
erb -T- "template-folder/${TEMPLATE_PATH}" > release-with-metadata/release.yml
