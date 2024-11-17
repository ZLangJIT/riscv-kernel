if [[ ! -d libmedia ]] ; then
	git clone https://github.com/mgood7123/libmedia --depth=1
        dir=$(pwd)
	cd libmedia
	git apply --allow-empty ../libmedia_build.patch
        rm -rf ffmpeg
        rm -rf ADB_PULL_DATA.media.player.pro
        rm -rf APKs
        rm -rf app/debug
        rm -rf app/release
        rm -rf app/libs/arm64-v8a/*
        rm -rf app/src/main/assets/0*
        rm -rf app/src/main/assets/CLAP.raw
        rm -rf app/src/main/assets/FUNKY_HOUSE.raw
        rm -rf app/src/main/assets/Rhythm8
        rm -rf app/src/main/assets/usr/libs/arm64-v8a/*
        git add -A ; git commit -m "reset point"
        git log --pretty=format:'%H' -n 1 > ../git_reset_libmedia
	git apply --allow-empty ../libmedia.patch
        cd app/src/main/java/libengine
        cd epoxy
        mv .git0 .git
        cp -R ../epoxy ../epoxy.reset
        cd ../virglrenderer
        mv .git0 .git
        cp -R ../virglrenderer ../virglrenderer.reset
        cd ../RVVM
        mv .git0 .git
        cp -R ../RVVM ../RVVM.reset
	cd $dir
	unset dir
fi
