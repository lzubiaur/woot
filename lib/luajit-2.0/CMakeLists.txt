cmake_minimum_required(VERSION 3.0)

set(LUAJIT_DIST "${PROJECT_SOURCE_DIR}/luajit-2.0")
set(LUAJIT_INCLUDE "${PROJECT_BINARY_DIR}/luajit/src")
# set(LUA_HEADERS ${LUAJIT_INCLUDE} PARENT_SCOPE)

# TODO don't hardcode library name
set(LUA_LIB libluajit.a)

# Copy to the build directory so we don't polute the source tree.
# WARNING add_custom_command doesnt seems to work if the output file is a variable.
# We must specify the output file using a string, that why we use
# ${PROJECT_BINARY_DIR}/luajit rather than just a variable.
add_custom_command(OUTPUT ${PROJECT_BINARY_DIR}/luajit
    COMMAND ${CMAKE_COMMAND} -E echo "Copying LuaJIT source to build directory..."
    COMMAND ${CMAKE_COMMAND} -E make_directory ${PROJECT_BINARY_DIR}/luajit
    COMMAND ${CMAKE_COMMAND} -E copy_directory ${LUAJIT_DIST} ${PROJECT_BINARY_DIR}/luajit
)

add_custom_command(OUTPUT ${PROJECT_BINARY_DIR}/luajit/src/libluajit.a
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}/luajit/src
    COMMAND $(MAKE) VERBOSE=1 clean
    COMMAND $(MAKE) VERBOSE=1 libluajit.a
    )

add_custom_target(lua_custom_build
    DEPENDS ${PROJECT_BINARY_DIR}/luajit
    DEPENDS ${PROJECT_BINARY_DIR}/luajit/src/libluajit.a
    )

add_library(liblua INTERFACE)
add_dependencies(liblua lua_custom_build)
# Specify libraries or flags to use when linking with target libluajit
target_link_libraries(liblua INTERFACE "${PROJECT_BINARY_DIR}/luajit/src/${LUA_LIB}")
#add_dependencies(liblua-static liblua)

target_include_directories(liblua INTERFACE ${LUAJIT_INCLUDE})
