#!/usr/bin/env bash
set -euo pipefail

if [ ! -z "$JUMPBOX_PRIVATE_KEY" ]; then
  eval "$( ssh-agent )"
  ssh-add - <<< "$JUMPBOX_PRIVATE_KEY"

  sshuttle -r "${JUMPBOX_USER}@${JUMPBOX_HOST}" "$DESTINATION_CIDR" \
    --daemon \
    -e 'ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ServerAliveInterval=600'
  echo "Establishing tunnel to Director via Jumpbox..."
  sleep 5

  if ! stat sshuttle.pid > /dev/null 2>&1; then
    echo "Failed to start sshuttle daemon"
    exit 1
  fi
fi

uaac target "${BOSH_ENVIRONMENT}:8443" --skip-ssl-validation
uaac token client get "$UAA_CLIENT" --secret "$UAA_CLIENT_SECRET"

if uaac clients | grep -q "$BOSH_TEAM_CLIENT"; then
  echo "uaa client: ${BOSH_TEAM_CLIENT} already exists"
  exit 0
fi

uaac client add "$BOSH_TEAM_CLIENT" \
  --authorities "bosh.teams.${BOSH_TEAM_CLIENT}.admin" \
  --authorized_grant_types client_credentials \
  --secret "$BOSH_TEAM_CLIENT_SECRET" \
  --no-interactive