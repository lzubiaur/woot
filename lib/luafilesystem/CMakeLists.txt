cmake_minimum_required(VERSION 3.3)

# set(LFS_ROOT "${PROJECT_SOURCE_DIR}/luafilesystem")
# set(LFS_WORKING_DIR "${CMAKE_BINARY_DIR}/luafilesystem")
# set(LFS_INCLUDE "${LFS_WORKING_DIR}/src")

# Copy to the build directory. Not required since we don't use the provided make file
# add_custom_target(copy_lfs
    # COMMAND ${CMAKE_COMMAND} -E echo "Copying LuaFileSystem source to build directory..."
    # COMMAND ${CMAKE_COMMAND} -E make_directory ${LFS_WORKING_DIR}
    # COMMAND ${CMAKE_COMMAND} -E copy_directory ${LFS_ROOT} ${LFS_WORKING_DIR}
# )

# Add the libary target. Note that we can't specify the source using
# ${CMAKE_BINARY_DIR}/src/lfs.c because it's not yet copied in the build dir.
# Include the def file to expose the module loading function on Windows (luaopen_lfs)
add_library(liblfs SHARED src/lfs.c src/lfs.def)
# Add dependencies targets
# add_dependencies(liblfs copy_lfs libluajit) # Copy files to the build dir before building the shared library
# add_dependencies(liblfs liblua)

include_directories("${PROJECT_SOURCE_DIR}/luajit-2.0/src")
set_target_properties(liblfs PROPERTIES OUTPUT_NAME "lfs")

# Specify libraries or flags to use when linking with target libfls
if(NOT BUILD_LINUX)
    # TODO Doesn't work on Linux but required on Windows and OSX. Why?
    target_link_libraries(liblfs liblua)
endif()
target_include_directories(liblfs PUBLIC ${LFS_INCLUDE})
