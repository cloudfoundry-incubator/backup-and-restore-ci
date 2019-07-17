#!/usr/bin/env bash
set -euo pipefail

if [ -z "$GCP_SERVICE_ACCOUNT_KEY" ]; then
  1>&2 echo "GCP_SERVICE_ACCOUNT_KEY must be set"
  exit 1
fi

gcloud auth activate-service-account --key-file <( echo "$GCP_SERVICE_ACCOUNT_KEY" )

unattached_disks="$( gcloud compute disks list --format="json(selfLink,users.basename())" | jq -r '.[] | select(has("users") | not) | .selfLink' )"

if [ -z "$unattached_disks" ]; then
    echo "No unattached disks to delete"
    exit 0
fi

xargs gcloud compute disks delete --quiet <<< "$unattached_disks"

