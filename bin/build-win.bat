@echo off

if not exists build\win (
    mkdir build\win
    )

cd build\win

CMAKE="cmake"

%CMAKE% ^
    -DBUILD_WIN=TRUE ^
    -DCMAKE_BUILD_TYPE=Release ^
    ..\..

%CMAKE% --build . --target install --config Release
