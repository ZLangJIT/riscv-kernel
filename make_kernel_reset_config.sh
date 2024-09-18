set -v
cd linux-6.11
rm -rf ../linux_kernel_build_dir
cp ../riscv_defconfig ./arch/riscv/configs/riscv_defconfig
make ARCH=riscv LLVM=1 LLVM_IAS=1 O=../linux_kernel_build_dir mrproper V=2
make ARCH=riscv LLVM=1 LLVM_IAS=1 O=../linux_kernel_build_dir riscv_defconfig V=2
make ARCH=riscv LLVM=1 LLVM_IAS=1 O=../linux_kernel_build_dir oldconfig V=2
