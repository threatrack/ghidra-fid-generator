#!/bin/bash

find rpms -iname "*.rpm" -exec ./01-unpack-rpm.sh {} \;

