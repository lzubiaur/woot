-- ImGui tests

local ffi      = require 'ffi'
local fileutil = require 'engine.fileutil'
local viewport = require 'engine.viewport'

ffi.cdef [[
    void imgui_test_render();
]]

local tests = ffi.load(fileutil.getModulePath('tests'))

ffi.cdef [[
    struct GLFWwindow;
    bool ImGui_ImplGlfwGL3_Init(GLFWwindow* window, bool install_callbacks);
]]
local imgui = ffi.load(fileutil.getModulePath('imgui'))

imgui.ImGui_ImplGlfwGL3_Init(viewport.getWindow(), true)

return {
    process = function(delta)
    end,
    render = function()
        tests.imgui_test_render()
    end
}
