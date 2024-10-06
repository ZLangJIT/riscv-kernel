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

if $(am --help 2>&1 | grep -q -i "to-intent-uri")
  then
    echo "Android detected"
    # prefer external application over termux shell
    if $(pm list packages -3 2>&1 | grep -q "idm.internet.download.manager.plus")
      then
        echo "1DM+ detected"
        am start --user 0 -n "idm.internet.download.manager.plus/idm.internet.download.manager.UrlHandlerDownloader" -d https://github.com/ZLangJIT/riscv-kernel/releases/download/$TAG/linux.kernel.rvvm.release.apk
        exit
    fi
    if [[ -d /data/data/com.termux/files/usr ]]
      then
        echo "Termux shell detected"
        cd /data/data/com.termux/files/home
        if [[ -f linux.kernel.rvvm.release.apk ]]
        	then
        		rm -v linux.kernel.rvvm.release.apk
        fi
        wget --no-verbose --show-progress https://github.com/ZLangJIT/riscv-kernel/releases/download/$TAG/linux.kernel.rvvm.release.apk &&
        set +x &&
        echo &&
        echo 'please install the following apk ...' &&
        echo &&
        echo '/data/data/com.termux/files/home/linux.kernel.rvvm.release.apk' &&
        echo
        exit
    fi
fi
