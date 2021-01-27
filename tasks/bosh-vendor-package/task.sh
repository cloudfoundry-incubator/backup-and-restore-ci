#!/usr/bin/env bash

set -eu

pushd release
  echo "---
blobstore:
  provider: s3
  options:
    access_key_id: $AWS_ACCESS_KEY_ID
    secret_access_key: $AWS_SECRET_ACCESS_KEY
" > config/private.yml

  bosh vendor-package "${VENDORED_PACKAGE_NAME}" ../vendored-package-release

  git add .
  
  if [ -z "$VENDOR_UPDATES_BRANCH" ]
  then
        curr_branch=$(git rev-parse --abbrev-ref HEAD)
        echo "Pushing vendor updates to the same branch '${curr_branch}'"
  else
        git checkout -b "${VENDOR_UPDATES_BRANCH}"
        echo "Pushing vendor updates to the configured branch '${VENDOR_UPDATES_BRANCH}'"
  fi

  if git commit -m "Update vendored package ${VENDORED_PACKAGE_NAME}"; then
    echo "Updated vendored package ${VENDORED_PACKAGE_NAME}"
  else
    echo "No change to vendored package ${VENDORED_PACKAGE_NAME}"
  fi
popd

cp -r release/. release-with-updated-vendored-package
