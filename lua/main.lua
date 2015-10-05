-- Lua module search path
package.path = './lua/?.lua'
-- C module (shared library) search path
package.cpath = '../MacOS/lib?.dylib;../bin/lib?.so'

assert(jit.os == 'OSX' or jit.os == 'Linux' or jit.os == 'Windows', 'Target OS not supported: ' .. jit.os)
require 'engine.fileutil'.init()

-- =============================================================================
-- Module loading

-- Load and open the LuaFileSystem
-- Note that C module can be loaded using `package.loadlib` instead of `require`
-- but loadlib does not perform any path searching unlike require.

-- Low level C module loading
-- local path = "../MacOS/liblfs.dylib"
-- local f = assert(package.loadlib('lfs', "luaopen_lfs"))
-- f()  -- actually open the library

-- Load Lua File System using `require`
local lfs = require 'lfs'
print(lfs.currentdir())

local glfw = require 'engine.glfw'('glfw')

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
