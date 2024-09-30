TAG=$(grep 'LOCALVERSION=' riscv_defconfig | sed 's/^.*[^0-9]\([0-9]*\.[0-9]*\.[0-9]*\).*$/\1/')
set -x
cd /data/data/com.termux/files/home
if [[ -f linux.kernel.rvvm.debug.apk ]]
	then
		rm -v linux.kernel.rvvm.debug.apk
fi
wget https://github.com/ZLangJIT/riscv-kernel/releases/download/$TAG/linux.kernel.rvvm.debug.apk &&
set +x &&
echo &&
echo 'please install the following apk ...' &&
echo &&
echo '/data/data/com.termux/files/home/linux.kernel.rvvm.debug.apk' &&
echo
