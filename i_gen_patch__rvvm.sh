set -x
if [[ -f rvvm.patch ]]
	then
		rm -v rvvm.patch
fi
touch rvvm.patch
cd libmedia/app/src/main/java/libengine/RVVM
git reset 2a5d6744e0261c5b63db218d41c73aab32416cc2
git add -Av && git commit -m "c" && git format-patch --progress --stdout -n1 > ../../../../../../../rvvm.patch
