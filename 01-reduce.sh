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

mv el6.x86_64 el6.x86_64.full
mkdir el6.x86_64
cd el6.x86_64.full
cp -R openssl-static boost-static glibc-static zlib-static lua-static ../el6.x86_64/.
cd ..

mv el6.i686 el6.i686.full
mkdir el6.i686
cd el6.i686.full
cp -R openssl-static boost-static glibc-static zlib-static lua-static ../el6.i686/.
cd ..

cd .. # el

