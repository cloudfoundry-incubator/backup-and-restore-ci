#!/usr/bin/env bash

set -e
set -u

gcp_version_account_key="$(mktemp)"
echo "${GCP_SERVICE_ACCOUNT_KEY}" > "${gcp_version_account_key}"

jumpbox_private_key="$(mktemp)"
bosh interpolate --path /jumpbox_ssh/private_key "bosh-state/${JUMPBOX_ENVIRONMENT_NAME}/creds.yml" > "${jumpbox_private_key}"

pushd terraform-state
  jumpbox_ip="$(terraform output jumpbox-ip)"
  internal_gw="$(terraform output internal-gw)"
  internal_ip="$(terraform output director-internal-ip)"
  zone="$(terraform output zone1)"
  network="$(terraform output director-network-name)"
  subnetwork="$(terraform output director-subnetwork-name)"
  tags="[$(terraform output director-tag)]"
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


export BOSH_ALL_PROXY="ssh+socks5://jumpbox@${jumpbox_ip}:22?private-key=${jumpbox_private_key}"

pushd bosh-deployment
    # shellcheck disable=SC2086   # we need to expand $opsfiles_arguments
    bosh ${BOSH_OPERATION} bosh.yml \
    --state="../bosh-state/${ENVIRONMENT_NAME}/state.json" \
    --vars-store="../bosh-state/${ENVIRONMENT_NAME}/creds.yml" \
    --var-file gcp_credentials_json="${gcp_version_account_key}" \
    -o gcp/cpi.yml \
    -o uaa.yml \
    -o credhub.yml \
    -o jumpbox-user.yml \
    -o bbr.yml \
    -o "../opsfiles/opsfiles/b-drats/gcp/bosh-director-ephemeral-ip-ops.yml" \
    -v director_name="${DIRECTOR_NAME}" \
    -v internal_cidr="${internal_cidr}" \
    -v internal_gw="${internal_gw}" \
    -v internal_ip="${internal_ip}" \
    -v project_id="${project_id}" \
    -v zone="${zone}" \
    -v tags="${tags}" \
    -v network="${network}" \
    -v subnetwork="${subnetwork}"
popd

if [[ ${BOSH_OPERATION} == "delete-env" ]]; then
    rm "bosh-state/${ENVIRONMENT_NAME}/creds.yml"
fi
