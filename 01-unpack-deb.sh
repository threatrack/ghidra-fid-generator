#!/bin/bash

if [[ $# -ne 1 ]]; then
	echo "usage: ${0} <deb>"
	exit 1
fi

debfile=$(readlink -f ${1})
pkg=$(echo ${debfile} | grep -o "[^\/]*\.deb")
name=$(echo ${pkg} | sed 's/^\(.*\)-\([^-]\+\)-\(.\+\)\.deb$/\1/g')
version=$(echo ${pkg} | sed 's/^\(.*\)-\([^-]\+\)-\(.\+\)\.deb$/\2/g')
release=$(echo ${pkg} | sed 's/^\(.*\)-\([^-]\+\)-\(.\+\)\.deb$/\3/g')
dist=$(echo ${pkg} | grep -o "ubuntu")
path="lib/${dist}/${name}/${version}/${release}"

mkdir -p "${path}"
path=$(readlink -f "${path}")
tmp=$(mktemp -p . -d "tmp.XXXXXXXXXXXXXXX")
cd "${tmp}"
ar x "${debfile}"
tar -xf data.tar.*
find "$(pwd)" -iname "*.a" -exec mv {} "${path}/." \;
cd ..
rm -rf "${tmp}"

