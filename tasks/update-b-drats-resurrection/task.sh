#!/usr/bin/env bash

set -euo pipefail

jumpbox_private_key="$(mktemp)"
bosh interpolate --path /jumpbox_ssh/private_key "bosh-vars-store/${JUMPBOX_VARS_STORE_PATH}" > "${jumpbox_private_key}"

pushd terraform-state
    jumpbox_ip="$(terraform output jumpbox-ip)"
    bosh_host="$(terraform output director-internal-ip)"
popd

bosh_ca_cert="$(bosh int --path=/director_ssl/ca "bosh-vars-store/${BOSH_VARS_STORE_PATH}")"
bosh_client_secret="$(bosh int --path=/admin_password "bosh-vars-store/${BOSH_VARS_STORE_PATH}")"

bosh_ca_cert_path="$(mktemp)"
echo "${bosh_ca_cert}" > "${bosh_ca_cert_path}"

export BOSH_ALL_PROXY="ssh+socks5://jumpbox@${jumpbox_ip}:22?private-key=${jumpbox_private_key}"

bosh --environment "${bosh_host}" \
  --client "${BOSH_CLIENT}" \
  --client-secret "${bosh_client_secret}" \
  --ca-cert "${bosh_ca_cert_path}" \
  update-resurrection "${RESURRECTION}" -n
