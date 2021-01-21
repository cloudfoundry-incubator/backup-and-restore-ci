#!/usr/bin/env bash

set -euo pipefail

for env in $WORKER_IDS
do
  USER=${USER} nimbus-ctl --lease 7 extend-lease $env
done
