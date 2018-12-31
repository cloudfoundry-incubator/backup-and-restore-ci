#!/bin/bash

set -eu
set -o pipefail

if gcloud compute disks list --filter="-users:*" --uri | grep "Listed 0 items."; then
    gcloud compute disks list --filter="-users:*" --uri  | xargs gcloud compute disks delete --quiet
else
    echo "No unattached disks to delete"
fi