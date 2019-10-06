#!/bin/bash

libpath="$(pwd)/lib"

provider="sigmoid"

cd ${provider}
ls | while read f; do
	if echo "${f}" | grep "\.tar\.gz$"; then
		dir=$(echo ${f} | sed 's/\.tar.gz//g')
		mkdir -p "${dir}"
		tar -xf "${f}" -C "${dir}"
	elif echo "${f}" | grep "\.zip$"; then
		dir=$(echo ${f} | sed 's/\.zip//g')
		mkdir -p "${dir}"
		unzip -o "${f}" -d "${dir}"
	elif echo "${f}" | grep "\.7z$"; then
		dir=$(echo ${f} | sed 's/\.7z//g')
		mkdir -p "${dir}"
		7z -y x "${f}" -o"${dir}"
	else
		continue
	fi
	lib=$(echo "${dir}" | sed 's/\([^-]\+\)-\([^-]\+\)-\([^-]\+\)/\1/g')
	ver=$(echo "${dir}" | sed 's/\([^-]\+\)-\([^-]\+\)-\([^-]\+\)/\2/g')
	var=$(echo "${dir}" | sed 's/\([^-]\+\)-\([^-]\+\)-\([^-]\+\)/\3/g')
	path="${libpath}/${provider}/${lib}/${ver}/${var}"
	mkdir -p "${path}"

	cd "${dir}"
	find -type f -not -iname '*.lib' -and -not -iname '*.a' -exec rm {} \;
	cp -R . "${path}/."
	cd ..
done
cd ..

