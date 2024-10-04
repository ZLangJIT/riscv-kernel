if [[ -f disk.img ]]
	then
		rm -v disk.img
fi

dd if=/dev/zero of=disk.img bs=$((1024*1024)) count=100

ls -lh disk.img

cd libmedia/app/src/main/java/libengine/RVVM
if make USE_VIRTIO=1
    then
        cd ../../../../../../..
        ./libmedia/app/src/main/java/libengine/RVVM/release*/rvvm* -- uboot -v -k Image -m 800m -cmdline="console=ttyS0 rootflags=discard rw $1" -i disk.img $2
fi

