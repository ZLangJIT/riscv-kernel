#
# to exit via terminal - CTRL-A + x
#
# to exit via kernel shell - busybox poweroff -f
#

../RVVM/debug_BUILD/rvvm --help
../RVVM/debug_BUILD/rvvm ../RVVM/uboot -v -k Image -m 100m -cmdline="console=ttyS0 rootflags=discard rw $1" $2
#qemu-system-riscv64 -nographic -machine virt -kernel Image --append "console=ttyS0 rootflags=discard rw $1" $2
