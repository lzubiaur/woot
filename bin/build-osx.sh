#!/bin/sh

if ! [ -f "lib/gl3w/src/gl3w.c" ]; then
  pushd lib/gl3w 
  ./gl3w_gen.py
  popd
fi

if ! [ -d "build/osx" ]
then
   mkdir -p "build/osx"
fi
cd build/osx

msg=" --------------------- BUILD SUCCEEDED ---------------------"

# Generate build system using the XCode generator.
# Should also work using the "Unix Makefiles" generator.
cmake -G "Xcode" \
    -DBUILD_OSX=TRUE \
    -DCMAKE_BUILD_TYPE=Release \
    ../..

# Build and install the project using the Release config
cmake --build . --target install --config Release && echo $msg
