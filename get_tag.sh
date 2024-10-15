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
      if [[ "$1" == '--version-code' ]]
        then
          LIBMEDIA_GRADLE_VERSION_CODE="$2"
          shift
          shift
        else
          if [[ "$1" == '-h' || "$1" == '--help' ]]
            then
              echo "usage:"
              echo ""
              echo "    -h, --help        this help text"
              echo "    -v                print file download progress"
              echo "    -v -v             print detailed file download progress"
              echo "    --version-code    specify the version code, eg   --version-code 17"
              exit 1
            else
              shift
          fi
      fi
  fi
done
if [[ -z $LIBMEDIA_GRADLE_VERSION_CODE ]]
  then
    . ./compute_libmedia_version.sh
fi
