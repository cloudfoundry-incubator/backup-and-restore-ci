#!/bin/bash

set -eu
set -o pipefail

# Add GitHub SSH key to avoid rate-limit
eval "$(ssh-agent)"
chmod 400 bosh-backup-and-restore-meta/keys/github
ssh-add bosh-backup-and-restore-meta/keys/github

# Get BOSH Director SSH key from CredHub
director_ssh_key="$(credhub find -n "$BOSH_DEPLOYMENT/jumpbox_ssh" --output-json \
 | jq -r .credentials[0].name \
 | xargs credhub get --output-json -n \
 | jq -r .value.private_key)"

DIRECTOR_SSH_KEY_PATH="$(mktemp)"
echo -e "${director_ssh_key}" > "$DIRECTOR_SSH_KEY_PATH"
chmod 0600 "$DIRECTOR_SSH_KEY_PATH"
export DIRECTOR_SSH_KEY_PATH

# Set BOSH_ALL_PROXY to run bbr through SSH tunnel
jumpbox_private_key_path="$(mktemp)"
echo -e "${JUMPBOX_PRIVATE_KEY}" > "$jumpbox_private_key_path"
chmod 0600 "$jumpbox_private_key_path"

export BOSH_ALL_PROXY="ssh+socks5://${JUMPBOX_USER}@${JUMPBOX_HOST}?private-key=${jumpbox_private_key_path}"

# Set up GOPATH
export GOPATH=$PWD
export PATH=$PATH:$GOPATH/bin

cd src/github.com/cloudfoundry-incubator/bosh-backup-and-restore
make sys-test-director-ci
