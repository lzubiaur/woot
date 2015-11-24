#!/bin/sh

if ! [ -f "lib/gl3w/src/gl3w.c" ]; then
  cd lib/gl3w 
  ./gl3w_gen.py
  cd ../..
fi

if ! [ -d "build/linux" ]; then
    mkdir -p "build/linux"
fi
cd build/linux

export CXX="gcc"

msg=" --------------------- BUILD SUCCEEDED ---------------------"

# Use default cmake
CMAKE="cmake"

$CMAKE \
    -DBUILD_LINUX=TRUE \
    -DCMAKE_BUILD_TYPE=Release \
    ../..

$CMAKE --build . --target install --config Release && echo $msg
