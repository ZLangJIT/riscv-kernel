if [[ -f disk.img ]]
	then
		rm -v disk.img
fi

dd if=/dev/zero of=disk.img bs=$((1024*1024)) count=100

qemu-system-riscv64 -nographic -machine virt -m 800m -kernel Image --append "console=ttyS0 rootflags=discard rw $1" \
-drive file=disk.img,format=raw,if=none,id=nvm -device nvme,serial=deadbeef,drive=nvm $2
