#!/usr/bin/env bash
set -euo pipefail

if [ -z "${BBL_STATE:=}" ]; then 2>&1 echo "BBL_STATE must be provided"; fi

function get_ip_port() {
  grep -o "\d\{1,\}\.\d\{1,\}\.\d\{1,\}\.\d\{1,\}:\d\{1,\}" <<< "$1"
}

eval "$( bbl --state-dir "bosh-backup-and-restore-meta/$BBL_STATE" print-env )"

cat > source-file/source-file.json <<EOF
{
  "jumpbox_username": "jumpbox",
  "jumpbox_ssh_key": "$( awk '{printf "%s\\n", $0}' "${JUMPBOX_PRIVATE_KEY}" )",
  "jumpbox_url": "$( get_ip_port "$BOSH_ALL_PROXY" )",
  "target": "${BOSH_ENVIRONMENT}",
  "client": "${BOSH_CLIENT}",
  "client_secret": "${BOSH_CLIENT_SECRET}",
  "cert": "$( awk '{printf "%s\\n", $0}' <<< "${BOSH_CA_CERT}" )"
}
EOF
