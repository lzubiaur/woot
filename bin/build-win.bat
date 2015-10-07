@echo off

if not exist build\win (
    mkdir build\win
    )

pushd build\win

cmake.exe ^
    -DBUILD_WIN=TRUE ^
    -DCMAKE_BUILD_TYPE=Release ^
    ..\..

cmake.exe --build . --target install --config Release

popd
