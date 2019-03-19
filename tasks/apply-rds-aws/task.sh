#!/usr/bin/env bash

set -eu

git config --global user.name "PCF Backup & Restore CI"
git config --global user.email "cf-lazarus@pivotal.io"

pushd bosh-backup-and-restore-meta/terraform/bbr-sdk-system-tests/aws
  terraform init
  terraform apply \
  -var "aws_access_key=${AWS_ACCESS_KEY}" \
  -var "aws_secret_key=${AWS_SECRET_KEY}" \
  -var "aws_region=${AWS_REGION}" \
  -var "mysql_5_5_password=${MYSQL_5_5_PASSWORD}" \
  -var "mysql_5_6_password=${MYSQL_5_6_PASSWORD}" \
  -var "mysql_5_7_password=${MYSQL_5_7_PASSWORD}" \
  -var "postgres_9_4_password=${POSTGRES_9_4_PASSWORD}" \
  -var "postgres_9_6_password=${POSTGRES_9_6_PASSWORD}" \
  -var "postgres_10_6_password=${POSTGRES_10_6_PASSWORD}" \
  -var "postgres_11_password=${POSTGRES_11_PASSWORD}" \
  -auto-approve
popd

pushd bosh-backup-and-restore-meta/
  git add terraform/bbr-sdk-system-tests/aws/terraform.tfstate*
  if git commit -m "Update terraform-state" ; then
    echo "Update terraform-state"
  else
    echo "No deploy occurred; bailing out"
  fi
popd

cp -r bosh-backup-and-restore-meta/ bosh-backup-and-restore-meta-output/
