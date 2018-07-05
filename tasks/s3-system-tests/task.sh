#!/usr/bin/env bash

set -eu

eval "$(ssh-agent)"

chmod 400 bosh-backup-and-restore-meta/keys/github
ssh-add bosh-backup-and-restore-meta/keys/github
chmod 400 bosh-backup-and-restore-meta/genesis-bosh/bosh.pem

export GOPATH="${PWD}/backup-and-restore-sdk-release"
export PATH="$PATH:$GOPATH/bin"
export BOSH_ENVIRONMENT="${BOSH_ENVIRONMENT:="https://lite-bosh.backup-and-restore.cf-app.com"}"
export BOSH_CA_CERT="${BOSH_CA_CERT:="${PWD}/bosh-backup-and-restore-meta/certs/lite-bosh.backup-and-restore.cf-app.com.crt"}"
export BOSH_GW_USER="${BOSH_GW_USER:="vcap"}"
export BOSH_GW_HOST="${BOSH_GW_HOST:="lite-bosh.backup-and-restore.cf-app.com"}"

if [[ -z "${BOSH_GW_PRIVATE_KEY}" ]]; then
  export BOSH_GW_PRIVATE_KEY="${PWD}/bosh-backup-and-restore-meta/genesis-bosh/bosh.pem"
else
  echo -e "${BOSH_GW_PRIVATE_KEY}" > "${PWD}/ssh.key"
  chmod 0600 "${PWD}/ssh.key"
  export BOSH_GW_PRIVATE_KEY="${PWD}/ssh.key"
fi

if [[ "$USE_BOSH_ALL_PROXY" = true ]]; then
  export BOSH_ALL_PROXY="ssh+socks5://${BOSH_GW_USER}@${BOSH_GW_HOST}?private-key=${BOSH_GW_PRIVATE_KEY}"
fi

cd backup-and-restore-sdk-release/src/github.com/cloudfoundry-incubator/backup-and-restore-sdk-release-system-tests/s3

if [[ ! -z "${FOCUS_SPEC}" ]]; then
  ginkgo -focus "${FOCUS_SPEC}" -v -r -trace
else
  ginkgo -v -r -trace
fi
