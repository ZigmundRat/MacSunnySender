# Install script for directory: /Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/yasdi-1/projects/generic-cmake

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/usr/local")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Release")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  if("${CMAKE_INSTALL_CONFIG_NAME}" MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/bin" TYPE EXECUTABLE FILES "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Debug/yasdishell")
    if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/yasdishell" AND
       NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/yasdishell")
      execute_process(COMMAND "/usr/bin/install_name_tool"
        -change "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Debug/libyasdi.1.dylib" "libyasdi.1.dylib"
        -change "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Debug/libyasdimaster.1.dylib" "libyasdimaster.1.dylib"
        "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/yasdishell")
      if(CMAKE_INSTALL_DO_STRIP)
        execute_process(COMMAND "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/strip" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/yasdishell")
      endif()
    endif()
  elseif("${CMAKE_INSTALL_CONFIG_NAME}" MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/bin" TYPE EXECUTABLE FILES "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Release/yasdishell")
    if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/yasdishell" AND
       NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/yasdishell")
      execute_process(COMMAND "/usr/bin/install_name_tool"
        -change "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Release/libyasdi.1.dylib" "libyasdi.1.dylib"
        -change "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Release/libyasdimaster.1.dylib" "libyasdimaster.1.dylib"
        "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/yasdishell")
      if(CMAKE_INSTALL_DO_STRIP)
        execute_process(COMMAND "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/strip" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/yasdishell")
      endif()
    endif()
  elseif("${CMAKE_INSTALL_CONFIG_NAME}" MATCHES "^([Mm][Ii][Nn][Ss][Ii][Zz][Ee][Rr][Ee][Ll])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/bin" TYPE EXECUTABLE FILES "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/MinSizeRel/yasdishell")
    if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/yasdishell" AND
       NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/yasdishell")
      execute_process(COMMAND "/usr/bin/install_name_tool"
        -change "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/MinSizeRel/libyasdi.1.dylib" "libyasdi.1.dylib"
        -change "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/MinSizeRel/libyasdimaster.1.dylib" "libyasdimaster.1.dylib"
        "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/yasdishell")
      if(CMAKE_INSTALL_DO_STRIP)
        execute_process(COMMAND "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/strip" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/yasdishell")
      endif()
    endif()
  elseif("${CMAKE_INSTALL_CONFIG_NAME}" MATCHES "^([Rr][Ee][Ll][Ww][Ii][Tt][Hh][Dd][Ee][Bb][Ii][Nn][Ff][Oo])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/bin" TYPE EXECUTABLE FILES "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/RelWithDebInfo/yasdishell")
    if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/yasdishell" AND
       NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/yasdishell")
      execute_process(COMMAND "/usr/bin/install_name_tool"
        -change "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/RelWithDebInfo/libyasdi.1.dylib" "libyasdi.1.dylib"
        -change "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/RelWithDebInfo/libyasdimaster.1.dylib" "libyasdimaster.1.dylib"
        "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/yasdishell")
      if(CMAKE_INSTALL_DO_STRIP)
        execute_process(COMMAND "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/strip" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/yasdishell")
      endif()
    endif()
  endif()
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  if("${CMAKE_INSTALL_CONFIG_NAME}" MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES
      "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Debug/libyasdi.1.8.1.dylib"
      "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Debug/libyasdi.1.dylib"
      "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Debug/libyasdi.dylib"
      )
    foreach(file
        "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libyasdi.1.8.1.dylib"
        "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libyasdi.1.dylib"
        "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libyasdi.dylib"
        )
      if(EXISTS "${file}" AND
         NOT IS_SYMLINK "${file}")
        execute_process(COMMAND "/usr/bin/install_name_tool"
          -id "libyasdi.1.dylib"
          "${file}")
        if(CMAKE_INSTALL_DO_STRIP)
          execute_process(COMMAND "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/strip" "${file}")
        endif()
      endif()
    endforeach()
  elseif("${CMAKE_INSTALL_CONFIG_NAME}" MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES
      "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Release/libyasdi.1.8.1.dylib"
      "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Release/libyasdi.1.dylib"
      "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Release/libyasdi.dylib"
      )
    foreach(file
        "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libyasdi.1.8.1.dylib"
        "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libyasdi.1.dylib"
        "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libyasdi.dylib"
        )
      if(EXISTS "${file}" AND
         NOT IS_SYMLINK "${file}")
        execute_process(COMMAND "/usr/bin/install_name_tool"
          -id "libyasdi.1.dylib"
          "${file}")
        if(CMAKE_INSTALL_DO_STRIP)
          execute_process(COMMAND "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/strip" "${file}")
        endif()
      endif()
    endforeach()
  elseif("${CMAKE_INSTALL_CONFIG_NAME}" MATCHES "^([Mm][Ii][Nn][Ss][Ii][Zz][Ee][Rr][Ee][Ll])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES
      "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/MinSizeRel/libyasdi.1.8.1.dylib"
      "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/MinSizeRel/libyasdi.1.dylib"
      "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/MinSizeRel/libyasdi.dylib"
      )
    foreach(file
        "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libyasdi.1.8.1.dylib"
        "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libyasdi.1.dylib"
        "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libyasdi.dylib"
        )
      if(EXISTS "${file}" AND
         NOT IS_SYMLINK "${file}")
        execute_process(COMMAND "/usr/bin/install_name_tool"
          -id "libyasdi.1.dylib"
          "${file}")
        if(CMAKE_INSTALL_DO_STRIP)
          execute_process(COMMAND "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/strip" "${file}")
        endif()
      endif()
    endforeach()
  elseif("${CMAKE_INSTALL_CONFIG_NAME}" MATCHES "^([Rr][Ee][Ll][Ww][Ii][Tt][Hh][Dd][Ee][Bb][Ii][Nn][Ff][Oo])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES
      "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/RelWithDebInfo/libyasdi.1.8.1.dylib"
      "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/RelWithDebInfo/libyasdi.1.dylib"
      "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/RelWithDebInfo/libyasdi.dylib"
      )
    foreach(file
        "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libyasdi.1.8.1.dylib"
        "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libyasdi.1.dylib"
        "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libyasdi.dylib"
        )
      if(EXISTS "${file}" AND
         NOT IS_SYMLINK "${file}")
        execute_process(COMMAND "/usr/bin/install_name_tool"
          -id "libyasdi.1.dylib"
          "${file}")
        if(CMAKE_INSTALL_DO_STRIP)
          execute_process(COMMAND "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/strip" "${file}")
        endif()
      endif()
    endforeach()
  endif()
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  if("${CMAKE_INSTALL_CONFIG_NAME}" MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES
      "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Debug/libyasdimaster.1.8.1.dylib"
      "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Debug/libyasdimaster.1.dylib"
      "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Debug/libyasdimaster.dylib"
      )
    foreach(file
        "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libyasdimaster.1.8.1.dylib"
        "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libyasdimaster.1.dylib"
        "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libyasdimaster.dylib"
        )
      if(EXISTS "${file}" AND
         NOT IS_SYMLINK "${file}")
        execute_process(COMMAND "/usr/bin/install_name_tool"
          -id "libyasdimaster.1.dylib"
          -change "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Debug/libyasdi.1.dylib" "libyasdi.1.dylib"
          "${file}")
        if(CMAKE_INSTALL_DO_STRIP)
          execute_process(COMMAND "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/strip" "${file}")
        endif()
      endif()
    endforeach()
  elseif("${CMAKE_INSTALL_CONFIG_NAME}" MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES
      "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Release/libyasdimaster.1.8.1.dylib"
      "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Release/libyasdimaster.1.dylib"
      "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Release/libyasdimaster.dylib"
      )
    foreach(file
        "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libyasdimaster.1.8.1.dylib"
        "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libyasdimaster.1.dylib"
        "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libyasdimaster.dylib"
        )
      if(EXISTS "${file}" AND
         NOT IS_SYMLINK "${file}")
        execute_process(COMMAND "/usr/bin/install_name_tool"
          -id "libyasdimaster.1.dylib"
          -change "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Release/libyasdi.1.dylib" "libyasdi.1.dylib"
          "${file}")
        if(CMAKE_INSTALL_DO_STRIP)
          execute_process(COMMAND "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/strip" "${file}")
        endif()
      endif()
    endforeach()
  elseif("${CMAKE_INSTALL_CONFIG_NAME}" MATCHES "^([Mm][Ii][Nn][Ss][Ii][Zz][Ee][Rr][Ee][Ll])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES
      "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/MinSizeRel/libyasdimaster.1.8.1.dylib"
      "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/MinSizeRel/libyasdimaster.1.dylib"
      "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/MinSizeRel/libyasdimaster.dylib"
      )
    foreach(file
        "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libyasdimaster.1.8.1.dylib"
        "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libyasdimaster.1.dylib"
        "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libyasdimaster.dylib"
        )
      if(EXISTS "${file}" AND
         NOT IS_SYMLINK "${file}")
        execute_process(COMMAND "/usr/bin/install_name_tool"
          -id "libyasdimaster.1.dylib"
          -change "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/MinSizeRel/libyasdi.1.dylib" "libyasdi.1.dylib"
          "${file}")
        if(CMAKE_INSTALL_DO_STRIP)
          execute_process(COMMAND "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/strip" "${file}")
        endif()
      endif()
    endforeach()
  elseif("${CMAKE_INSTALL_CONFIG_NAME}" MATCHES "^([Rr][Ee][Ll][Ww][Ii][Tt][Hh][Dd][Ee][Bb][Ii][Nn][Ff][Oo])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES
      "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/RelWithDebInfo/libyasdimaster.1.8.1.dylib"
      "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/RelWithDebInfo/libyasdimaster.1.dylib"
      "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/RelWithDebInfo/libyasdimaster.dylib"
      )
    foreach(file
        "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libyasdimaster.1.8.1.dylib"
        "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libyasdimaster.1.dylib"
        "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libyasdimaster.dylib"
        )
      if(EXISTS "${file}" AND
         NOT IS_SYMLINK "${file}")
        execute_process(COMMAND "/usr/bin/install_name_tool"
          -id "libyasdimaster.1.dylib"
          -change "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/RelWithDebInfo/libyasdi.1.dylib" "libyasdi.1.dylib"
          "${file}")
        if(CMAKE_INSTALL_DO_STRIP)
          execute_process(COMMAND "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/strip" "${file}")
        endif()
      endif()
    endforeach()
  endif()
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  if("${CMAKE_INSTALL_CONFIG_NAME}" MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES
      "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Debug/libyasdi_drv_ip.1.8.1.dylib"
      "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Debug/libyasdi_drv_ip.1.dylib"
      "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Debug/libyasdi_drv_ip.dylib"
      )
    foreach(file
        "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libyasdi_drv_ip.1.8.1.dylib"
        "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libyasdi_drv_ip.1.dylib"
        "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libyasdi_drv_ip.dylib"
        )
      if(EXISTS "${file}" AND
         NOT IS_SYMLINK "${file}")
        execute_process(COMMAND "/usr/bin/install_name_tool"
          -id "libyasdi_drv_ip.1.dylib"
          -change "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Debug/libyasdi.1.dylib" "libyasdi.1.dylib"
          "${file}")
        if(CMAKE_INSTALL_DO_STRIP)
          execute_process(COMMAND "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/strip" "${file}")
        endif()
      endif()
    endforeach()
  elseif("${CMAKE_INSTALL_CONFIG_NAME}" MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES
      "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Release/libyasdi_drv_ip.1.8.1.dylib"
      "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Release/libyasdi_drv_ip.1.dylib"
      "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Release/libyasdi_drv_ip.dylib"
      )
    foreach(file
        "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libyasdi_drv_ip.1.8.1.dylib"
        "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libyasdi_drv_ip.1.dylib"
        "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libyasdi_drv_ip.dylib"
        )
      if(EXISTS "${file}" AND
         NOT IS_SYMLINK "${file}")
        execute_process(COMMAND "/usr/bin/install_name_tool"
          -id "libyasdi_drv_ip.1.dylib"
          -change "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Release/libyasdi.1.dylib" "libyasdi.1.dylib"
          "${file}")
        if(CMAKE_INSTALL_DO_STRIP)
          execute_process(COMMAND "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/strip" "${file}")
        endif()
      endif()
    endforeach()
  elseif("${CMAKE_INSTALL_CONFIG_NAME}" MATCHES "^([Mm][Ii][Nn][Ss][Ii][Zz][Ee][Rr][Ee][Ll])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES
      "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/MinSizeRel/libyasdi_drv_ip.1.8.1.dylib"
      "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/MinSizeRel/libyasdi_drv_ip.1.dylib"
      "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/MinSizeRel/libyasdi_drv_ip.dylib"
      )
    foreach(file
        "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libyasdi_drv_ip.1.8.1.dylib"
        "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libyasdi_drv_ip.1.dylib"
        "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libyasdi_drv_ip.dylib"
        )
      if(EXISTS "${file}" AND
         NOT IS_SYMLINK "${file}")
        execute_process(COMMAND "/usr/bin/install_name_tool"
          -id "libyasdi_drv_ip.1.dylib"
          -change "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/MinSizeRel/libyasdi.1.dylib" "libyasdi.1.dylib"
          "${file}")
        if(CMAKE_INSTALL_DO_STRIP)
          execute_process(COMMAND "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/strip" "${file}")
        endif()
      endif()
    endforeach()
  elseif("${CMAKE_INSTALL_CONFIG_NAME}" MATCHES "^([Rr][Ee][Ll][Ww][Ii][Tt][Hh][Dd][Ee][Bb][Ii][Nn][Ff][Oo])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES
      "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/RelWithDebInfo/libyasdi_drv_ip.1.8.1.dylib"
      "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/RelWithDebInfo/libyasdi_drv_ip.1.dylib"
      "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/RelWithDebInfo/libyasdi_drv_ip.dylib"
      )
    foreach(file
        "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libyasdi_drv_ip.1.8.1.dylib"
        "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libyasdi_drv_ip.1.dylib"
        "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libyasdi_drv_ip.dylib"
        )
      if(EXISTS "${file}" AND
         NOT IS_SYMLINK "${file}")
        execute_process(COMMAND "/usr/bin/install_name_tool"
          -id "libyasdi_drv_ip.1.dylib"
          -change "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/RelWithDebInfo/libyasdi.1.dylib" "libyasdi.1.dylib"
          "${file}")
        if(CMAKE_INSTALL_DO_STRIP)
          execute_process(COMMAND "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/strip" "${file}")
        endif()
      endif()
    endforeach()
  endif()
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  if("${CMAKE_INSTALL_CONFIG_NAME}" MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES
      "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Debug/libyasdi_drv_serial.1.8.1.dylib"
      "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Debug/libyasdi_drv_serial.1.dylib"
      "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Debug/libyasdi_drv_serial.dylib"
      )
    foreach(file
        "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libyasdi_drv_serial.1.8.1.dylib"
        "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libyasdi_drv_serial.1.dylib"
        "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libyasdi_drv_serial.dylib"
        )
      if(EXISTS "${file}" AND
         NOT IS_SYMLINK "${file}")
        execute_process(COMMAND "/usr/bin/install_name_tool"
          -id "libyasdi_drv_serial.1.dylib"
          -change "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Debug/libyasdi.1.dylib" "libyasdi.1.dylib"
          "${file}")
        if(CMAKE_INSTALL_DO_STRIP)
          execute_process(COMMAND "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/strip" "${file}")
        endif()
      endif()
    endforeach()
  elseif("${CMAKE_INSTALL_CONFIG_NAME}" MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES
      "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Release/libyasdi_drv_serial.1.8.1.dylib"
      "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Release/libyasdi_drv_serial.1.dylib"
      "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Release/libyasdi_drv_serial.dylib"
      )
    foreach(file
        "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libyasdi_drv_serial.1.8.1.dylib"
        "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libyasdi_drv_serial.1.dylib"
        "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libyasdi_drv_serial.dylib"
        )
      if(EXISTS "${file}" AND
         NOT IS_SYMLINK "${file}")
        execute_process(COMMAND "/usr/bin/install_name_tool"
          -id "libyasdi_drv_serial.1.dylib"
          -change "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Release/libyasdi.1.dylib" "libyasdi.1.dylib"
          "${file}")
        if(CMAKE_INSTALL_DO_STRIP)
          execute_process(COMMAND "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/strip" "${file}")
        endif()
      endif()
    endforeach()
  elseif("${CMAKE_INSTALL_CONFIG_NAME}" MATCHES "^([Mm][Ii][Nn][Ss][Ii][Zz][Ee][Rr][Ee][Ll])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES
      "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/MinSizeRel/libyasdi_drv_serial.1.8.1.dylib"
      "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/MinSizeRel/libyasdi_drv_serial.1.dylib"
      "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/MinSizeRel/libyasdi_drv_serial.dylib"
      )
    foreach(file
        "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libyasdi_drv_serial.1.8.1.dylib"
        "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libyasdi_drv_serial.1.dylib"
        "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libyasdi_drv_serial.dylib"
        )
      if(EXISTS "${file}" AND
         NOT IS_SYMLINK "${file}")
        execute_process(COMMAND "/usr/bin/install_name_tool"
          -id "libyasdi_drv_serial.1.dylib"
          -change "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/MinSizeRel/libyasdi.1.dylib" "libyasdi.1.dylib"
          "${file}")
        if(CMAKE_INSTALL_DO_STRIP)
          execute_process(COMMAND "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/strip" "${file}")
        endif()
      endif()
    endforeach()
  elseif("${CMAKE_INSTALL_CONFIG_NAME}" MATCHES "^([Rr][Ee][Ll][Ww][Ii][Tt][Hh][Dd][Ee][Bb][Ii][Nn][Ff][Oo])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES
      "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/RelWithDebInfo/libyasdi_drv_serial.1.8.1.dylib"
      "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/RelWithDebInfo/libyasdi_drv_serial.1.dylib"
      "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/RelWithDebInfo/libyasdi_drv_serial.dylib"
      )
    foreach(file
        "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libyasdi_drv_serial.1.8.1.dylib"
        "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libyasdi_drv_serial.1.dylib"
        "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libyasdi_drv_serial.dylib"
        )
      if(EXISTS "${file}" AND
         NOT IS_SYMLINK "${file}")
        execute_process(COMMAND "/usr/bin/install_name_tool"
          -id "libyasdi_drv_serial.1.dylib"
          -change "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/RelWithDebInfo/libyasdi.1.dylib" "libyasdi.1.dylib"
          "${file}")
        if(CMAKE_INSTALL_DO_STRIP)
          execute_process(COMMAND "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/strip" "${file}")
        endif()
      endif()
    endforeach()
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT)
  set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INSTALL_COMPONENT}.txt")
else()
  set(CMAKE_INSTALL_MANIFEST "install_manifest.txt")
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
file(WRITE "/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/${CMAKE_INSTALL_MANIFEST}"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
