local ffi = require("ffi")
ffi.cdef[[

typedef struct GLFWwindow GLFWwindow;
typedef struct GLFWmonitor GLFWmonitor;

void glfwMakeContextCurrent (GLFWwindow *window);
GLFWwindow * glfwCreateWindow (int width, int height, const char *title, GLFWmonitor *monitor, GLFWwindow *share);

typedef struct { double x, y; } point_t;
]]

local window = ffi.C.glfwCreateWindow(100,100,'test',nil,nil)
ffi.C.glfwMakeContextCurrent(window)

local buf = ffi.new('unsigned long[?]',10)
buf[1] = 100
print(buf[10],tonumber(buf[1]))

local point
local mt = {
    __add = function(a, b) return point(a.x+b.x, a.y+b.y) end,
    __len = function(a) return math.sqrt(a.x*a.x + a.y*a.y) end,
    __index = {
        area = function(a) return a.x*a.x + a.y*a.y end,
    },
    __gc = {
        print 'GC'
    }
}


point = ffi.metatype("point_t", mt)

local a = point(3, 4)
print(a.x, a.y)  --> 3  4
print(#a)        --> 5
print(a:area())  --> 25
ffi.gc(a,function() print('GC a') end)

print(ffi.sizeof("point_t"))
print(ffi.sizeof(point))

local b = a + point(0.5, 8)
print(#b)        --> 12.5
ffi.gc(b,function() print('GC b') end)

local tt = ffi.new('point_t')
tt.x = 4
tt.y = 4
print(tt:area())
ffi.gc(tt,function() print('GC tt') end)
