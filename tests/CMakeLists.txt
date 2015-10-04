cmake_minimum_required(VERSION 3.3)
project(tests)

include_directories(${GLFW_HEADERS})

# LuaJIT
add_executable(test_luajit luajit.c)
add_dependencies(test_luajit liblua)
target_link_libraries(test_luajit liblua)

# GLFW
add_executable(test_glfw glfw.c)
target_link_libraries(test_glfw glfw ${GLFW_LIBRARIES})

# FFI
add_executable(test_ffi ffi.c)
add_dependencies(test_ffi liblua)
target_link_libraries(test_ffi glfw ${GLFW_LIBRARIES} liblua)

if(BUILD_OSX)
    # set_target_properties(test_luajit PROPERTIES MACOSX_BUNDLE true)
    # Must defined pagezero_size and image_base or LuaJIT will crash on MacOSX 64bits. See luajit.org/install.html for flags
    set_target_properties(test_luajit test_ffi PROPERTIES LINK_FLAGS "-pagezero_size 10000 -image_base 100000000")
elseif(BUILD_LINUX)
endif(BUILD_OSX)

set(APPS ${CMAKE_CURRENT_BINARY_DIR}/test_luajit.app)
set(DIRS /Users/lzubiaur/Dev/woot/lib/luajit-2.0/src/)

install(TARGETS test_luajit test_glfw test_ffi
    BUNDLE  DESTINATION "tests"
    RUNTIME DESTINATION "tests"
    # LIBRARY DESTINATION "tests/lib"
    # ARCHIVE DESTINATION "tests/lib/static"
    )

install(FILES ffi.lua DESTINATION "tests")

#INSTALL(CODE "
#  include(BundleUtilities)
#  fixup_bundle(\"${APPS}\" \"\" \"${DIRS}\")
#  " COMPONENT Runtime)
