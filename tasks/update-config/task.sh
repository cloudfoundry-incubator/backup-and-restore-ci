#!/usr/bin/env bash

set -eu

eval "$(bbl print-env --state-dir "bbl-state/${BBL_STATE_DIR}")"
bosh -n update-config --name "$NAME" --type "$TYPE" "bbl-state/${BBL_STATE_DIR}/${CONFIG_PATH}"
