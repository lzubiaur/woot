-- Test image loading

local ffi = require 'ffi'
local fileutil = require 'engine.fileutil'

ffi.cdef [[
    void load_image(const char*filename);
]]

-- Test binding
local tests = ffi.load(fileutil.getModulePath('tests'))

tests.load_image('logo.jpg')

return {
    process = function()
    end,
    render = function()
    end
}
