#!/usr/bin/env bash

set -eu

export BOSH_CA_CERT="$BOSH_CA_CERT_DIR/$BOSH_CA_CERT_PATH"

bosh delete-deployment -d "${BOSH_DEPLOYMENT}" -n
