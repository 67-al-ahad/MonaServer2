cmake_minimum_required(VERSION 3.0)

project(MonaCore)

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

file(GLOB_RECURSE HEADERS "include/*.h" LIST_DIRECTORIES true )
file(GLOB_RECURSE SOURCE "sources/*.cpp" LIST_DIRECTORIES true )

add_library(${PROJECT_NAME} STATIC ${SOURCE} ${HEADERS})

set_property(TARGET ${PROJECT_NAME} PROPERTY CXX_STANDARD 14)
set_property(TARGET ${PROJECT_NAME} PROPERTY CXX_STANDARD_REQUIRED ON)
#[[target_include_directories adds an include directory to a target(MSVC solution). PUBLIC doesn't mean much for an executable;
for a library it lets CMake know that any targets that link to this target must also need that include directory.
It is the same as going in the property editor in Microsoft Visual C++ and adding in the C/C++ folder in the Additional Include Directories
the full path from a folder containing many header(*.h) files.]]
target_include_directories(${PROJECT_NAME} PRIVATE include)
target_include_directories(${PROJECT_NAME} INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include> $<INSTALL_INTERFACE:include/mona-core>
)

#target_include_directories(${PROJECT_NAME} PUBLIC "${HEADERS_FOLDER}\${PROJECT_NAME}")

#[[target_link_libraries links a library file (.lib) to a target(MSVC solution). It is the same as going in the property editor in Microsoft Visual C++
and adding in the Linker folder in the Input property the full path of a normal library.lib file]]
target_link_libraries(${PROJECT_NAME} PRIVATE MonaBase OpenSSL::SSL OpenSSL::Crypto) # Ws2_32.lib Crypt32.lib

#install(FILES ${HEADERS} DESTINATION $<INSTALL_INTERFACE:include/${TOLOWER})

install(TARGETS ${PROJECT_NAME}
        RUNTIME DESTINATION bin
        LIBRARY DESTINATION lib
        ARCHIVE DESTINATION lib)

install(DIRECTORY include/ DESTINATION include/mona-core FILES_MATCHING PATTERN "*.h")

# This will install the necessary files to C:\vcpkg\installed\x86-windows
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
