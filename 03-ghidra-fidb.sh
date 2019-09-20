#!/bin/bash

if [[ ! $GHIDRA_HOME ]]; then
	echo "Must set \$GHIDRA_HOME, e.g. via:"
	echo "export GHIDRA_HOME=/home/user/ghidra/ghidra_9.0.4"
	exit 1
fi
if [[ ! $GHIDRA_PROJ ]]; then
	echo "Must set \$GHIDRA_PROJ, e.g. via:"
	echo "export GHIDRA_PROJ=/home/user/ghidra-proj"
	exit 1
fi

ghidra_path="${GHIDRA_HOME}"
ghidra_headless="${ghidra_path}/support/analyzeHeadless"
ghidra_scripts="${ghidra_path}/Ghidra/Features/FunctionID/ghidra_scripts"
ghidra_proj="${GHIDRA_PROJ}"
proj="el-fidb"

if [[ $# -ne 1 ]]; then
	echo "usage: ${0} <path>"
	exit 1
fi

libpath="${1}"
langid="x86:LE:32:default"
os_arch=$(basename $(readlink -f ${libpath}))
if echo "${os_arch}" | grep -q -E "x86_64\$"; then
	langid="x86:LE:64:default"
fi

mkdir -p "fidb"
rm -f "fidb/${os_arch}.fidb"
mkdir -p "log"

touch "log/common.txt"
touch "log/duplicate_results.txt"

# TODO: actually use common.txt
"${ghidra_headless}" "${ghidra_proj}" "${proj}" -noanalysis -scriptPath ghidra_scripts -preScript AutoCreateMultipleLibraries.java log/duplicate_results.txt true fidb "/${os_arch}" log/common.txt "${langid}"

# TODO: `Ghidra/Features/FunctionID/data/building_fid.txt` says the included .fidb files were cleaned up with the follow two scripts:
# RemoveFunctions.java
# RepackFid.java


