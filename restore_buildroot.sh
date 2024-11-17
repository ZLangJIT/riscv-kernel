if [[ ! -d buildroot ]] ; then
	git clone https://gitlab.com/buildroot.org/buildroot
        dir=$(pwd)
	cd buildroot
	git reset --hard $(cat ../git_reset_buildroot)
	git apply --allow-empty ../buildroot.patch
	cd $dir
	unset dir
fi
