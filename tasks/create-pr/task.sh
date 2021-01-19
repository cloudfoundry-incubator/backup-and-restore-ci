#!/usr/bin/env bash

set -euo pipefail

apt update
apt-get install -y software-properties-common
apt-key adv --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0
apt-add-repository https://cli.github.com/packages
apt update
apt install -y gh

pushd repo
  gh auth login --with-token < <(echo $GITHUB_TOKEN)
  gh pr create --fill --base $BASE
popd
