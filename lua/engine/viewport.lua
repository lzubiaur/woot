local Viewport = {}

-- GLFW shared library is libglfw.so on Linux, libglfw.dylib OSX but it's named glfw3.dll on Windows
local name = (jit.os == 'Windows') and 'glfw' or 'glfw.3'
local glfw = require 'engine.glfw'(name)

local jit = require 'jit'

local scene_tree = {}
local window = nil

function Viewport.init()
    -- Initialize GLFW
    if glfw.Init() == 0 then
        return false
    end
end

function Viewport.create(width, height, windowName)
    -- specify the client API version that the created context must be compatible with
    -- glfwCreateWindow will still fail if the resulting OpenGL version is less than the one requested
    -- ImGui requires OpenGL 3.3
    glfw.WindowHint('CONTEXT_VERSION_MAJOR', 3);
    glfw.WindowHint('CONTEXT_VERSION_MINOR', 3);
    -- specifies which OpenGL profile to create the context for:
    -- OPENGL_CORE_PROFILE or OPENGL_COMPAT_PROFILE, or OPENGL_ANY_PROFILE.
    -- If requesting an OpenGL version below 3.2, OPENGL_ANY_PROFILE must be used
    glfw.WindowHint('OPENGL_PROFILE', 'OPENGL_CORE_PROFILE');
    if (jit.os == 'OSX') then
        -- OpenGL context should be forward-compatible (all functionality deprecated in the requested version of OpenGL is removed)
        -- This may only be used if the requested OpenGL version is 3.0 or above.
        glfw.WindowHint('OPENGL_FORWARD_COMPAT', 1);
    end
    -- Resizable window in non fullscreen mode
    -- glfw.WindowHint('RESIZABLE',1)

    window = glfw.CreateWindow(width, height, windowName)
    if window == nil then
      glfw.Terminate()
    end
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
        delta = (prev_time > 0.0) and (glfw.GetTime() - g_Time) or (1.0/60.0);
        -- Render here
        for _,node in ipairs(scene_tree) do
            node.process(delta)
        end

        -- for _,node in ipairs(scene_tree) do
        --     node.render()
        -- end

        -- Swap front and back buffers
        glfw.SwapBuffers(window)

        -- Poll for and process events
        glfw.PollEvents()
    end

    glfw.Terminate()
end

return Viewport
