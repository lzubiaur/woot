cmake_minimum_required(VERSION 3.0)
project(woot)

set(CMAKE_VERBOSE_MAKEFILE OFF)
set(CMAKE_INSTALL_PREFIX ${PROJECT_SOURCE_DIR}/products) 

if(BUILD_OSX)
    set(PKG_NAME ${PROJECT_NAME}.app)
    set(PKG_RESOURCE_PREFIX "${PKG_NAME}/Contents/Resources")
elseif(BUILD_LINUX)
    set(PKG_NAME ${PROJECT_NAME})
    set(PKG_RESOURCE_PREFIX "${PKG_NAME}")
endif(BUILD_OSX)

# add_definitions(-Wall -std=c++0x)
add_definitions(-Wall)

add_subdirectory(lib)
add_subdirectory(tests)
add_subdirectory(src)

install(DIRECTORY lua DESTINATION ${PKG_RESOURCE_PREFIX} COMPONENT Runtime)
# Copy the content of the res folder into the package resource directory
file(GLOB USER_RESOURCES res/*)
install(FILES ${USER_RESOURCES} DESTINATION ${PKG_RESOURCE_PREFIX})

