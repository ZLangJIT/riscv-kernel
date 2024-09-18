# to exit via terminal - CTRL-A + x
#
# to exit via kernel shell - busybox poweroff -f
#
#./make.sh
#./debug_BUILD/rvvm ./uboot -v -k ./riscv-linux-prebuilt/kernel/vmlinux-rv64-5.4-rc7 -m 100m

TAG=$(grep 'LOCALVERSION=' riscv_defconfig | sed 's/^.*[^0-9]\([0-9]*\.[0-9]*\.[0-9]*\).*$/\1/')
set -x
wget https://github.com/ZLangJIT/riscv-kernel/releases/download/$TAG.1/vmlinux-riscv64 &&
../RVVM/debug_BUILD/rvvm ../RVVM/uboot -v -k vmlinux-riscv64 -m 100m
