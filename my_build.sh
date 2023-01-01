#!/bin/bash

uname | grep -qe "MSYS_NT"
if [[ $? -ne 0 ]]; then
	>&2 echo "Must be run on MSYS2"
	exit 1
fi

set -e

BIN_PATH="/usr/local/bin"
PATTERN="luajit-2.1.*.exe"
SYMLINK="luajit.exe"

make amalg install

echo
echo "========"

LATEST="$(ls -1tr "${BIN_PATH}/"${PATTERN} | tail -n1)"
echo "latest luajit-2.1 is ${LATEST}"

# second grep is safety check
ls -1tr "${BIN_PATH}/"${PATTERN} | \
	grep -v "${LATEST}" | \
	grep -F "luajit-2.1." | \
	xargs -rn10 rm

TARGET="$(basename $(readlink -f "${BIN_PATH}/${SYMLINK}"))"
NEW_TARGET="$(basename "${LATEST}")"

if [[ "${TARGET}" != "${NEW_TARGET}" ]]; then
	echo "linking ${SYMLINK} to ${NEW_TARGET}"
	cd "${BIN_PATH}"
	ln -sfT "./${NEW_TARGET}" "./${SYMLINK}"
else
	echo "${SYMLINK} already links to ${NEW_TARGET}"
fi
