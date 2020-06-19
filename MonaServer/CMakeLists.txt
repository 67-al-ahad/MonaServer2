cmake_minimum_required(VERSION 3.0)

project(MonaServer)

find_package(Lua51 REQUIRED)
set(OPENSSL_USE_STATIC_LIBS TRUE)
find_package(OpenSSL REQUIRED)
#[[ This section is about showing internal variables from both vcpkg and CMake
get_cmake_property(_variableNames VARIABLES)

list (SORT _variableNames)
foreach (_variableName ${_variableNames})
    message(STATUS "${_variableName}=${${_variableName}}")
endforeach()
]]

#set(CMAKE_DEBUG_POSTFIX d)

message(STATUS "CMAKE_BUILD_TYPE            ${CMAKE_BUILD_TYPE}")
message(STATUS "")
message(STATUS "PROJECT_NAME				${PROJECT_NAME}")
message(STATUS "CMAKE_BINARY_DIR            ${CMAKE_BINARY_DIR}")
message(STATUS "CMAKE_CURRENT_BINARY_DIR            ${CMAKE_CURRENT_BINARY_DIR}")
message(STATUS "CMAKE_SOURCE_DIR            ${CMAKE_SOURCE_DIR}")
message(STATUS "CMAKE_CURRENT_SOURCE_DIR            ${CMAKE_CURRENT_SOURCE_DIR}")
message(STATUS "CMAKE_INCLUDE_PATH             ${CMAKE_INCLUDE_PATH}")
message(STATUS "CMAKE_LIBRARY_PATH              ${CMAKE_LIBRARY_PATH}")
# -----------------------------------------------------------------------------
# Project name lower case
#-----------------------------------------------------------------------------

string(TOLOWER ${PROJECT_NAME} PROJECT_NAME_LOWER)

if(WIN32)
    include(windows.cmake)
else()
    include(unix.cmake)
endif()

message(STATUS "Current folder : ${CMAKE_CURRENT_SOURCE_DIR}")

file(GLOB_RECURSE SOURCE "sources/*.cpp" LIST_DIRECTORIES true )

add_executable(${PROJECT_NAME} ${SOURCE})

#target_include_directories(${PROJECT_NAME} PUBLIC "${HEADERS_FOLDER}\${PROJECT_NAME}")

#[[target_link_libraries links a library file (.lib) to a target(MSVC solution). It is the same as going in the property editor in Microsoft Visual C++
and adding in the Linker folder in the Input property the full path of a normal library.lib file]]
target_link_libraries(${PROJECT_NAME} MonaBase MonaCore Lua51 OpenSSL::SSL OpenSSL::Crypto ${LUA_LIBRARIES})

#install(FILES ${HEADERS} DESTINATION $<INSTALL_INTERFACE:include/${TOLOWER})

#install(TARGETS ${PROJECT_NAME} DESTINATION bin)

add_custom_target(fake_install_${PROJECT_NAME}
    ALL
    "${CMAKE_COMMAND}"
    -D CMAKE_INSTALL_PREFIX:string=${CMAKE_CURRENT_BINARY_DIR}/testdir
    -P "${CMAKE_CURRENT_BINARY_DIR}/cmake_install.cmake"
    DEPENDS ${PROJECT_NAME} )
