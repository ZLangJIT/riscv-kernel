set -v

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

set -x

if [[ -d epoxy.current ]]
  then
    cd libmedia
    load epoxy
    cd ..
fi
if [[ -d virglrenderer.current ]]
  then
    cd libmedia
    load virglrenderer
    cd ..
fi
if [[ -d RVVM.current ]]
  then
    cd libmedia
    load RVVM
    cd ..
fi

./i_gen_patch__epoxy.sh
./i_gen_patch__virglrenderer.sh
./i_gen_patch__rvvm.sh
if [[ -f libmedia.patch ]]
	then
		rm -v libmedia.patch
fi
R=$(cat git_reset_libmedia)
echo "patch file" > libmedia.patch
cd libmedia
git reset $R


save epoxy
save virglrenderer
save RVVM

git add -AN
git diff --binary $R >> ../libmedia.patch

load epoxy
load virglrenderer
load RVVM

