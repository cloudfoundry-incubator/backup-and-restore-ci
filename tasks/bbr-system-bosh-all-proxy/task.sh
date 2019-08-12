#!/bin/bash

set -eu

eval "$(ssh-agent)"
chmod 400 bosh-backup-and-restore-meta/keys/github
ssh-add bosh-backup-and-restore-meta/keys/github

jumpbox_private_key_path="$(mktemp)"
echo -e "${BOSH_GW_PRIVATE_KEY}" > "$jumpbox_private_key_path"
chmod 0600 "$jumpbox_private_key_path"
export BOSH_GW_PRIVATE_KEY="$jumpbox_private_key_path"

director_private_key_path="$(mktemp)"
echo -e "${DIRECTOR_SSH_KEY}" > "$director_private_key_path"
chmod 0600 "$director_private_key_path"
export DIRECTOR_SSH_KEY_PATH="$director_private_key_path"

cd bosh-backup-and-restore
make sys-test-bosh-all-proxy-ci
