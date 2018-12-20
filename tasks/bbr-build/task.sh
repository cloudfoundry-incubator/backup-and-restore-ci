#!/bin/bash

set -eu

eval "$(ssh-agent)"
chmod 400 bosh-backup-and-restore-meta/keys/github
ssh-add bosh-backup-and-restore-meta/keys/github

export GOPATH=$PWD
export PATH=$PATH:$GOPATH/bin
VERSION=$(cat version/number)
export VERSION

BBR_REPO="src/github.com/cloudfoundry-incubator/bosh-backup-and-restore"
pushd "$BBR_REPO"
  make release
  tar -cvf bbr-"$VERSION".tar releases/*
popd

mv "$BBR_REPO"/bbr-"$VERSION".tar bbr-build/

echo "Auto-delivered in
https://s3-eu-west-1.amazonaws.com/bosh-backup-and-restore-builds/bbr-$VERSION.tar

[Backup and Restore Bot]" > bbr-build/message

LINUX=bbr-linux-amd64
mv "$BBR_REPO"/releases/bbr bbr-build/"$LINUX"
cat "$BBR_REPO"/releases/checksum.sha256 | cut -d' ' -f1  | sed -n '1p' > bbr-build/"$LINUX".sha265

DARWIN=bbr-darwin-amd64
mv "$BBR_REPO"/releases/bbr-mac bbr-build/"$DARWIN"
cat "$BBR_REPO"/releases/checksum.sha256 | cut -d' ' -f1  | sed -n '2p' > bbr-build/"$DARWIN".sha265


