#!/usr/bin/env bash

set -e

eval "$(bbl print-env --state-dir bbl-state/${BBL_STATE_DIR})"
bosh cloud-config > cloud-config.yml
bosh update-cloud-config -o "ops-files/${OPS_FILE_PATH}" -n cloud-config.yml
