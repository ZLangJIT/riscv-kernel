cd ../tmp
if [[ -e nixos.iso.tmp ]] ; then
	rm -v nixos.iso.tmp
fi
URL="https://github.com/ZLangJIT/termux-gcc-riscv/releases/download/nixos/nixos.iso"
wget --no-verbose --show-progress "$URL" -O nixos.iso.tmp
if [[ -e nixos.iso ]] ; then
	rm -v nixos.iso
fi
mv -v nixos.iso.tmp nixos.iso
