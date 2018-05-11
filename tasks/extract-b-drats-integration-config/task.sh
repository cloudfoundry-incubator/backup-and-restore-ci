#!/usr/bin/env bash

set -e
set -u

if [[ ! -z "${TERRAFORM_STATE_PREPARE_CMD}" ]]; then
  "${TERRAFORM_STATE_PREPARE_CMD}"
fi

if [[ ! -z "${BOSH_VARS_STORE_PREPARE_CMD}" ]]; then
  "${BOSH_VARS_STORE_PREPARE_CMD}"
fi

bosh_host="$(terraform output -state="${TERRAFORM_STATE_PATH}" director-ip)"
bosh_ssh_username="${BOSH_SSH_USERNAME}"
bosh_ssh_private_key="$(bosh-cli int --path=/jumpbox_ssh/private_key "${BOSH_VARS_STORE_PATH}")"
timeout="${TIMEOUT_IN_MINUTES}"
bosh_client="${BOSH_CLIENT}"
bosh_client_secret="$(bosh-cli int --path=/admin_password "${BOSH_VARS_STORE_PATH}")"
bosh_ca_cert="$(bosh-cli int --path=/director_ssl/ca "${BOSH_VARS_STORE_PATH}")"

vars="bosh_host bosh_ssh_username bosh_ssh_private_key timeout bosh_client bosh_client_secret bosh_ca_cert"

integration_config="{}"

for var in $vars
do
  integration_config=$(echo ${integration_config} | jq ".${var}=\"${!var}\"")
done

echo "$integration_config" > "${OUTPUT_DIR}/integration_config.json"
