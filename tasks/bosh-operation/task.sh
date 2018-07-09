#!/usr/bin/env bash

set -e
set -u

opsfiles_arguments=""
for op in ${OPS_FILES}
  do
    opsfiles_arguments="${opsfiles_arguments} -o ${op}"
done

pushd terraform-state
  external_ip=$(terraform output director-ip)
  zone="$(terraform output zone1)"
  network="$(terraform output director-network-name)"
  subnetwork="$(terraform output director-subnetwork-name)"
  tags="[$(terraform output director-tag)]"
  internal_cidr="$(terraform output director-subnetwork-cidr-range)"
  project_id="$(terraform output projectid)"
popd

function commit_bosh_state() {
  pushd "${BOSH_STATE_DIR}/${ENVIRONMENT_NAME}"
    git add bosh-state.json
    git add creds.yml
    if git commit -m "Update bosh state for ${ENVIRONMENT_NAME} after bosh ${BOSH_OPERATION}"; then
      echo "Updated bosh-state for ${ENVIRONMENT_NAME} after bosh ${BOSH_OPERATION}"
    else
      echo "No change to BOSH state for ${ENVIRONMENT_NAME} after bosh ${BOSH_OPERATION}"
    fi
  popd

  cp -r "${BOSH_STATE_DIR}/." "${BOSH_STATE_OUTPUT_DIR}"
}

trap commit_bosh_state EXIT

gcp_version_account_key="$(mktemp)"
echo "${GCP_SERVICE_ACCOUNT_KEY}" > "${gcp_version_account_key}"

pushd bosh-deployment
    # shellcheck disable=SC2086   # we need to expand $opsfiles_arguments
    bosh-cli ${BOSH_OPERATION} bosh.yml \
    --state="../${BOSH_STATE_DIR}/${ENVIRONMENT_NAME}/bosh-state.json" \
    --vars-store="../${BOSH_STATE_DIR}/${ENVIRONMENT_NAME}/creds.yml" \
    --var-file gcp_credentials_json="${gcp_version_account_key}" \
    $opsfiles_arguments \
    -v director_name="${DIRECTOR_NAME}" \
    -v internal_cidr="${internal_cidr}" \
    -v internal_gw=10.0.0.1 \
    -v internal_ip=10.0.0.6 \
    -v project_id="${project_id}" \
    -v zone="${zone}" \
    -v tags="${tags}" \
    -v network="${network}" \
    -v external_ip="${external_ip}" \
    -v subnetwork="${subnetwork}"
popd

if [[ ${BOSH_OPERATION} == "delete-env" ]]; then
    rm "${BOSH_STATE_DIR}/${ENVIRONMENT_NAME}/creds.yml"
fi
