cmake_minimum_required(VERSION 2.8)
project(gl3w)


if(BUILD_OSX)
    set(CMAKE_C_FLAGS "-x objective-c")
endif()

include_directories(include)

add_library(gl3w src/gl3w.c)

target_include_directories(gl3w PUBLIC ${PROJECT_SOURCE_DIR}/include)

if(UNIX)
    target_link_libraries(gl3w dl)
elseif(BUILD_OSX)
    target_link_libraries(gl3w
        "-framework Cocoa"
        "-framework AppKit"
        "-framework CoreData"
        "-framework Foundation"
    )
endif()
