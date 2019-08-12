#!/usr/bin/env bash
set -euo pipefail

eval "$( ssh-agent )"
ssh-add - <<< "$GITHUB_SSH_KEY"

cd bosh-backup-and-restore
make test
