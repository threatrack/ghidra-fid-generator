#!/bin/bash

if [[ $# -ne 1 ]]; then
	echo "usage: ${0} <lib>"
	exit 1
fi

path="$(pwd)/${1}"
common="$(pwd)/${1}-common.txt"

cd "${path}"
find "$(pwd)" -regex ".*\.\(lib\|a\)" | while read lib; do
	echo "${lib} ##########################################################"
	subdir=$(echo "${lib}" | sed 's/\.\(a\|lib\)//g')
	if ! 7z -y x "${lib}" -o"${subdir}"; then
		echo "7z ERROR #####################################################"
		mkdir "${subdir}"
	fi
	# fixup names. some .lib contain files with \ in names.
	# 7z doesn't extract these to dirs but includes the \ in name
	# for Ghidra \ = / ... so we must replace \ with _
	find . -name '*\\*' -type f -exec bash -c 't="${0//\\//}"; mkdir -p "${t%/*}"; mv -v "$0" "$t"' {} \;
	cd "${subdir}"
	cat *.txt | awk '{print $2}' >> ${common}
	find -type f -not -iname '*.o' -and -not -iname '*.obj' -exec rm {} \;
	rm -rf "${lib}"
done
sort -u ${common} -o ${common}

