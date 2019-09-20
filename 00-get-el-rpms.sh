#!/bin/bash
if [ ! -f filelist ]; then
	wget http://mirror.centos.org/centos/filelist.gz
	gzip -d filelist.gz
fi

mkdir -p rpms
cd rpms
cat ../filelist | grep "\-static\-.*\.rpm$" | while read rpm; do
	wget -c "http://mirror.centos.org/centos/${rpm}"
done

