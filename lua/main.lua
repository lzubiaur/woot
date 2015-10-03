package.path = './lua/?.lua'

local glfw = require 'engine.glfw'()

-- Load and open the LuaFileSystem
-- TODO test on Linux
local path = "../MacOS/liblfs.dylib"
local f = assert(package.loadlib(path, "luaopen_lfs"))
f()  -- actually open the library

print(lfs.currentdir())

-- Initialize the library
if glfw.Init() == 0 then
  return
end

-- Create a windowed mode window and its OpenGL context
local window = glfw.CreateWindow(640, 480, "Hello World")
if window == 0 then
  glfw.Terminate()
  return
end

-- Make the window's context current
glfw.MakeContextCurrent(window)

-- Loop until the user closes the window
while glfw.WindowShouldClose(window) == 0 do
  -- Render here

  -- Swap front and back buffers
  glfw.SwapBuffers(window)

  -- Poll for and process events
  glfw.PollEvents()
end

glfw.Terminate()
