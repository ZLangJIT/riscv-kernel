if [[ -f disk.img ]]
	then
		rm -v disk.img
fi

dd if=/dev/zero of=disk.img bs=1M count=100

./rvvm uboot -v -k Image -m 100m -cmdline="console=ttyS0 rootflags=discard rw $1" -k disk.img $2
