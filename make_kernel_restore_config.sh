set -v
cd linux_kernel_build_dir
cp -v ../riscv_defconfig .config
make LLVM=1 LLVM_IAS=1 ARCH=riscv oldconfig V=12 O=../linux_kernel_build_dir
