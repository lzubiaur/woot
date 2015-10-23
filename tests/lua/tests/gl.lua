local gl       = require 'engine.gl'
local ffi      = require 'ffi'
local fileutil = require 'engine.fileutil'

local render_test        = nil
local program, posAttrib = nil, nil

function _render()
    gl.glUseProgram(program)
    gl.glDrawArrays(gl.GL_TRIANGLES, 0, 3)
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

    gl.glGenBuffers(1, vbo)
    gl.glBindBuffer(gl.GL_ARRAY_BUFFER, vbo[0])
    gl.glBufferData(gl.GL_ARRAY_BUFFER, ffi.sizeof(vertices), vertices, gl.GL_STATIC_DRAW);

    program = gl.createProgram(vertexSource, fragmentSource)

    gl.glGenVertexArrays(1, vao);
    gl.glBindVertexArray(vao[0]);

    posAttrib = gl.glGetAttribLocation(program, 'position')
    gl.glVertexAttribPointer(posAttrib, 2, gl.GL_FLOAT, gl.GL_FALSE, 0, nil)
    gl.glEnableVertexAttribArray(posAttrib)

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
