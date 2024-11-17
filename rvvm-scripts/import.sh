#!/bin/bash
mkdir ../tmp
cd ../tmp
set -x
rm -rf ./{CMakeLists.txt,build_root.cmake,epoxy,epoxy.reset,virglrenderer,virglrenderer.reset,RVVM,RVVM.reset,DiligentLog,cmake}
cp -r ../libmedia/app/src/main/java/libengine/{CMakeLists.txt,build_root.cmake,epoxy,epoxy.reset,virglrenderer,virglrenderer.reset,RVVM,RVVM.reset,DiligentLog,cmake} .
if [[ ! -f Makefile ]] ; then
	wget https://github.com/ZLangJIT/ZLangTranspiler/raw/refs/heads/main/Makefile
fi
if [[ -e debug_BUILD/BUILD_ROOT/SRC/rvvm ]]
	then
		rm -rf debug_BUILD/BUILD_ROOT/SRC/rvvm
fi
#if [[ -e debug_BUILD/BUILD_ROOT/SRC/virglrenderer ]]
#	then
#		rm -rf debug_BUILD/BUILD_ROOT/SRC/virglrenderer
#fi
