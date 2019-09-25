#!/bin/bash

if [[ $# -ne 1 ]]; then
	echo "usage: ${0} <path>"
	exit 1
fi

libpath="${1}"
provider=$(basename $(readlink -f ${libpath}))

cat "lib/${provider}-headless.log" | grep -o "INFO  REPORT: Import succeeded with language \".*\" and cspec" | grep -o "\".*\"" | sed 's/"//g' | sort -u > "lib/${provider}-langids.txt"

