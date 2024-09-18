set -v
cd linux_kernel_build_dir
make LLVM=1 LLVM_IAS=1 ARCH=riscv V=12
