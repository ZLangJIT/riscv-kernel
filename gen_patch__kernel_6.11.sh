set -x
if [[ -f kernel.patch ]]
	then
		rm -v kernel.patch
fi
touch kernel.patch
cd linux-6.11
git reset ae9b65c0b03a53587f933ef7cc3f5aa598b8cf36
git add -Av && git commit -m "c" && git format-patch --progress --stdout -n1 > ../kernel.patch
