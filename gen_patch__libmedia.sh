./i_gen_patch__epoxy.sh
./i_gen_patch__virglrenderer.sh
./i_gen_patch__rvvm.sh
set -x
if [[ -f libmedia.patch ]]
	then
		rm -v libmedia.patch
fi
R=$(cat git_reset_libmedia)
echo "patch file" > libmedia.patch
cd libmedia
git reset $R

function save() {
mv app/src/main/java/libengine/$1/.git app/src/main/java/libengine/$1/.git0
mv app/src/main/java/libengine/$1.reset/.git app/src/main/java/libengine/$1.reset/.git0
mv app/src/main/java/libengine/$1 ../$1.current
mv app/src/main/java/libengine/$1.reset app/src/main/java/libengine/$1
}

function load() {
mv app/src/main/java/libengine/$1 app/src/main/java/libengine/$1.reset
mv ../$1.current app/src/main/java/libengine/$1
mv app/src/main/java/libengine/$1.reset/.git0 app/src/main/java/libengine/$1.reset/.git
mv app/src/main/java/libengine/$1/.git0 app/src/main/java/libengine/$1/.git
}

save epoxy
save virglrenderer
save RVVM

git add -AN
git diff --binary $R >> ../libmedia.patch

load epoxy
load virglrenderer
load RVVM

