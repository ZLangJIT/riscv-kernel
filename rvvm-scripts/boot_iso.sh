cd ../tmp

LD_LIBRARY_PATH=./debug_BUILD/BUILD_ROOT/ROOTFS/usr/lib \
./debug_BUILD/BUILD_ROOT/ROOTFS/usr/bin/rvvm .././libmedia/app/src/main/assets/uboot -v -m 800m \
-i ./nixos.iso $2
