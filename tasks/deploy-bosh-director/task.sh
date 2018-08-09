#!/usr/bin/env bash

set -eu

TEST_RELEASE_PATH=$(readlink -f dummy-bbr-script-release-bucket/test-bosh-backup-and-restore-release-*.tgz)

bosh-cli create-env \
  "bosh-backup-and-restore-meta/${DIRECTOR_ENV}/bosh.yml" \
  --var=test-release-path="file://${TEST_RELEASE_PATH}" \
  --vars-store="bosh-backup-and-restore-meta/${DIRECTOR_ENV}/creds.yml"

pushd bosh-backup-and-restore-meta
  git add "${DIRECTOR_ENV}/bosh-state.json"

  if [ -f "${DIRECTOR_ENV}/creds.yml" ]; then
    git add "${DIRECTOR_ENV}/creds.yml"
  fi

  git config --global user.name "PCF Backup & Restore CI"
  git config --global user.email "cf-lazarus@pivotal.io"

  if git commit -m "Update bosh state for ${DIRECTOR_ENV} director" ; then
    echo "Updated bosh state for ${DIRECTOR_ENV} director"
  else
    echo "No change in bosh state for ${DIRECTOR_ENV} director"
  fi
popd

cp -r bosh-backup-and-restore-meta/. bosh-backup-and-restore-meta-updated/
