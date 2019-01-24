#!/usr/bin/env bash

set -eu

bosh_deployment="bosh-backup-and-restore-meta/maru-lite/bosh-deployment"

bosh interpolate -o "bosh-backup-and-restore-meta/$OPS_FILE_PATH" "$bosh_deployment/gcp/bosh-lite-vm-type.yml" > updated_ops_file
mv updated_ops_file "$bosh_deployment/gcp/bosh-lite-vm-type.yml"

cp -r bosh-backup-and-restore-meta/. updated-meta