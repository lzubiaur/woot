-- Set the Lua module search path
package.path = './lua/?.lua'

local viewport = require 'engine.viewport'
viewport.create(1280, 720, 'test')
viewport.addNode(require 'imgui')
viewport.run()
