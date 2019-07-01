#!/usr/bin/env bash

set -eu

save_server_certs() {
  CERTS_DIR=ci/backup-and-restore-sdk-release/certs/gcp-"$1"
  mkdir -p "${CERTS_DIR}"
  INSTANCE_NAME="$(terraform output -state=terraform/bbr-sdk-system-tests/gcp/terraform.tfstate "$1"-name)"
  gcloud sql instances describe "${INSTANCE_NAME}" --format='value(serverCaCert.cert)' > "$CERTS_DIR"/test-server-cert.pem
  if ! gcloud sql ssl-certs list --instance "${INSTANCE_NAME}" | grep "test-client-cert "
  then
    rm -f "$CERTS_DIR"/test-client-key.pem
    gcloud sql ssl-certs create test-client-cert "$CERTS_DIR"/test-client-key.pem --instance "${INSTANCE_NAME}"
    gcloud sql ssl-certs describe test-client-cert --instance "${INSTANCE_NAME}" --format='value(cert)' > "$CERTS_DIR"/test-client-cert.pem
  fi
}

git config --global user.name "PCF Backup & Restore CI"
git config --global user.email "cf-lazarus@pivotal.io"

keyfile="$(mktemp)"
echo "$GCP_SERVICE_ACCOUNT_KEY" > $keyfile

pushd bosh-backup-and-restore-meta/terraform/bbr-sdk-system-tests/gcp
  terraform init
  terraform apply \
  -var "mysql-5-6-password=${MYSQL_5_6_PASSWORD}" \
  -var "mysql-5-7-password=${MYSQL_5_7_PASSWORD}" \
  -var "postgres-9-6-password=${POSTGRES_9_6_PASSWORD}" \
  -var "director-external-ip=${DIRECTOR_EXTERNAL_IP}" \
  -var "director-jumpbox-ip=${DIRECTOR_JUMPBOX_IP}" \
  -var "gcp-key=${keyfile}" \
  -auto-approve
popd

pushd bosh-backup-and-restore-meta/
  git add terraform/bbr-sdk-system-tests/gcp/terraform.tfstate*
  if git commit -m "Update terraform-state" ; then
    echo "Update terraform-state"
  else
    echo "No deploy occurred; bailing out"
  fi

  gcloud auth activate-service-account --key-file=$keyfile
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
popd
cp -r bosh-backup-and-restore-meta/ bosh-backup-and-restore-meta-output/
