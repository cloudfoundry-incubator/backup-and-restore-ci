#!/bin/bash

set -eu

eval "$(ssh-agent)"
chmod 400 bosh-backup-and-restore-meta/keys/github
ssh-add bosh-backup-and-restore-meta/keys/github


echo -e "${BOSH_GW_PRIVATE_KEY}" > "${PWD}/ssh.key"
chmod 0600 "${PWD}/ssh.key"
export BOSH_GW_PRIVATE_KEY="${PWD}/ssh.key"

echo -e "${DIRECTOR_SSH_KEY}" > "${PWD}/director.key"
chmod 0600 "${PWD}/director.key"
export DIRECTOR_SSH_KEY_PATH="${PWD}/director.key"

export GOPATH=$PWD
export PATH=$PATH:$GOPATH/bin
cd src/github.com/cloudfoundry-incubator/bosh-backup-and-restore
make sys-test-bosh-all-proxy-ci
