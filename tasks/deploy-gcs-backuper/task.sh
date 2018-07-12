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

export BOSH_CA_CERT="./bosh-backup-and-restore-meta/certs/${BOSH_ENVIRONMENT}.crt"

GCP_SERVICE_ACCOUNT_KEY="$(echo "$GCP_SERVICE_ACCOUNT_KEY" | sed -e 's/^/  /')"
vars_file="$(mktemp)"
echo "gcp-service-account-key: |
${GCP_SERVICE_ACCOUNT_KEY}" > "$vars_file"

bosh-cli --non-interactive \
  --deployment "${BOSH_DEPLOYMENT}" \
  deploy "backup-and-restore-sdk-release/ci/manifests/${MANIFEST_NAME}" \
  --var=deployment-name="${BOSH_DEPLOYMENT}" \
  --var=backup-and-restore-sdk-release-version="$(cat release-tarball/version)" \
  --var=backup-and-restore-sdk-release-url="$(cat release-tarball/url)" \
  --vars-file="$vars_file" \
  --var=gcs-bucket-name="$GCS_BUCKET_NAME"
