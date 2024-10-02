set -x
if [[ -f virglrenderer.patch ]]
	then
		rm -v virglrenderer.patch
fi
touch virglrenderer.patch
cd libmedia/app/src/main/java/libengine/virglrenderer
git reset 2e38df33fb02e5635bbca8189e14eb15fc4f4a9c
git add -Av && git commit -m "c" && git format-patch --progress --stdout -n1 > ../../../../../../../virglrenderer.patch
