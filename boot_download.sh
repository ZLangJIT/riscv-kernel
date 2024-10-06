IS_VERBOSE="-q"
while [[ $# -gt '0' ]]
  do
    if [[ "$1" == '-v' ]]
      then
        IS_VERBOSE="--show-progress -q"
        shift
        if [[ $# -gt '0' ]]
          then
            if [[ "$1" == '-v' ]]
              then
                IS_VERBOSE="--show-progress -v"
                shift
            fi
        fi
    else
      if [[ "$1" == '--version_code' ]]
        then
          LIBMEDIA_GRADLE_VERSION_CODE="$2"
          shift
          shift
        else
          shift
      fi
  fi
done
if [[ -z $LIBMEDIA_GRADLE_VERSION_CODE ]]
  then
    . ./compute_libmedia_version.sh
fi
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
