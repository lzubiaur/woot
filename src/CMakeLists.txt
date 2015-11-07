cmake_minimum_required(VERSION 3.3)

configure_file("config.h.in" "${PROJECT_BINARY_DIR}/config.h")

include_directories(${GLFW_HEADERS} ${PROJECT_SOURCE_DIR}/src ${PROJECT_BINARY_DIR})

set(RUNTIME_TARGET ${PROJECT_NAME})

add_executable(${RUNTIME_TARGET} main.c file_util.c)
add_dependencies(${RUNTIME_TARGET} liblua liblfs freetype glfw imgui)
target_link_libraries(${RUNTIME_TARGET} liblua)

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
elseif(BUILD_WIN)
    set(APP "${CMAKE_INSTALL_PREFIX}/${BUNDLE_NAME}/bin/${RUNTIME_TARGET}.exe")
    set(PLUGINS_DESTINATION "${CMAKE_INSTALL_PREFIX}/${BUNDLE_NAME}/bin")
    # Runtime destination into the bundle
    set(BUNDLE_RUNTIME_DESTINATION ${BUNDLE_NAME}/bin)
    # create a WinMain() instead of just main()
    set_target_properties(${RUNTIME_TARGET} PROPERTIES WIN32_EXECUTABLE true)
endif(BUILD_OSX)

install(TARGETS ${RUNTIME_TARGET}
    BUNDLE  DESTINATION "." COMPONENT Runtime
    RUNTIME DESTINATION ${BUNDLE_RUNTIME_DESTINATION} COMPONENT Runtime
    LIBRARY DESTINATION ${BUNDLE_RUNTIME_DESTINATION} COMPONENT Runtime
    ARCHIVE DESTINATION ${BUNDLE_RUNTIME_DESTINATION} COMPONENT Runtime
    )

# On Linux and MacOS we use fixup_bundle. On Windows use
# installrequiredsystemlibraries and manually copy plugins
# directories to search for prerequisites. Libraries are copied automatically
set(DIRS ${CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELEASE})

# Plugins are loadable bundles that extend the basic features of your application
# On MacOSX it can be frameworks or shared lib not linked with the executable.
# Plugins must be copied manually before they can be fixed by fixup_bundle.
get_target_property(LFS_LIB_NAME liblfs OUTPUT_NAME)
get_target_property(GLFW_LIB_NAME glfw OUTPUT_NAME)
# Freetype CMakeLists.txt does not set any OUTPUT_NAME for the library target
# get_target_property(FREETYPE_LIB_NAME freetype OUTPUT_NAME)

# DLL shared libraries are build in the runtime directory on Windows
if(BUILD_WIN)
   set(LIB_OUTPUT "${CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE}")
else()
   set(LIB_OUTPUT "${CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELEASE}")
endif()
# Use shorter variable for clarity
set(LIB_PREFIX ${CMAKE_SHARED_LIBRARY_PREFIX})
set(LIB_SUFFIX ${CMAKE_SHARED_LIBRARY_SUFFIX})

set(PLUGINS "${LIB_OUTPUT}/${LIB_PREFIX}${LFS_LIB_NAME}${LIB_SUFFIX}")
list(APPEND PLUGINS "${LIB_OUTPUT}/${LIB_PREFIX}${GLFW_LIB_NAME}${LIB_SUFFIX}")
list(APPEND PLUGINS "${LIB_OUTPUT}/${LIB_PREFIX}freetype${LIB_SUFFIX}")
list(APPEND PLUGINS "${LIB_OUTPUT}/${LIB_PREFIX}imgui${LIB_SUFFIX}")
list(APPEND PLUGINS "${LIB_OUTPUT}/${LIB_PREFIX}DevIL${LIB_SUFFIX}")
list(APPEND PLUGINS "${LIB_OUTPUT}/${LIB_PREFIX}tests${LIB_SUFFIX}")

if(BUILD_WIN)
   # Check the architecture
   if(CMAKE_CL_64)
      if(MSVC_VERSION GREATER 1599)
         # VS 10 and later:
         set(CMAKE_MSVC_ARCH x64)
      else()
         # VS 9 and earlier:
         set(CMAKE_MSVC_ARCH amd64)
      endif()
   else()
      set(CMAKE_MSVC_ARCH x86)
   endif()

   set(CMAKE_INSTALL_SYSTEM_RUNTIME_LIBS_NO_WARNING FALSE)
   set(CMAKE_INSTALL_DEBUG_LIBRARIES_ONLY FALSE)
   set(CMAKE_INSTALL_SYSTEM_RUNTIME_LIBS_SKIP FALSE)
   set(CMAKE_INSTALL_SYSTEM_RUNTIME_LIBS_SKIP_NO_WARNINGS OFF)
   set(CMAKE_INSTALL_MFC_LIBRARIES FALSE)
   set(PROG_FILES_DIR "$ENV{ProgramFiles}")
   string(REGEX REPLACE "\\\\" "/" PROG_FILES_DIR ${PROG_FILES_DIR})
   # Copy all the redistribuable C Runtime Libraries (CRT) so we can support pre-Windows10 systems
   # without requestng the user to manually install VCRedist
   # VCRedist may be installed automatically if an installer is used to install the application (see CPack)
   # http://blogs.msdn.com/b/vcblog/archive/2015/03/03/introducing-the-universal-crt.aspx
   file(GLOB CRT_REDIST_DLL "${PROG_FILES_DIR}/Windows Kits/10/Redist/ucrt/DLLs/${CMAKE_MSVC_ARCH}/*.dll")
   # message(STATUS "DEBUG ${CRT_REDIST_DLL}")
   set(CMAKE_INSTALL_SYSTEM_RUNTIME_LIBS "${CRT_REDIST_DLL}")
   set(CMAKE_INSTALL_SYSTEM_RUNTIME_DESTINATION "${BUNDLE_RUNTIME_DESTINATION}")
   # Using install(CODE) does not work because the cmake environment is not exported
   # install(CODE "include(InstallRequiredSystemLibraries)" COMPONENT Runtime)
   include(InstallRequiredSystemLibraries)
endif(BUILD_WIN)

# Rebase the bundle using configurable cmake script (fixup_bundle.cmake.in)
# Could be done using "install CODE" but it's more flexible using script. Plus get_filename_component
# doesn't seem to work in embedded script ("install CODE").
set(fixup_bundle ${PROJECT_BINARY_DIR}/fixup_bundle.cmake)
configure_file(../cmake/fixup_bundle.cmake.in ${fixup_bundle} @ONLY)
install(SCRIPT ${fixup_bundle} COMPONENT Runtime)

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
