# Compile on Linux (Debian/Ubuntu)
Tested on "Linux debian 3.16 i686"

Dependencies - Required packages
cmake
gcc (should be installed with cmake)
git-core
g++ (C++ compiler)
libgl1-mesa-dev (OpenGL development libraries)
xorg-dev

sudo apt-get install cmake git-core g++ libgl1-mesa-dev xorg-dev

# Debugging
List the executable dependencies 
ldd <executable>
Check that the rpath are correct using patchelf
patchelf --print-rpath <executable>
Display ELF executable information
readelf -d <executabl>