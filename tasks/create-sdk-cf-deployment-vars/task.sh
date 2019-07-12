#!/usr/bin/env bash

set -euo pipefail

terraform_output() {
  terraform output -state=terraform-state/terraform.tfstate "$1"
}

live_bucket="$(terraform_output "backup-and-restore-s3-unversioned-acceptance-live-bucket")"
backup_bucket="$(terraform_output "backup-and-restore-s3-unversioned-acceptance-backup-bucket")"

echo """
aws_region: ${AWS_REGION}
aws_backup_region: ${AWS_BACKUP_REGION}
blobstore_access_key_id: ${AWS_ACCESS_KEY}
blobstore_secret_access_key: ${AWS_SECRET_KEY}
buildpack_directory_key: ${live_bucket}
buildpack_backup_directory_key: ${backup_bucket}
app_package_directory_key: ${live_bucket}
app_package_backup_directory_key: ${backup_bucket}
droplet_directory_key: ${live_bucket}
droplet_backup_directory_key: ${backup_bucket}
resource_directory_key: ${live_bucket}
""" > "bosh-backup-and-restore-meta/${S3_UNVERSIONED_CF_DEPLOYMENT_VARS_FILE}"


live_bucket="$(terraform_output "backup-and-restore-s3-versioned-acceptance-live-bucket")"
database_address="$(terraform_output "backup-and-restore-acceptance-external-db-address")"

echo """
aws_region: ${AWS_REGION}
blobstore_access_key_id: ${AWS_ACCESS_KEY}
blobstore_secret_access_key: ${AWS_SECRET_KEY}
buildpack_directory_key: ${live_bucket}
app_package_directory_key: ${live_bucket}
droplet_directory_key: ${live_bucket}
resource_directory_key: ${live_bucket}
external_database_type: ${DATABASE_TYPE}
external_database_port: ${DATABASE_PORT}
external_cc_database_name: cc-db
external_cc_database_address: ${database_address}
external_cc_database_username: ${DATABASE_USERNAME}
external_cc_database_password: ${DATABASE_PASSWORD}
external_uaa_database_name: uaa-db
external_uaa_database_address: ${database_address}
external_uaa_database_username: ${DATABASE_USERNAME}
external_uaa_database_password: ${DATABASE_PASSWORD}
external_bbs_database_name: bbs-db
external_bbs_database_address: ${database_address}
external_bbs_database_username: ${DATABASE_USERNAME}
external_bbs_database_password: ${DATABASE_PASSWORD}
external_routing_api_database_name: api-db
external_routing_api_database_address: ${database_address}
external_routing_api_database_username: ${DATABASE_USERNAME}
external_routing_api_database_password: ${DATABASE_PASSWORD}
external_policy_server_database_address: ${database_address}
external_policy_server_database_name: policy-server-db
external_policy_server_database_password: ${DATABASE_PASSWORD}
external_policy_server_database_username: ${DATABASE_USERNAME}
external_silk_controller_database_address: ${database_address}
external_silk_controller_database_name: silk-controller-db
external_silk_controller_database_password: ${DATABASE_PASSWORD}
external_silk_controller_database_username: ${DATABASE_USERNAME}
external_locket_database_password: ${DATABASE_PASSWORD}
external_locket_database_address: ${database_address}
external_locket_database_name: locket-db
external_locket_database_username: ${DATABASE_USERNAME}
external_credhub_database_password: ${DATABASE_PASSWORD}
external_credhub_database_username: ${DATABASE_USERNAME}
external_credhub_database_name: credhub-db
external_credhub_database_address: ${database_address}
""" > "bosh-backup-and-restore-meta/${S3_VERSIONED_CF_DEPLOYMENT_VARS_FILE}"

(
  cd bosh-backup-and-restore-meta

  git add "$S3_VERSIONED_CF_DEPLOYMENT_VARS_FILE"
  git add "$S3_UNVERSIONED_CF_DEPLOYMENT_VARS_FILE"
  if git commit -m "Update cf-deployment vars for external directors"; then
    echo "Updated cf-deployment vars for external directors"
  else
    echo "No change to cf-deployment vars for external directors"
  fi
)

