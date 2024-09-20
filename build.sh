
. cores.sh

# Compile
#

mkdir initrd.dir
cd initrd.dir
mkdir usr ; chmod 755 usr
mkdir bin ; chmod 755 bin
mkdir proc ; chmod 755 proc
mkdir sys ; chmod 755 sys
mkdir sbin ; chmod 755 sbin
ln -s /bin usr/bin
ln -s /sbin usr/sbin
cp ../initrd.dir.riscv64/bin/busybox bin/busybox ; chmod 755 bin/busybox
cp ../initrd.dir.riscv64/init init ; chmod 755 init
mkdir dev ; chmod 755 dev
mknod dev/console c 5 1 ; chmod 666 dev/console
mknod dev/null c 1 3 ; chmod 666 dev/null
mknod dev/zero c 1 5 ; chmod 666 dev/zero
cd ..

if [ "$IS_LTS" = "NO" ]; then
	echo -e "Using $LOGICAL_CORES jobs for this non-LTS build..."
	#make CC='ccache clang -Qunused-arguments -fcolor-diagnostics' ARCH=riscv LLVM=1 LLVM_IAS=1 -j$LOGICAL_CORES V=2
else
	echo -e "Using $LOGICAL_CORES jobs for this LTS build..."
	#make ARCH=riscv LLVM=1 LLVM_IAS=1 -j$LOGICAL_CORES V=2
fi

pacman -S --noconfirm rsync wget
useradd -m build
echo "build ALL=(ALL:ALL) ALL" >> /etc/sudoers
mkdir build_dir
chown build:build build_dir
chmod 777 build_dir
#su --command="cd build_dir ; git clone --recursive https://github.com/ATS-INTC/linux-image --depth 1 linux-image" build
#su --command="cd build_dir/linux-image ; rm -rf linux-xlnx ; git clone https://github.com/torvalds/linux -b v6.11 --depth 1 linux-xlnx" build
#su --command="cd build_dir/linux-image/buildroot ; cp ../.buildrootconfig .config ; make CC='ccache clang -Qunused-arguments -fcolor-diagnostics' ARCH=riscv LLVM=1 LLVM_IAS=1 -j$LOGICAL_CORES V=2 ; cp output/images/rootfs.cpio ../rootfs.cpio" build
#su --command="cd build_dir/linux-image/buildroot ; cp ../.linuxconfig .config ; make CC='ccache clang -Qunused-arguments -fcolor-diagnostics' ARCH=riscv LLVM=1 LLVM_IAS=1 -j$LOGICAL_CORES V=2 " build
