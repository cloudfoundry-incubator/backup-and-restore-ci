#!/usr/bin/env bash
set -euo pipefail

eval "$( ssh-agent )"
ssh-add - <<< "$GITHUB_SSH_KEY"

export GOPATH="$PWD"
export PATH="${PATH}:${GOPATH}/bin"

cd src/github.com/cloudfoundry-incubator/bosh-backup-and-restore
make test-ci
