set -x
if [[ -f buildroot.patch ]]
	then
		rm -v buildroot.patch
fi
R=$(cat git_reset_buildroot)
echo "patch file" > buildroot.patch
cd buildroot
clang ../t.c -o t || exit 1
./t ../.buildrootconfig > dot_buildrootconfig
rm t
git reset $R
git add -AN
git diff --binary $R >> ../buildroot.patch
