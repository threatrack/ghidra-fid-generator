#!/bin/bash

lib="$(pwd)/lib"

cd teskalabs
ls | while read f; do
	if echo "${f}" | grep "\.tar\.gz$"; then
		dir=$(echo ${f} | sed 's/\.tar.gz//g')
		mkdir -p "${dir}"
		tar -xf "${f}" -C "${dir}"
	elif echo "${f}" | grep "\.zip$"; then
		dir=$(echo ${f} | sed 's/\.zip//g')
		mkdir -p "${dir}"
		unzip -o "${f}" -d "${dir}"
	else
		continue
	fi
	ver=$(echo "${dir}" | sed 's/openssl-dev-\([^-]\+\)-\(.*\)/\1/g')
	var=$(echo "${dir}" | sed 's/openssl-dev-\([^-]\+\)-\(.*\)/\2/g')
	path="${lib}/teskalabs/openssl-dev/${ver}/${var}"
	mkdir -p "${path}"

	cd "${dir}"
	find -type f -not -iname '*.lib' -and -not -iname '*.a' -exec rm {} \;
	cp -R openssl "${path}/."
	cd ..
done
cd ..

