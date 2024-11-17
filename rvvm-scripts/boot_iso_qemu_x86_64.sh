cd ../tmp

qemu-system-x86_64 -nographic -m 800m \
-cdrom nixos.iso \
$2
