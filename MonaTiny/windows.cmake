message(STATUS "STARTING WINDOWS BUILD")

message(STATUS "Setting MSVC flags")
#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /EHc /std:c++latest")

message(STATUS "ARCH ${CMAKE_HOST_WIN32}")
message(STATUS "CMAKE_SYSTEM_PROCESSOR ${CMAKE_SYSTEM_PROCESSOR}")

if(${CMAKE_HOST_WIN32})
	message(STATUS "Multithreaded library in DEBUG compilation")
	if (CMAKE_BUILD_TYPE MATCHES Debug)
		add_compile_options(/MP /GS /W3 /ZI /Od /sdl /GF- /WX- /Zc:forScope /RTC1 /Gd /Oy- /MDd) #/Gm-
	else ()
		add_compile_options(/MP /GS- /W3 /GM- /Ox /Ob2 /GF /WX- /Gd /Oy /Oi /MTd) #/wd""4267"" /wd""4244"" /wd"4800"
	endif ()
else()
	message(STATUS "Multithreaded library in RELEASE compilation")
	if (CMAKE_BUILD_TYPE MATCHES Debug)
		add_compile_options(/MP /GS /GL /analyze- /W3 /Gm- /Ox /Ob2 /GF- /WX- /Zc:forScope /Gd /Oy /Oi /MDd)
	else ()
		add_compile_options(/MP /GS /GL /W3 /GM- /GF /WX- /Zc:forScope /Gd /Oy /Oi /MTd) #/wd""4267"" /wd""4244"" /wd""4800""
	endif ()
endif()

add_compile_options(/analyze- /Zc:inline /fp:precise )