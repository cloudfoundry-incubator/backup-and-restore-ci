#!/bin/bash

set -eu

eval "$(ssh-agent)"
chmod 400 bosh-backup-and-restore-meta/keys/github
ssh-add bosh-backup-and-restore-meta/keys/github

if [[ "$USE_BOSH_ALL_PROXY" = true ]]; then
  echo -e "${BOSH_GW_PRIVATE_KEY}" > "${PWD}/ssh.key"
  chmod 0600 "${PWD}/ssh.key"
  export BOSH_GW_PRIVATE_KEY="${PWD}/ssh.key"
  export BOSH_ALL_PROXY="ssh+socks5://${BOSH_GW_USER}@${BOSH_GW_HOST}?private-key=${BOSH_GW_PRIVATE_KEY}"
else
  chmod 400 "${BOSH_GW_PRIVATE_KEY:-bosh-backup-and-restore-meta/genesis-bosh/bosh.pem}"
  export BOSH_GW_HOST=$BOSH_ENVIRONMENT
  export BOSH_GW_USER=${BOSH_GW_USER:-vcap}
  export BOSH_GW_PRIVATE_KEY=$PWD/${BOSH_GW_PRIVATE_KEY:-bosh-backup-and-restore-meta/genesis-bosh/bosh.pem}
fi

if [[ -z "$BOSH_CA_CERT_PATH" ]]; then
  export BOSH_CA_CERT="$PWD/$BOSH_CA_CERT_PATH"
fi

export GOPATH=$PWD
export PATH=$PATH:$GOPATH/bin
cd src/github.com/cloudfoundry-incubator/bosh-backup-and-restore
make sys-test-deployment-ci
