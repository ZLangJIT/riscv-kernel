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

git add -Av ; git commit -m "update to riscv-kernel-6.11.0 v$LIBMEDIA_GRADLE_VERSION_CODE" ; git log -n 1 ; git push
