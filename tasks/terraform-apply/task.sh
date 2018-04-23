#!/usr/bin/env bash
set -x

terraform version

./bosh-backup-and-restore-meta/unlock-ci.sh

git config --global user.name "PCF Backup & Restore CI"
git config --global user.email "cf-lazarus@pivotal.io"

pushd "bosh-backup-and-restore-meta/${TERRAFORM_DIR}"
  set +x
  terraform init
  terraform apply -auto-approve
  set -x

  git add terraform.tfstate*
  if git commit -m "Update terraform-state" ; then
    echo "Update terraform-state"
  else
    echo "No deploy occurred; bailing out"
  fi
popd
cp -r bosh-backup-and-restore-meta/* meta-with-updated-terraform/
