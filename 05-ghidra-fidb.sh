#!/bin/bash

if [[ ! $GHIDRA_HOME ]]; then
	echo "Must set \$GHIDRA_HOME, e.g. via:"
	echo "export GHIDRA_HOME=/home/user/ghidra/ghidra_9.0.4"
	exit 1
fi
if [[ ! $GHIDRA_PROJ ]]; then
	echo "Must set \$GHIDRA_PROJ, e.g. via:"
	echo "export GHIDRA_PROJ=/home/user/ghidra_projects"
	exit 1
fi

ghidra_path="${GHIDRA_HOME}"
ghidra_headless="${ghidra_path}/support/analyzeHeadless"
ghidra_scripts="${ghidra_path}/Ghidra/Features/FunctionID/ghidra_scripts"
ghidra_proj="${GHIDRA_PROJ}"
proj="lib-fidb"

if [[ $# -lt 1 ]]; then
	echo "usage: ${0} <path> [langid]"
	exit 1
fi

libpath="${1}"
provider=$(basename $(readlink -f ${libpath}))

mkdir -p "fidb"
mkdir -p "log"

rm "log/duplicate_results.txt"
touch "log/duplicate_results.txt"

cat "lib/${provider}-langids.txt" | while read langid; do 
langid_dots="$(echo "${langid}" | sed 's/:/./g')"

"${ghidra_headless}" "${ghidra_proj}" "${proj}" -noanalysis -scriptPath ghidra_scripts -preScript AutoCreateMultipleLibraries.java log/duplicate_results.txt true fidb "${provider}-${langid_dots}.fidb" "/${provider}" lib/${provider}-common.txt "${langid}"

done

# TODO: `Ghidra/Features/FunctionID/data/building_fid.txt` says the included .fidb files were cleaned up with the follow two scripts:
echo "Please check the generated fidb/${os_arch}.fidb and manually run RemoveFunctions.java on it."
echo "Then run RepackFid.java to export it for distribution."


