#!/bin/bash

mkdir -p lib/uclibc/uclibc/0.9.30.1/binaries/
cd uclibc
ls *.tar.bz2 | while read f; do
	dir=$(echo ${f} | sed 's/\.tar\.bz2//g;s/mini-native-//g')
	mkdir -p "${dir}"
	tar -xf "${f}" -C "${dir}"
	cd ${dir}
	find -type f -not -iname '*.lib' -and -not -iname '*.a' -exec rm {} \;
	cd ..
	cp -r ${dir} ../lib/uclibc/uclibc/0.9.30.1/binaries/.
done

