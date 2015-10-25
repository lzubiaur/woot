-- Test OpenGL Lua binding
-- WARNING shader must be compiled after glfwMakeContextCurrent is called.
local gl       = require 'engine.gl'
local ffi      = require 'ffi'
local fileutil = require 'engine.fileutil'

local render_test        = nil
local program, posAttrib = nil, nil

function _render()
    gl.useProgram(program)
    gl.drawArrays(gl.TRIANGLES, 0, 3)
end

function _init()
    local vertexSource = [[
        #version 330
        in vec2 position;
        void main()
        {
            gl_Position = vec4(position, 0.0, 1.0);
        }
    ]]

    local fragmentSource = [[
        #version 330
        out vec4 outColor;
        void main()
        {
            outColor = vec4(1.0, 1.0, 1.0, 1.0);
        }
    ]]

    local vao = ffi.new 'GLuint[1]'
    local vbo = ffi.new 'GLuint[1]'
    local vertices = ffi.new('float[6]', { 0.0, 0.5, 0.5, -0.5, -0.5, -0.5} )

    gl.genBuffers(1, vbo)
    gl.bindBuffer(gl.ARRAY_BUFFER, vbo[0])
    gl.bufferData(gl.ARRAY_BUFFER, ffi.sizeof(vertices), vertices, gl.STATIC_DRAW);

    program = gl.createProgram(vertexSource, fragmentSource)

    gl.genVertexArrays(1, vao);
    gl.bindVertexArray(vao[0]);

    posAttrib = gl.getAttribLocation(program, 'position')
    gl.vertexAttribPointer(posAttrib, 2, gl.FLOAT, gl.FALSE, 0, nil)
    gl.enableVertexAttribArray(posAttrib)

    render_test = _render
end

render_test = _init

return {
    process = function(dt)
    end,
    render = function()
        render_test()
    end
}
