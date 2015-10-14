-- ---------------------------------------------------------
-- fileutil.lua
-- Copyright (C) 2015 Laurent Zubiaur, voodoocactus.com
-- All Rights Reserved.
-- ---------------------------------------------------------

local jit = require 'jit'
local ffi = require 'ffi'

local fileutil = {}

function fileutil.getRealPath(name)
    local buf = ffi.new("uint8_t[?]", 1024)
    ffi.C.realpath(name,buf)
    return ffi.string(buf)
end

function fileutil.init()
    ffi.cdef [[
        char *realpath(const char *path, char *resolved_path);
    ]]

    if (jit.os == 'OSX') then
        fileutil.getModulePath = function(name)
            return '../MacOS/lib' .. name .. '.dylib'
        end
    elseif (jit.os == 'Linux') then
        fileutil.getModulePath = function(name)
            return './bin/lib' .. name .. '.so'
        end
    elseif (jit.os == 'Windows') then
        fileutil.getModulePath = function(name)
            return './bin/' .. name .. '.dll'
        end
    else
        error('Unsupported platform')
    end
end

-- Return this package
return fileutil
-- EOF
