if ! [ -d "build" ]
then
    mkdir build
fi
cd build

if ! [ -d "build-osx" ]
then
    mkdir build-osx
fi
cd build-osx

#    -DCMAKE_INSTALL_PREFIX=$libprefix \

# cmake -G "Xcode" \
cmake \
    -DBUILD_OSX=TRUE \
    -DCMAKE_BUILD_TYPE=Release \
    ../..

cmake --build . --target install --config Release

