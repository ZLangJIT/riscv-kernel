rm disk.img
dd if=/dev/zero of=disk.img bs=1M count=100

qemu-system-riscv64 -nographic -machine virt -kernel Image --append "console=ttyS0 rootflags=discard rw $1" \
-drive file=disk.img,format=raw,if=none,id=nvm -device nvme,serial=deadbeef,drive=nvm $2
