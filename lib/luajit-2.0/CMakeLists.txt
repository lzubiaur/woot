cmake_minimum_required(VERSION 3.3)

set(LUAJIT_DIST "${PROJECT_SOURCE_DIR}/luajit-2.0")
set(LUAJIT_INCLUDE "${PROJECT_BINARY_DIR}/luajit/src")
# set(LUA_HEADERS ${LUAJIT_INCLUDE} PARENT_SCOPE)

if(BUILD_WIN)
    set(LUA_LIB lua51.lib)
else()
    set(LUA_LIB libluajit.a)
endif()

# Copy to the build directory so we don't polute the source tree.
# WARNING add_custom_command doesnt seems to work if the output file is a variable.
# We must specify the output file using a string, that why we use
# ${PROJECT_BINARY_DIR}/luajit rather than just a variable.
add_custom_command(OUTPUT ${PROJECT_BINARY_DIR}/luajit
    COMMAND ${CMAKE_COMMAND} -E echo "Copying LuaJIT source to build directory..."
    COMMAND ${CMAKE_COMMAND} -E make_directory ${PROJECT_BINARY_DIR}/luajit
    COMMAND ${CMAKE_COMMAND} -E copy_directory ${LUAJIT_DIST} ${PROJECT_BINARY_DIR}/luajit
)

if(BUILD_WIN)
    add_custom_command(OUTPUT ${PROJECT_BINARY_DIR}/luajit/src/lua51.lib
        WORKING_DIRECTORY ${PROJECT_BINARY_DIR}/luajit/src
        COMMAND msvcbuild.bat
    )

    add_custom_target(lua_custom_build
        DEPENDS ${PROJECT_BINARY_DIR}/luajit
        DEPENDS ${PROJECT_BINARY_DIR}/luajit/src/lua51.lib
    )
else()
    add_custom_command(OUTPUT ${PROJECT_BINARY_DIR}/luajit/src/libluajit.a
        WORKING_DIRECTORY ${PROJECT_BINARY_DIR}/luajit/src
        COMMAND make VERBOSE=1 clean
        COMMAND make VERBOSE=1 libluajit.a
    )

    add_custom_target(lua_custom_build
        DEPENDS ${PROJECT_BINARY_DIR}/luajit
        DEPENDS ${PROJECT_BINARY_DIR}/luajit/src/libluajit.a
    )
endif()

add_library(liblua INTERFACE)
add_dependencies(liblua lua_custom_build)
# Specify libraries or flags to use when linking with target libluajit
if(BUILD_LINUX)
    # Since LuaJIT is link the static library we need to add the external dependencies  (-lm -ldl)
    # http://luajit.org/install.html
    target_link_libraries(liblua INTERFACE "${PROJECT_BINARY_DIR}/luajit/src/${LUA_LIB}" dl m)
else()
    target_link_libraries(liblua INTERFACE "${PROJECT_BINARY_DIR}/luajit/src/${LUA_LIB}")
endif()
# Specify the headers so they will be implicitly included when other targert link against this library
target_include_directories(liblua INTERFACE ${LUAJIT_INCLUDE})
