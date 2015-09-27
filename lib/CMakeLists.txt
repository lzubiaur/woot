cmake_minimum_required(VERSION 3.0)
project(lib)

set(GLFW_HEADERS "${PROJECT_SOURCE_DIR}/glfw/include" PARENT_SCOPE)

# GLFW options
set(BUILD_SHARED_LIBS ON)
set(GLFW_BUILD_EXAMPLES OFF)
set(GLFW_BUILD_TESTS OFF)
set(GLFW_BUILD_DOCS OFF)
set(GLFW_INSTALL OFF)
set(GLFW_DOCUMENT_INTERNALS OFF)

# Add third-party libraries
add_subdirectory(glfw)
add_subdirectory(luajit-2.0)
