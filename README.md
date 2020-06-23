# MonaServer2 CMake version on Windows
CMakelists version of https://github.com/MonaSolutions/MonaServer2

# Windows Operating Systems

Read the following for the correct version of your environment.

## Dependencies
* **vcpkg** see [Installation](https://github.com/microsoft/vcpkg)
* **Microsoft Visual Studio** see [Installation](https://visualstudio.microsoft.com)
* **OpenSSL** installed via **vcpkg**

## How to install OpenSSL both for x86 and x64 via vcpkg

### DLL version of OpenSSL
#### libssl.dll & libcrypto.dll will be outputted externally with main executable file

* vcpkg install openssl-windows:x86-windows
* vcpkg install openssl-windows:x64-windows

### Static version of OpenSSL
#### 1 executable file will be merged with libssl.lib & libcrypto.lib

* vcpkg install openssl-windows:x86-windows-static
* vcpkg install openssl-windows:x64-windows-static

# OpenSSL library bug with vcpkg and Visual Studio

When you want to compile the **debug** version of **MonaTiny** you will encounter one bug which will break the build process. You will encounter an error message like the following image:

![image](https://user-images.githubusercontent.com/66976729/85026694-467d5700-b179-11ea-9ea7-001547b8a7c7.png)

This happens because the maintainer of **OpenSSL** forgot to use the **set(CMAKE_DEBUG_POSTFIX d)**  flag of their **CMakeLists.txt** when they created the static port on **vcpkg**. I filed a bug on vcpkg's bugs tracker here : https://github.com/microsoft/vcpkg/issues/12001. The workaround for this bug is explained here : https://github.com/microsoft/vcpkg/issues/12001#issuecomment-648097118. Until they fix this issue we have to rely on this little trick to be able to build the whole project without hassle.

# CMakeSettings.json file in Visual Studio (static library merged in executable)

If you are working with CMake directly inside Visual Studio then I recommend that you set the correct parameters in the CMakeSettings.json file for both **x86/x64**. See following image:

![image](https://user-images.githubusercontent.com/66976729/85393300-0d642e80-b54d-11ea-936e-6e9e52639ecd.png)

```
{
  "configurations": [
    {
      "name": "x86-Debug",
      "generator": "Ninja",
      "configurationType": "Debug",
      "buildRoot": "${projectDir}\\out\\build\\${name}",
      "installRoot": "${projectDir}\\out\\install\\${name}",
      "cmakeCommandArgs": "-DVCPKG_TARGET_TRIPLET=x86-windows-static",
      "buildCommandArgs": "",
      "ctestCommandArgs": "",
      "inheritEnvironments": [ "msvc_x86" ],
      "variables": [],
      "cmakeToolchain": "C:/vcpkg/scripts/buildsystems/vcpkg.cmake"
    },
    {
      "name": "x86-Release",
      "generator": "Ninja",
      "configurationType": "Release",
      "buildRoot": "${projectDir}\\out\\build\\${name}",
      "installRoot": "${projectDir}\\out\\install\\${name}",
      "cmakeCommandArgs": "-DVCPKG_TARGET_TRIPLET=x86-windows-static",
      "buildCommandArgs": "",
      "ctestCommandArgs": "",
      "inheritEnvironments": [ "msvc_x86" ],
      "variables": [],
      "cmakeToolchain": "C:/vcpkg/scripts/buildsystems/vcpkg.cmake"
    }
  ]
}
```

# CMakeSettings.json file in Visual Studio (dynamic library separate from  executable)

Just replace with the following line:

```
"cmakeCommandArgs": "-DVCPKG_TARGET_TRIPLET=x86-windows",
```

# Microsoft Visual Studio 2019

This version can be compiled without any problem both as x86 and x64 version.
Note that all dependencies are handled by **vcpkg** integrated with MSVC++ 2019.

# Microsoft Visual Studio 2017

I tried many different solutions to be able to compile with MSVC++ 2017 but due to compiler bug it is impossible to do so.
Also it is important to note that the MS Team mentioned that the bug was fixed in MSVC++ 2019. That's why I uninstalled this
version and reinstalled the latest one. The only way to compile this is by generating one of the following templates with CMake.

* cmake -G "Visual Studio 15 2017" -A Win32
* cmake -G "Visual Studio 15 2017" -A x64

# Microsoft Visual Studio 2015

Since the original official version of the project was made with this version there is no need to do anything. 

# Integration with CMake and vcpkg triplets

Read the following link to setup the triplets used by vcpkg to compile MonServer2 with the static library instead of the dlls.

https://github.com/microsoft/vcpkg/blob/master/docs/users/integration.md#with-cmake

There is actually a bug with OpenSSL concerning static library. I filed a bug on their  vcpkg github repo : https://github.com/microsoft/vcpkg/issues/12001
Untile they fix that incongruence you would have to rename the 2 libraries installed by vcpkg with adding d(debug) the end end of the file name.

# SRT Enabled

Since I don't know yet how to implement this header file the CMake way. It will be ignored until I find a way to understand how to translate this **Pre-Build Event** correctly.

```
if not exist "$(ProjectDir)..\External\include\srt\srt.h" (
	mkdir "$(ProjectDir)..\External\include\srt\"
	copy /Y "$(ProjectDir)..\External\SRT" "$(ProjectDir)..\External\include\srt\srt.h"
)
```
![Pre-Built Event](/images/pre-built-event.jpg)
