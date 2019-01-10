#!/usr/bin/env bash
# Makes a docker image from a warden stemcell

set -eu

version="170.16"

wget -O stemcell.tgz "https://bosh.io/d/stemcells/bosh-warden-boshlite-ubuntu-xenial-go_agent?v=$version"
tar xvf stemcell.tgz

docker login --username "$DOCKER_USERNAME" --password "$DOCKER_PASSWORD"
sha=$(docker import image | cut -d':' -f2)

docker tag "$sha" "cloudfoundrylondon/backup-and-restore-bosh-stemcell:latest"
docker push "cloudfoundrylondon/backup-and-restore-bosh-stemcell:latest"

docker tag "$sha" "cloudfoundrylondon/backup-and-restore-bosh-stemcell:$version"
docker push "cloudfoundrylondon/backup-and-restore-bosh-stemcell:$version"
