local ffi = require("ffi")
ffi.cdef[[

typedef struct GLFWwindow GLFWwindow;
typedef struct GLFWmonitor GLFWmonitor;

void glfwMakeContextCurrent (GLFWwindow *window);
GLFWwindow * glfwCreateWindow (int width, int height, const char *title, GLFWmonitor *monitor, GLFWwindow *share);
]]

local window = ffi.C.glfwCreateWindow(100,100,'test',nil,nil)
ffi.C.glfwMakeContextCurrent(window)

while (true) do
end
