mkdir ../tmp
cd ../tmp
if [[ ! -e buildroot ]]
	then
		echo "copying buildroot..."
		cp -r ../buildroot .
fi
cd buildroot
cp ../../.buildrootconfig .config
make CC='clang -Qunused-arguments -fcolor-diagnostics' ARCH=riscv LLVM=1 LLVM_IAS=1 -j1
