IS_VERBOSE="-q"
if [[ $# -gt '0' ]]
  then
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
    fi
fi

. ./compute_libmedia_version.sh

git add -Av ; git commit -m "update to riscv-kernel-6.11.0 v$LIBMEDIA_GRADLE_VERSION_CODE" ; git log -n 1 ; git push
