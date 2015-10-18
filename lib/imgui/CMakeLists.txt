cmake_minimum_required(VERSION 3.3 FATAL_ERROR)

project(libimgui C CXX)

set(IMGUI_SRC imgui.cpp imgui_demo.cpp imgui_draw.cpp imgui_impl_glfw_gl3.cpp)

include_directories(${GLFW_HEADERS})

add_library(imgui SHARED ${IMGUI_SRC})

add_dependencies(imgui gl3w glfw)

target_link_libraries(imgui glfw gl3w)

target_include_directories(imgui PUBLIC ${PROJECT_SOURCE_DIR})
