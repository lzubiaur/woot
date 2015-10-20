-- Set the Lua module search path
package.path = './lua/?.lua'
-- Load the game engine
local viewport = require 'engine.viewport'
-- Test module loading and binding. Must be called after the engine is loaded (require 'engine.viewport')
require 'tests.mod'
-- Create the viewport
viewport.create(1280, 720, 'Woot Game Egine')
-- Load the GUI test
viewport.addNode(require 'tests.imgui')
-- Run the tests
viewport.run()
