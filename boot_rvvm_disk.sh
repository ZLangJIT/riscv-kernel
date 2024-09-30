if [[ -f disk.img ]]
	then
		rm -v disk.img
fi

dd if=/dev/zero of=disk.img bs=1M count=100

../RVVM/debug_BUILD/rvvm ../RVVM/uboot -v -k Image -m 100m -cmdline="console=ttyS0 rootflags=discard rw $1" -k disk.img $2
# gdb --args ./rvvm ../RVVM/uboot -v -k Image -m 100m -cmdline="console=ttyS0 rootflags=discard rw $1" -k disk.img $2
