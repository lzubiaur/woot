cmake_minimum_required(VERSION 3.3 FATAL_ERROR)
project(docs)

set(PROJECT_NAME "Woot")
set(AUTHOR "Laurent Zubiaur")
set(COPYRIGHT "Laurent Zubiaur 2015")
set(DOCS_DIR ${PROJECT_SOURCE_DIR})
set(SITE_DIR ${PROJECT_BINARY_DIR})
configure_file("mkdocs.yml.in" "${PROJECT_BINARY_DIR}/mkdocs.yml")
