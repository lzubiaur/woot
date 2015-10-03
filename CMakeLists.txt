################################################################################
# You can configure your Application build here
set(PROJECT_NAME "woot")

option(ENGINE_BUILD_TESTS "Build the Engine tests programs" ON)
# Set the Application bundle name (.app will be added on OSX).
set(BUNDLE_NAME ${PROJECT_NAME})

#
set(CMAKE_VERBOSE_MAKEFILE OFF)
################################################################################

cmake_minimum_required(VERSION 3.3 FATAL_ERROR)

# Set the project name and the supported languages.
project(${PROJECT_NAME} C CXX)

set(CMAKE_INSTALL_PREFIX ${PROJECT_SOURCE_DIR}/products/${CMAKE_BUILD_TYPE})

if(BUILD_OSX)
    set(BUNDLE_NAME "${BUNDLE_NAME}.app")
    set(BUNDLE_RESOURCE_PREFIX "${BUNDLE_NAME}/Contents/Resources")

   # Disable RPATH for build and install. We use fixup_bundle to assemble a
   # standle alone bundle.
   # CMAKE_SKIP_RPATH is required disabled on OSX because dependencies like
   # GLFW are linked using the install path and fixup_bundle can't find them if they
   # are not yet installed (which we don't want to do).
   set(CMAKE_SKIP_RPATH TRUE)
elseif(BUILD_LINUX)
   set(BUNDLE_RESOURCE_PREFIX "${BUNDLE_NAME}")

   # use, i.e. don't skip the full RPATH for the build tree
   SET(CMAKE_SKIP_BUILD_RPATH  FALSE)

   # when building, don't use the install RPATH already
   # (but later on when installing)
   SET(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)

   # the RPATH to be used when installing
   SET(CMAKE_INSTALL_RPATH ".")

   # don't add the automatically determined parts of the RPATH
   # which point to directories outside the build tree to the install RPATH
   SET(CMAKE_INSTALL_RPATH_USE_LINK_PATH FALSE)
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

# add_definitions(-Wall -std=c++0x)
add_definitions(-Wall)

# Include the dependencies, tests and source
add_subdirectory(lib)
if(ENGINE_BUILD_TESTS)
    add_subdirectory(tests)
endif()
add_subdirectory(src)

install(DIRECTORY lua DESTINATION ${BUNDLE_RESOURCE_PREFIX} COMPONENT Runtime)
# Copy the content of the res folder into the package resource directory
file(GLOB USER_RESOURCES res/*)
install(FILES ${USER_RESOURCES} DESTINATION ${BUNDLE_RESOURCE_PREFIX})
