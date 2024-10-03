set -x
if [[ -f buildroot.patch ]]
	then
		rm -v buildroot.patch
fi
R=$(cat git_reset_buildroot)
touch buildroot.patch
cd buildroot
git reset $R
git add -AN
git diff --binary > ../buildroot.patch
