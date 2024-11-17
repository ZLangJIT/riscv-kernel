cd ../tmp

qemu-system-riscv64 -nographic -machine virt -m 800m \
-cdrom nixos.iso \
$2
