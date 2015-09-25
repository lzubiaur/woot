cmake_minimum_required(VERSION 3.0)

# Internal version number for the Woot game engine
set(WOOT_VERSION_MAJOR "0")
set(WOOT_VERSION_MINOR "1")
set(WOOT_VERSION_PATCH "1")
set(WOOT_VERSION_EXTRA "b")
set(WOOT_VERSION "${WOOT_VERSION_MAJOR}.${WOOT_VERSION_MINOR}")
set(WOOT_VERSION_FULL "${WOOT_VERSION}.${WOOT_VERSION_PATCH}${WOOT_VERSION_EXTRA}")

configure_file("config.h.in" "${PROJECT_BINARY_DIR}/config.h")

include_directories(${GLFW_HEADERS})

add_executable(${PROJECT_NAME} main.c file_util.c)
add_dependencies(${PROJECT_NAME} libluajit)

target_link_libraries(${PROJECT_NAME} glfw ${GLFW_LIBRARIES} liblua)

if(BUILD_OSX)
    set(PKG_NAME ${PROJECT_NAME}.app)
    set(PKG_RESOURCE_PREFIX ${BUNDLE_NAME}/Contents/MacOS)
    # MACOSX_BUNDLE can not be used with CPack
    set_target_properties(${PROJECT_NAME} PROPERTIES MACOSX_BUNDLE true)
    # Must defined pagezero_size and image_base or LuaJIT will crash on MacOSX 64bits. See luajit.org/install.html for flags
    set_target_properties(${PROJECT_NAME} PROPERTIES LINK_FLAGS "-pagezero_size 10000 -image_base 100000000")
elseif(BUILD_LINUX)
   set(PKG_NAME ${PROJECT_NAME})
   set(PKG_RUNTIME_DESTINATION ${PKG_NAME})
   set(PKG_RESOURCE_PREFIX ${PKG_NAME})
   # Since LuaJIT is link the static library we need to add the external dependencies  (-lm -ldl)
   # http://luajit.org/install.html
   target_link_libraries(${PROJECT_NAME} dl m)
   # export all symbols
   # set_target_properties(${PROJECT_NAME} PROPERTIES LINK_FLAGS "-E")
endif(BUILD_OSX)

# paths to executables
set(APPS ${CMAKE_CURRENT_BINARY_DIR}/${PKG_NAME})
# directories to search for prerequisites. Libraries are copied automatically
set(DIRS ${CMAKE_CURRENT_BINARY_DIR}/lib)
# Plugins are loadable bundles that extend the basic features of your application
set(PLUGINS "")

install(TARGETS ${PROJECT_NAME}
    BUNDLE  DESTINATION "." COMPONENT Runtime # Mac OS X only
    RUNTIME DESTINATION ${PKG_RUNTIME_DESTINATION} COMPONENT Runtime
    # LIBRARY DESTINATION "libs"
    # ARCHIVE DESTINATION "libs/static"
    )

install(FILES main.lua DESTINATION ${PKG_RESOURCE_PREFIX} COMPONENT Runtime)
install(DIRECTORY lua DESTINATION ${PKG_RESOURCE_PREFIX} COMPONENT Runtime)

# rebase the bundle
INSTALL(CODE "
    include(BundleUtilities)
    fixup_bundle(\"${APPS}\" \"${PLUGINS}\" \"${DIRS}\")
    " COMPONENT Runtime)

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
   set(CPACK_PACKAGE_INSTALL_DIRECTORY "CMake ${WOOT_VERSION_MAJOR}.${WOOT_VERSION_MINOR}")
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
