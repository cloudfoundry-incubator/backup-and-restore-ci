#!/usr/bin/env bash

set -x
set -e
set -u

terraform version

if [[ ! -z "$TERRFORM_STATE_PREPARE_CMD" ]]; then
  "$TERRAFORM_STATE_DIR/$TERRFORM_STATE_PREPARE_CMD"
fi

git config --global user.name "$GIT_USER_NAME"
git config --global user.email "$GIT_USER_EMAIL"

pushd "$TERRAFORM_STATE_DIR/$ENVIRONMENT_NAME"
  terraform init
  terraform apply -auto-approve

  git add terraform.tfstate*

  if git commit -m "Update terraform-state for $ENVIRONMENT_NAME"; then
    echo "Updated terraform-state for $ENVIRONMENT_NAME"
  else
    echo "No change to terraform-state for $ENVIRONMENT_NAME"
  fi
popd

cp -r "$TERRAFORM_STATE_DIR" "$OUTPUT_TERRAFORM_STATE_DIR"
