#!/usr/bin/env bash

set -e
set -u

terraform_output() {
   terraform output -state="${HOME}/workspace/bosh-backup-and-restore-meta/${TERRAFORM_STATE_PATH}" $1
}

if [[ ! -z "${TERRAFORM_STATE_PREPARE_CMD}" ]]; then
  "terraform-state/${TERRAFORM_STATE_PREPARE_CMD}"
fi

if [[ ! -z "${BOSH_VARS_STORE_PREPARE_CMD}" ]]; then
  "bosh-vars-store/${BOSH_VARS_STORE_PREPARE_CMD}"
fi

bosh_host="$(terraform_output director-ip)"
bosh_ca_cert="$(bosh-cli int --path=/director_ssl/ca "bosh-vars-store/${BOSH_VARS_STORE_PATH}")"
bosh_client_secret="$(bosh-cli int --path=/admin_password "bosh-vars-store/${BOSH_VARS_STORE_PATH}")"
zone="$(terraform_output zone1)"
network="$(terraform_output director-network-name)"
subnetwork="$(terraform_output director-subnetwork-name)"
tags="'[$(terraform_output director-tag)]'"
internal_cidr="$(terraform_output director-subnetwork-cidr-range)"

bosh_ca_cert_path="$(mktemp)"
echo "${bosh_ca_cert}" > "${bosh_ca_cert_path}"

bosh-cli --environment "${bosh_host}" \
    --client "${BOSH_CLIENT}" \
    --client-secret "${bosh_client_secret}" \
    --ca-cert "${bosh_ca_cert_path}" \
    update-cloud-config \
    -v internal_cidr="${internal_cidr}" \
    -v internal_gw=10.0.0.1 \
    -v zone="${zone}" \
    -v network="${network}" \
    -v subnetwork="${subnetwork}" \
    -v tags="${tags}" \
    "cloud-config/${CLOUD_CONFIG_PATH}" -n
