macro(build_root_message str)
  if (NOT EXISTS ${CMAKE_CURRENT_BINARY_DIR}/build_root_log.txt)
    file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/build_root_log.txt "BUILD_ROOT LOG      : ${str}\n")
  else()
    file(APPEND ${CMAKE_CURRENT_BINARY_DIR}/build_root_log.txt "BUILD_ROOT LOG      : ${str}\n")
  endif()
  message("${str}")
endmacro()

macro(build_root_fatal str)
  if (NOT EXISTS ${CMAKE_CURRENT_BINARY_DIR}/build_root_log.txt)
    file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/build_root_log.txt "BUILD_ROOT LOG FATAL: ${str}\n")
  else()
    file(APPEND ${CMAKE_CURRENT_BINARY_DIR}/build_root_log.txt "BUILD_ROOT LOG FATAL: ${str}\n")
  endif()
  message("<BUILD_ROOT log stored at '${CMAKE_CURRENT_BINARY_DIR}/build_root_log.txt'>")
  #message("<BUILD_ROOT LOG START>")
  #execute_process(COMMAND cat ${CMAKE_CURRENT_BINARY_DIR}/build_root_log.txt)
  #message("<BUILD_ROOT LOG END>")
  message(FATAL_ERROR "${str}")
endmacro()

if (APPLE)
  build_root_message("PLATFORM APPLE")
  set(BUILD_ROOT_OS__APPLE TRUE)
  set(BUILD_ROOT_OS__UNIX_LIKE TRUE)
  set(BUILD_ROOT_OS "Apple")
elseif (UNIX AND NOT ANDROID)
  find_program(CYGPATH_EXE NAMES cygpath.exe)

  if (CYGPATH_EXE)
    execute_process(COMMAND "${CYGPATH_EXE}" "-w" "/" OUTPUT_VARIABLE CYGDIR)
    string(STRIP ${CYGDIR} CYGDIR)
  endif()
  if (EXISTS "${CYGDIR}usr/bin/cygpath.exe")
    if (EXISTS "${CYGDIR}usr/lib/libmsys-2.0.a")
      build_root_message("ENV MSYSTEM = $ENV{MSYSTEM}")
      if ("$ENV{MSYSTEM}" STREQUAL "MSYS")
        # msys2 itself is based on CYGWIN
        build_root_message("PLATFORM WINDOWS CYGWIN")
        set(BUILD_ROOT_OS__CYGWIN TRUE)
        set(BUILD_ROOT_OS__CYGWIN_PATH ${CYGDIR})
        set(BUILD_ROOT_OS__UNIX_LIKE TRUE)
        set(BUILD_ROOT_OS "Cygwin")
      else()
        build_root_message("PLATFORM WINDOWS MSYS")
        set(BUILD_ROOT_OS__MSYS TRUE)
        execute_process(COMMAND "${CYGPATH_EXE}" "-w" "$ENV{MINGW_PREFIX}" OUTPUT_VARIABLE CYGDIRP)
        string(STRIP ${CYGDIRP} CYGDIRP)
        set(BUILD_ROOT_OS__MSYS_PATH ${CYGDIRP})
        set(BUILD_ROOT_OS__UNIX_LIKE TRUE)
        set(BUILD_ROOT_OS "MSYS")
      endif()
    else()
      build_root_message("PLATFORM WINDOWS CYGWIN")
      set(BUILD_ROOT_OS__CYGWIN TRUE)
      set(BUILD_ROOT_OS__CYGWIN_PATH ${CYGDIR})
      set(BUILD_ROOT_OS__UNIX_LIKE TRUE)
      set(BUILD_ROOT_OS "Cygwin")
    endif()
  else()
    build_root_message("PLATFORM LINUX")
    set(BUILD_ROOT_OS__LINUX TRUE)
    set(BUILD_ROOT_OS__UNIX_LIKE TRUE)
    set(BUILD_ROOT_OS "Linux")
  endif()
elseif (UNIX AND ANDROID)
  build_root_message("PLATFORM LINUX ANDROID")
  set(BUILD_ROOT_OS__ANDROID TRUE)
  set(BUILD_ROOT_OS__UNIX_LIKE TRUE)
  set(BUILD_ROOT_OS "Android")
elseif (WIN32)
  find_program(CYGPATH_EXE NAMES cygpath.exe)

  if (CYGPATH_EXE)
    execute_process(COMMAND "${CYGPATH_EXE}" "-w" "/" OUTPUT_VARIABLE CYGDIR)
    string(STRIP ${CYGDIR} CYGDIR)
  endif()
  if (EXISTS "${CYGDIR}usr/bin/cygpath.exe")
    if (EXISTS "${CYGDIR}usr/lib/libmsys-2.0.a")
      build_root_message("ENV MSYSTEM = $ENV{MSYSTEM}")
      if ("$ENV{MSYSTEM}" STREQUAL "MSYS")
        # msys2 itself is based on CYGWIN
        build_root_message("PLATFORM WINDOWS CYGWIN")
        set(BUILD_ROOT_OS__CYGWIN TRUE)
        set(BUILD_ROOT_OS__CYGWIN_PATH ${CYGDIR})
        set(BUILD_ROOT_OS__UNIX_LIKE TRUE)
        set(BUILD_ROOT_OS "Cygwin")
      else()
        build_root_message("PLATFORM WINDOWS MSYS")
        set(BUILD_ROOT_OS__MSYS TRUE)
        execute_process(COMMAND "${CYGPATH_EXE}" "-w" "$ENV{MINGW_PREFIX}" OUTPUT_VARIABLE CYGDIRP)
        string(STRIP ${CYGDIRP} CYGDIRP)
        set(BUILD_ROOT_OS__MSYS_PATH ${CYGDIRP})
        set(BUILD_ROOT_OS__UNIX_LIKE TRUE)
        set(BUILD_ROOT_OS "MSYS")
      endif()
    else()
      build_root_message("PLATFORM WINDOWS CYGWIN")
      set(BUILD_ROOT_OS__CYGWIN TRUE)
      set(BUILD_ROOT_OS__CYGWIN_PATH ${CYGDIR})
      set(BUILD_ROOT_OS__UNIX_LIKE TRUE)
      set(BUILD_ROOT_OS "Cygwin")
    endif()
  else()
    build_root_message("PLATFORM WINDOWS")
    set(BUILD_ROOT_OS__WIN32 TRUE)
    set(BUILD_ROOT_OS "Windows")
  endif()
else()
  build_root_message("WARNING: UNKNOWN PLATFORM")
  set(BUILD_ROOT_OS "Unknown")
  set(BUILD_ROOT_OS_CANNOT_BE_DETECTED TRUE)
endif()

macro (build_root_exec)
    build_root_message("build_root_exec ARGN = \"${ARGN}\"")
    unset(command_list)
    unset(command_list CACHE)
    string(REGEX MATCHALL "([^\"' \r\n\t;\\]+|[\\].|\"([^\"\\]+|[\\].)*\")+( +([^\"' \r\n\t;\\]+|[\\].|\"([^\"\\]+|[\\].)*\")+)*" command_list "${ARGN}")
    unset(command_str)
    unset(command_str CACHE)
    foreach(ARG IN ITEMS ${command_list})
        if (command_str)
          string(APPEND command_str " ")
        endif()
        string(APPEND command_str "${ARG}")
    endforeach()
    execute_process(
        COMMAND ${command_list}
        COMMAND_ECHO STDOUT
        RESULT_VARIABLE EXEC_FAILED
    )
    if (EXEC_FAILED)
        build_root_fatal("failed to execute command: '${command_str}'")
    endif()
endmacro()

macro (build_root_exec_working_directory working_directory)
    build_root_message("build_root_exec_working_directory ARGN = \"${ARGN}\"")
    unset(command_list)
    unset(command_list CACHE)
    string(REGEX MATCHALL "([^\"' \r\n\t;\\]+|[\\].|\"([^\"\\]+|[\\].)*\")+( +([^\"' \r\n\t;\\]+|[\\].|\"([^\"\\]+|[\\].)*\")+)*" command_list "${ARGN}")
    unset(command_str)
    unset(command_str CACHE)
    foreach(ARG IN ITEMS ${command_list})
        if (command_str)
          string(APPEND command_str " ")
        endif()
        string(APPEND command_str "${ARG}")
    endforeach()
    execute_process(
        COMMAND ${command_list}
        COMMAND_ECHO STDOUT
        RESULT_VARIABLE EXEC_FAILED
        WORKING_DIRECTORY ${working_directory}
    )
    if (EXEC_FAILED)
        build_root_fatal("failed to execute command: 'cd ${working_directory} ; ${command_str}'")
    endif()
endmacro()

macro (build_root_exec_cmake new_line_seperated_extra_c_flags new_line_seperated_extra_cxx_flags)
    build_root_message("build_root_exec_cmake ARGN = \"${ARGN}\"")
    unset(command_list)
    unset(command_list CACHE)
    string(REGEX MATCHALL "([^\"' \r\n\t;\\]+|[\\].|\"([^\"\\]+|[\\].)*\")+( +([^\"' \r\n\t;\\]+|[\\].|\"([^\"\\]+|[\\].)*\")+)*" command_list "${ARGN}")
    unset(command_str)
    unset(command_str CACHE)
    foreach(ARG IN ITEMS ${command_list})
        if (command_str)
          string(APPEND command_str " ")
        endif()
        string(APPEND command_str "${ARG}")
    endforeach()
    build_root_message("new_line_seperated_extra_c_flags = ${new_line_seperated_extra_c_flags}")
    build_root_message("new_line_seperated_extra_cxx_flags = ${new_line_seperated_extra_cxx_flags}")
    execute_process(
        COMMAND
        ${command_list}
        "-DCMAKE_COLOR_DIAGNOSTICS=${CMAKE_COLOR_DIAGNOSTICS}"
        "-DCMAKE_COLOR_MAKEFILE=${CMAKE_COLOR_MAKEFILE}"
        "-DCMAKE_MAKE_PROGRAM=${CMAKE_MAKE_PROGRAM}"
        "-DCMAKE_VERBOSE_MAKEFILE=${CMAKE_VERBOSE_MAKEFILE}"
        "-DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}"
        "-DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}"
        "-DCMAKE_C_COMPILER_LAUNCHER=${CMAKE_C_COMPILER_LAUNCHER}"
        "-DCMAKE_C_STANDARD=${CMAKE_C_STANDARD}"
        "-DCMAKE_C_STANDARD_REQUIRED=${CMAKE_C_STANDARD_REQUIRED}"
        "-DCMAKE_C_FLAGS=${CMAKE_C_FLAGS} ${new_line_seperated_extra_c_flags} ${BUILD_ROOT_____________ADDITIONAL_C_FLAGS}"
        "-DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}"
        "-DCMAKE_CXX_COMPILER_LAUNCHER=${CMAKE_CXX_COMPILER_LAUNCHER}"
        "-DCMAKE_CXX_STANDARD=${CMAKE_CXX_STANDARD}"
        "-DCMAKE_CXX_STANDARD_REQUIRED=${CMAKE_CXX_STANDARD_REQUIRED}"
        "-DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS} ${new_line_seperated_extra_cxx_flags} ${BUILD_ROOT_____________ADDITIONAL_C_FLAGS}"
        "-DCMAKE_MODULE_LINKER_FLAGS=${CMAKE_MODULE_LINKER_FLAGS}"
        "-DCMAKE_SHARED_LINKER_FLAGS=${CMAKE_SHARED_LINKER_FLAGS}"
        "-DCMAKE_EXE_LINKER_FLAGS=${CMAKE_EXE_LINKER_FLAGS}"
        "-DCMAKE_INSTALL_PREFIX=${LLVM_BUILD_ROOT__ROOTFS}"
        "-DCMAKE_POLICY_DEFAULT_CMP0074=${CMAKE_POLICY_DEFAULT_CMP0074}"
        "-DCMAKE_POLICY_DEFAULT_CMP0075=${CMAKE_POLICY_DEFAULT_CMP0075}"
        "-DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}"
        "-DCMAKE_SYSROOT=${CMAKE_SYSROOT}"
        "-DCMAKE_MODULE_PATH=${CMAKE_MODULE_PATH}"
        "-DCMAKE_SYSTEM_PREFIX_PATH=${CMAKE_SYSTEM_PREFIX_PATH}"
        "-DLLVM_BUILD_ROOT__ROOTFS=${LLVM_BUILD_ROOT__ROOTFS}"
        "-DANDROID_ABI=${ANDROID_ABI}"
        "-DANDROID_ARM_MODE=${ANDROID_ARM_MODE}"
        "-DANDROID_ARM_NEON=${ANDROID_ARM_NEON}"
        "-DANDROID_PLATFORM=${ANDROID_PLATFORM}"
        "-DANDROID_STL=${ANDROID_STL}"
        COMMAND_ECHO STDOUT
        RESULT_VARIABLE EXEC_FAILED
    )
    if (EXEC_FAILED)
        build_root_fatal("failed to execute command: '${command_str}'")
    endif()
endmacro()

macro (build_root_exec_meson new_line_seperated_extra_c_flags new_line_seperated_extra_cxx_flags)
    build_root_message("build_root_exec_meson ARGN = \"${ARGN}\"")
    unset(command_list)
    unset(command_list CACHE)
    string(REGEX MATCHALL "([^\"' \r\n\t;\\]+|[\\].|\"([^\"\\]+|[\\].)*\")+( +([^\"' \r\n\t;\\]+|[\\].|\"([^\"\\]+|[\\].)*\")+)*" command_list "${ARGN}")
    unset(command_str)
    unset(command_str CACHE)
    foreach(ARG IN ITEMS ${command_list})
        if (command_str)
          string(APPEND command_str " ")
        endif()
        string(APPEND command_str "${ARG}")
    endforeach()
    build_root_message("new_line_seperated_extra_c_flags = ${new_line_seperated_extra_c_flags}")
    build_root_message("new_line_seperated_extra_cxx_flags = ${new_line_seperated_extra_cxx_flags}")

    if (ANDROID)
        file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/BUILD_ROOT_DOT_CMAKE__FILES__cross.build "
            [binaries]
            ar = '${BUILD_ROOT_____________deps_ar}'
            c = ['${BUILD_ROOT_____________deps_cc}']
            cpp = ['${BUILD_ROOT_____________deps_cxx}']
            strip = ['${BUILD_ROOT_____________deps_strip}']
            pkg-config = ['env', 'PKG_CONFIG_LIBDIR=${LLVM_BUILD_ROOT__ROOTFS}/lib/pkgconfig:${LLVM_BUILD_ROOT__ROOTFS}/usr/lib/pkgconfig:${CMAKE_ANDROID_NDK}/lib/pkgconfig:${CMAKE_ANDROID_NDK}/usr/lib/pkgconfig', '${PKG_CONFIG_COMMAND}']
            cmake = ['${CMAKE_COMMAND}']
            [host_machine]
            system = 'android'
            endian = 'little'
            cpu = '${BUILD_ROOT_____________android_machine}'
            cpu_family = '${BUILD_ROOT_____________android_machine_family}'
        ")
    else()
        file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/BUILD_ROOT_DOT_CMAKE__FILES__cross.build "
            [binaries]
            ar = '${BUILD_ROOT_____________deps_ar}'
            c = ['${BUILD_ROOT_____________deps_cc}']
            cpp = ['${BUILD_ROOT_____________deps_cxx}']
            strip = ['${BUILD_ROOT_____________deps_strip}']
            pkg-config = ['env', 'PKG_CONFIG_LIBDIR=${LLVM_BUILD_ROOT__ROOTFS}/lib/pkgconfig:${LLVM_BUILD_ROOT__ROOTFS}/usr/lib/pkgconfig:/usr/local/lib/pkgconfig:/usr/local/share/pkgconfig:/usr/lib/pkgconfig:/usr/share/pkgconfig', '${PKG_CONFIG_COMMAND}']
            cmake = ['${CMAKE_COMMAND}']
        ")
    endif()

    execute_process(
        COMMAND
        ${command_list}
        --cross-file ${CMAKE_CURRENT_BINARY_DIR}/BUILD_ROOT_DOT_CMAKE__FILES__cross.build
        --prefix ${LLVM_BUILD_ROOT__ROOTFS}
        COMMAND_ECHO STDOUT
        RESULT_VARIABLE EXEC_FAILED
    )
    if (EXEC_FAILED)
        if (EXISTS ${BUILD_ROOT__MESON_BUILD_DIR___CURRENT}/meson-logs/meson-log.txt)
          execute_process(COMMAND cat ${BUILD_ROOT__MESON_BUILD_DIR___CURRENT}/meson-logs/meson-log.txt COMMAND_ECHO STDOUT)
        endif()
        build_root_fatal("failed to execute command: '${command_str}'")
    endif()
endmacro()

macro(build_root_init cmake_packages_dir build_root_dir)
  if (NOT EXISTS ${cmake_packages_dir})
    build_root_fatal("error: cmake package directory '${cmake_packages_dir}' does not exist")
  endif()
  unset(LLVM_BUILD_ROOT__ROOTFS)
  unset(LLVM_BUILD_ROOT__ROOTFS CACHE)
  set(LLVM_BUILD_ROOT__ROOTFS "${build_root_dir}/ROOTFS" CACHE BOOL "" FORCE)
  list(INSERT CMAKE_MODULE_PATH 0 "${cmake_packages_dir}")
  list(INSERT CMAKE_SYSTEM_PREFIX_PATH 0 "${LLVM_BUILD_ROOT__ROOTFS}")

  if (NOT EXISTS ${build_root_dir})
    build_root_exec(mkdir -p ${build_root_dir})
    build_root_exec(mkdir -p ${LLVM_BUILD_ROOT__ROOTFS})
    if (BUILD_ROOT_OS__UNIX_LIKE)
      build_root_exec(mkdir -p ${LLVM_BUILD_ROOT__ROOTFS}/usr)
      build_root_exec(mkdir -p ${LLVM_BUILD_ROOT__ROOTFS}/usr/bin)
      build_root_exec(mkdir -p ${LLVM_BUILD_ROOT__ROOTFS}/usr/include)
      build_root_exec(mkdir -p ${LLVM_BUILD_ROOT__ROOTFS}/usr/lib)
      build_root_exec(mkdir -p ${LLVM_BUILD_ROOT__ROOTFS}/usr/lib32)
      build_root_exec(mkdir -p ${LLVM_BUILD_ROOT__ROOTFS}/usr/lib64)
      build_root_exec(mkdir -p ${LLVM_BUILD_ROOT__ROOTFS}/usr/libx32)
      build_root_exec(mkdir -p ${LLVM_BUILD_ROOT__ROOTFS}/usr/libx64)
      build_root_exec(mkdir -p ${LLVM_BUILD_ROOT__ROOTFS}/usr/share)
      build_root_exec(ln -s usr/bin ${LLVM_BUILD_ROOT__ROOTFS}/bin)
      build_root_exec(ln -s usr/include ${LLVM_BUILD_ROOT__ROOTFS}/include)
      build_root_exec(ln -s usr/lib ${LLVM_BUILD_ROOT__ROOTFS}/lib)
      build_root_exec(ln -s usr/lib32 ${LLVM_BUILD_ROOT__ROOTFS}/lib32)
      build_root_exec(ln -s usr/lib64 ${LLVM_BUILD_ROOT__ROOTFS}/lib64)
      build_root_exec(ln -s usr/libx32 ${LLVM_BUILD_ROOT__ROOTFS}/libx32)
      build_root_exec(ln -s usr/libx64 ${LLVM_BUILD_ROOT__ROOTFS}/libx64)
      build_root_exec(ln -s usr/share ${LLVM_BUILD_ROOT__ROOTFS}/share)
    endif()
    build_root_exec(mkdir -p ${build_root_dir}/BUILD)
    build_root_exec(mkdir -p ${build_root_dir}/SRC)
    if (NOT EXISTS ${build_root_dir})
      build_root_fatal("error: failed to create build root directory '${build_root_dir}'")
    endif()
  endif()

  unset(BUILD_ROOT_CMAKE_PACKAGE_DIRECTORY)
  unset(BUILD_ROOT_CMAKE_PACKAGE_DIRECTORY CACHE)
  set(BUILD_ROOT_CMAKE_PACKAGE_DIRECTORY "${cmake_packages_dir}")
  unset(BUILD_ROOT_BUILD_DIRECTORY)
  unset(BUILD_ROOT_BUILD_DIRECTORY CACHE)
  set(BUILD_ROOT_BUILD_DIRECTORY "${build_root_dir}")

  set(BUILD_ROOT_____________BASH_PROGRAM sh)

  if (ANDROID)
    build_root_exec(ls -l ${CMAKE_ANDROID_NDK}/toolchains/llvm/prebuilt/linux-x86_64/bin)
    set(BUILD_ROOT_____________cross_rc "")
    # replace ANDROID_PLATFORM==android-28   with  linux-android28
    string(REPLACE "android-" "linux-android" BUILD_ROOT_____________android_compiler_suffix "${ANDROID_PLATFORM}")
    if(CMAKE_ANDROID_ARCH_ABI MATCHES x86_64)
      set(BUILD_ROOT_____________android_machine x86_64)
      set(BUILD_ROOT_____________android_machine_family x86_64)
      set(BUILD_ROOT_____________android_compiler_prefix x86_64)
      set(BUILD_ROOT_____________NBBY 8)
    elseif(CMAKE_ANDROID_ARCH_ABI MATCHES x86)
      set(BUILD_ROOT_____________android_machine i686)
      set(BUILD_ROOT_____________android_machine_family i686)
      set(BUILD_ROOT_____________android_compiler_prefix i686)
      set(BUILD_ROOT_____________NBBY 4)
    elseif(CMAKE_ANDROID_ARCH_ABI MATCHES armeabi-v7a)
      set(BUILD_ROOT_____________android_machine arm)
      set(BUILD_ROOT_____________android_machine_family arm)
      set(BUILD_ROOT_____________android_compiler_prefix armv7a)
      set(BUILD_ROOT_____________NBBY 4)
    elseif(CMAKE_ANDROID_ARCH_ABI MATCHES arm64-v8a)
      set(BUILD_ROOT_____________android_machine armv8)
      set(BUILD_ROOT_____________android_machine_family aarch64)
      set(BUILD_ROOT_____________android_compiler_prefix aarch64)
      set(BUILD_ROOT_____________NBBY 8)
    else()
      build_root_fatal("unknown android arch: ${CMAKE_ANDROID_ARCH_ABI}")
    endif()
    set(BUILD_ROOT_____________cross_host "${BUILD_ROOT_____________android_compiler_prefix}-${BUILD_ROOT_____________android_compiler_suffix}")
    set(BUILD_ROOT_____________deps_cc "${CMAKE_ANDROID_NDK}/toolchains/llvm/prebuilt/linux-x86_64/bin/${BUILD_ROOT_____________cross_host}-clang")
    set(BUILD_ROOT_____________deps_cxx "${CMAKE_ANDROID_NDK}/toolchains/llvm/prebuilt/linux-x86_64/bin/${BUILD_ROOT_____________cross_host}-clang++")
    set(BUILD_ROOT_____________deps_ld "${CMAKE_ANDROID_NDK}/toolchains/llvm/prebuilt/linux-x86_64/bin/ld")
    set(BUILD_ROOT_____________deps_ranlib "${CMAKE_ANDROID_NDK}/toolchains/llvm/prebuilt/linux-x86_64/bin/llvm-ranlib")
    set(BUILD_ROOT_____________deps_as "${CMAKE_ANDROID_NDK}/toolchains/llvm/prebuilt/linux-x86_64/bin/llvm-as")
    set(BUILD_ROOT_____________deps_nm "${CMAKE_ANDROID_NDK}/toolchains/llvm/prebuilt/linux-x86_64/bin/llvm-nm")
    set(BUILD_ROOT_____________deps_objdump "${CMAKE_ANDROID_NDK}/toolchains/llvm/prebuilt/linux-x86_64/bin/llvm-objdump")
    set(BUILD_ROOT_____________deps_ar "${CMAKE_ANDROID_NDK}/toolchains/llvm/prebuilt/linux-x86_64/bin/llvm-ar")
    set(BUILD_ROOT_____________deps_strip "${CMAKE_ANDROID_NDK}/toolchains/llvm/prebuilt/linux-x86_64/bin/llvm-strip")
    set(BUILD_ROOT_____________deps_strings "${CMAKE_ANDROID_NDK}/toolchains/llvm/prebuilt/linux-x86_64/bin/llvm-strings")
    set(BUILD_ROOT_____________FLAGS_CORE "export LD=${BUILD_ROOT_____________deps_ld} \; export RANLIB=${BUILD_ROOT_____________deps_ranlib} \; export AR=${BUILD_ROOT_____________deps_ar} \; export NM=${BUILD_ROOT_____________deps_nm} \; export AS=${BUILD_ROOT_____________deps_as} \; export OBJDUMP=${BUILD_ROOT_____________deps_objdump} \; export STRIP=${BUILD_ROOT_____________deps_strip} \; export INSTALL_STRIP_PROGRAM=${BUILD_ROOT_____________deps_strip} \; export STRINGS=${BUILD_ROOT_____________deps_strings} \;")
  else()
    set(BUILD_ROOT_____________NBBY 8)
    if (CMAKE_CROSSCOMPILING)
      set(BUILD_ROOT_____________cross_host "${ARCH_TRIPLET}")
    else()
      set(BUILD_ROOT_____________cross_host "")
    endif()
    if (WIN32)
      # TODO: figure out how to locate windres on windows platform
      #set(BUILD_ROOT_____________cross_rc "WINDRES=${CMAKE_RC_COMPILER}")
    else()
      set(BUILD_ROOT_____________cross_rc "")
    endif()
    set(BUILD_ROOT_____________deps_ar "${CMAKE_AR}")
    set(BUILD_ROOT_____________deps_cc "${CMAKE_C_COMPILER}")
    set(BUILD_ROOT_____________deps_cxx "${CMAKE_CXX_COMPILER}")
    set(BUILD_ROOT_____________deps_strip "${BUILD_ROOT_STRIP_PROGRAM}")
    set(BUILD_ROOT_____________FLAGS_CORE "")
  endif()
  set(BUILD_ROOT_____________COMMON_LINK_FLAGS "-L${LLVM_BUILD_ROOT__ROOTFS}/lib")
  set(BUILD_ROOT_____________COMMON_INCLUDE_FLAGS "-I${LLVM_BUILD_ROOT__ROOTFS}/include")
  set(BUILD_ROOT_____________COMMON_FLAGS "${BUILD_ROOT_____________COMMON_INCLUDE_FLAGS} ${BUILD_ROOT_____________COMMON_LINK_FLAGS}")
  if (ANDROID)
    unset(BUILD_ROOT_____________ADDITIONAL_C_FLAGS)
    unset(BUILD_ROOT_____________ADDITIONAL_C_FLAGS CACHE)
    set(BUILD_ROOT_____________ADDITIONAL_C_FLAGS "-DANDROID_API=${ANDROID_PLATFORM}")
  else()
    unset(BUILD_ROOT_____________ADDITIONAL_C_FLAGS)
    unset(BUILD_ROOT_____________ADDITIONAL_C_FLAGS CACHE)
    set(BUILD_ROOT_____________ADDITIONAL_C_FLAGS "")
  endif()

  # kept for static archive notes
  if (NOT APPLE)
    unset(BUILD_ROOT_LINK_GROUP_START)
    unset(BUILD_ROOT_LINK_GROUP_START CACHE)
    set(BUILD_ROOT_LINK_GROUP_START "-Wl,--start-group")
    unset(BUILD_ROOT_LINK_GROUP_END)
    unset(BUILD_ROOT_LINK_GROUP_END)
    set(BUILD_ROOT_LINK_GROUP_END "-Wl,--end-group")
  else()
    # apple's linker automatically behaves as-if start-group and end-group, and it does not accept such options
    unset(BUILD_ROOT_LINK_GROUP_START)
    unset(BUILD_ROOT_LINK_GROUP_START CACHE)
    set(BUILD_ROOT_LINK_GROUP_START "")
    unset(BUILD_ROOT_LINK_GROUP_END)
    unset(BUILD_ROOT_LINK_GROUP_END)
    set(BUILD_ROOT_LINK_GROUP_END "")
  endif()

  build_root_message("BUILD_ROOT_OS = ${BUILD_ROOT_OS}")
  if (BUILD_ROOT_OS__MSYS)
    build_root_message("BUILD_ROOT_OS__MSYS_PATH = ${BUILD_ROOT_OS__MSYS_PATH}")
  endif()
  if (BUILD_ROOT_OS__CYGWIN)
    build_root_message("BUILD_ROOT_OS__CYGWIN_PATH = ${BUILD_ROOT_OS__CYGWIN_PATH}")
  endif()
  build_root_message("ENV - CMAKE_BUILD_PARALLEL_LEVEL = $ENV{CMAKE_BUILD_PARALLEL_LEVEL}")
  build_root_message("CMAKE_SYSTEM_NAME = ${CMAKE_SYSTEM_NAME}")
  build_root_message("CMAKE_SYSTEM = ${CMAKE_SYSTEM}")
  build_root_message("CMAKE_HOST_SYSTEM_NAME = ${CMAKE_HOST_SYSTEM_NAME}")
  build_root_message("CMAKE_ANDROID_NDK = ${CMAKE_ANDROID_NDK}")
  build_root_message("CMAKE_ANDROID_NDK_VERSION = ${CMAKE_ANDROID_NDK_VERSION}")
  build_root_message("CMAKE_ANDROID_NDK_TOOLCHAIN_HOST_TAG = ${CMAKE_ANDROID_NDK_TOOLCHAIN_HOST_TAG}")
  build_root_message("CMAKE_ANDROID_NDK_TOOLCHAIN_VERSION = ${CMAKE_ANDROID_NDK_TOOLCHAIN_VERSION}")
  build_root_message("-CMAKE_COLOR_DIAGNOSTICS=${CMAKE_COLOR_DIAGNOSTICS}")
  build_root_message("-DCMAKE_COLOR_MAKEFILE=${CMAKE_COLOR_MAKEFILE}")
  build_root_message("-DCMAKE_MAKE_PROGRAM=${CMAKE_MAKE_PROGRAM}")
  build_root_message("-DCMAKE_VERBOSE_MAKEFILE=${CMAKE_VERBOSE_MAKEFILE}")
  build_root_message("-DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}")
  build_root_message("-DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}")
  build_root_message("-DCMAKE_C_COMPILER_LAUNCHER=${CMAKE_C_COMPILER_LAUNCHER}")
  build_root_message("-DCMAKE_C_STANDARD=${CMAKE_C_STANDARD}")
  build_root_message("-DCMAKE_C_STANDARD_REQUIRED=${CMAKE_C_STANDARD_REQUIRED}")
  build_root_message("-DCMAKE_C_FLAGS=${CMAKE_C_FLAGS}")
  build_root_message("-DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}")
  build_root_message("-DCMAKE_CXX_COMPILER_LAUNCHER=${CMAKE_CXX_COMPILER_LAUNCHER}")
  build_root_message("-DCMAKE_CXX_STANDARD=${CMAKE_CXX_STANDARD}")
  build_root_message("-DCMAKE_CXX_STANDARD_REQUIRED=${CMAKE_CXX_STANDARD_REQUIRED}")
  build_root_message("-DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS}")
  build_root_message("-DCMAKE_MODULE_LINKER_FLAGS=${CMAKE_MODULE_LINKER_FLAGS}")
  build_root_message("-DCMAKE_SHARED_LINKER_FLAGS=${CMAKE_SHARED_LINKER_FLAGS}")
  build_root_message("-DCMAKE_EXE_LINKER_FLAGS=${CMAKE_EXE_LINKER_FLAGS}")
  build_root_message("-DCMAKE_INSTALL_PREFIX=${LLVM_BUILD_ROOT__ROOTFS}")
  build_root_message("-DCMAKE_POLICY_DEFAULT_CMP0074=${CMAKE_POLICY_DEFAULT_CMP0074}")
  build_root_message("-DCMAKE_POLICY_DEFAULT_CMP0075=${CMAKE_POLICY_DEFAULT_CMP0075}")
  build_root_message("-DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}")
  build_root_message("-DCMAKE_SYSROOT=${CMAKE_SYSROOT}")
  build_root_message("-DCMAKE_MODULE_PATH=${CMAKE_MODULE_PATH}")
  build_root_message("-DCMAKE_SYSTEM_PREFIX_PATH=${CMAKE_SYSTEM_PREFIX_PATH}")
  build_root_message("-DLLVM_BUILD_ROOT__ROOTFS=${LLVM_BUILD_ROOT__ROOTFS}")
  build_root_message("-DANDROID_ABI=${ANDROID_ABI}")
  build_root_message("-DANDROID_ARM_MODE=${ANDROID_ARM_MODE}")
  build_root_message("-DANDROID_ARM_NEON=${ANDROID_ARM_NEON}")
  build_root_message("-DANDROID_PLATFORM=${ANDROID_PLATFORM}")
  build_root_message("-DANDROID_STL=${ANDROID_STL}")
  
  if (NOT ANDROID)
    build_root_message("\n\nwarning: strip program unknown by default, please specify it via cmake: set(BUILD_ROOT_STRIP_PROGRAM /path/to/strip/program)\n\n")
  endif()
endmacro()

macro(build_root_add_cmake_package src relative_path_to_cmake_dir build_dir new_line_seperated_extra_c_flags new_line_seperated_extra_cxx_flags new_line_seperated_extra_cmake_config)
  build_root_message("BUILD_ROOT_CMAKE_PACKAGE_DIRECTORY is '${BUILD_ROOT_CMAKE_PACKAGE_DIRECTORY}'")
  build_root_message("BUILD_ROOT_BUILD_DIRECTORY is '${BUILD_ROOT_BUILD_DIRECTORY}'")
  unset(${build_dir}_ROOT)
  unset(${build_dir}_ROOT CACHE)
  set(${build_dir}_ROOT "${build_dir}")
  if (NOT EXISTS "${src}")
    build_root_fatal("source directory '${src}' does not exist")
  endif()
  if (NOT EXISTS "${src}/${relative_path_to_cmake_dir}")
    build_root_fatal("relative source directory '${relative_path_to_cmake_dir}' does not exist inside source directory '${src}'")
  endif()
  if (NOT EXISTS "${src}/${relative_path_to_cmake_dir}/CMakeLists.txt")
    build_root_fatal("cmake file 'CMakeLists.txt' does not exist inside relative source directory '${relative_path_to_cmake_dir}' inside source directory '${src}'")
  endif()
  if (NOT EXISTS "${BUILD_ROOT_BUILD_DIRECTORY}/SRC/${build_dir}")
    build_root_exec(cp -r "${src}" "${BUILD_ROOT_BUILD_DIRECTORY}/SRC/${build_dir}")
  endif()
  if (NOT EXISTS "${BUILD_ROOT_BUILD_DIRECTORY}/BUILD/${build_dir}")
    build_root_exec(mkdir "${BUILD_ROOT_BUILD_DIRECTORY}/BUILD/${build_dir}")
  endif()

  unset(HAS_CMAKE_COLOR)
  unset(HAS_CMAKE_COLOR CACHE)

  if (CMAKE_COLOR_MAKEFILE OR CMAKE_COLOR_DIAGNOSTICS)
    set(HAS_CMAKE_COLOR ON)
  endif()

  build_root_message("(could be empty) new_line_seperated_extra_cmake_config = ${new_line_seperated_extra_cmake_config}")
  unset(new_line_seperated_extra_cmake_config_list)
  unset(new_line_seperated_extra_cmake_config_list CACHE)
  build_root_message("(should be empty) new_line_seperated_extra_cmake_config_list = ${new_line_seperated_extra_cmake_config_list}")
  string(REGEX MATCHALL "([^\"' \r\n\t;\\]+|[\\].|\"([^\"\\]+|[\\].)*\")+( +([^\"' \r\n\t;\\]+|[\\].|\"([^\"\\]+|[\\].)*\")+)*" new_line_seperated_extra_cmake_config_list "${new_line_seperated_extra_cmake_config}")
  build_root_message("(could be empty) new_line_seperated_extra_cmake_config_list = ${new_line_seperated_extra_cmake_config_list}")
  unset(new_line_seperated_extra_cmake_config_list_str)
  unset(new_line_seperated_extra_cmake_config_list_str CACHE)
  foreach(ARG IN ITEMS ${new_line_seperated_extra_cmake_config_list})
      if (new_line_seperated_extra_cmake_config_list_str)
        string(APPEND new_line_seperated_extra_cmake_config_list_str " ")
      endif()
      string(APPEND new_line_seperated_extra_cmake_config_list_str "'${ARG}'")
  endforeach()
  build_root_message("(could be empty) new_line_seperated_extra_cmake_config_list_str = ${new_line_seperated_extra_cmake_config_list_str}")

  build_root_message("-------- BUILDING CMAKE PROJECT: '${build_dir}'")
  
  build_root_message("-------- BUILDING CMAKE PROJECT: '${build_dir}' -- CONFIGURING")
  build_root_exec_cmake(
    "${new_line_seperated_extra_c_flags}"
    "${new_line_seperated_extra_cxx_flags}"
    # configure
    ${CMAKE_COMMAND}
    -G "${CMAKE_GENERATOR}"
    -S "${BUILD_ROOT_BUILD_DIRECTORY}/SRC/${build_dir}/${relative_path_to_cmake_dir}"
    -B "${BUILD_ROOT_BUILD_DIRECTORY}/BUILD/${build_dir}"
    ${new_line_seperated_extra_cmake_config_list_str}
  )
  build_root_message("-------- BUILDING CMAKE PROJECT: '${build_dir}' -- CONFIGURED")
  build_root_message("-------- BUILDING CMAKE PROJECT: '${build_dir}' -- BUILDING")
  build_root_exec(
    # build
    ${CMAKE_COMMAND}
    --build "${BUILD_ROOT_BUILD_DIRECTORY}/BUILD/${build_dir}"
  )
  build_root_message("-------- BUILDING CMAKE PROJECT: '${build_dir}' -- BUILT")
  build_root_message("-------- BUILDING CMAKE PROJECT: '${build_dir}' -- INSTALLING")
  build_root_exec(
    # install
    ${CMAKE_COMMAND}
    --install
    "${BUILD_ROOT_BUILD_DIRECTORY}/BUILD/${build_dir}"
  )
  build_root_message("-------- BUILDING CMAKE PROJECT: '${build_dir}' -- INSTALLED")
  build_root_message("-------- BUILT CMAKE PROJECT: '${build_dir}'")
endmacro()

macro(build_root_add_makefile_package src relative_path_to_makefile_dir build_dir new_line_seperated_extra_c_flags new_line_seperated_extra_cxx_flags new_line_seperated_extra_makefile_config)
  build_root_message("BUILD_ROOT_BUILD_DIRECTORY is '${BUILD_ROOT_BUILD_DIRECTORY}'")
  unset(${build_dir}_ROOT)
  unset(${build_dir}_ROOT CACHE)
  set(${build_dir}_ROOT "${build_dir}")
  if (NOT EXISTS ${src})
    build_root_fatal("source directory '${src}' does not exist")
  endif()
  if (NOT EXISTS ${src}/${relative_path_to_makefile_dir})
    build_root_fatal("relative source directory '${relative_path_to_makefile_dir}' does not exist inside source directory '${src}'")
  endif()
  if (NOT EXISTS "${BUILD_ROOT_BUILD_DIRECTORY}/BUILD/${build_dir}")
    build_root_exec(cp -r "${src}" "${BUILD_ROOT_BUILD_DIRECTORY}/BUILD/${build_dir}")
  endif()
  
  build_root_message("(could be empty) new_line_seperated_extra_makefile_config = ${new_line_seperated_extra_makefile_config}")
  unset(new_line_seperated_extra_makefile_config_list)
  unset(new_line_seperated_extra_makefile_config_list CACHE)
  build_root_message("(should be empty) new_line_seperated_extra_makefile_config_list = ${new_line_seperated_extra_makefile_config_list}")
  string(REGEX MATCHALL "([^\"' \r\n\t;\\]+|[\\].|\"([^\"\\]+|[\\].)*\")+( +([^\"' \r\n\t;\\]+|[\\].|\"([^\"\\]+|[\\].)*\")+)*" new_line_seperated_extra_makefile_config_list "${new_line_seperated_extra_makefile_config}")
  build_root_message("(could be empty) new_line_seperated_extra_makefile_config_list = ${new_line_seperated_extra_makefile_config_list}")
  unset(new_line_seperated_extra_makefile_config_list_str)
  unset(new_line_seperated_extra_makefile_config_list_str CACHE)
  foreach(ARG IN ITEMS ${new_line_seperated_extra_makefile_config_list})
      if (new_line_seperated_extra_makefile_config_list_str)
        string(APPEND new_line_seperated_extra_makefile_config_list_str " ")
      endif()
      string(APPEND new_line_seperated_extra_makefile_config_list_str "${ARG}")
  endforeach()
  build_root_message("(could be empty) new_line_seperated_extra_makefile_config_list_str = ${new_line_seperated_extra_makefile_config_list_str}")

  build_root_message("(could be empty) new_line_seperated_extra_c_flags = ${new_line_seperated_extra_c_flags}")
  unset(new_line_seperated_extra_c_flags_list)
  unset(new_line_seperated_extra_c_flags_list CACHE)
  build_root_message("(should be empty) new_line_seperated_extra_c_flags_list = ${new_line_seperated_extra_c_flags_list}")
  string(REGEX MATCHALL "([^\"' \r\n\t;\\]+|[\\].|\"([^\"\\]+|[\\].)*\")+( +([^\"' \r\n\t;\\]+|[\\].|\"([^\"\\]+|[\\].)*\")+)*" new_line_seperated_extra_c_flags_list "${new_line_seperated_extra_c_flags}")
  build_root_message("(could be empty) new_line_seperated_extra_c_flags_list = ${new_line_seperated_extra_c_flags_list}")
  unset(new_line_seperated_extra_c_flags_list_str)
  unset(new_line_seperated_extra_c_flags_list_str CACHE)
  foreach(ARG IN ITEMS ${new_line_seperated_extra_c_flags_list})
      if (new_line_seperated_extra_c_flags_list_str)
        string(APPEND new_line_seperated_extra_c_flags_list_str " ")
      endif()
      string(APPEND new_line_seperated_extra_c_flags_list_str "${ARG}")
  endforeach()
  build_root_message("(could be empty) new_line_seperated_extra_c_flags_list_str = ${new_line_seperated_extra_c_flags_list_str}")

  build_root_message("(could be empty) new_line_seperated_extra_cxx_flags = ${new_line_seperated_extra_cxx_flags}")
  unset(new_line_seperated_extra_cxx_flags_list)
  unset(new_line_seperated_extra_cxx_flags_list CACHE)
  build_root_message("(should be empty) new_line_seperated_extra_cxx_flags_list = ${new_line_seperated_extra_cxx_flags_list}")
  string(REGEX MATCHALL "([^\"' \r\n\t;\\]+|[\\].|\"([^\"\\]+|[\\].)*\")+( +([^\"' \r\n\t;\\]+|[\\].|\"([^\"\\]+|[\\].)*\")+)*" new_line_seperated_extra_cxx_flags_list "${new_line_seperated_extra_cxx_flags}")
  build_root_message("(could be empty) new_line_seperated_extra_cxx_flags_list = ${new_line_seperated_extra_cxx_flags_list}")
  unset(new_line_seperated_extra_cxx_flags_list_str)
  unset(new_line_seperated_extra_cxx_flags_list_str CACHE)
  foreach(ARG IN ITEMS ${new_line_seperated_extra_cxx_flags_list})
      if (new_line_seperated_extra_cxx_flags_list_str)
        string(APPEND new_line_seperated_extra_cxx_flags_list_str " ")
      endif()
      string(APPEND new_line_seperated_extra_cxx_flags_list_str "${ARG}")
  endforeach()
  build_root_message("(could be empty) new_line_seperated_extra_cxx_flags_list_str = ${new_line_seperated_extra_cxx_flags_list_str}")

  unset(BUILD_ROOT_____________FLAGS)
  unset(BUILD_ROOT_____________FLAGS CACHE)

  if (WIN32)
      # LLVM_BUILD_ROOT__ROOTFS is an absolute path
      #  LLVM_BUILD_ROOT__ROOTFS = C:/foo
      #
      #  we need to transform the drive letter into a msys2 path so PKG_CONFIG_PATH works
      #
      #  C:/foo -> /c/foo
      #
      string(LENGTH "${LLVM_BUILD_ROOT__ROOTFS}" LLVM_BUILD_ROOT__ROOTFS__MSYS_TMP_LENGTH)
      string(SUBSTRING "${LLVM_BUILD_ROOT__ROOTFS}" 0 1 LLVM_BUILD_ROOT__ROOTFS__MSYS_LETTER_)
      string(TOLOWER "${LLVM_BUILD_ROOT__ROOTFS__MSYS_LETTER_}" LLVM_BUILD_ROOT__ROOTFS__MSYS_LETTER)
      math(EXPR LLVM_BUILD_ROOT__ROOTFS__MSYS_TMP_LENGTH_ADJUSTED "${LLVM_BUILD_ROOT__ROOTFS__MSYS_TMP_LENGTH} - 2" OUTPUT_FORMAT DECIMAL)
      string(SUBSTRING "${LLVM_BUILD_ROOT__ROOTFS}" 2 ${LLVM_BUILD_ROOT__ROOTFS__MSYS_TMP_LENGTH_ADJUSTED} LLVM_BUILD_ROOT__ROOTFS__MSYS__PATH)
      set(LLVM_BUILD_ROOT__ROOTFS__MSYS "/${LLVM_BUILD_ROOT__ROOTFS__MSYS_LETTER}${LLVM_BUILD_ROOT__ROOTFS__MSYS__PATH}")
  else()
      set(LLVM_BUILD_ROOT__ROOTFS__MSYS "${LLVM_BUILD_ROOT__ROOTFS}")
  endif()

  set(BUILD_ROOT_____________FLAGS "${BUILD_ROOT_____________FLAGS_CORE} export PKG_CONFIG_PATH=\"${LLVM_BUILD_ROOT__ROOTFS__MSYS}/lib/pkgconfig:${LLVM_BUILD_ROOT__ROOTFS__MSYS}/share/pkgconfig:\$PKG_CONFIG_PATH\" \; export CC=\"${BUILD_ROOT_____________deps_cc}\" \; export LDFLAGS=\"${BUILD_ROOT_____________COMMON_LINK_FLAGS}\" \; export CFLAGS=\"${BUILD_ROOT_____________COMMON_FLAGS} ${BUILD_ROOT_____________ADDITIONAL_C_FLAGS} ${new_line_seperated_extra_c_flags_list_str} ${CMAKE_C_FLAGS}\" \; export CXX=\"${BUILD_ROOT_____________deps_cxx}\" \; export CXXFLAGS=\"${BUILD_ROOT_____________COMMON_FLAGS} ${BUILD_ROOT_____________ADDITIONAL_C_FLAGS} ${new_line_seperated_extra_cxx_flags_list_str} ${CMAKE_CXX_FLAGS}\" \;")

  build_root_message("-------- BUILDING MAKEFILE PROJECT: '${build_dir}'")

  unset(BUILD_ROOT_____________HAS_M)
  unset(BUILD_ROOT_____________HAS_M CACHE)
  unset(BUILD_ROOT_____________HAS_C)
  unset(BUILD_ROOT_____________HAS_C CACHE)
  unset(BUILD_ROOT_____________HAS_A)
  unset(BUILD_ROOT_____________HAS_A CACHE)
  unset(BUILD_ROOT_____________HAS_DIR)
  unset(BUILD_ROOT_____________HAS_DIR CACHE)
  if (NOT EXISTS "${BUILD_ROOT_BUILD_DIRECTORY}/BUILD/${build_dir}/${relative_path_to_makefile_dir}/Makefile")
      if (NOT EXISTS "${BUILD_ROOT_BUILD_DIRECTORY}/BUILD/${build_dir}/${relative_path_to_makefile_dir}/configure")
          if (NOT EXISTS "${BUILD_ROOT_BUILD_DIRECTORY}/BUILD/${build_dir}/${relative_path_to_makefile_dir}/autogen.sh")
              if (NOT EXISTS "${BUILD_ROOT_BUILD_DIRECTORY}/BUILD/${build_dir}/Makefile")
                  if (NOT EXISTS "${BUILD_ROOT_BUILD_DIRECTORY}/BUILD/${build_dir}/configure")
                      if (NOT EXISTS "${BUILD_ROOT_BUILD_DIRECTORY}/BUILD/${build_dir}/autogen.sh")
                          build_root_fatal("could not find any of the following files 'Makefile', 'configure', 'autogen.sh', searched inside relative source directory '${relative_path_to_makefile_dir}' inside source directory '${src}', searched inside source directory '${src}'")
                      else()
                          set(BUILD_ROOT_____________HAS_A true)
                          set(BUILD_ROOT_____________HAS_DIR "${BUILD_ROOT_BUILD_DIRECTORY}/BUILD/${build_dir}")
                      endif()
                  else()
                      set(BUILD_ROOT_____________HAS_C true)
                      set(BUILD_ROOT_____________HAS_DIR "${BUILD_ROOT_BUILD_DIRECTORY}/BUILD/${build_dir}")
                  endif()
              else()
                  set(BUILD_ROOT_____________HAS_M true)
                  set(BUILD_ROOT_____________HAS_DIR "${BUILD_ROOT_BUILD_DIRECTORY}/BUILD/${build_dir}")
              endif()
          else()
              set(BUILD_ROOT_____________HAS_A true)
              set(BUILD_ROOT_____________HAS_DIR "${BUILD_ROOT_BUILD_DIRECTORY}/BUILD/${build_dir}/${relative_path_to_makefile_dir}")
          endif()
      else()
          set(BUILD_ROOT_____________HAS_C true)
          set(BUILD_ROOT_____________HAS_DIR "${BUILD_ROOT_BUILD_DIRECTORY}/BUILD/${build_dir}/${relative_path_to_makefile_dir}")
      endif()
  else()
      set(BUILD_ROOT_____________HAS_M true)
      set(BUILD_ROOT_____________HAS_DIR "${BUILD_ROOT_BUILD_DIRECTORY}/BUILD/${build_dir}/${relative_path_to_makefile_dir}")
  endif()
  
  if (BUILD_ROOT_____________HAS_A)
      # autogen.sh does not provide a --help option
      build_root_message("-------- BUILDING MAKEFILE PROJECT: '${build_dir}' -- GENERATING (AUTOGEN)")
      build_root_exec_working_directory("${BUILD_ROOT_____________HAS_DIR}"
        ${BUILD_ROOT_____________BASH_PROGRAM} ./autogen.sh
      )
      if (NOT EXISTS "${BUILD_ROOT_____________HAS_DIR}/configure")
          build_root_fatal("'autogen.sh' failed to generate a 'configure' file inside the directory '${BUILD_ROOT_____________HAS_DIR}'")
      else()
          set(BUILD_ROOT_____________HAS_C true)
      endif()
      build_root_message("-------- BUILDING MAKEFILE PROJECT: '${build_dir}' -- GENERATED (AUTOGEN)")
  endif()
  if (BUILD_ROOT_____________HAS_C)
      build_root_message("-------- BUILDING MAKEFILE PROJECT: '${build_dir}' -- CONFIGURING (--help)")
      build_root_exec_working_directory("${BUILD_ROOT_____________HAS_DIR}"
        ${BUILD_ROOT_____________BASH_PROGRAM} -c "${BUILD_ROOT_____________FLAGS} sh ./configure --help"
      )
      build_root_message("-------- BUILDING MAKEFILE PROJECT: '${build_dir}' -- CONFIGURING")
      if (BUILD_ROOT_____________cross_host)
        set(BUILD_ROOT_____________HOST_OPT "--host=${BUILD_ROOT_____________cross_host}")
      else()
        set(BUILD_ROOT_____________HOST_OPT "")
      endif()
      build_root_exec_working_directory("${BUILD_ROOT_____________HAS_DIR}"
        ${BUILD_ROOT_____________BASH_PROGRAM} -c "${BUILD_ROOT_____________FLAGS} sh ./configure ${BUILD_ROOT_____________HOST_OPT} ${BUILD_ROOT_____________cross_rc} --prefix=${LLVM_BUILD_ROOT__ROOTFS} ${new_line_seperated_extra_makefile_config_list_str}"
      )
      if (NOT EXISTS "${BUILD_ROOT_____________HAS_DIR}/Makefile")
          build_root_fatal("'configure' failed to generate a 'Makefile' file inside the directory '${BUILD_ROOT_____________HAS_DIR}'")
      else()
          set(BUILD_ROOT_____________HAS_M true)
      endif()
      build_root_message("-------- BUILDING MAKEFILE PROJECT: '${build_dir}' -- CONFIGURED")
  endif()
  if (BUILD_ROOT_____________HAS_M)
      build_root_message("-------- BUILDING MAKEFILE PROJECT: '${build_dir}' -- BUILDING (--help)")
      build_root_exec_working_directory("${BUILD_ROOT_____________HAS_DIR}"
        ${BUILD_ROOT_____________BASH_PROGRAM} -c "${BUILD_ROOT_____________FLAGS} make --help"
      )
      build_root_message("-------- BUILDING MAKEFILE PROJECT: '${build_dir}' -- BUILDING (--trace)")
      build_root_exec_working_directory("${BUILD_ROOT_____________HAS_DIR}"
        ${BUILD_ROOT_____________BASH_PROGRAM} -c "${BUILD_ROOT_____________FLAGS} make --trace"
      )
      build_root_message("-------- BUILDING MAKEFILE PROJECT: '${build_dir}' -- BUILT")
      build_root_message("-------- BUILDING MAKEFILE PROJECT: '${build_dir}' -- INSTALLING (--help)")
      build_root_exec_working_directory("${BUILD_ROOT_____________HAS_DIR}"
        ${BUILD_ROOT_____________BASH_PROGRAM} -c "${BUILD_ROOT_____________FLAGS} make install --help"
      )
      build_root_message("-------- BUILDING MAKEFILE PROJECT: '${build_dir}' -- INSTALLING")
      build_root_exec_working_directory("${BUILD_ROOT_____________HAS_DIR}"
        ${BUILD_ROOT_____________BASH_PROGRAM} -c "${BUILD_ROOT_____________FLAGS} make install"
      )
      build_root_message("-------- BUILDING MAKEFILE PROJECT: '${build_dir}' -- INSTALLED")
  endif()
  build_root_message("-------- BUILT MAKEFILE PROJECT: '${build_dir}'")
endmacro()

macro(build_root_add_meson_package src relative_path_to_meson_dir build_dir new_line_seperated_extra_c_flags new_line_seperated_extra_cxx_flags new_line_seperated_extra_meson_config)
  build_root_message("BUILD_ROOT_BUILD_DIRECTORY is '${BUILD_ROOT_BUILD_DIRECTORY}'")
  unset(${build_dir}_ROOT)
  unset(${build_dir}_ROOT CACHE)
  set(${build_dir}_ROOT "${build_dir}")
  unset(BUILD_ROOT__MESON_BUILD_DIR___CURRENT)
  unset(BUILD_ROOT__MESON_BUILD_DIR___CURRENT CACHE)
  set(BUILD_ROOT__MESON_BUILD_DIR___CURRENT ${BUILD_ROOT_BUILD_DIRECTORY}/BUILD/${build_dir})
  if (NOT EXISTS "${src}")
    build_root_fatal("source directory '${src}' does not exist")
  endif()
  if (NOT EXISTS "${src}/${relative_path_to_meson_dir}")
    build_root_fatal("relative source directory '${relative_path_to_meson_dir}' does not exist inside source directory '${src}'")
  endif()
  if (NOT EXISTS "${src}/${relative_path_to_meson_dir}/meson.build")
    build_root_fatal("cmake file 'meson.build' does not exist inside relative source directory '${relative_path_to_meson_dir}' inside source directory '${src}'")
  endif()
  if (NOT EXISTS "${BUILD_ROOT_BUILD_DIRECTORY}/SRC/${build_dir}")
    build_root_exec(cp -r "${src}" "${BUILD_ROOT_BUILD_DIRECTORY}/SRC/${build_dir}")
  endif()
  if (NOT EXISTS "${BUILD_ROOT_BUILD_DIRECTORY}/BUILD/${build_dir}")
    build_root_exec(mkdir "${BUILD_ROOT_BUILD_DIRECTORY}/BUILD/${build_dir}")
  endif()

  unset(HAS_CMAKE_COLOR)
  unset(HAS_CMAKE_COLOR CACHE)

  if (CMAKE_COLOR_MAKEFILE OR CMAKE_COLOR_DIAGNOSTICS)
    set(HAS_CMAKE_COLOR ON)
  endif()

  build_root_message("(could be empty) new_line_seperated_extra_meson_config = ${new_line_seperated_extra_meson_config}")
  unset(new_line_seperated_extra_meson_config_list)
  unset(new_line_seperated_extra_meson_config_list CACHE)
  build_root_message("(should be empty) new_line_seperated_extra_meson_config_list = ${new_line_seperated_extra_meson_config_list}")
  string(REGEX MATCHALL "([^\"' \r\n\t;\\]+|[\\].|\"([^\"\\]+|[\\].)*\")+( +([^\"' \r\n\t;\\]+|[\\].|\"([^\"\\]+|[\\].)*\")+)*" new_line_seperated_extra_meson_config_list "${new_line_seperated_extra_meson_config}")
  build_root_message("(could be empty) new_line_seperated_extra_meson_config_list = ${new_line_seperated_extra_meson_config_list}")
  unset(new_line_seperated_extra_meson_config_list_str)
  unset(new_line_seperated_extra_meson_config_list_str CACHE)
  foreach(ARG IN ITEMS ${new_line_seperated_extra_meson_config_list})
      if (new_line_seperated_extra_meson_config_list_str)
        string(APPEND new_line_seperated_extra_meson_config_list_str " ")
      endif()
      string(APPEND new_line_seperated_extra_meson_config_list_str "'${ARG}'")
  endforeach()
  build_root_message("(could be empty) new_line_seperated_extra_meson_config_list_str = ${new_line_seperated_extra_meson_config_list_str}")

  build_root_message("-------- BUILDING MESON PROJECT: '${build_dir}'")
  
  if (NOT MESON_COMMAND)
      find_program(MESON_COMMAND NAMES meson.exe meson REQUIRED)
  endif()
  
  if (NOT PKG_CONFIG_COMMAND)
    find_program(PKG_CONFIG_COMMAND NAMES pkg-config.exe pkg-config REQUIRED)
  endif()
  
  build_root_message("-------- BUILDING MESON PROJECT: '${build_dir}' -- CONFIGURING")
  build_root_exec_meson(
    "${new_line_seperated_extra_c_flags}"
    "${new_line_seperated_extra_cxx_flags}"
    # configure
    ${MESON_COMMAND}
    setup
    "${BUILD_ROOT_BUILD_DIRECTORY}/BUILD/${build_dir}"
    "${BUILD_ROOT_BUILD_DIRECTORY}/SRC/${build_dir}/${relative_path_to_cmake_dir}"
    ${new_line_seperated_extra_meson_config_list_str}
  )
  build_root_message("-------- BUILDING MESON PROJECT: '${build_dir}' -- CONFIGURED")
  build_root_message("-------- BUILDING MESON PROJECT: '${build_dir}' -- BUILDING")
  build_root_exec(
    # build
    ${MESON_COMMAND}
    compile
    -C "${BUILD_ROOT_BUILD_DIRECTORY}/BUILD/${build_dir}"
  )
  build_root_message("-------- BUILDING MESON PROJECT: '${build_dir}' -- BUILT")
  build_root_message("-------- BUILDING MESON PROJECT: '${build_dir}' -- INSTALLING")
  build_root_exec(
    # install
    ${MESON_COMMAND}
    install
    --no-rebuild -C "${BUILD_ROOT_BUILD_DIRECTORY}/BUILD/${build_dir}"
  )
  build_root_message("-------- BUILDING MESON PROJECT: '${build_dir}' -- INSTALLED")
  build_root_message("-------- BUILT MESON PROJECT: '${build_dir}'")
endmacro()
