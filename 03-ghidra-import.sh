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

if [[ $# -ne 1 ]]; then
	echo "usage: ${0} <path>"
	exit 1
fi

libpath="${1}"
provider=$(basename $(readlink -f ${libpath}))

"${ghidra_headless}" "${ghidra_proj}"  "${proj}" -import "${libpath}" -recursive -preScript FunctionIDHeadlessPrescript.java -postScript FunctionIDHeadlessPostscript.java | tee -a "lib/${provider}-headless.log"


