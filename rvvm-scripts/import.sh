#!/bin/bash
set -x
rm -rf ./{CMakeLists.txt,build_root.cmake,epoxy,epoxy.reset,virglrenderer,virglrenderer.reset,RVVM,RVVM.reset,DiligentLog,cmake}
cp -r ../riscv-kernel/libmedia/app/src/main/java/libengine/{CMakeLists.txt,build_root.cmake,epoxy,epoxy.reset,virglrenderer,virglrenderer.reset,RVVM,RVVM.reset,DiligentLog,cmake} .
if [[ -e debug_BUILD/BUILD_ROOT/SRC/rvvm ]]
	then
		rm -rf debug_BUILD/BUILD_ROOT/SRC/rvvm
fi
