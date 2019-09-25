#!/bin/bash

find debs -iname "*.deb" -exec ./01-unpack-deb.sh {} \;

