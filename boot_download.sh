TAG=$(grep 'LOCALVERSION=' riscv_defconfig | sed 's/^.*[^0-9]\([0-9]*\.[0-9]*\.[0-9]*\).*$/\1/')
set -x
if [[ -f Image.gz ]]
	then
		rm -v Image.gz
fi
wget https://github.com/ZLangJIT/riscv-kernel/releases/download/$TAG/Image.gz && gunzip -f -d Image.gz
