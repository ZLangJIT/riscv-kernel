set -x
if [[ -f rvvm.patch ]]
	then
		rm -v rvvm.patch
fi
R=$(cat git_reset_rvvm)
echo "patch file" > rvvm.patch
cd libmedia/app/src/main/java/libengine/RVVM
git reset $R
#git add -AN
git diff --binary $R >> ../../../../../../../rvvm.patch
