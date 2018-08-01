#!/bin/bash

# Copyright (C) 2017-Present Pivotal Software, Inc. All rights reserved.
#
# This program and the accompanying materials are made available under
# the terms of the under the Apache License, Version 2.0 (the "License”);
# you may not use this file except in compliance with the License.
#
# You may obtain a copy of the License at
# http:#www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#
# See the License for the specific language governing permissions and
# limitations under the License.

set -eu

echo -e "${SSH_PROXY_PRIVATE_KEY}" > /tmp/private.key
chmod 0400 /tmp/private.key

export GOPATH=$PWD/backup-and-restore-sdk-release
export PATH=$PATH:$GOPATH/bin
export BOSH_ENVIRONMENT="${BOSH_ENVIRONMENT:="https://lite-bosh.backup-and-restore.cf-app.com"}"
export BOSH_CA_CERT="${BOSH_CA_CERT:="${PWD}/bosh-backup-and-restore-meta/certs/lite-bosh.backup-and-restore.cf-app.com.crt"}"
export BOSH_GW_USER=${SSH_PROXY_USER}
export BOSH_GW_HOST=${SSH_PROXY_HOST}
export BOSH_GW_PRIVATE_KEY=/tmp/private.key
export SSH_PROXY_KEY_FILE=/tmp/private.key

if [[ "$USE_BOSH_ALL_PROXY" = true ]]; then
  export BOSH_ALL_PROXY="ssh+socks5://${BOSH_GW_USER}@${BOSH_GW_HOST}:22?private-key=${BOSH_GW_PRIVATE_KEY}"
fi

export POSTGRES_CA_CERT="${POSTGRES_CA_CERT:-$(cat "$PWD/bosh-backup-and-restore-meta/${POSTGRES_CA_CERT_PATH}")}"
export POSTGRES_CLIENT_CERT="${POSTGRES_CLIENT_CERT:-$(cat "$PWD/bosh-backup-and-restore-meta/${POSTGRES_CLIENT_CERT_PATH}")}"
export POSTGRES_CLIENT_KEY="${POSTGRES_CLIENT_KEY:-$(cat "$PWD/bosh-backup-and-restore-meta/${POSTGRES_CLIENT_KEY_PATH}")}"

cd backup-and-restore-sdk-release/src/github.com/cloudfoundry-incubator/database-backup-restore
ginkgo -v -r "system_tests/${TEST_SUITE_NAME}" -trace
