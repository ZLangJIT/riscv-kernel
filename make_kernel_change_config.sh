set -v
cd linux_kernel_build_dir
make help
make LLVM=1 LLVM_IAS=1 ARCH=riscv menuconfig V=2
