#!/usr/bin/env bash

set -e
set -u

terraform version

if [[ ! -z "$TERRAFORM_STATE_PREPARE_CMD" ]]; then
  "$TERRAFORM_STATE_PREPARE_CMD"
fi

git config --global user.name "$GIT_USER_NAME"
git config --global user.email "$GIT_USER_EMAIL"

pushd "$TERRAFORM_STATE_DIR"
  terraform init
  terraform apply -auto-approve

  git add terraform.tfstate*

  if git commit -m "Update terraform state"; then
    echo "Updated terraform state"
  else
    echo "No change to terraform state"
  fi
popd

cp -r "$TERRAFORM_STATE_DIR/." "$OUTPUT_DIR"
