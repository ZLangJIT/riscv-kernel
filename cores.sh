if [ "$(cat /sys/devices/system/cpu/smt/active)" = "1" ]; then
        export LOGICAL_CORES=$(($(nproc --all) * 2))
else
        export LOGICAL_CORES=$(nproc --all)
fi
