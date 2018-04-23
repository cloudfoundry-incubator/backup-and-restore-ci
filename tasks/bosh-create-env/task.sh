#!/usr/bin/env bash

set -ex

opsfiles_arguments=""
for op in ${OPS_FILES}
  do
    opsfiles_arguments="${opsfiles_arguments} -o bosh-deployment/${op}"
done

pushd bosh-deployment
    bosh-cli create-env bosh.yml \
    --state="../bosh-backup-and-restore-meta/${BOSH_STATE_DIR}/bosh-state.json" \
    --vars-store="../bosh-backup-and-restore-meta/${BOSH_STATE_DIR}/creds.yml" \
    --var-file gcp_credentials_json="../bosh-backup-and-restore-meta/${BOSH_STATE_DIR}/gcp_service_account_key.json" \
    ${opsfiles_arguments} \
    -v director_name=${DIRECTOR_NAME} \
    -v internal_cidr=10.0.0.0/24 \
    -v internal_gw=10.0.0.1 \
    -v internal_ip=10.0.0.6 \
    -v project_id=${PROJECT_ID} \
    -v zone=${ZONE} \
    -v tags=${TAG} \
    -v network=${NETWORK} \
    -v external_ip=${IP} \
    -v subnetwork=${SUBNET}
popd

pushd "bosh-backup-and-restore-meta/${BOSH_STATE_DIR}"
  git add bosh-state.json
  if git commit -m "Update bosh state" ; then
    echo "Update bosh-state"
  else
    echo "No deploy occurred; bailing out"
  fi
popd
cp -r bosh-backup-and-restore-meta/. meta-with-updated-bosh-state/
