cmake_minimum_required(VERSION 3.3 FATAL_ERROR)
project(libimgui C CXX)

set(IMGUI_SRC imgui.cpp imgui_demo.cpp imgui_draw.cpp)
add_library(imgui SHARED ${IMGUI_SRC})
target_include_directories(imgui PUBLIC ${PROJECT_SOURCE_DIR})
