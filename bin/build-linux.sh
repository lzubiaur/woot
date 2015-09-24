#!/bin/sh
if ! [ -d "build" ]
then
    mkdir build
fi
cd build

if ! [ -d "build-linux" ]
then
    mkdir build-linux
fi
cd build-linux

export CXX="gcc"

cmake \
    -DBUILD_LINUX=TRUE \
    -DCMAKE_BUILD_TYPE=Release \
    ../..

cmake --build . --target install --config Release
