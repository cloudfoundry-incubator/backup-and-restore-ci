#!/usr/bin/env bash

set -eux -o pipefail

pushd repo
  # find latest tag
  latest_tag=$(git describe --abbrev=0 --tags)
  # git lg from that tag to current
  export COMMITS=$(git log ${latest_tag}..HEAD  --format=' %n%B'  | grep -v "Signed-off-by" | grep -v '^$')
  export STORIES=$(echo -e "$COMMITS" | grep "\[\#" | sort | uniq | awk -F'[^0-9]*' '{print $2}' | xargs -IN echo https://www.pivotaltracker.com/story/show/N)
popd

erb -T- template-folder/${TEMPLATE_PATH} > release-notes/release-notes.md