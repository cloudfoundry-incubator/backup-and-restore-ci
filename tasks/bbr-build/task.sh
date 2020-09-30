#!/bin/bash

set -eu

eval "$(ssh-agent)"
chmod 400 bosh-backup-and-restore-meta/keys/github
ssh-add bosh-backup-and-restore-meta/keys/github

VERSION=$(cat bosh-backup-and-restore-meta/bbr-current-release/version)
export VERSION

BBR_REPO="bosh-backup-and-restore"
pushd "$BBR_REPO"
  make release
popd

echo "BBR successfully built. Copying to release directory..."

cp -r "$BBR_REPO/releases" bbr-release

echo "Auto-delivered in
https://s3-eu-west-1.amazonaws.com/bosh-backup-and-restore-builds/bbr-$VERSION.tar

[Backup and Restore Bot]" > bbr-build/message

echo "Moving linux binary to the build directory..."

LINUX="bbr-$VERSION-linux-amd64"
mv "$BBR_REPO"/releases/bbr bbr-build/"$LINUX"
cat "$BBR_REPO"/releases/checksum.sha256 | cut -d' ' -f1  | sed -n '1p' > bbr-build/"$LINUX".sha256

echo "Moving mac binary to the build directory..."

DARWIN="bbr-$VERSION-darwin-amd64"
mv "$BBR_REPO"/releases/bbr-mac bbr-build/"$DARWIN"
cat "$BBR_REPO"/releases/checksum.sha256 | cut -d' ' -f1  | sed -n '2p' > bbr-build/"$DARWIN".sha256

echo "Done building BBR"
