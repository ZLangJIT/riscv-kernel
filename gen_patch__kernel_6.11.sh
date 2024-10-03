set -x
if [[ -f kernel.patch ]]
	then
		rm -v kernel.patch
fi
R=$(cat git_reset_kernel)
touch kernel.patch
cd linux-6.11
git reset $R
git add -AN
git diff --binary > ../kernel.patch
