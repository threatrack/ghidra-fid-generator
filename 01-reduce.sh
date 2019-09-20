#!/bin/bash

cd el
mv el7.i686 el7.i686.full
mkdir el7.i686
cd el7.i686.full
cp -R openssl-static boost-static glibc-static libstdc++-static libgo-static protobuf-static protobuf-lite-static zlib-static lua-static ../el7.i686/.
cd ..

mv el7.x86_64 el7.x86_64.full
mkdir el7.x86_64
cd el7.x86_64.full
cp -R openssl-static boost-static glibc-static libstdc++-static libgo-static protobuf-static protobuf-lite-static zlib-static lua-static ../el7.x86_64/.
cd ..

