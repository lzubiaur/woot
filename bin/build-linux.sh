#!/bin/sh
if ! [ -d "build/linux" ]; then 
    mkdir -p "build/linux"
fi
cd build/linux

export CXX="gcc"

# Use default cmake
CMAKE="cmake"

$CMAKE \
    -DBUILD_LINUX=TRUE \
    -DCMAKE_BUILD_TYPE=Release \
    ../..

$CMAKE --build . --target install --config Release
