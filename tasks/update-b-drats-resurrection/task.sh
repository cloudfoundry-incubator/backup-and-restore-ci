#!/usr/bin/env bash

set -e
set -u

pushd terraform-state
    bosh_host="$(terraform output director-ip)"
popd

bosh_ca_cert="$(bosh int --path=/director_ssl/ca "bosh-vars-store/${BOSH_VARS_STORE_PATH}")"
bosh_client_secret="$(bosh int --path=/admin_password "bosh-vars-store/${BOSH_VARS_STORE_PATH}")"

bosh_ca_cert_path="$(mktemp)"
echo "${bosh_ca_cert}" > "${bosh_ca_cert_path}"

bosh --environment "${bosh_host}" \
    --client "${BOSH_CLIENT}" \
    --client-secret "${bosh_client_secret}" \
    --ca-cert "${bosh_ca_cert_path}" \
    update-resurrection "${RESURRECTION}" -n
