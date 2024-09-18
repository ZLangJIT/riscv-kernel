set -v
cd linux-6.11
make LLVM=1 LLVM_IAS=1 ARCH=riscv O=../linux_kernel_build_dir defconfig V=2
