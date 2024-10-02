TAG=$(grep 'LOCALVERSION=' riscv_defconfig | sed 's/^.*[^0-9]\([0-9]*\.[0-9]*\.[0-9]*\).*$/\1/')
set -x
if [[ -f Image.gz ]]
	then
		rm -v Image.gz
fi
if [[ -f Image ]]
	then
		rm -v Image
fi
echo "downloading version $TAG ..."
wget https://github.com/ZLangJIT/riscv-kernel/releases/download/$TAG/Image.gz && ls -lh Image.gz && gunzip -f Image.gz && ls -lh Image
