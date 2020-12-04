#!/bin/bash

set -eu
set -o pipefail

# Add GitHub SSH key to avoid rate-limit
eval "$(ssh-agent)"
chmod 400 bosh-backup-and-restore-meta/keys/github
ssh-add bosh-backup-and-restore-meta/keys/github

# Write Jumpbox SSH key to file
jumpbox_ssh_key_path="$(mktemp)"
echo -e "${JUMPBOX_SSH_KEY}" > "$jumpbox_ssh_key_path"
chmod 0600 "$jumpbox_ssh_key_path"

DIRECTOR_SSH_KEY_PATH="$(mktemp)"
echo -e "${DIRECTOR_SSH_KEY}" > "$DIRECTOR_SSH_KEY_PATH"
chmod 0600 "$DIRECTOR_SSH_KEY_PATH"
export DIRECTOR_SSH_KEY_PATH

# Create tunnel to Director via Jumpbox
ssh-add "$jumpbox_ssh_key_path"
sshuttle -r "${JUMPBOX_USER}@${JUMPBOX_HOST}" "$DIRECTOR_HOST/32" \
  --daemon \
  -e 'ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ServerAliveInterval=600'
echo "Establishing tunnel to Director via Jumpbox..."
sleep 5

if ! stat sshuttle.pid > /dev/null 2>&1; then
  echo "Failed to start sshuttle daemon"
  exit 1
fi

echo -e "${BOSH_GW_PRIVATE_KEY}" > "${PWD}/ssh.key"
chmod 0600 "${PWD}/ssh.key"
export BOSH_GW_PRIVATE_KEY="${PWD}/ssh.key"
export BOSH_ALL_PROXY="ssh+socks5://${BOSH_GW_USER}@${BOSH_GW_HOST}?private-key=${BOSH_GW_PRIVATE_KEY}"

cd bosh-backup-and-restore
make sys-test-director-ci
