#!/bin/bash

cd avr-libc
unzip -o avr-libc-bin-1.8.1.zip -d avr-libc-bin-1.8.1
cd avr-libc-bin-1.8.1
find -type f -not -iname '*.lib' -and -not -iname '*.a' -exec rm {} \;
cd ..
unzip -o avr-libc-bin-2.0.0.zip -d avr-libc-bin-2.0.0
cd avr-libc-bin-2.0.0
find -type f -not -iname '*.lib' -and -not -iname '*.a' -exec rm {} \;
cd ..
cd ../lib/
mkdir -p avr-libc
cd avr-libc
mkdir -p avr-libc/1.8.1
mkdir -p avr-libc/2.0.0
cp -r ../../avr-libc/avr-libc-bin-1.8.1 avr-libc/1.8.1/bin
cp -r ../../avr-libc/avr-libc-bin-2.0.0 avr-libc/2.0.0/bin

