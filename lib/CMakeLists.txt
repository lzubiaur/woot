cmake_minimum_required(VERSION 3.3)
project(lib)

set(GLFW_HEADERS "${PROJECT_SOURCE_DIR}/glfw/include" PARENT_SCOPE)

add_subdirectory(glfw)
add_subdirectory(luajit-2.0)
