set -x
if [[ -f virglrenderer.patch ]]
	then
		rm -v virglrenderer.patch
fi
R=$(cat git_reset_virglrenderer)
echo "patch file" > virglrenderer.patch
cd libmedia/app/src/main/java/libengine/virglrenderer
git reset $R
git diff --binary $R >> ../../../../../../../virglrenderer.patch
git add -AN
git diff --binary $R >> ../../../../../../../virglrenderer.patch
