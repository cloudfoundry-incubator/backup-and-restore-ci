#!/usr/bin/env bash

set -e
set -u

pushd terraform-state
    bosh_host="$(terraform output director-ip)"
    zone="$(terraform output zone1)"
    network="$(terraform output director-network-name)"
    subnetwork="$(terraform output director-subnetwork-name)"
    tags="[$(terraform output internal-tag)]"
    internal_cidr="$(terraform output director-subnetwork-cidr-range)"
popd

bosh_ca_cert="$(bosh-cli int --path=/director_ssl/ca "bosh-vars-store/${BOSH_VARS_STORE_PATH}")"
bosh_client_secret="$(bosh-cli int --path=/admin_password "bosh-vars-store/${BOSH_VARS_STORE_PATH}")"


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
