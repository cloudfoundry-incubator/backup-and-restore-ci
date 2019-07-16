#!/usr/bin/env bash

set -eu

wget "$RDS_CA_BUNDLE_URL" -O "bosh-backup-and-restore-meta/$RDS_CA_BUNDLE_PATH"

(
  cd bosh-backup-and-restore-meta

  git add "$RDS_CA_BUNDLE_PATH"

  if git commit -m "Update rds ca bundle"; then
    echo "Update rds ca bundle"
  else
    echo "There is no update in the rds ca bundle"
  fi
)

