set -x
touch rvvm.patch
cd libmedia/app/src/main/java/libengine/RVVM
git reset f4031a4f7860cdfd37ecf8b94d1a9d607960efb5
git add -Av && git commit -m "c" && git format-patch --progress --stdout -n1 > ../../../../../../../rvvm.patch
