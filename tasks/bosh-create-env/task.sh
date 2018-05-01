#!/usr/bin/env bash

set -e
set -u

if [[ ! -z "$BOSH_STATE_PREPARE_CMD" ]]; then
  "$BOSH_STATE_PREPARE_CMD"
fi

opsfiles_arguments=""
for op in ${OPS_FILES}
  do
    opsfiles_arguments="${opsfiles_arguments} -o ${op}"
done

pushd bosh-deployment
    # shellcheck disable=SC2086   # we need to expand $opsfiles_arguments
    bosh-cli create-env bosh.yml \
    --state="../${BOSH_STATE_DIR}/bosh-state.json" \
    --vars-store="../${BOSH_STATE_DIR}/creds.yml" \
    --var-file gcp_credentials_json="../${BOSH_STATE_DIR}/gcp_service_account_key.json" \
    $opsfiles_arguments \
    -v director_name="$DIRECTOR_NAME" \
    -v internal_cidr=10.0.0.0/24 \
    -v internal_gw=10.0.0.1 \
    -v internal_ip=10.0.0.6 \
    -v project_id="$PROJECT_ID" \
    -v zone="$ZONE" \
    -v tags="$TAGS" \
    -v network="$NETWORK" \
    -v external_ip="$IP" \
    -v subnetwork="$SUBNET"
popd

pushd "${BOSH_STATE_DIR}"
  git add bosh-state.json
  git add creds.yml

  if git commit -m "Update BOSH director state" ; then
    echo "Updated BOSH director state"
  else
    echo "No change to BOSH director state"
  fi
popd

cp -r "${BOSH_STATE_DIR}/." "${OUTPUT_DIR}"
