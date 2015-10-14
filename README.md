![WOOT](/docs/logo.png)

### Introduction

**Woot** is a cross-platform Lua 2D game engine. Targeted platforms are Mac OS X, Linux and Windows.

This is a *work-in-progress* project and code/design will change frequently.

### Build from source

To build the project from source run the `build-<platform>` script from the project root folder. To build on Linux enter the following commands. You will need at least git, cmake and gcc already installed on your Linux system.

```
git clone http://github.com/lzubiaur/woot
cd woot
./bin/build-linux.sh
```

To build on OSX use `./bin/build-osx.sh` and `.\bin\build-win.bat` on Windows.

By default the project is built is `build/<platform>` and installed in `product`.

Please see platform specific requirements in the [docs](docs) subfolder.

### Binary distribution

Binary distribution will be available for all supported target platforms.
