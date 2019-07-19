#!/usr/bin/env bash
set -euo pipefail

nameserver="$( jq -r '.resources[0].instances[0].attributes.name_servers[0]' terraform/terraform.tfstate )"
nameserver="$( grep -Po '(ns-cloud-[a-z])' <<< "$nameserver" )"

if ! dig "$ADDRESS" | grep "$nameserver"; then
  2>&1 echo "could not resolve ${ADDRESS} through gcp nameservers"
fi

