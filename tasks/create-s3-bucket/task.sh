#!/usr/bin/env bash

set -eu

echo "Creating bucket: $BUCKET_NAME..."
aws --endpoint "$ENDPOINT" s3api create-bucket --bucket "$BUCKET_NAME"

if [ "$VERSIONED" = true ] ; then
  echo "Enabling versioning on bucket: $BUCKET_NAME"
  aws --endpoint "$ENDPOINT" s3api put-bucket-versioning --bucket "$BUCKET_NAME" --versioning-configuration Status=Enabled
fi
