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

function mod.getError()
    local err = tonumber(bind.glGetError())
    while err ~= bind.GL_NO_ERROR do
        if err == bind.GL_INVALID_ENUM then
            print('OpenGL Error: GL_INVALID_ENUM', err)
        elseif err == bind.GL_INVALID_VALUE then
            print('OpenGL Error: GL_INVALID_VALUE', err)
        elseif err == bind.GL_INVALID_OPERATION then
            print('OpenGL Error: GL_INVALID_OPERATION', err)
        elseif err == bind.GL_INVALID_FRAMEBUFFER_OPERATION then
            print('OpenGL Error: GL_INVALID_FRAMEBUFFER_OPERATION', err)
        elseif err == bind.GL_OUT_OF_MEMORY then
            print('OpenGL Error: GL_OUT_OF_MEMORY', err)
        end
    end
end

function mod.createProgram(vert, frag)
    -- Purge error
    bind.glGetError()
    local program = bind.glCreateProgram()

    local vertexShader   = mod.createShader(vert, bind.GL_VERTEX_SHADER)
    local fragmentShader = mod.createShader(frag, bind.GL_FRAGMENT_SHADER)

    bind.glAttachShader(program, vertexShader)
    bind.glAttachShader(program, fragmentShader)

    bind.glLinkProgram(program)

    local status = ffi.new('GLint[1]',0)
    bind.glGetProgramiv(program, bind.GL_LINK_STATUS, status);
    if status == bind.GL_FALSE then
	    local maxLength = ffi.new('GLint[1]',0);
	    bind.glGetProgramiv(program, bind.GL_INFO_LOG_LENGTH, maxLength);
	    -- The maxLength includes the NULL character
        local buf = ffi.new('GLchar[?]', maxLength)
	    bind.glGetProgramInfoLog(program, maxLength[0], maxLength, buf);
        print('Progam linking FAILED.')
        print(buf)
    end

    mod.getError()

    return program
end

return mod
