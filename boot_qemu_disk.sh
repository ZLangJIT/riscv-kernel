qemu-system-riscv64 -nographic -machine virt -kernel Image --append "console=ttyS0 rootflags=discard rw" \
-drive file=disk.img,format=raw,if=none,id=nvm -device nvme,serial=deadbeef,drive=nvm $1
