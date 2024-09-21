rm disk.img
dd if=/dev/zero of=disk.img bs=1M count=100

lldb ../RVVM/debug_BUILD/rvvm -- ../RVVM/uboot -v -k Image -m 100m -cmdline="console=ttyS0 rootflags=discard rw $1" \
-k disk.img $2
