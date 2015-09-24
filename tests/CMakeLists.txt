cmake_minimum_required(VERSION 3.0)
project(tests)

include_directories(${GLFW_HEADERS})

add_executable(test_luajit luajit.c)
target_link_libraries(test_luajit liblua)
add_executable(test_glfw glfw.c)
target_link_libraries(test_glfw glfw ${GLFW_LIBRARIES})
if(BUILD_OSX)
    # set_target_properties(test_luajit PROPERTIES MACOSX_BUNDLE true)
    # Must defined pagezero_size and image_base or LuaJIT will crash on MacOSX 64bits. See luajit.org/install.html for flags
    set_target_properties(test_luajit PROPERTIES LINK_FLAGS "-pagezero_size 10000 -image_base 100000000")
elseif(BUILD_LINUX)
   message("BUILD_LINUX DEBUG")
   # TODO check why luajit must link against dl and m (math)
   target_link_libraries(test_luajit dl m)
endif(BUILD_OSX)

set(APPS ${CMAKE_CURRENT_BINARY_DIR}/test_luajit.app)
set(DIRS /Users/lzubiaur/Dev/woot/lib/luajit-2.0/src/)

install(TARGETS test_luajit test_glfw
    BUNDLE  DESTINATION "tests"
    RUNTIME DESTINATION "tests"
    # LIBRARY DESTINATION "tests/lib"
    # ARCHIVE DESTINATION "tests/lib/static"
    )

#INSTALL(CODE "
#  include(BundleUtilities)
#  fixup_bundle(\"${APPS}\" \"\" \"${DIRS}\")
#  " COMPONENT Runtime)
