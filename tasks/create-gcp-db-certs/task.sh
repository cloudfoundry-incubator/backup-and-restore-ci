#!/usr/bin/env bash

set -eu

save_server_certs() {
  local certs_dir; certs_dir="ci/backup-and-restore-sdk-release/certs/gcp-${1}"
  # Apparently in terraform 0.14.2 output command returns quotes around the instance name. This breaks gcloud command
  # Stripping the quotes using jq solves the problem - https://www.terraform.io/docs/commands/output.html#use-in-automation
  local instance_name; instance_name="$(terraform output -state=../terraform-state/terraform.tfstate "${1}_name" | jq -r .)"

  mkdir -p "$certs_dir"
  gcloud sql instances describe "$instance_name" --format='value(serverCaCert.cert)' > "${certs_dir}/test-server-cert.pem"
  if ! gcloud sql ssl-certs list --instance "$instance_name" | grep "test-client-cert "
  then
    rm -f "${certs_dir}/test-client-key.pem"
    gcloud sql ssl-certs create test-client-cert "${certs_dir}/test-client-key.pem" --instance "$instance_name"
    gcloud sql ssl-certs describe test-client-cert --instance "$instance_name" --format='value(cert)' > "${certs_dir}/test-client-cert.pem"
  fi
}

git config --global user.name "PCF Backup & Restore CI"
git config --global user.email "cf-lazarus@pivotal.io"

(
  cd bosh-backup-and-restore-meta/
  gcloud auth activate-service-account --key-file=<(echo "$GCP_SERVICE_ACCOUNT_KEY")
  gcloud config set project cf-backup-and-restore

  save_server_certs "mysql_5_6"
  save_server_certs "mysql_5_7"
  save_server_certs "postgres_9_6"
  save_server_certs "postgres_9_6_mutual_tls"

  git add ci/backup-and-restore-sdk-release
  if git commit -m "Update GCP certs" ; then
    echo "Update GCP certs"
  else
    echo "No change to certs"
  fi
 )
