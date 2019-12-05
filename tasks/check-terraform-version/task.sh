#!/usr/bin/env bash

set -euo pipefail

main() {
	local upstream_version downstream_version semver_regex
	upstream_version="$( cat terraform-github-release/version )"
	downstream_version="$( terraform -version | head -n 1 | awk '{ print $2 }' | sed -e 's/v//')"
	semver_regex='^([0-9]+\.[0-9]+)\.([0-9]+)$'

	echo "Comparing Upstream and Downstream Terraform versions..."

	local upstream_major_minor upstream_patch
	if [[ "${upstream_version}" =~ ${semver_regex} ]]; then
		upstream_major_minor="${BASH_REMATCH[1]}"
		upstream_patch="${BASH_REMATCH[2]}"
	else
		echo "Non-semver format for upstream version '${upstream_version}'."
		exit 1
	fi

	local downstream_major_minor downstream_patch
	if [[ "${downstream_version}" =~ ${semver_regex} ]]; then
		downstream_major_minor="${BASH_REMATCH[1]}"
		downstream_patch="${BASH_REMATCH[2]}"
	else
		echo "Non-semver format for downstream version '${downstream_version}'."
		exit 1
	fi

	if [[ "${upstream_major_minor}" != "${downstream_major_minor}" ]]; then
		echo "Refusing to perform an automatic major or minor version bump to '${upstream_version}'."
		exit 1
	fi

	if [[ "${upstream_major_minor}" == "${downstream_major_minor}" ]]; then
		echo "Downstream version '${downstream_version}' is up-to-date!"
	elif [[ "${upstream_patch}" -gt "${downstream_patch}" ]]; then
		echo "Bumping to new patch version '${upstream_version}'!"
	else
		echo "Refusing to perform an automatic version bump to an older version."
		exit 1
	fi

	echo "{ \"TERRAFORM_VERSION\": ${upstream_version} }" > dockerbuild-env/env-file.json
}

main "${@}"
