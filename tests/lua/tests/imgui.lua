-- ImGui tests

local ffi = require 'ffi'
local fileutil = require 'engine.fileutil'
local viewport = require 'engine.viewport'

ffi.cdef [[
    void test_1();
    void imgui_test_render();
]]

-- Test binding
local tests_bind = ffi.load(fileutil.getModulePath('tests'))
tests_bind.test_1()

ffi.cdef [[
    struct GLFWwindow;
    bool ImGui_ImplGlfwGL3_Init(GLFWwindow* window, bool install_callbacks);
]]
local imgui_bind = ffi.load(fileutil.getModulePath('imgui'))

imgui_bind.ImGui_ImplGlfwGL3_Init(viewport.getWindow(), true)

return {
    process = function(delta)
    end,
    render = function()
        tests_bind.imgui_test_render()
    end
}
