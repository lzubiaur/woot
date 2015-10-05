-- ---------------------------------------------------------
-- fileutil.lua
-- Copyright (C) 2015 Laurent Zubiaur, voodoocactus.com
-- All Rights Reserved.
-- ---------------------------------------------------------

local jit = require 'jit'
local ffi = require 'ffi'

local fileutil = {}; fileutil.__index = fileutil

local header = [[
char *realpath(const char *path, char *resolved_path);
]]

setmetatable(fileutil,
{
    __call = function(t,k) -- Table, Key
        return setmetatable({
            -- var = nil,
        }, fileutil):init()
    end
})

function fileutil:getRealPath(name)
    local buf = ffi.new("uint8_t[?]", 1024)
    ffi.C.realpath(name,buf)
    return ffi.string(buf)
end

function fileutil:getModulePath(name)
    if (jit.os == 'OSX') then
        return '../MacOS/lib' .. name .. '.dylib'
    elseif (jit.os == 'Linux') then
        return '../bin/lib' .. name .. '.so'
    else
        assert(false,'Not implemented for this architecture: ' .. jit.os)
        -- Windows
    end
end

function fileutil:init()
    ffi.cdef(header)
    print(self:getRealPath("../MacOS"))
    return self
end

-- Return this package
return fileutil
-- EOF
