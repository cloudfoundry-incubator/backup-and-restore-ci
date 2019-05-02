#!/usr/bin/env bash

set -euo pipefail

gcp_version_account_key="$(mktemp)"
echo "${GCP_SERVICE_ACCOUNT_KEY}" > "${gcp_version_account_key}"

pushd terraform-state
  internal_gw="$(terraform output internal-gw)"
  internal_ip="$(terraform output jumpbox-internal-ip)"
  external_ip="$(terraform output jumpbox-ip)"
  zone="$(terraform output zone1)"
  network="$(terraform output director-network-name)"
  subnetwork="$(terraform output director-subnetwork-name)"
  tags="[$(terraform output bosh-open-tag), $(terraform output jumpbox-tag)]"
  internal_cidr="$(terraform output director-subnetwork-cidr-range)"
  project_id="$(terraform output projectid)"
popd

function commit_bosh_state() {
  pushd "bosh-state/${ENVIRONMENT_NAME}"
    git add state.json
    git add creds.yml
    if git commit -m "Update bosh state for ${ENVIRONMENT_NAME} after bosh ${BOSH_OPERATION}"; then
      echo "Updated bosh-state for ${ENVIRONMENT_NAME} after bosh ${BOSH_OPERATION}"
    else
      echo "No change to BOSH state for ${ENVIRONMENT_NAME} after bosh ${BOSH_OPERATION}"
    fi
  popd

  cp -r "bosh-state/." "bosh-state-updated"
}

trap commit_bosh_state EXIT

pushd jumpbox-deployment
    bosh "${BOSH_OPERATION}" jumpbox.yml \
    --state="../bosh-state/${ENVIRONMENT_NAME}/state.json" \
    --vars-store="../bosh-state/${ENVIRONMENT_NAME}/creds.yml" \
    --var-file gcp_credentials_json="${gcp_version_account_key}" \
    -o gcp/cpi.yml \
    -v internal_cidr="${internal_cidr}" \
    -v internal_gw="${internal_gw}" \
    -v internal_ip="${internal_ip}" \
    -v external_ip="${external_ip}" \
    -v tags="${tags}" \
    -v project_id="${project_id}" \
    -v zone="${zone}" \
    -v network="${network}" \
    -v subnetwork="${subnetwork}"
popd

if [[ ${BOSH_OPERATION} == "delete-env" ]]; then
    rm "bosh-state/${ENVIRONMENT_NAME}/creds.yml"
fi
