#!/usr/bin/env bash

set -eux -o pipefail

pushd repo
  latest_tag=$(git describe --abbrev=0 --tags)
  export COMMITS=$(git log ${latest_tag}..HEAD --oneline | grep -v "Merge" | cut -d ' ' -f2-| uniq -u)
popd

erb -T- template-folder/${TEMPLATE_PATH} > release-notes/release-notes.md
