set -x
if [[ -f kernel.patch ]]
	then
		rm -v kernel.patch
fi
R=$(cat git_reset_kernel)
echo "patch file" > kernel.patch
cd linux-6.11
clang ../t.c -o t || exit 1
./t ../.linuxconfig > dot_linuxconfig
rm t
git reset $R
git add -AN
git diff --binary $R >> ../kernel.patch
