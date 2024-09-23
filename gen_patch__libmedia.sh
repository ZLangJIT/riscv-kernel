set -x
touch libmedia.patch
cd libmedia
git reset 0f06c20bf1341da28213178545ba056f1791896f
git add -Av && git commit -m "c" && git format-patch --progress --stdout -n1 > ../libmedia.patch
