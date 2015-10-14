### Build on Windows

Build tested on Windows 10 (32bits) using Visual Studio Express 2015.

Open a git bash

```
git clone http://github.com/lzubiaur/woot
cd woot
./bin/build-linux.sh
```

### Requirements

* CMake (3.3)
* Git (only to clone the project)
* Visual Studio Express 2015 (for Desktop)

### Debug

If ```build-win.bat``` can't find the CMake executable (cmake.exe) please make sure the CMake bin directory is set in your PATH environment variable.
If not add to the current console session it as follow.

```
set PATH=<path-to-cmake-install>\bin;%PATH%
```
