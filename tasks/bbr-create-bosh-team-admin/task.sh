#!#!/usr/bin/env bash

set -eu

if [ -z "$JUMPBOX_PRIVATE_KEY" ]; then
  eval "$(ssh-agent)"
  private_key_path="$(mktemp)"
  echo -e "$JUMPBOX_PRIVATE_KEY" > "$private_key_path"
  chmod 0600 "$private_key_path"
  ssh-add "$private_key_path"

  sshuttle -r "${JUMPBOX_USER}@${JUMPBOX_HOST}" "$DESTINATION_CIDR" \
    --daemon \
    -e 'ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ServerAliveInterval=600'
  sleep 5
fi

uaac target "$BOSH_ENVIRONMENT:8443" --skip-ssl-validation
uaac token client get "$UAA_CLIENT" --secret "$UAA_CLIENT_SECRET"
uaac client add "$BOSH_TEAM_CLIENT" \
  --authorities "bosh.teams.${BOSH_TEAM_CLIENT}.admin" \
  --authorized_grant_types client_credentials \
  --secret "$BOSH_TEAM_CLIENT_SECRET" \
  --no-interactive