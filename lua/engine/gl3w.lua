local ffi = require 'ffi'
local fileutil = require 'engine.fileutil'

ffi.cdef [[
    typedef void (*GL3WglProc)(void);

    int gl3wInit(void);
    int gl3wIsSupported(int major, int minor);
    GL3WglProc gl3wGetProcAddress(const char *proc);
]]

return ffi.load(fileutil.getModulePath('gl3w'))
