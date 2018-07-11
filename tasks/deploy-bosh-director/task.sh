#!/usr/bin/env bash

set -e

export tmp_ssh_key
tmp_ssh_key=$(mktemp)
echo "$GIT_SSH_KEY" > tmp_ssh_key
chmod 400 tmp_ssh_key
eval "$(ssh-agent)"
ssh-add tmp_ssh_key

mkdir -p ~/.ssh/
echo "$GITHUB_PUBLIC_KEY" >> ~/.ssh/known_hosts

set -x

TEST_RELEASE_PATH=$(readlink -f dummy-bbr-script-release-bucket/test-bosh-backup-and-restore-release-*.tgz)

bosh-cli create-env \
  "bosh-backup-and-restore-meta/${DIRECTOR_ENV}/bosh.yml" \
  --var=test-release-path="file://${TEST_RELEASE_PATH}" \
  --vars-store="bosh-backup-and-restore-meta/${DIRECTOR_ENV}/creds.yml"

cd bosh-backup-and-restore-meta

git checkout master
git add "${DIRECTOR_ENV}/bosh-state.json"

if [ -f "${DIRECTOR_ENV}/creds.yml" ]; then
  git add "${DIRECTOR_ENV}/creds.yml"
fi

git config --global user.name "PCF Backup & Restore CI"
git config --global user.email "cf-lazarus@pivotal.io"

if git commit -m "Update bosh state for ${DIRECTOR_ENV} director" ; then
  while true ; do
    git pull --rebase
    if git push ; then
      break
    fi
  done
else
  echo "No deploy occurred; bailing out"
fi
