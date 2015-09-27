cmake_minimum_required(VERSION 3.0)
project(lib)

set(GLFW_HEADERS "${PROJECT_SOURCE_DIR}/glfw/include" PARENT_SCOPE)

# GLFW options
option(BUILD_SHARED_LIBS ON)
option(GLFW_BUILD_EXAMPLES OFF)
option(GLFW_BUILD_TESTS OFF)
option(GLFW_BUILD_DOCS OFF)
option(GLFW_INSTALL OFF)
option(GLFW_DOCUMENT_INTERNALS OFF)

# Add third-party libraries
add_subdirectory(glfw)
add_subdirectory(luajit-2.0)

