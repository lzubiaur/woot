#ifndef TESTS_H
#define TESTS_H

#ifdef __cplusplus
extern "C" {
#endif

/* Function MUST have 'C' linkage (compiler does not mangle the name). If not
 * declared using extern "C" then C++ function (e.g. imgui_test_render in imgui.cpp)
 * will be decorated and Lua FFI binding will not work.
 * To check that a function has no decoration use the `nm` command.
 * For instance, when no declared using extern "C" the imgui_test_render is exported
 * as `__Z17imgui_test_renderv` in the shared library. When using C linkage it has the
 * symbole `_imgui_test_render`.
 */
void test_C_module_binding();
void imgui_test_render();
void load_image(const char*filename);

#ifdef __cplusplus
}
#endif

#endif /* TESTS_H */
