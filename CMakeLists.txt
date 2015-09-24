cmake_minimum_required(VERSION 3.0)
project(woot)

set(CMAKE_INSTALL_PREFIX ${PROJECT_SOURCE_DIR}/products) 

# add_definitions(-Wall -std=c++0x)
add_definitions(-Wall)

add_subdirectory(lib)
add_subdirectory(tests)

#add_executable(${PROJECT_NAME} src/woot.cpp)
#target_link_libraries(${PROJECT_NAME} liblua)

