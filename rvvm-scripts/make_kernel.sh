mkdir ../tmp
cd ../tmp
if [[ ! -e kernel ]]
	then
		echo "copying kernel..."
		cp -r ../linux-6.11 kernel
fi
cd kernel
cp ../../.linuxconfig .config
make CC='clang -Qunused-arguments -fcolor-diagnostics' ARCH=riscv LLVM=1 LLVM_IAS=1 -j1
