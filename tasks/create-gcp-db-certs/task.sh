#!/usr/bin/env bash

set -eu

save_server_certs() {
  local certs_dir; certs_dir="ci/backup-and-restore-sdk-release/certs/gcp-${1}"
  local instance_name; instance_name="$(terraform output -state=terraform-state/terraform.tfstate "${1}-name")"

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

  save_server_certs "mysql-5-6"
  save_server_certs "mysql-5-7"
  save_server_certs "postgres-9-6"
  save_server_certs "postgres-9-6-mutual-tls"

  git add ci/backup-and-restore-sdk-release
  if git commit -m "Update GCP certs" ; then
    echo "Update GCP certs"
  else
    echo "No change to certs"
  fi
 )
