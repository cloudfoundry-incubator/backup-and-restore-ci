#!/bin/env bash

set -eu

bosh interpolate -o "backup-and-restore-meta/$OPS_FILE_PATH" "bosh-deployment/gcp/bosh-lite-vm-type.yml" > tmpfile

mv tmpfile bosh-deployment/gcp/bosh-lite-vm-type.yml

cp -r bosh-deployment/ updated-bosh-deployment