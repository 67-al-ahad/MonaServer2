# MonaServer2 CMake version on Windows
CMakelists version of https://github.com/MonaSolutions/MonaServer2

# Windows Operating Systems

Read the following for the correct version of your environment.

## Dependencies
* **vcpkg** see [Installation](https://github.com/microsoft/vcpkg)
* **Microsoft Visual Studio** see [Installation](https://visualstudio.microsoft.com)
* **openSSL** installed via **vcpkg**

## How to install openSSL both for x86 and x64 via vcpkg

### DLL version of OpenSSL
#### libssl.dll & libcrypto.dll will be outputted externally with main executable file

* vcpkg install openssl-windows:x86-windows
* vcpkg install openssl-windows:x64-windows

### Static version of OpenSSL
#### 1 executable file will be merged with libssl.lib & libcrypto.lib

* vcpkg install openssl-windows:x86-windows-static
* vcpkg install openssl-windows:x64-windows-static

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
