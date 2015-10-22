-- set the C module (shared library) search path
package.cpath = '../MacOS/lib?.dylib;./bin/lib?.so;./bin/?.dll'

-- Must init fileutil before loading any module
local fileutil = require 'engine.fileutil'.init()
-- GLFW shared library is libglfw.so on Linux, libglfw.dylib OSX but it's named glfw3.dll on Windows
local glfw = require 'engine.glfw'(jit.os == 'Windows' and 'glfw' or 'glfw.3')
local gl3w = require 'engine.gl3w'
local gl   = require 'engine.gl'
local jit  = require 'jit'
local ffi  = require 'ffi'

local Viewport   = {}
local scene_tree = {}
local window     = nil

function Viewport.create(width, height, windowName, isFullScreen)
    -- Can only be called once
    if window then return nil end

    -- Initialize the GLFW module
    if glfw.Init() == 0 then
        -- TODO throw error
        return nil
    end

    -- specify the client API version that the created context must be compatible with
    -- glfwCreateWindow will still fail if the resulting OpenGL version is less than the one requested
    -- ImGui requires OpenGL 3.3
    glfw.WindowHint('CONTEXT_VERSION_MAJOR', 3);
    glfw.WindowHint('CONTEXT_VERSION_MINOR', 3);
    -- specifies which OpenGL profile to create the context for:
    -- OPENGL_CORE_PROFILE or OPENGL_COMPAT_PROFILE, or OPENGL_ANY_PROFILE.
    -- If requesting an OpenGL version *below* 3.2, OPENGL_ANY_PROFILE must be used
    -- We use OPENGL_CORE_PROFILE which only supports the new core functionality.
    glfw.WindowHint('OPENGL_PROFILE', 'OPENGL_CORE_PROFILE');
    if (jit.os == 'OSX') then
        -- OpenGL context should be forward-compatible (all functionality deprecated in the requested version of OpenGL is removed)
        -- This may only be used if the requested OpenGL version is 3.0 or above.
        glfw.WindowHint('OPENGL_FORWARD_COMPAT', 1);
    end
    -- Don't allow resizable window
    glfw.WindowHint('RESIZABLE', 0)

    window = glfw.CreateWindow(width, height, windowName, isFullScreen and glfw.GetPrimaryMonitor() or nil, nil)
    if window == nil then
      glfw.Terminate()
      return nil
    end

    -- Init GL3W. Must be called after glfw.CreateWindow (OpenGL context created)
    if gl3w.gl3wInit() == 0 then
        -- TODO throw error
        return nil
    end

    Viewport.getWindow = function() return window end
    return window
end

function Viewport.addNode(node)
    table.insert(scene_tree,node)
end

function Viewport.run()
    -- Make the window's context current
    glfw.MakeContextCurrent(window)

    local prev_time = 0.0
    local delta = 0.0

    -- Loop until the user closes the window
    while glfw.WindowShouldClose(window) == 0 do
        -- Poll for and process events
        glfw.PollEvents()

        delta = (prev_time > 0.0) and (glfw.GetTime() - g_Time) or (1.0/60.0);
        for _,node in ipairs(scene_tree) do
            node.process(delta)
        end

        -- Clean buffer
        gl.glClearColor(0.3,0.28,0.35,1)
        local width, height = glfw.GetFramebufferSize(window)
        gl.glViewport(0, 0, width, height);
        gl.glClear(gl.GL_COLOR_BUFFER_BIT);

        -- Render the scene tree
        for _,node in ipairs(scene_tree) do
            node.render()
        end

        -- Swap front and back buffers
        glfw.SwapBuffers(window)
    end

    glfw.DestroyWindow(window)
    glfw.Terminate()
end

return Viewport
