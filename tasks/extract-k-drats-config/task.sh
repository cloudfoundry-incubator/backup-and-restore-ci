#!/usr/bin/env bash

set -eu
set -o pipefail

pushd "bbl-state/$BBL_STATE_DIR"
  eval "$(bbl print-env)"
popd

api_server_ip="$(jq -r .external_ip < terraform/metadata)"
ca_cert="$(bosh int <(credhub get -n "${BOSH_DIRECTOR_NAME}/${BOSH_DEPLOYMENT}/tls-kubernetes" --output-json) --path=/value/ca)"
password="$(bosh int <(credhub get -n "${BOSH_DIRECTOR_NAME}/${BOSH_DEPLOYMENT}/kubo-admin-password" --output-json) --path=/value)"

integration_config="{}"
integration_config=$(echo "$integration_config" | jq ".timeout_in_minutes=${TIMEOUT_IN_MINUTES}")
integration_config=$(echo "$integration_config" | jq ".cluster_name=\"${CLUSTER_NAME}\"")
integration_config=$(echo "$integration_config" | jq ".api_server_url=\"https://${api_server_ip}:8443\"")
integration_config=$(echo "$integration_config" | jq ".ca_cert=\"${ca_cert}\"")
integration_config=$(echo "$integration_config" | jq ".username=\"${KUBO_USERNAME}\"")
integration_config=$(echo "$integration_config" | jq ".password=\"${password}\"")

echo "$integration_config" > k-drats-config/config.json
