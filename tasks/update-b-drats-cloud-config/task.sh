#!/usr/bin/env bash

set -euo pipefail

jumpbox_private_key="$(mktemp)"
bosh interpolate --path /jumpbox_ssh/private_key "bosh-vars-store/${JUMPBOX_VARS_STORE_PATH}" > "${jumpbox_private_key}"

pushd terraform-state
    bosh_host="$(terraform output director-internal-ip)"
    jumpbox_ip="$(terraform output jumpbox-ip)"
    jumpbox_internal_ip="$(terraform output jumpbox-internal-ip)"
    internal_gw="$(terraform output internal-gw)"
    zone="$(terraform output zone1)"
    network="$(terraform output director-network-name)"
    subnetwork="$(terraform output director-subnetwork-name)"
    tags="[$(terraform output internal-tag)]"
    internal_cidr="$(terraform output director-subnetwork-cidr-range)"
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
  update-cloud-config \
  -o "opsfiles/opsfiles/b-drats/gcp/cloud-config-jumpbox-reserved-ip.yml" \
  -v internal_cidr="${internal_cidr}" \
  -v internal_gw="${internal_gw}"\
  -v zone="${zone}" \
  -v network="${network}" \
  -v subnetwork="${subnetwork}" \
  -v tags="${tags}" \
  -v subnetwork_reserved_ip="${jumpbox_internal_ip}" \
  "cloud-config/${CLOUD_CONFIG_PATH}" -n
