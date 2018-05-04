#!/usr/bin/env bash

set -e
set -u

if [[ ! -z "$BOSH_CA_CERT_PREPARE_CMD" ]]; then
  "$BOSH_CA_CERT_DIR/$BOSH_CA_CERT_PREPARE_CMD"
fi

export BOSH_CLIENT
export BOSH_CLIENT_SECRET
export BOSH_ENVIRONMENT
export BOSH_CA_CERT="$BOSH_CA_CERT_DIR/$BOSH_CA_CERT_PATH"

bosh-cli delete-deployment -d ${BOSH_DEPLOYMENT} -n


