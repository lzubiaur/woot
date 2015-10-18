local Viewport = {}

-- GLFW shared library is libglfw.so on Linux, libglfw.dylib OSX but it's named glfw3.dll on Windows
local name = (jit.os == 'Windows') and 'glfw' or 'glfw.3'
local glfw = require 'engine.glfw'(name)

local scene_tree = {}
local window = nil

function Viewport.init()
    -- Initialize GLFW
    if glfw.Init() == 0 then
        return false
    end
end

function Viewport.create(width, height, windowName)
    window = glfw.CreateWindow(width, height, windowName)
    Viewport.window = window
    if window == 0 then
      glfw.Terminate()
      return false
    end
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
