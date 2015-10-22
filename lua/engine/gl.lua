local fileutil = require 'engine.fileutil'
local ffi      = require 'ffi'

require 'engine.gl_h'

-- return ffi.load(ffi.os == 'OSX' and 'OpenGL.framework/OpenGL' or 'GL')
local bind = ffi.load(fileutil.getModulePath('gl3w'))

local mt = {
    __index = bind
}
local mod = {}
setmetatable(mod,mt)

function mod.createShader(source, type)
    local buf  = ffi.new('char[?]', #source, source)
    local pbuf = ffi.new('const char*[1]', buf)
    local shader = bind.glCreateShader(type)
    bind.glShaderSource(shader, 1, pbuf, nil)
    bind.glCompileShader(shader)

    -- Checking if a shader compiled successfully
    local status = ffi.new('GLint[1]',0)
    bind.glGetShaderiv(shader, bind.GL_COMPILE_STATUS, status)

    -- TODO write to logging system instead of stdout
    local status = tonumber(status[0])
    if status ~= bind.GL_TRUE then
        -- Retrieving the compile log
        -- TODO get required buffer
        local buffer = ffi.new 'char[512]'
        bind.glGetShaderInfoLog(shader, 512, nil, buffer)
        -- Write error log
        print('Compile shader FAILED.')
        print(ffi.string(buffer))
    end

    return shader
end

function mod.createProgram(vert, frag)
    local program = bind.glCreateProgram()

    local vertexShader   = mod.createShader(vert, bind.GL_VERTEX_SHADER)
    local fragmentShader = mod.createShader(frag, bind.GL_FRAGMENT_SHADER)

    bind.glAttachShader(program, vertexShader)
    bind.glAttachShader(program, fragmentShader)

    bind.glLinkProgram(program)
    local errnum = tonumber(bind.glGetError())
    if errnum ~= 0 then
        print('Link program FAILED: ', errnum)
    end

    return program
end

return mod
