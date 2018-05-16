#!/usr/bin/env bash

set -e

pushd "bbl-state/${BBL_STATE_DIR}"
  eval "$(bbl print-env)"

  for name in ${ERRAND_NAMES}; do
    bosh -d cf run-errand "$name"
  done
popd
