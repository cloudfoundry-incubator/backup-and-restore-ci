#!/usr/bin/env bash

set -eu

jumpbox_private_key="$( mktemp )"
bosh interpolate --path /jumpbox_ssh/private_key "bosh-vars-store/${JUMPBOX_VARS_STORE_PATH}" > "$jumpbox_private_key"

tar xvf bbr-binary-release/*.tar
export BBR_BINARY_PATH="$( pwd )/bbr-binary-release/releases/bbr"

export GOPATH="$( pwd )"
export PATH="${PATH}:${GOPATH}/bin"
export INTEGRATION_CONFIG_PATH="$( pwd )/b-drats-integration-config/${INTEGRATION_CONFIG_PATH}"

export BOSH_ALL_PROXY="ssh+socks5://jumpbox@${jumpbox_ip}:22?private-key=${jumpbox_private_key}"
export CREDHUB_PROXY="ssh+socks5://jumpbox@${jumpbox_ip}:22?private-key=${jumpbox_private_key}"

./src/github.com/cloudfoundry-incubator/bosh-disaster-recovery-acceptance-tests/scripts/_run_acceptance_tests.sh

