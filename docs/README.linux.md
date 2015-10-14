### Build on Linux (Debian/Ubuntu)
Tested on debian 8 (jessie) and Ubuntu 15.04 64bit.

### Dependencies - Required packages
cmake (3.3)
gcc (should be installed with cmake)
git-core
g++ (C++ compiler)
libgl1-mesa-dev (OpenGL development libraries)
xorg-dev

```
sudo apt-get install cmake git-core g++ libgl1-mesa-dev xorg-dev
```

### Debugging

List the executable dependencies
ldd <executable>

Check that the rpath are correct using patchelf
patchelf --print-rpath <executable>

Display ELF executable information
readelf -d <executabl>
