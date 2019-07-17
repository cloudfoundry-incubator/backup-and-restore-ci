#!/usr/bin/env bash
set -euo pipefail

: "${BBL_TERRAFORM_STATE?BBL_TERRAFORM_STATE must be set}"
: "${TERRAFORM_STATE?TERRAFORM_STATE must be set}"
: "${GCP_KEY?GCP_KEY must be set}"

nameservers="$( terraform output "--state=${BBL_TERRAFORM_STATE}" system_domain_dns_servers )"
env_name="$( terraform output "--state=${BBL_TERRAFORM_STATE}" director_name)"

terraform init bosh-backup-and-restore-meta/terraform/backup-and-restore-sdk-acceptance-tests/add-subdomain-record-set/

terraform apply \
  --auto-approve \
  --var "nameservers=${nameservers}" \
  --var "record_set_name=${env_name#"bosh-"}.platform-recovery.cf-app.com." \
  --var "project_id=$( jq -r .project_id <<< "$GCP_KEY" )"\
  --var region=europe-west1 \
  --var "credentials=${GCP_KEY}" \
  --var zone=platform-recovery \
  "--state=${TERRAFORM_STATE}" \
  bosh-backup-and-restore-meta/terraform/backup-and-restore-sdk-acceptance-tests/add-subdomain-record-set/
