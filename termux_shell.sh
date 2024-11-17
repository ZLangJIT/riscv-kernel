if [ $# == 0 ] ; then
	cmd="-c"
	args="\"cd /termux_pwd ; exec bash\""
else
	cmd="-c"
	args="\"cd /termux_pwd ; $@\""
fi

export TERMUX_PREFIX=$(cd ; cd ../.. ; pwd)
eval proot-distro login ubuntu \
	--isolated --bind "$(pwd):/termux_pwd" \
	-- bash -i $cmd $args
