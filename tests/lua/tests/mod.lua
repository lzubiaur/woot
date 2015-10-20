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

-- Test LuaJIT FFI binding
local fileutil = require 'engine.fileutil'
local ffi      = require 'ffi'
-- C declaration
ffi.cdef [[
    void test_C_module_binding();
]]
-- Load the module
local tests = ffi.load(fileutil.getModulePath('tests'))
-- Call the C function
tests.test_C_module_binding()
