#!/usr/bin/env bash

set -eu

rm "bosh-backup-and-restore-meta/${S3_UNVERSIONED_CF_DEPLOYMENT_VARS_FILE}"
rm "bosh-backup-and-restore-meta/${S3_VERSIONED_CF_DEPLOYMENT_VARS_FILE}"
rm "bosh-backup-and-restore-meta/${GCS_CF_DEPLOYMENT_VARS_FILE}"
rm "bosh-backup-and-restore-meta/${AZURE_CF_DEPLOYMENT_VARS_FILE}"

(
  cd bosh-backup-and-restore-meta

  git add "$S3_VERSIONED_CF_DEPLOYMENT_VARS_FILE"
  git add "$S3_UNVERSIONED_CF_DEPLOYMENT_VARS_FILE"
  git add "$GCS_CF_DEPLOYMENT_VARS_FILE"
  git add "$AZURE_CF_DEPLOYMENT_VARS_FILE"

  if git commit -m "Remove cf-deployment vars for external directors"; then
    echo "Remove cf-deployment vars for external directors"
  else
    echo "No change to cf-deployment vars for external directors"
  fi
)

