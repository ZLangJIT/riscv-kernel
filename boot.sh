#
# to exit via terminal - CTRL-A + x
#
# to exit via kernel shell - busybox poweroff -f
#

../RVVM/debug_BUILD/rvvm --help
../RVVM/debug_BUILD/rvvm ../RVVM/uboot -v -k vmlinux-riscv64 -m 100m \
  -cmdline="console=ttyS0 rootflags=discard rw $1"
