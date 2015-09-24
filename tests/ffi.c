#include <GLFW/glfw3.h>
#include <lua.h>
#include <lauxlib.h>
#include <stdlib.h>
#include <stdio.h>

static void error_callback(int error, const char* description)
{
    fprintf(stderr, "Error: %s\n", description);
}

int main(void)
{
    GLFWwindow* window;
    int status, result;
    lua_State *L;

    glfwSetErrorCallback(error_callback);

    if (!glfwInit())
        exit(EXIT_FAILURE);

    L = luaL_newstate();

    if (!L) {
        printf("ERROR: Can't open Lua state.\n");
        exit(0);
    }

    luaL_openlibs(L);

    status = luaL_loadfile(L, "ffi.lua");
    if (status) {
        fprintf(stderr, "Couldn't load file: %s\n", lua_tostring(L, -1));
        exit(1);
    }

    result = lua_pcall(L, 0, LUA_MULTRET, 0);
    if (result) {
        fprintf(stderr, "Failed to run script: %s\n", lua_tostring(L, -1));
        exit(1);
    }

    lua_close(L);

    exit(EXIT_SUCCESS);
    return 0;
}
