#!/bin/bash

mkdir -p teskalabs
cd teskalabs
cat ../teskalabs.txt | while read url; do
	wget -c "${url}"
done

