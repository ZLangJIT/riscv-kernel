cd ../tmp
if [[ -f disk.img ]]
	then
		rm disk.img && echo "removed disk.img"
fi

dd if=/dev/zero of=disk.img bs=$((1024*1024)) count=100

ls -lh disk.img

./debug_BUILD/BUILD_ROOT/ROOTFS/usr/bin/rvvm .././libmedia/app/src/main/assets/uboot -v -k ./Image -m 800m -cmdline="console=ttyS0 rootflags=discard rw $1" \
-i ./disk.img $2
