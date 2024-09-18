#
if [ "$(cat /sys/devices/system/cpu/smt/active)" = "1" ]; then
	export LOGICAL_CORES=$(($(nproc --all) * 2))
else
	export LOGICAL_CORES=$(nproc --all)
fi
# Compile
#
if [ "$IS_LTS" = "NO" ]; then
	echo -e "Using $LOGICAL_CORES jobs for this non-LTS build..."
	make CC='ccache clang -Qunused-arguments -fcolor-diagnostics' ARCH=riscv LLVM=1 LLVM_IAS=1 -j$LOGICAL_CORES V=2
else
	echo -e "Using $LOGICAL_CORES jobs for this LTS build..."
	make ARCH=riscv LLVM=1 LLVM_IAS=1 -j$LOGICAL_CORES V=2
fi
