cmake_minimum_required(VERSION 3.0)

set(LUAJIT_ROOT "${PROJECT_SOURCE_DIR}/luajit-2.0")
set(LUAJIT_INCLUDE "${LUAJIT_ROOT}/src")
# set(LUA_HEADERS ${LUAJIT_INCLUDE} PARENT_SCOPE)

set(LUA_LIB libluajit.a)

add_custom_command(OUTPUT ${LUAJIT_ROOT}/src/libluajit.a
    WORKING_DIRECTORY ${LUAJIT_ROOT}/src
    COMMAND $(MAKE) VERBOSE=1 clean 
    COMMAND $(MAKE) VERBOSE=1 libluajit.a
    ) 

add_custom_target(libluajit
    DEPENDS ${LUAJIT_ROOT}/src/libluajit.a
    )

add_library(liblua INTERFACE)
# Specify libraries or flags to use when linking with target libluajit
target_link_libraries(liblua INTERFACE "${LUAJIT_ROOT}/src/${LUA_LIB}")
#add_dependencies(liblua-static liblua)

target_include_directories(liblua INTERFACE ${LUAJIT_INCLUDE})
