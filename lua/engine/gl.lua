local fileutil = require 'engine.fileutil'
local ffi = require 'ffi'

require 'engine.gl_h'

-- return ffi.load(ffi.os == 'OSX' and 'OpenGL.framework/OpenGL' or 'GL')
return ffi.load(fileutil.getModulePath('gl3w'))
