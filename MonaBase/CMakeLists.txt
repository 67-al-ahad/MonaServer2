cmake_minimum_required(VERSION 3.0)

project(MonaBase)

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
message(STATUS "")
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

#-----------------------------------------------------------------------------
# CMake options
#-----------------------------------------------------------------------------

function(CACHE_VAR _var_name _var_default _var_type _var_help)
  set(_advanced 0)
  set(_force)
  foreach(_argn ${ARGN})
    if(_argn STREQUAL ADVANCED)
      set(_advanced 1)
    elseif(_argn STREQUAL FORCE)
      set(_force FORCE)
    endif()
  endforeach()

  set(${_var_name} ${_var_default} CACHE ${_var_type} "${_var_help}" ${_force})
  if(_advanced)
    mark_as_advanced(${_var_name})
  endif()
endfunction()

#-----------------------------------------------------------------------------
# Set a default build type if none was specified
#-----------------------------------------------------------------------------

if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  message(STATUS "Setting build type to 'Debug' as none was specified.")
  set(CMAKE_BUILD_TYPE Debug CACHE STRING "Choose the type of build." FORCE)

  # Set the possible values of build type for cmake-gui
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY
               STRINGS "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
endif()

option(SRT_ENABLED "Enable if SRT protocol should be integrated in build" 0)

if(WIN32)
    include(windows.cmake)

  set(default_runtime_install_dir bin/)
  set(default_tools_install_dir bin/)
  set(default_library_install_dir bin/)
  set(default_archive_install_dir lib/)
  set(default_header_install_dir include/${PROJECT_NAME_LOWER})
  set(default_auxiliary_install_dir share/${PROJECT_NAME_LOWER})
else()
    include(unix.cmake)
endif()

#-----------------------------------------------------------------------------
# Caching variables
#-----------------------------------------------------------------------------

CACHE_VAR(RUNTIME_INSTALL_DIR ${default_runtime_install_dir} STRING "Relative install location for binaries" ADVANCED)
CACHE_VAR(TOOLS_INSTALL_DIR ${default_tools_install_dir} STRING "Relative install location for tools" ADVANCED)
CACHE_VAR(LIBRARY_INSTALL_DIR ${default_library_install_dir} STRING "Relative install location for libraries" ADVANCED)
CACHE_VAR(ARCHIVE_INSTALL_DIR ${default_archive_install_dir} STRING "Relative install location for archives" ADVANCED)
CACHE_VAR(HEADER_INSTALL_DIR ${default_header_install_dir} STRING "Relative install location for headers" ADVANCED)
CACHE_VAR(AUXILIARY_INSTALL_DIR ${default_auxiliary_install_dir} STRING "Relative install location for auxiliary files" ADVANCED)

message(STATUS "Configuration ${Configuration}")
IF(OPENSSL_FOUND)
    message(STATUS "")
    message(STATUS "")
    message(STATUS "OpenSSL found successfully !")
    message(STATUS "OPENSSL_VERSION			${OPENSSL_VERSION}")
	message(STATUS "OPENSSL_INCLUDE_DIR			${OPENSSL_INCLUDE_DIR}")
    message(STATUS "OPENSSL_CRYPTO_LIBRARY		${OPENSSL_CRYPTO_LIBRARY}")
    message(STATUS "OPENSSL_SSL_LIBRARY			${OPENSSL_SSL_LIBRARY}")
    message(STATUS "OPENSSL_LIBRARIES			${OPENSSL_LIBRARIES}")
    
	message(STATUS "")
    message(STATUS "")
ENDIF(OPENSSL_FOUND)

message(STATUS "Current folder : ${CMAKE_CURRENT_SOURCE_DIR}")

set(HEADERS_FOLDER "${CMAKE_CURRENT_SOURCE_DIR}/include")
set(SOURCE_FOLDER "${CMAKE_CURRENT_SOURCE_DIR}/sources")

#message(STATUS "Headers folder : ${HEADERS_FOLDER}")
#message(STATUS "Source folder : ${SOURCE_FOLDER}")

#aux_source_directory(${HEADERS_FOLDER} HEADERS)
#aux_source_directory(${SOURCE_FOLDER} SOURCE)


file(GLOB_RECURSE HEADERS "include/*.h" LIST_DIRECTORIES true )
file(GLOB_RECURSE SOURCE "sources/*.cpp" LIST_DIRECTORIES true )

message(STATUS "")
#message(STATUS "Header files ${HEADERS}")
#message(STATUS "Source files ${SOURCE}")
message(STATUS "")
#message(STATUS "Supported features = ${CMAKE_CXX_COMPILE_FEATURES}")
message(STATUS "")

add_library(${PROJECT_NAME} STATIC ${SOURCE} ${HEADERS})

#include_directories(BEFORE ${HEADERS_FOLDER})
#target_include_directories(${PROJECT_NAME} PRIVATE ${HEADERS_FOLDER})

#[[target_include_directories adds an include directory to a target(MSVC solution). PUBLIC doesn't mean much for an executable;
for a library it lets CMake know that any targets that link to this target must also need that include directory.
It is the same as going in the property editor in Microsoft Visual C++ and adding in the C/C++ folder in the Additional Include Directories
the full path from a folder containing many header(*.h) files.]]
target_include_directories(${PROJECT_NAME} PRIVATE include ) #${OPENSSL_INCLUDE_DIR}
target_include_directories(${PROJECT_NAME} INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include> $<INSTALL_INTERFACE:include/mona-base>
)

#target_include_directories(${PROJECT_NAME} PUBLIC "${HEADERS_FOLDER}\${PROJECT_NAME}")

#[[target_link_libraries links a library file (.lib) to a target(MSVC solution). It is the same as going in the property editor in Microsoft Visual C++
and adding in the Linker folder in the Input property the full path of a normal library.lib file]]

target_link_libraries(${PROJECT_NAME} OpenSSL::SSL OpenSSL::Crypto)

#install(FILES ${HEADERS} DESTINATION $<INSTALL_INTERFACE:include/${TOLOWER})

install(TARGETS ${PROJECT_NAME}
        RUNTIME DESTINATION bin
        LIBRARY DESTINATION lib
        ARCHIVE DESTINATION lib)

install(DIRECTORY include/ DESTINATION include/mona-base FILES_MATCHING PATTERN "*.h")

if(${CMAKE_BUILD_TYPE} MATCHES "Debug")
    install(TARGETS ${PROJECT_NAME} CONFIGURATIONS Debug RUNTIME DESTINATION Debug/lib)
else()
    install(TARGETS ${PROJECT_NAME} CONFIGURATIONS Release RUNTIME DESTINATION lib)
endif()

add_custom_target(fake_install_${PROJECT_NAME}
    ALL
    "${CMAKE_COMMAND}"
    -D CMAKE_INSTALL_PREFIX:string=${CMAKE_CURRENT_BINARY_DIR}/testdir
    -P "${CMAKE_CURRENT_BINARY_DIR}/cmake_install.cmake"
    DEPENDS ${PROJECT_NAME} )
