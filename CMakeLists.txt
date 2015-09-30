cmake_minimum_required(VERSION 3.0)
project(woot C CXX)

set(CMAKE_VERBOSE_MAKEFILE OFF)
set(CMAKE_INSTALL_PREFIX ${PROJECT_SOURCE_DIR}/products/${CMAKE_BUILD_TYPE}) 

if(BUILD_OSX)
    set(BUNDLE_NAME ${PROJECT_NAME}.app)
    set(BUNDLE_RESOURCE_PREFIX "${BUNDLE_NAME}/Contents/Resources")
elseif(BUILD_LINUX)
    set(BUNDLE_NAME ${PROJECT_NAME})
    set(BUNDLE_RESOURCE_PREFIX "${BUNDLE_NAME}")
endif(BUILD_OSX)

# Output directories for runtime, library and archive (static library).
# We must defined an explicit output destination because fixup_bundle 
# needs to know where to find the dependencies.
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELEASE ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELEASE ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE ${CMAKE_BINARY_DIR}/bin)

# Disable RPATH for build and install. We use fixup_bundle to assemble a 
# standle alone bundle.
# CMAKE_SKIP_RPATH is required disabled on OSX because dependencies like 
# GLFW are linked using the install path and fixup_bundle can't find them if they
# are not yet installed (which we don't want to do).
set(CMAKE_SKIP_RPATH TRUE)

# add_definitions(-Wall -std=c++0x)
add_definitions(-Wall)

# Include the dependencies, tests and source
add_subdirectory(lib)
add_subdirectory(tests)
add_subdirectory(src)

install(DIRECTORY lua DESTINATION ${BUNDLE_RESOURCE_PREFIX} COMPONENT Runtime)
# Copy the content of the res folder into the package resource directory
file(GLOB USER_RESOURCES res/*)
install(FILES ${USER_RESOURCES} DESTINATION ${BUNDLE_RESOURCE_PREFIX})

