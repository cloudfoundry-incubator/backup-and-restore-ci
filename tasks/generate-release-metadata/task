#!/usr/bin/env bash

set -eu
set -o pipefail

# shellcheck disable=SC2144
if [ -e release/*.tar ]; then
    cp release/*.tar release-with-metadata/
    release_tar=$(ls release-with-metadata/*.tar)
    export RELEASE_TAR=$release_tar
fi

# shellcheck disable=SC2144
if [ -e release/*.tgz ]; then
    cp release/*.tgz release-with-metadata/
    release_tar=$(ls release-with-metadata/*.tgz)
    export RELEASE_TAR=$release_tar
fi

version=$(cat "version-folder/${VERSION_PATH}")
export VERSION=$version
erb -T- "template-folder/${TEMPLATE_PATH}" > release-with-metadata/release.yml
