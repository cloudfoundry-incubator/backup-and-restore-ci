#!/usr/bin/env bash

set -e
set -u

if [[ ! -z "${TERRAFORM_STATE_PREPARE_CMD}" ]]; then
  "terraform-state/${TERRAFORM_STATE_PREPARE_CMD}"
fi

if [[ ! -z "${BOSH_VARS_STORE_PREPARE_CMD}" ]]; then
  "bosh-vars-store/${BOSH_VARS_STORE_PREPARE_CMD}"
fi

bosh_host="$(terraform output -state="terraform-state/${TERRAFORM_STATE_PATH}" director-ip)"
bosh_ca_cert="$(bosh-cli int --path=/director_ssl/ca "bosh-vars-store/${BOSH_VARS_STORE_PATH}")"
bosh_client_secret="$(bosh-cli int --path=/admin_password "bosh-vars-store/${BOSH_VARS_STORE_PATH}")"

bosh_ca_cert_path="$(mktemp)"
echo "${bosh_ca_cert}" > "${bosh_ca_cert_path}"

bosh-cli --environment "${bosh_host}" \
    --client "${BOSH_CLIENT}" \
    --client-secret "${bosh_client_secret}" \
    --ca-cert "${bosh_ca_cert_path}" \
    update-resurrection "${RESURRECTION}" -n
