if [[ -f disk.img ]]
	then
		rm -v disk.img
fi

dd if=/dev/zero of=disk.img bs=$((1024*1024)) count=100

ls -lh disk.img

./rvvm uboot -v -k Image -m 500m -cmdline="console=ttyS0 rootflags=discard rw $1" -k disk.img $2
