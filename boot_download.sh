TAG=$(grep 'LOCALVERSION=' riscv_defconfig | sed 's/^.*[^0-9]\([0-9]*\.[0-9]*\.[0-9]*\).*$/\1/')
set -x
rm vmlinux-riscv64.ramdisk.gz
rm vmlinux-riscv64
wget https://github.com/ZLangJIT/riscv-kernel/releases/download/$TAG/vmlinux-riscv64.ramdisk.gz &&
wget https://github.com/ZLangJIT/riscv-kernel/releases/download/$TAG/vmlinux-riscv64
