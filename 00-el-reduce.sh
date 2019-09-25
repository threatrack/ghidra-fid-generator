#!/bin/bash

cd rpms
ls | grep -v "^\(openssl-static\|boost-static\|boost159-static\|glibc-static\|libstdc++-static\|libgo-static\|protobuf-static\|protobuf-lite-static\|zlib-static\|lua-static\|libpng-static\|libjpeg-turbo-static\|glib2-static\|libsodium-static\|libtiff-static\|libusb1\?-static\|gcc\)" | while read f; do rm $f; done

