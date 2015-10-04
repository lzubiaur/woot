cmake_minimum_required(VERSION 3.3)

# Internal version number for the Woot game engine
set(ENGINE_NAME "Woot")
set(ENGINE_COPYRIGHT "Copyright (C) 2015 Laurent Zubiaur")
set(ENGINE_VERSION_MAJOR "0")
set(ENGINE_VERSION_MINOR "1")
set(ENGINE_VERSION_PATCH "1")
set(ENGINE_VERSION_EXTRA "b")
set(ENGINE_VERSION "${ENGINE_VERSION_MAJOR}.${ENGINE_VERSION_MINOR}")
set(ENGINE_VERSION_FULL "${ENGINE_VERSION}.${ENGINE_VERSION_PATCH}${ENGINE_VERSION_EXTRA}")

configure_file("config.h.in" "${PROJECT_BINARY_DIR}/config.h")

include_directories(${GLFW_HEADERS} ${PROJECT_BINARY_DIR})

set(RUNTIME_TARGET ${PROJECT_NAME})

add_executable(${RUNTIME_TARGET} main.c file_util.c)
add_dependencies(${RUNTIME_TARGET} liblua liblfs)

target_link_libraries(${RUNTIME_TARGET} glfw ${GLFW_LIBRARIES} liblua)

if(BUILD_OSX)
    set(APP "${CMAKE_INSTALL_PREFIX}/${BUNDLE_NAME}")
    set(PLUGINS_DESTINATION "${CMAKE_INSTALL_PREFIX}/${BUNDLE_NAME}/Contents/MacOS")
    set(BUNDLE_RUNTIME_DESTINATION ".")
    # MACOSX_BUNDLE can not be used with CPack
    set_target_properties(${RUNTIME_TARGET} PROPERTIES MACOSX_BUNDLE true)
    # Must defined pagezero_size and image_base or LuaJIT will crash on MacOSX 64bits. See luajit.org/install.html for flags
    set_target_properties(${RUNTIME_TARGET} PROPERTIES LINK_FLAGS "-pagezero_size 10000 -image_base 100000000")
elseif(BUILD_LINUX)
    set(APP "${CMAKE_INSTALL_PREFIX}/${BUNDLE_NAME}/bin/${RUNTIME_TARGET}")
    set(PLUGINS_DESTINATION "${CMAKE_INSTALL_PREFIX}/${BUNDLE_NAME}/bin")
    # Runtime destination into the bundle
    set(BUNDLE_RUNTIME_DESTINATION ${BUNDLE_NAME}/bin)
endif(BUILD_OSX)

install(TARGETS ${RUNTIME_TARGET}
    BUNDLE  DESTINATION "." COMPONENT Runtime
    RUNTIME DESTINATION ${BUNDLE_RUNTIME_DESTINATION} COMPONENT Runtime
    )

# directories to search for prerequisites. Libraries are copied automatically
set(DIRS ${CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELEASE})
# Plugins are loadable bundles that extend the basic features of your application
# On MacOSX it can be frameworks or shared lib not linked with the executable.
# Plugins must be copied manually before they can be fixed by fixup_bundle.
get_target_property(LFS_LIB_NAME liblfs OUTPUT_NAME)
set(PLUGINS "${CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELEASE}/${CMAKE_SHARED_LIBRARY_PREFIX}${LFS_LIB_NAME}${CMAKE_SHARED_LIBRARY_SUFFIX}")

# test
# list(APPEND PLUGINS "${CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELEASE}/libffi.dylib")

# Rebase the bundle using configurable cmake script (fixup_bundle.cmake.in)
# Could be done using "install CODE" but it's more flexible using script. Plus get_filename_component
# doesn't seem to work in embedded script ("install CODE").
set(fixup_bundle ${PROJECT_BINARY_DIR}/fixup_bundle.cmake)
configure_file(fixup_bundle.cmake.in ${fixup_bundle} @ONLY)
install(SCRIPT ${fixup_bundle} COMPONENT Runtime)

# rebase the bundle (Update the runtime and libraries RPATH) to make a standalone
# bundle.
# install(CODE "
#     configure_file(${PLUGIN_LFS} ${PLUGIN_DESTINATION} COPYONLY)
#     include(BundleUtilities)
#     fixup_bundle(\"${APPS}\" \"${PLUGIN_DESTINATION}/liblfs.dylib\" \"${DIRS}\")
#     " COMPONENT Runtime)

# Supported MacOSX package:
# CPACK_BINARY_BUNDLE       Enable to build OSX bundles
# CPACK_BINARY_DRAGNDROP    Enable to build OSX Drag And Drop package
# CPACK_BINARY_OSXX11       Enable to build OSX X11 packages
# CPACK_BINARY_PACKAGEMAKER Enable to build PackageMaker packages

if(BUILD_OSX)
   set(CPACK_GENERATOR Bundle) # set CPACK_BINARY_BUNDLE to ON
   set(CPACK_BUNDLE_COMPONENT_INSTALL ON)

   configure_file("res/MacOSXBundleInfo.plist.in" "${PROJECT_BINARY_DIR}/Info.plist")

   include(InstallRequiredSystemLibraries)
   set(CPACK_BUNDLE_NAME ${PROJECT_NAME})
   # SET(CPACK_PACKAGE_DESCRIPTION_SUMMARY "My funky project")
   # SET(CPACK_PACKAGE_VENDOR "Me, myself, and I")
   # SET(CPACK_PACKAGE_DESCRIPTION_FILE "${CMAKE_CURRENT_SOURCE_DIR}/ReadMe.txt")
   # SET(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/Copyright.txt")
   # set(CPACK_PACKAGE_ERSION_MAJOR "1")
   # set(CPACK_PACKAGE_VERSION_MINOR "3")
   # set(CPACK_PACKAGE_VERSION_PATCH "2")
   set(CPACK_PACKAGE_INSTALL_DIRECTORY "CMake ${ENGINE_VERSION_MAJOR}.${ENGINE_VERSION_MINOR}")
   # CPACK_BUNDLE_STARTUP_COMMAND Can be an executable or a script for non trivial startup
   set(CPACK_BUNDLE_STARTUP_COMMAND "${PROJECT_BINARY_DIR}/src/${PROJECT_NAME}")
   set(CPACK_BUNDLE_PLIST "${PROJECT_BINARY_DIR}/Info.plist")
   set(CPACK_BUNDLE_ICON "${PROJECT_SOURCE_DIR}/src/res/app.icns")
   # SET(CPACK_PACKAGE_EXECUTABLES "MyExecutable" "My Executable")

   # create the package target
elseif(BUILD_LINUX)
   # TODO
endif(BUILD_OSX)

include(CPack)
