./gen_patch__rvvm.sh
./gen_patch__virglrenderer.sh
set -x
if [[ -f libmedia.patch ]]
	then
		rm -v libmedia.patch
fi
touch libmedia.patch
cd libmedia
git reset 0f06c20bf1341da28213178545ba056f1791896f

mv app/src/main/java/libengine/RVVM/.git app/src/main/java/libengine/RVVM/.git0
mv app/src/main/java/libengine/RVVM.reset/.git app/src/main/java/libengine/RVVM.reset/.git0
mv app/src/main/java/libengine/RVVM ../RVVM.current
mv app/src/main/java/libengine/RVVM.reset app/src/main/java/libengine/RVVM

mv app/src/main/java/libengine/virglrenderer/.git app/src/main/java/libengine/virglrenderer/.git0
mv app/src/main/java/libengine/virglrenderer.reset/.git app/src/main/java/libengine/virglrenderer.reset/.git0
mv app/src/main/java/libengine/virglrenderer ../virglrenderer.current
mv app/src/main/java/libengine/virglrenderer.reset app/src/main/java/libengine/virglrenderer

git add -Av && git commit -m "c" && git format-patch --progress --stdout -n1 > ../libmedia.patch

mv app/src/main/java/libengine/RVVM app/src/main/java/libengine/RVVM.reset
mv ../RVVM.current app/src/main/java/libengine/RVVM
mv app/src/main/java/libengine/RVVM.reset/.git0 app/src/main/java/libengine/RVVM.reset/.git
mv app/src/main/java/libengine/RVVM/.git0 app/src/main/java/libengine/RVVM/.git

mv app/src/main/java/libengine/virglrenderer app/src/main/java/libengine/virglrenderer.reset
mv ../virglrenderer.current app/src/main/java/libengine/virglrenderer
mv app/src/main/java/libengine/virglrenderer.reset/.git0 app/src/main/java/libengine/virglrenderer.reset/.git
mv app/src/main/java/libengine/virglrenderer/.git0 app/src/main/java/libengine/virglrenderer/.git
