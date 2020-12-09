#!/usr/bin/env bash
set -euo pipefail

nameserver="$( jq -r '.modules[0].resources."google_dns_managed_zone.zone".primary.attributes."name_servers.0"' terraform/terraform.tfstate )"
nameserver="$( grep -Po '(ns-cloud-[a-z])' <<< "$nameserver" )"

dns_resolution="$( dig "$ADDRESS" )"

if ! grep "$nameserver" <<< "$dns_resolution"; then
  2>&1 echo "could not resolve ${ADDRESS} through gcp nameservers"
  2>&1 echo "$dns_resolution"
  exit 1
fi

