TAG=$(grep 'LOCALVERSION=' riscv_defconfig | sed 's/^.*[^0-9]\([0-9]*\.[0-9]*\.[0-9]*\).*$/\1/')
set -x
if [[ -f /data/data/com.termux/files/home/linux.kernel.rvvm.debug.apk ]]
	then
		rm -v /data/data/com.termux/files/home/linux.kernel.rvvm.debug.apk
fi
wget https://github.com/ZLangJIT/riscv-kernel/releases/download/$TAG/linux.kernel.rvvm.debug.apk \
-O /data/data/com.termux/files/home/linux.kernel.rvvm.debug.apk &&
echo 'please execute in a new shell...' &&
echo &&
echo 'pm install /data/data/com.termux/files/home/linux.kernel.rvvm.debug.apk'
