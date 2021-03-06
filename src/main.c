/*
 Major portions taken verbatim or adapted from the Lua and LuaJit interpreter (lua.c, luajit.c)
*/

#include <stdlib.h>
#include <stdio.h>

#ifdef _WIN32
#include <windows.h> /* WinMain */
#include <direct.h> /* _chdir */
#else
#include <unistd.h>
#endif

#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"
#include "luajit.h"

#include "config.h"
#include "file_util.h"

#define LUA_INIT_SCRIPT "lua/main.lua"

#ifdef _WIN32
#define chdir(p) (_chdir(p))
#endif

static void l_version()
{
    fputs(LUA_RELEASE " -- " LUA_COPYRIGHT ". \n", stdout);
    fputs(LUAJIT_VERSION " -- " LUAJIT_COPYRIGHT ". " LUAJIT_URL "\n", stdout);
    fputs(ENGINE_RELEASE " -- " ENGINE_COPYRIGHT ". \n",stdout);
}
static void l_message(const char *pname, const char *msg)
{
  if (pname) fprintf(stderr, "%s: ", pname);
  fprintf(stderr, "%s\n", msg);
  fflush(stderr);
}

/* luajit.c traceback */
static int traceback(lua_State *L)
{
  if (!lua_isstring(L, 1)) { /* Non-string error object? Try metamethod. */
    if (lua_isnoneornil(L, 1) ||
	!luaL_callmeta(L, 1, "__tostring") ||
	!lua_isstring(L, -1))
      return 1;  /* Return non-string error object. */
    lua_remove(L, 1);  /* Replace object by result of __tostring metamethod. */
  }
  luaL_traceback(L, L, lua_tostring(L, 1), 1);
  return 1;
}

static int report(lua_State *L, int status)
{
  if (status && !lua_isnil(L, -1)) {
    const char *msg = lua_tostring(L, -1);
    if (msg == NULL) msg = "(error object is not a string)";
    l_message(NULL, msg);
    lua_pop(L, 1);
  }
  return status;
}

static int docall(lua_State *L, int narg, int clear)
{
  int status;
  int base = lua_gettop(L) - narg;  /* function index */
  lua_pushcfunction(L, traceback);  /* push traceback function */
  lua_insert(L, base);  /* put it under chunk and args */
  status = lua_pcall(L, narg, (clear ? 0 : LUA_MULTRET), base);
  lua_remove(L, base);  /* remove traceback function */
  /* force a complete garbage collection in case of errors */
  if (status != 0) lua_gc(L, LUA_GCCOLLECT, 0);
  return status;
}

static int dofile(lua_State *L, const char *name)
{
  int status = luaL_loadfile(L, name) || docall(L, 0, 1);
  return report(L, status);
}

static int pmain(lua_State *L)
{
    /* Load Lua libraries */
    luaL_openlibs(L);
    l_version();

    return dofile(L,LUA_INIT_SCRIPT);
}

#ifdef _WIN32
int CALLBACK WinMain(
   HINSTANCE hInstance,
   HINSTANCE hPrevInstance,
   LPSTR     lpCmdLine,
   int       nCmdShow)
#else
int main(int argc, char **argv)
#endif
{
    int status;
    char *dir = NULL;
#ifdef __APPLE__
    const char *res_dir = "../Resources";
#else
    const char *res_dir = "..";
#endif

    if ((dir = get_app_dir()) == NULL) {
        return EXIT_FAILURE;
    }
    if (chdir(dir) != 0) {
        perror("Can't change to the application directory");
        return EXIT_FAILURE;
    }
    if (chdir(res_dir) != 0) {
        perror("Can't change to resources directory");
        return EXIT_FAILURE;
    }
    free(dir);

    lua_State *L;
    L = luaL_newstate();
    if (!L) {
        fprintf(stderr, "Couldn't create Lua state (not enough memory).");
        return EXIT_FAILURE;
    }
    status = lua_cpcall(L, pmain, NULL);
    lua_close(L);
    return status ? EXIT_FAILURE : EXIT_SUCCESS;
}
