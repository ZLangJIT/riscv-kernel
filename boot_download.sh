. ./compute_libmedia_version.sh
TAG=$LIBMEDIA_GRADLE_VERSION_CODE
set -x
if [[ -f Image.gz ]]
	then
		rm -v Image.gz
fi
if [[ -f Image ]]
	then
		rm -v Image
fi
echo "downloading version $TAG ..."
wget --no-verbose --show-progress https://github.com/ZLangJIT/riscv-kernel/releases/download/$TAG/Image.gz && ls -lh Image.gz && gunzip -f Image.gz && ls -lh Image
