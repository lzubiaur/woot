### Introduction

> This is a *work-in-progress* project and is subject to change without notice.

**Woot** is a cross-platform Lua 2D game engine. Targeted platforms are Mac OS X, Linux and Windows.

### Build from source

To build the project from source run the `build-<platform>` script from the project root folder. To build on Linux enter the following commands. You will need at least git, cmake and gcc already installed on your Linux system.

```
git clone http://github.com/lzubiaur/woot
cd woot
./bin/build-linux.sh
```

To build on OSX use `./bin/build-osx.sh` and `.\bin\build-win.bat` on Windows. By default the project is built in `build/<platform>` and installed in `product`. Please see the platform specific requirements in the [docs](docs) subfolder.

### Test

### Binary distribution

Binary distribution will be available for all supported platforms.
