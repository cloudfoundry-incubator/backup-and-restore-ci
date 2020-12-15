#!/usr/bin/env bash

set -eu

storage_account_name="$(terraform output -state=terraform-state/terraform.tfstate "azure-storage-account-name" | jq -r .)"

az login --service-principal --username "$APP_ID" --password "$PASSWORD" --tenant "$TENANT_ID"

az storage blob service-properties delete-policy update \
  --days-retained 1  --account-name "$storage_account_name" --enable true

