cmake_minimum_required(VERSION 3.0)

# Internal version number for the Woot game engine
set(WOOT_VERSION_MAJOR "0")
set(WOOT_VERSION_MINOR "1")
set(WOOT_VERSION_PATCH "1")
set(WOOT_VERSION_EXTRA "b")
set(WOOT_VERSION "${WOOT_VERSION_MAJOR}.${WOOT_VERSION_MINOR}")
set(WOOT_VERSION_FULL "${WOOT_VERSION}.${WOOT_VERSION_PATCH}${WOOT_VERSION_EXTRA}")

configure_file("config.h.in" "${PROJECT_BINARY_DIR}/config.h")

add_executable(${PROJECT_NAME} main.c)
add_dependencies(${PROJECT_NAME} libluajit)
target_link_libraries(${PROJECT_NAME} glfw ${GLFW_LIBRARIES} liblua)

if(BUILD_OSX)
    # Must defined pagezero_size and image_base or LuaJIT will crash on MacOSX 64bits. See luajit.org/install.html for flags
    # TODO add bundle support
    # set_target_properties(${PROJECT_NAME} PROPERTIES MACOSX_BUNDLE true)
    set_target_properties(${PROJECT_NAME} PROPERTIES LINK_FLAGS "-pagezero_size 10000 -image_base 100000000")
elseif(BUILD_LINUX)
   message("BUILD_LINUX DEBUG")
   # Since LuaJIT is link the static library we need to add the external dependencies  (-lm -ldl)
   # http://luajit.org/install.html
   target_link_libraries(${PROJECT_NAME} dl m)
endif(BUILD_OSX)

# TODO rebase the bundle
# set(APPS ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.app)
# set(DIRS /Users/lzubiaur/Dev/woot/lib/luajit-2.0/src/)

install(TARGETS ${PROJECT_NAME}
    # BUNDLE  DESTINATION ${PROJECT_NAME}
    RUNTIME DESTINATION ${PROJECT_NAME}
    # LIBRARY DESTINATION "tests/lib"
    # ARCHIVE DESTINATION "tests/lib/static"
    )

install(FILES main.lua DESTINATION ${PROJECT_NAME})
install(DIRECTORY lua DESTINATION ${PROJECT_NAME})

