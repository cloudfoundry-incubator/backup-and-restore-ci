#!/usr/bin/env bash

set -euo pipefail

if [ -z "${TITLE}"]
then
  TITLE="[CI Bot] Latest Release Notes"
fi

if [ -z "${MESSAGE}" ]
then
MESSAGE=$(cat <<-EOM
This is an automatically generated Pull Request from the Cryogenics CI Bot.

I have updated the release notes with the latest release and contents.

If this does not look right, please reach out to the #mapbu-cryogenics team.
EOM
)
fi

pushd repo
  git checkout $BRANCH

  gh auth login --with-token < <(echo $GITHUB_TOKEN)
  gh pr create --base $BASE --title "${TITLE}" --body "$MESSAGE"
popd
