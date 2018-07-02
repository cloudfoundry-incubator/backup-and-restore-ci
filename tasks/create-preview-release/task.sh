#!/usr/bin/env bash

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

VERSION=$(cat github-release/version)
COMMIT_SHA=$(cat github-release/commit_sha)

pushd backup-and-restore-sdk-release
  git reset --hard "${COMMIT_SHA}"

  bosh-cli create-release \
    --version "${VERSION}" \
    --name="backup-and-restore-sdk-preview" \
    --tarball="../backup-and-restore-sdk-release-build/backup-and-restore-sdk-addon-${VERSION}.tgz" \
    --force
popd
