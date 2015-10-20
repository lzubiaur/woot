local ffi = require 'ffi'

ffi.cdef [[
enum {
    GL_DEPTH_BUFFER_BIT               = 0x00000100,
    GL_STENCIL_BUFFER_BIT             = 0x00000400,
    GL_COLOR_BUFFER_BIT               = 0x00004000
};
    typedef float GLclampf;
    typedef int GLint;
    typedef int GLsizei;
    typedef unsigned int GLbitfield;
    void glClear (GLbitfield mask);
    void glViewport (GLint x, GLint y, GLsizei width, GLsizei height);
    void glClearColor (GLclampf red, GLclampf green, GLclampf blue, GLclampf alpha);
]]
return ffi.load(ffi.os == 'OSX' and 'OpenGL.framework/OpenGL' or 'GL')
