#!/bin/bash

mkdir -p ${1}
cd ${1}
cat ../${1}.txt | while read url; do
	wget -c "${url}"
done

