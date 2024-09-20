TAG=$(grep 'LOCALVERSION=' riscv_defconfig | sed 's/^.*[^0-9]\([0-9]*\.[0-9]*\.[0-9]*\).*$/\1/')
set -x
rm Image.gz
wget https://github.com/ZLangJIT/riscv-kernel/releases/download/$TAG/Image.gz
