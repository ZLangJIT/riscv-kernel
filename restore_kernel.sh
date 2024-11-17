if [[ ! -d linux-6.11 ]] ; then
	git clone https://github.com/torvalds/linux -b v6.11 --depth 1 linux-6.11
        dir=$(pwd)
	cd linux-6.11
	git reset --hard $(cat ../git_reset_kernel)
	git apply --allow-empty ../kernel.patch
	cd $dir
	unset dir
fi
