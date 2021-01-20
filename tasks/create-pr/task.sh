#!/usr/bin/env bash

set -euo pipefail

pushd repo
  gh auth login --with-token < <(echo $GITHUB_TOKEN)
  gh pr create --fill --base $BASE
popd
