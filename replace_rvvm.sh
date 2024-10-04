#!/bin/bash
cd libmedia/app/src/main/java/libengine/RVVM
cd src
A=$1
B=$2
shift
shift
while [[ $# != 0 ]]
  do
    if [[ -e $1 ]]
      then
        echo "processing $1"
        set -x
        printf '%s\n' ",s/$A/$B/g" w q | ed --quiet $1
        shift
      else
        echo "$1 not found"
        exit
    fi
done
