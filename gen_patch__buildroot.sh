set -x
if [[ -f buildroot.patch ]]
	then
		rm -v buildroot.patch
fi
touch buildroot.patch
cd buildroot
git reset 8d835ffc524e2dab66ce1421240b9eb93c8f8f6a
git add -Av && git commit -m "c" && git format-patch --progress --stdout -n1 > ../buildroot.patch
