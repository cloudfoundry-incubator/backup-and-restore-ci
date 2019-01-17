#!/bin/bash

set -eu

echo -e "${BOSH_GW_PRIVATE_KEY}" > "${PWD}/ssh.key"
chmod 0600 "${PWD}/ssh.key"
export BOSH_GW_PRIVATE_KEY="${PWD}/ssh.key"
export BOSH_ALL_PROXY="ssh+socks5://${BOSH_GW_USER}@${BOSH_GW_HOST}?private-key=${BOSH_GW_PRIVATE_KEY}"

if [[ -z "$BOSH_CA_CERT_PATH" ]]; then
  export BOSH_CA_CERT="$PWD/$BOSH_CA_CERT_PATH"
fi

export GOPATH=$PWD
export PATH=$PATH:$GOPATH/bin
cd src/github.com/cloudfoundry-incubator/bosh-backup-and-restore
make sys-test-deployment-ci
