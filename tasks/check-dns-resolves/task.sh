#!/usr/bin/env bash
set -euo pipefail
set -x

nameserver="$(jq -r .resources[0].instances[0].attributes.name_servers[0] terraform/terraform.tfstate)"

nameserver="$(grep -Po '(ns-cloud-[a-z])' <<< "$nameserver")"

dig "$ADDRESS" | grep "$nameserver"

