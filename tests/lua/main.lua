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
--[[
    void ImGui_ImplGlfwGL3_Shutdown();
    void ImGui_ImplGlfwGL3_NewFrame();

    void ImGui_ImplGlfwGL3_InvalidateDeviceObjects();
    bool ImGui_ImplGlfwGL3_CreateDeviceObjects();

    void ImGui_ImplGlfwGL3_MouseButtonCallback(GLFWwindow* window, int button, int action, int mods);
    void ImGui_ImplGlfwGL3_ScrollCallback(GLFWwindow* window, double xoffset, double yoffset);
    void ImGui_ImplGlfwGL3_KeyCallback(GLFWwindow* window, int key, int scancode, int action, int mods);
    void ImGui_ImplGlfwGL3_CharCallback(GLFWwindow* window, unsigned int c);
]]

local tests_bind = ffi.load(fileutil.getModulePath('tests'))
tests_bind.test_1()
tests_bind.imgui_test_render()

local viewport = require 'engine.viewport'

viewport.init()
viewport.create(480,320,'test')

ffi.cdef [[
    typedef struct GLFWwindow GLFWwindow;
    bool ImGui_ImplGlfwGL3_Init(GLFWwindow* window, bool install_callbacks);
    ]]

local imgui_bind = ffi.load(fileutil.getModulePath('imgui'))
imgui_bind.ImGui_ImplGlfwGL3_Init(viewport.window, false)

viewport.addNode {
    process = function(delta)
    end,
    render = function()
        -- body...
    end
}

viewport.run()
