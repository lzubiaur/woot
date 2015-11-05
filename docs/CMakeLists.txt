cmake_minimum_required(VERSION 3.3 FATAL_ERROR)
project(docs)

find_package(MkDocs REQUIRED)

# message(STATUS "${MKDOCS_EXECUTABLE} ${MKDOCS_VERSION}")

set(PROJECT_NAME "Woot")
set(AUTHOR "Laurent Zubiaur")
set(COPYRIGHT "Laurent Zubiaur 2015")
set(DOCS_DIR ${PROJECT_SOURCE_DIR})
set(SITE_DIR ${PROJECT_BINARY_DIR}/docs)
set(USE_DIRECTORY_URLS FALSE)
configure_file("mkdocs.yml.in" "${PROJECT_BINARY_DIR}/mkdocs.yml")

add_custom_target(docs ALL ${MKDOCS_EXECUTABLE} build
                  WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
                  COMMENT "Generating HTML documentation" VERBATIM)

install(DIRECTORY "${PROJECT_BINARY_DIR}/docs" DESTINATION .
PATTERN "CMakeLists.txt" EXCLUDE
PATTERN "mkdocs.yml.in" EXCLUDE)
