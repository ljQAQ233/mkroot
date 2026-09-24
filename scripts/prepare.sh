#!/bin/sh

ver=$1
url=$2
sha=$3

function err {
    echo $1
    exit 1
}

scripts="$(cd "$(dirname "$0")" && pwd)"

mkdir ".source"
mkdir ".source/${ver}"

cd ".source/${ver}"

file=$(echo "${url}" | sed 's|.*/||')

wget "${url}" -O "${file}" || err "cannot download ${url}"
echo "${sha} ${file}" > hash
sha256sum -c hash || err "sha256sum not match"
${scripts}/extract.sh "${file}" || err "cannot extract source"
