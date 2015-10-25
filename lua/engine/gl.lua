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
    local shader = bind.createShader(type)
    bind.shaderSource(shader, 1, pbuf, nil)
    bind.compileShader(shader)

    -- Checking if a shader compiled successfully
    local status = ffi.new('GLint[1]',0)
    bind.getShaderiv(shader, bind.COMPILE_STATUS, status)

    -- TODO write to logging system instead of stdout
    local status = tonumber(status[0])
    if status ~= bind.TRUE then
        -- Retrieving the compile log
        -- TODO get required buffer
        local buffer = ffi.new 'char[512]'
        bind.getShaderInfoLog(shader, 512, nil, buffer)
        -- Write error log
        print('Compile shader FAILED.')
        print(ffi.string(buffer))
    end

    return shader
end

function mod.getError()
    local err = tonumber(bind.getError())
    while err ~= bind.NO_ERROR do
        if err == bind.INVALID_ENUM then
            print('OpenGL Error: GL_INVALID_ENUM', err)
        elseif err == bind.INVALID_VALUE then
            print('OpenGL Error: GL_INVALID_VALUE', err)
        elseif err == bind.INVALID_OPERATION then
            print('OpenGL Error: GL_INVALID_OPERATION', err)
        elseif err == bind.INVALID_FRAMEBUFFER_OPERATION then
            print('OpenGL Error: GL_INVALID_FRAMEBUFFER_OPERATION', err)
        elseif err == bind.OUT_OF_MEMORY then
            print('OpenGL Error: GL_OUT_OF_MEMORY', err)
        end
    end
end

function mod.createProgram(vert, frag)
    -- Purge error
    bind.getError()
    local program = bind.createProgram()

    local vertexShader   = mod.createShader(vert, bind.VERTEX_SHADER)
    local fragmentShader = mod.createShader(frag, bind.FRAGMENT_SHADER)

    bind.attachShader(program, vertexShader)
    bind.attachShader(program, fragmentShader)

    bind.linkProgram(program)

    local status = ffi.new('GLint[1]',0)
    bind.getProgramiv(program, bind.LINK_STATUS, status);
    if status == bind.FALSE then
	    local maxLength = ffi.new('GLint[1]',0);
	    bind.getProgramiv(program, bind.INFO_LOG_LENGTH, maxLength);
	    -- The maxLength includes the NULL character
        local buf = ffi.new('GLchar[?]', maxLength)
	    bind.getProgramInfoLog(program, maxLength[0], maxLength, buf);
        print('Progam linking FAILED.')
        print(buf)
    end

    mod.getError()

    return program
end

return mod
