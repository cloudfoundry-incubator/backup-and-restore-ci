#!/usr/bin/env bash

set -euo pipefail

pushd repo
  has_changes=$(git log HEAD..origin/HEAD)

  echo "Running: git log HEAD..origin/HEAD"
  echo "Changes are:"
  echo "$has_changes"

  if [[ -z "$has_changes" ]]; then
    echo "There are no changes to publish in a new release!"
    exit 1
  fi
popd
