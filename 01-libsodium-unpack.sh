#!/bin/bash

lib="$(pwd)/lib"

cd libsodium
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
	ver=$(echo "${dir}" | sed 's/libsodium-\([^-]\+\)-\(.*\)/\1/g')
	var=$(echo "${dir}" | sed 's/libsodium-\([^-]\+\)-\(.*\)/\2/g')
	path="${lib}/libsodium/libsodium/${ver}/${var}"
	mkdir -p "${path}"

	cd "${dir}"
	find -type f -not -iname '*.lib' -and -not -iname '*.a' -exec rm {} \;
	cp -R * "${path}/."
	cd ..
done
cd ..

