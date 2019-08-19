#!/usr/bin/env bash

set -euo pipefail

eval "$( bbl print-env --state-dir "bbl-state/${BBL_STATE_DIR}" )"
bosh upload-release "$( bosh int <( bosh runtime-config --name=dns ) --path /releases/name=bosh-dns/url )"
