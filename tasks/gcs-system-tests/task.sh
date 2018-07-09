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

export GOPATH="$PWD/backup-and-restore-sdk-release"
export PATH="$PATH:$GOPATH/bin"

GCP_SERVICE_ACCOUNT_KEY_PATH="$(mktemp)"
echo "$GCP_SERVICE_ACCOUNT_KEY" > "$GCP_SERVICE_ACCOUNT_KEY_PATH"
export GCP_SERVICE_ACCOUNT_KEY_PATH

cd backup-and-restore-sdk-release/src/github.com/cloudfoundry-incubator/backup-and-restore-sdk-release-system-tests/gcs
ginkgo -v -r -trace
