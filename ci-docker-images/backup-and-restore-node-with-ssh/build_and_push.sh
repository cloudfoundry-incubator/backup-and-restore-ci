#!/bin/bash

set -eux

cd "$(dirname "$0")"


docker build . -t cloudfoundrylondon/backup-and-restore-node-with-ssh:latest
docker push cloudfoundrylondon/backup-and-restore-node-with-ssh
