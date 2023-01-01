#!/bin/bash

uname | grep -qe "Linux"
if [[ $? -ne 0 ]]; then
	>&2 echo "Must be run on Linux"
	exit 1
fi

set -e

CYGWIN_BRANCH="v2.1-cygwin"
CYGWIN_BASE="v2.1-cygwin-base"
UPSTREAM_BRANCH="v2.1"
UPSTREAM="upstream/${UPSTREAM_BRANCH}"

if [[ "$(git branch --show-current)" != "${CYGWIN_BRANCH}" ]]; then
	>&2 echo "Not on ${CYGWIN_BRANCH} branch"
	exit 1
fi

git fetch upstream --prune

merge_base="$(git merge-base "${CYGWIN_BRANCH}" "${UPSTREAM}")"
upstream_commit="$(git rev-parse "${UPSTREAM}")"

if [[ "${merge_base}" != "${upstream_commit}" ]]; then
	git rebase --onto "${UPSTREAM}" "${CYGWIN_BASE}"
fi

git fetch upstream "${UPSTREAM_BRANCH}:${CYGWIN_BASE}"
git fetch upstream "${UPSTREAM_BRANCH}:${UPSTREAM_BRANCH}"
# git push origin "${MINE_BRANCH}" # needs --force
git push origin "${UPSTREAM_BRANCH}"
