#
# to exit via terminal - CTRL-A + x
#
# to exit via kernel shell - busybox poweroff -f
#

../RVVM/debug_BUILD/rvvm --help
../RVVM/debug_BUILD/rvvm ../RVVM/uboot -v -k Image -m 102m -cmdline="console=ttyS rootflags=discard rw $1"
