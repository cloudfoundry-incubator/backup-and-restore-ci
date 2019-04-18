#!/bin/bash

set -eu

eval "$(ssh-agent)"

echo -e "${BOSH_GW_PRIVATE_KEY}" > "${PWD}/ssh.key"
chmod 0600 "${PWD}/ssh.key"
export BOSH_GW_PRIVATE_KEY="${PWD}/ssh.key"
export BOSH_ALL_PROXY="ssh+socks5://${BOSH_GW_USER}@${BOSH_GW_HOST}?private-key=${BOSH_GW_PRIVATE_KEY}"

bosh --non-interactive \
  --deployment "${DEPLOYMENT_NAME}" \
  deploy "bosh-backup-and-restore/fixtures/redis-maru-lite.yml" \
  --var=deployment-name="${DEPLOYMENT_NAME}"
