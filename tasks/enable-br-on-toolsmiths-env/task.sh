#!/usr/bin/env bash

set -eu

pool_metadata="env-pool/metadata"

OPS_MAN_URL=$(< "$pool_metadata" jq -r .ops_manager.url)
OPS_MAN_USER=$(< "$pool_metadata" jq -r .ops_manager.username)
OPS_MAN_PASS=$(< "$pool_metadata" jq -r .ops_manager.password)

OM_CMD="om --target ${OPS_MAN_URL} --username ${OPS_MAN_USER} --password ${OPS_MAN_PASS} -k"

$OM_CMD configure-product --config <(echo "---
product-name: cf
resource-config:
  backup_restore:
    instances: 1")

$OM_CMD apply-changes
