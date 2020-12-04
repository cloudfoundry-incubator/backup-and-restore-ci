#!/usr/bin/env bash
set -euo pipefail

get_abs_filename() {
  # $1 : relative filename
  echo "$( cd "$( dirname "$1" )" && pwd )/$( basename "$1" )"
}

export GOPATH; GOPATH="$( get_abs_filename "../${GOPATH}" )"

ssh-keyscan -H 10.10.0.12 >> ~/.ssh/known_hosts

eval "$( ssh-agent )"
ssh-add - <<< "$GITHUB_SSH_KEY"

cd bosh-backup-and-restore
make test
