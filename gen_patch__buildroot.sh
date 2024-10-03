set -x
if [[ -f buildroot.patch ]]
	then
		rm -v buildroot.patch
fi
R=$(cat git_reset_buildroot)
echo "patch file" > buildroot.patch
cd buildroot
git reset $R
#git add -AN
git diff --binary $R >> ../buildroot.patch
