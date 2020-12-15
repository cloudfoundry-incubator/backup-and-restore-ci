#!/usr/bin/env bash
set -euo pipefail

: "${BBL_TERRAFORM_STATE?BBL_TERRAFORM_STATE must be set}"
: "${TERRAFORM_STATE?TERRAFORM_STATE must be set}"
: "${GCP_KEY?GCP_KEY must be set}"

nameservers="$( terraform output "--state=${BBL_TERRAFORM_STATE}" -json | jq -r .system_domain_dns_servers.value)"
env_name="$( terraform output "--state=${BBL_TERRAFORM_STATE}" -json | jq -r .director_name)"

terraform init bosh-backup-and-restore-meta/terraform/backup-and-restore-sdk-acceptance-tests/add-subdomain-record-set/

terraform ${TERRAFORM_ACTION} \
  --auto-approve \
  --var "nameservers=${nameservers}" \
  --var "record_set_name=${env_name#"bosh-"}.cryo.cf-app.com." \
  --var "project_id=$( jq -r .project_id <<< "$GCP_KEY" )"\
  --var region=europe-west1 \
  --var "credentials=${GCP_KEY}" \
  --var zone=cryo \
  "--state=bosh-backup-and-restore-meta/${TERRAFORM_STATE}" \
  bosh-backup-and-restore-meta/terraform/backup-and-restore-sdk-acceptance-tests/add-subdomain-record-set/

(
  cd bosh-backup-and-restore-meta

  git config user.name "${GIT_COMMIT_USERNAME}"
  git config user.email "${GIT_COMMIT_EMAIL}"
  git add "$TERRAFORM_STATE*"

  if git commit -m "Update add-subdomain-record-set terraform state for ${env_name#"bosh-"}"; then
    echo "Update add-subdomain-record-set terraform state for ${env_name#"bosh-"}"
  else
    echo "No change to add-subdomain-record-set terraform state for ${env_name#"bosh-"}"
  fi
)
