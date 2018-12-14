#!/usr/bin/env bash
# Makes a docker image from a warden stemcell

set -eu

UBUNTU="xenial"
VERSION="170.13"

wget "https://s3.amazonaws.com/bosh-core-stemcells/bosh-stemcell-$VERSION-warden-boshlite-ubuntu-$UBUNTU-go_agent.tgz"
tar xvf "bosh-stemcell-$VERSION-warden-boshlite-ubuntu-$UBUNTU-go_agent.tgz"

docker login --username "$DOCKER_USERNAME" --password "$DOCKER_PASSWORD"
SHA=$(docker import image | cut -d':' -f2)
docker tag "$SHA" "cloudfoundrylondon/backup-and-restore-bosh-stemcell:latest"
docker push "cloudfoundrylondon/backup-and-restore-bosh-stemcell:latest"
docker tag "$SHA" "cloudfoundrylondon/backup-and-restore-bosh-stemcell:$VERSION"
docker push "cloudfoundrylondon/backup-and-restore-bosh-stemcell:$VERSION"

