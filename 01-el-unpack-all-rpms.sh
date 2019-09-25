#!/bin/bash

find rpms -iname "*.rpm" -exec ./01-el-unpack-rpm.sh {} \;

