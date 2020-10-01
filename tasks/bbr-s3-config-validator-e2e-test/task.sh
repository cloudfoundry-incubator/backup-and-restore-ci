#!/usr/bin/env bash

set -euo pipefail

cd bbr-s3-config-validator

ginkgo \
  -r \
  --randomizeAllSpecs \
  --keepGoing \
  --failOnPending \
  --cover \
  --race \
  --progress \
  test \
  | sed 's/"\(aws_.*\)"\: "\(.*\)"/"\1": "<redacted>"/g'

