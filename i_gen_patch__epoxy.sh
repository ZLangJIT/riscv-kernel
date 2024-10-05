set -x
if [[ -f epoxy.patch ]]
	then
		rm -v epoxy.patch
fi
R=$(cat git_reset_epoxy)
echo "patch file" > epoxy.patch
cd libmedia/app/src/main/java/libengine/epoxy
git reset $R
git add -AN
git diff --binary $R >> ../../../../../../../epoxy.patch
