set -x
if [[ -f rvvm.patch ]]
	then
		rm -v rvvm.patch
fi
touch rvvm.patch
cd libmedia/app/src/main/java/libengine/RVVM
git reset 879138053b941ce5ea79efbd5fc3b368523b05b0
git add -Av && git commit -m "c" && git format-patch --progress --stdout -n1 > ../../../../../../../rvvm.patch
