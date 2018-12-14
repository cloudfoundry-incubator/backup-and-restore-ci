#!/usr/bin/env bash
# Makes a docker image from a warden stemcell

set -eux

: "${1?"Invalid Usage: $0 version_of_stemcell"}"

eval "$(ssh-agent)"
github_ssh_key=$(mktemp)
# shellcheck disable=2153
echo "$GITHUB_SSH_KEY" > "$github_ssh_key"
chmod 400 "$github_ssh_key"
ssh-add "$github_ssh_key"

pushd "$(dirname "$0")"
  VERSION=$1

  mkdir workspace
  pushd workspace
    wget "https://s3.amazonaws.com/bosh-warden-stemcells/bosh-stemcell-$VERSION-warden-boshlite-ubuntu-trusty-go_agent.tgz"
    tar xvf "bosh-stemcell-$VERSION-warden-boshlite-ubuntu-trusty-go_agent.tgz"
    SHA=$(docker import image | cut -d':' -f2)
    docker tag "$SHA" "cloudfoundrylondon/backup-and-restore-bosh-stemcell:$VERSION"
    docker push "cloudfoundrylondon/backup-and-restore-bosh-stemcell:$VERSION"
  popd
  rm -rf workspace
  public: true
popd
