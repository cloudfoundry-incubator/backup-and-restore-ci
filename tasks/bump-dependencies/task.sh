#!/usr/bin/env bash

set -eu

minimal_dockerfile="ci-docker-images/backup-and-restore-minimal/Dockerfile"

bump_golang() {
    golang_version=$(jq -r .env[1] golang-docker-image/metadata.json | cut --fields=2 --delimiter==)
    regex="s/ENV go_version.*$/ENV go_version ${golang_version}/"
    echo "$regex"
    sed -i "$regex" "backup-and-restore-minimal-repo/${minimal_dockerfile}"
    echo "golang v${golang_version}"
}

commit_changes() {
    pushd backup-and-restore-minimal-repo
        if [[ -n $(git status --porcelain $minimal_dockerfile) ]]; then
            git add $minimal_dockerfile
            git config --global user.name "PCF Backup & Restore CI"
            git config --global user.email "cf-lazarus@pivotal.io"
            if git commit -m "Update golang in backup-and-restore-minimal to v${golang_version}"; then
                echo "Updated backup-and-restore-minimal docker image"
            else
                echo "No changes to image"
            fi
        else
            echo "No change detected"
        fi
    popd
}

bump_golang
cat "backup-and-restore-minimal-repo/${minimal_dockerfile}"
commit_changes