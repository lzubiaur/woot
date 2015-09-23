cmake_minimum_required(VERSION 3.3)
project(tests CXX)

# include_directories(${LUA_HEADERS})

add_executable(test_luajit luajit.c)
# target_link_libraries(test_luajit liblua)
target_link_libraries(test_luajit liblua)
if(BUILD_OSX)
    # set_target_properties(test_luajit PROPERTIES MACOSX_BUNDLE true)
    set_target_properties(test_luajit PROPERTIES LINK_FLAGS "-pagezero_size 10000 -image_base 100000000")
endif(BUILD_OSX)

set(APPS ${CMAKE_CURRENT_BINARY_DIR}/test_luajit.app)
set(DIRS /Users/lzubiaur/Dev/woot/lib/luajit-2.0/src/)

install(TARGETS test_luajit
    BUNDLE  DESTINATION "."
    RUNTIME DESTINATION "bin"
    LIBRARY DESTINATION "lib"
    ARCHIVE DESTINATION "lib/static")

#INSTALL(CODE "
#  include(BundleUtilities)
#  fixup_bundle(\"${APPS}\" \"\" \"${DIRS}\")
#  " COMPONENT Runtime)
