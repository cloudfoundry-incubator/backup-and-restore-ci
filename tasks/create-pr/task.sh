#!/usr/bin/env bash

set -euo pipefail

read -r -d '' MESSAGE << EOM
This is an automatically generated Pull Request from the Cryogenics CI Bot.

I have updated the release notes with the latest release and it's contents.

If this doesn't look right, please reach out to the #mapbu-cryogenics team.
EOM

pushd repo
  git checkout $BRANCH

  gh auth login --with-token < <(echo $GITHUB_TOKEN)
  gh pr create --base $BASE --title "$MESSAGE"
popd
