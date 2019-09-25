#!/bin/bash
if [[ $# -ne 1 ]]; then
	echo "usage: ${0} <yum-repo-path>"
	echo
	echo "Possible yum repos:"
	echo "http://mirror.centos.org/centos/7/os/x86_64/"
	echo "https://dl.fedoraproject.org/pub/epel/7/x86_64/"
	exit 1
fi

baseurl="${1}"
repomd="$(echo "${baseurl}" | sha256sum | awk '{print $1}')-primary.xml"
if [ ! -f "${repomd}" ]; then
	primary=$(wget "${baseurl}/repodata/repomd.xml" -O - | grep -o "repodata/[A-Za-z0-9]*-primary\.xml\.gz")
	wget "${baseurl}/${primary}" -O "${repomd}.gz"
	gzip -d "${repomd}"
fi

mkdir -p rpms
cd rpms
cat ../${repomd} | grep "<location href=\"Packages/.*>" | grep -o "Packages/.*\.rpm" |
#grep "\-static\-.*\.rpm$\|/gcc" | while read rpm; do
grep "gcc" |
grep -v "gcc-c++" |
while read rpm; do
	wget -c "${baseurl}/${rpm}"
done

