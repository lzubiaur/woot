-- test main file
-- Set the Lua module search path
package.path = './lua/?.lua'

-- Init the engine
require 'engine.init'

local ffi = require 'ffi'
local fileutil = require 'engine.fileutil'

ffi.cdef [[
    void test_1();
    void imgui_test_render();
]]

-- Test binding
local tests_bind = ffi.load(fileutil.getModulePath('tests'))
tests_bind.test_1()

local viewport = require 'engine.viewport'

viewport.init()
local window = viewport.create(1280, 720,'test')
assert(window,'Cannot create window')

ffi.cdef [[
    typedef void (*GL3WglProc)(void);
    /* gl3w api */
    int gl3wInit(void);
    int gl3wIsSupported(int major, int minor);
    GL3WglProc gl3wGetProcAddress(const char *proc);
]]

local gl3w_bind = ffi.load(fileutil.getModulePath('gl3w'))
gl3w_bind.gl3wInit()
print(gl3w_bind.gl3wIsSupported(1,0))

ffi.cdef [[
    struct GLFWwindow;
    bool ImGui_ImplGlfwGL3_Init(GLFWwindow* window, bool install_callbacks);
]]
local imgui_bind = ffi.load(fileutil.getModulePath('imgui'))

imgui_bind.ImGui_ImplGlfwGL3_Init(window, true)

viewport.addNode {
    process = function(delta)
        -- print 'DEBUG process'
        tests_bind.imgui_test_render()
    end,
    render = function()
        -- body...
    end
}

viewport.run()
