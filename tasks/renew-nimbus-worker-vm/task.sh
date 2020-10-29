#!/usr/bin/env bash

set -euo pipefail

USER=${USER} nimbus-ctl --lease 7 extend-lease ${WORKER_ID}
