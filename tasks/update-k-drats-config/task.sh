#!/usr/bin/env bash

set -eu
set -o pipefail

pushd "bbl-state/$BBL_STATE_DIR"
  eval "$(bbl print-env)"
popd

api_server_ip="$(jq -r .external_ip < terraform/metadata)"
ca_cert="$(bosh int <(credhub get -n "${BOSH_DIRECTOR_NAME}/${BOSH_DEPLOYMENT}/tls-kubernetes" --output-json) --path=/value/ca)"
password="$(bosh int <(credhub get -n "${BOSH_DIRECTOR_NAME}/${BOSH_DEPLOYMENT}/kubo-admin-password" --output-json) --path=/value)"

config="$(cat "k-drats-config/$CONFIG_PATH")"
config=$(echo "$config" | jq ".timeout_in_minutes=${TIMEOUT_IN_MINUTES}")
config=$(echo "$config" | jq ".cluster_name=\"${CLUSTER_NAME}\"")
config=$(echo "$config" | jq ".api_server_url=\"https://${api_server_ip}:8443\"")
config=$(echo "$config" | jq ".ca_cert=\"${ca_cert}\"")
config=$(echo "$config" | jq ".username=\"${KUBO_USERNAME}\"")
config=$(echo "$config" | jq ".password=\"${password}\"")

echo "$config" > updated-k-drats-config/config.json
