# GLFW
Optional builds have been disabled (e.g. examples,tests). See glfw/CMakeLists.txt

# Linux 

To view the executable shared library dependencies use the ldd command.
Use patchelf to list and modify the binary RPATH.

# OSX RPath Support

For debugging purposes, it is useful to know the following:

To view the install name of a shared library, use "otool -D <file>"
To view the install name of dependent shared libraries, use "otool -L <file>"
To view the RPATHs for locating dependent shared libraries using @rpath, use "otool -l <file> | grep LC_RPATH -A2"
To modify RPATHs, use install_name_tool's -rpath, -add_rpath, and -delete_rpath options.

References
http://www.kitware.com/blog/home/post/510
