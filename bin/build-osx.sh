if ! [ -d "build/osx" ]
then
   mkdir -p "build/osx"
fi
cd build/osx

# Generate build system using the XCode generator.
# Should also work using the "Unix Makefiles" generator.
cmake -G "Xcode" \
    -DBUILD_OSX=TRUE \
    -DCMAKE_BUILD_TYPE=Release \
    ../..

# Build and install the project using the Release config
cmake --build . --target install --config Release

