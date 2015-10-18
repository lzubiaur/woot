cmake_minimum_required(VERSION 3.3)
project(tests C CXX)

# include_directories(${GLFW_HEADERS})

# LuaJIT
add_library(tests src/tests.c)
# add_dependencies(test_luajit liblua)
# target_link_libraries(test_luajit liblua)

if(BUILD_OSX)
    set(INSTALL_DESTINATION "${BUNDLE_NAME}/Contents/MacOS")
elseif()
    set(INSTALL_DESTINATION "${BUNDLE_NAME}/bin")
endif()

install(TARGETS tests
    LIBRARY DESTINATION ${INSTALL_DESTINATION} COMPONENT Runtime
)

# Copy the content of the res folder into the package resource directory
file(GLOB TESTS_RESOURCES RELATIVE "${PROJECT_SOURCE_DIR}" "lua/*")
file(COPY ${TESTS_RESOURCES} DESTINATION ${CMAKE_INSTALL_PREFIX}/${BUNDLE_RESOURCE_PREFIX}/lua)
