#!/usr/bin/env bash

set -eu

terraform version

git config --global user.name "$GIT_USER_NAME"
git config --global user.email "$GIT_USER_EMAIL"

function commit_terraform_state() {
  pushd "$TERRAFORM_STATE_DIR/$ENVIRONMENT_NAME"
    git add terraform.tfstate*

    if git commit -m "Update terraform-state for $ENVIRONMENT_NAME after terraform $TERRAFORM_OPERATION"; then
      echo "Updated terraform-state for $ENVIRONMENT_NAME after terraform $TERRAFORM_OPERATION"
    else
      echo "No change to terraform-state for $ENVIRONMENT_NAME after terraform $TERRAFORM_OPERATION"
    fi
  popd

  cp -r "$TERRAFORM_STATE_DIR/." "$OUTPUT_TERRAFORM_STATE_DIR"
}

trap commit_terraform_state EXIT

pushd "$TERRAFORM_STATE_DIR/$ENVIRONMENT_NAME"
  terraform init
  terraform "$TERRAFORM_OPERATION" -auto-approve
popd
