#!/bin/bash
./replace_rvvm.sh "$1" "$2" devices/virtio{.h,-{blk,gpu,input,net}.c,_{common,device,feature,input-event-codes,list}.h}
