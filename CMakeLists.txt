cmake_minimum_required(VERSION 3.0)

project(MonaServer2)

# -----------------------------------------------------------------------------
# Project name lower case
#-----------------------------------------------------------------------------
message(STATUS "CMAKE_BUILD_TYPE BEFORE ${CMAKE_BUILD_TYPE}")

if(${CMAKE_BUILD_TYPE} MATCHES "")
	set(${CMAKE_BUILD_TYPE} "Debug")
endif()

message(STATUS "CMAKE_BUILD_TYPE AFTER ${CMAKE_BUILD_TYPE}")

string(TOLOWER ${PROJECT_NAME} PROJECT_NAME_LOWER)

message(STATUS "CMAKE_BUILD_TYPE            ${CMAKE_BUILD_TYPE}")
message(STATUS "")
message(STATUS "PROJECT_NAME				${PROJECT_NAME}")
message(STATUS "CMAKE_BINARY_DIR            ${CMAKE_BINARY_DIR}")
message(STATUS "CMAKE_CURRENT_BINARY_DIR            ${CMAKE_CURRENT_BINARY_DIR}")
message(STATUS "CMAKE_SOURCE_DIR            ${CMAKE_SOURCE_DIR}")
message(STATUS "CMAKE_CURRENT_SOURCE_DIR            ${CMAKE_CURRENT_SOURCE_DIR}")
message(STATUS "CMAKE_INCLUDE_PATH             ${CMAKE_INCLUDE_PATH}")
message(STATUS "CMAKE_LIBRARY_PATH              ${CMAKE_LIBRARY_PATH}")

add_subdirectory(MonaBase)
add_subdirectory(MonaCore)
#add_subdirectory(MonaServer)
add_subdirectory(MonaTiny)
