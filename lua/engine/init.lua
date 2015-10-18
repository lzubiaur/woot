-- C module (shared library) search path
package.cpath = '../MacOS/lib?.dylib;./bin/lib?.so;./bin/?.dll'

require 'engine.fileutil'.init()

-- =============================================================================
-- Module loading

-- Load and open the LuaFileSystem
-- Note that C module can be loaded using `package.loadlib` instead of `require`
-- but loadlib does not perform any path searching unlike require.

-- Low level C module loading
-- local path = "../MacOS/liblfs.dylib"
-- local f = assert(package.loadlib('lfs', "luaopen_lfs"))
-- f()  -- actually open the library

-- Load Lua File System using `require`
local lfs = require 'lfs'
print('Current directory is ', lfs.currentdir())
