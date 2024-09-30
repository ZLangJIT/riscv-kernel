./gen_patch__rvvm.sh
set -x
touch libmedia.patch
cd libmedia
git reset 0f06c20bf1341da28213178545ba056f1791896f
mv app/src/main/java/libengine/RVVM/.git app/src/main/java/libengine/RVVM/.git0
git add -Av && git commit -m "c" && git format-patch --progress --stdout -n1 > ../libmedia.patch
mv app/src/main/java/libengine/RVVM/.git0 app/src/main/java/libengine/RVVM/.git
