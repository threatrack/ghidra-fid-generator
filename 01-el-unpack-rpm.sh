#!/bin/bash

if [[ $# -ne 1 ]]; then
	echo "usage: ${0} <rpm>"
	exit 1
fi

rpmfile=$(readlink -f ${1})
pkg=$(echo ${rpmfile} | grep -o "[^\/]*\.rpm")
name=$(echo ${pkg} | sed 's/^\(.*\)-\([^-]\+\)-\(.\+\)\.rpm$/\1/g')
version=$(echo ${pkg} | sed 's/^\(.*\)-\([^-]\+\)-\(.\+\)\.rpm$/\2/g')
release=$(echo ${pkg} | sed 's/^\(.*\)-\([^-]\+\)-\(.\+\)\.rpm$/\3/g')
el=$(echo ${pkg} | grep -o "el8\|el7\|el6\|el5\|el4\|el3\|el2")
arch=$(echo ${pkg} | grep -o "x86_64\|i686\|i586\|i486\|i386")
path="lib/${el}/${name}/${version}/${release}"

mkdir -p "${path}"
path=$(readlink -f "${path}")
tmp=$(mktemp -p . -d "tmp.XXXXXXXXXXXXXXX")
cd "${tmp}"
rpm2cpio "${rpmfile}" | cpio -idmv
find "$(pwd)" -iname "*.a" -exec mv {} "${path}/." \;
cd ..
rm -rf "${tmp}"

