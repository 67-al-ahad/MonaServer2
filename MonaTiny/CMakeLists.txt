cmake_minimum_required(VERSION 3.0)

project(MonaTiny)

set(OPENSSL_USE_STATIC_LIBS TRUE)
find_package(OpenSSL REQUIRED)
#[[ This section is about showing internal variables from both vcpkg and CMake
get_cmake_property(_variableNames VARIABLES)

list (SORT _variableNames)
foreach (_variableName ${_variableNames})
    message(STATUS "${_variableName}=${${_variableName}}")
endforeach()
]]

message(STATUS "OPENSSL_ROOT_DIR             ${OPENSSL_ROOT_DIR}")
message(STATUS "OPENSSL_APPLINK_SOURCE            ${OPENSSL_APPLINK_SOURCE}")
message(STATUS "OPENSSL_INCLUDE_DIR            ${OPENSSL_INCLUDE_DIR}")
message(STATUS "OPENSSL_VERSION            ${OPENSSL_VERSION}")
message(STATUS "OPENSSL_LIBRARIES            ${OPENSSL_LIBRARIES}")
message(STATUS "OPENSSL_SSL_LIBRARIES            ${OPENSSL_SSL_LIBRARIES}")
message(STATUS "OPENSSL_SSL_LIBRARY            ${OPENSSL_SSL_LIBRARY}")
message(STATUS "OPENSSL_CRYPTO_LIBRARIES            ${OPENSSL_CRYPTO_LIBRARIES}")
message(STATUS "OPENSSL_CRYPTO_LIBRARY            ${OPENSSL_CRYPTO_LIBRARY}")
message(STATUS "OPENSSL_INCLUDE_DIR            ${OPENSSL_INCLUDE_DIR}")
message(STATUS "OPENSSL_FOUND            ${OPENSSL_FOUND}")

message(STATUS "")
message(STATUS "")
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

message(STATUS "Current folder : ${CMAKE_CURRENT_SOURCE_DIR}")

file(GLOB_RECURSE SOURCE "sources/*.*" LIST_DIRECTORIES true )

add_executable(${PROJECT_NAME} ${SOURCE})

#target_include_directories(${PROJECT_NAME} PRIVATE ${OPENSSL_INCLUDE_DIR})

#[[target_link_libraries links a library file (.lib) to a target(MSVC solution). It is the same as going in the property editor in Microsoft Visual C++
and adding in the Linker folder in the Input property the full path of a normal library.lib file]]
target_link_libraries(${PROJECT_NAME} PRIVATE MonaBase MonaCore OpenSSL::SSL OpenSSL::Crypto)

#install(FILES ${HEADERS} DESTINATION $<INSTALL_INTERFACE:include/${TOLOWER})

add_custom_target(fake_install_${PROJECT_NAME}
    ALL
    "${CMAKE_COMMAND}"
    -D CMAKE_INSTALL_PREFIX:string=${CMAKE_CURRENT_BINARY_DIR}/testdir
    -P "${CMAKE_CURRENT_BINARY_DIR}/cmake_install.cmake"
    DEPENDS ${PROJECT_NAME} )
