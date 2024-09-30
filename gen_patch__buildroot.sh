set -x
if [[ -f buildroot.patch ]]
	then
		rm -v buildroot.patch
fi
touch buildroot.patch
cd buildroot
git reset db37b0e27d3c54d27b854edbc3253d29f512a6ee
git add -Av && git commit -m "c" && git format-patch --progress --stdout -n1 > ../buildroot.patch
