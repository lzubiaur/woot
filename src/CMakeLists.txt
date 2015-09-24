cmake_minimum_required(VERSION 3.0)

# Internal version number for the Woot game engine
set(WOOT_VERSION_MAJOR "0")
set(WOOT_VERSION_MINOR "1")
set(WOOT_VERSION_PATCH "1")
set(WOOT_VERSION_EXTRA "b")
set(WOOT_VERSION "${WOOT_VERSION_MAJOR}.${WOOT_VERSION_MINOR}")
set(WOOT_VERSION_FULL "${WOOT_VERSION}.${WOOT_VERSION_PATCH}${WOOT_VERSION_EXTRA}")

# configure a header file to pass some of the CMake settings
# to the source code
configure_file("woot_config.h.in" "${PROJECT_BINARY_DIR}/src/woot_config.h")

