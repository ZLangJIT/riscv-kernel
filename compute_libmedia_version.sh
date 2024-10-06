function check_patch() {
    if [[ -f $1.patch.latest ]]
        then
            rm $1.patch.latest
    fi
    if [[ -f $1.patch.latest.major ]]
        then
            rm $1.patch.latest.major
    fi
    if [[ -f $1.patch.latest.minor ]]
        then
            rm $1.patch.latest.minor
    fi
    if [[ -f $1.patch.latest.version_code ]]
        then
            rm $1.patch.latest.version_code
    fi
    if ! wget ${IS_VERBOSE} https://github.com/ZLangJIT/riscv-kernel/releases/download/patches-$1/$1.patch -O $1.patch.latest
        then
            echo "REBUILD_${2}_FLAG=1"
            echo "$(eval "echo \$${2}_VERSION")" > $1.patch.latest.major
            echo "0" > $1.patch.latest.minor
            echo "1" > $1.patch.latest.version_code
        else
            wget ${IS_VERBOSE} https://github.com/ZLangJIT/riscv-kernel/releases/download/patches-$1/$1.patch.latest.major
            wget ${IS_VERBOSE} https://github.com/ZLangJIT/riscv-kernel/releases/download/patches-$1/$1.patch.latest.minor
            wget ${IS_VERBOSE} https://github.com/ZLangJIT/riscv-kernel/releases/download/patches-$1/$1.patch.latest.version_code
            if ! git diff --quiet --no-index $1.patch.latest $1.patch
                then
                    echo "REBUILD_${2}_FLAG=1"
                    if [[ $(eval "echo \$${2}_VERSION") != $(cat $1.patch.latest.major) ]]
                        then
                            echo "$(eval "echo \$${2}_VERSION")" > $1.patch.latest.major
                            echo "0" > $1.patch.latest.minor
                        else
                            echo "$(($(cat $1.patch.latest.minor)+1))" > $1.patch.latest.minor.tmp
                            mv $1.patch.latest.minor.tmp $1.patch.latest.minor
                    fi
                    echo "$(($(cat $1.patch.latest.version_code)+1))" > $1.patch.latest.version_code.tmp
                    mv $1.patch.latest.version_code.tmp $1.patch.latest.version_code
                else
                    echo "REBUILD_${2}_FLAG="
            fi
    fi

    echo "${2}_VERSION_MAJOR=$(cat $1.patch.latest.major)"
    eval "export ${2}_VERSION_MAJOR=$(cat $1.patch.latest.major)"

    echo "${2}_VERSION_MINOR=$(cat $1.patch.latest.minor)"
    eval "export ${2}_VERSION_MINOR=$(cat $1.patch.latest.minor)"

    echo "${2}_VERSION_CODE=$(cat $1.patch.latest.version_code)"
    eval "export ${2}_VERSION_CODE=$(cat $1.patch.latest.version_code)"
}

. version_information

check_patch buildroot BUILDROOT
check_patch kernel KERNEL
check_patch epoxy EPOXY
check_patch virglrenderer VIRGL
check_patch rvvm RVVM
check_patch libmedia LIBMEDIA

LIBMEDIA_GRADLE_VERSION_CODE=$(($KERNEL_VERSION_CODE+$BUILDROOT_VERSION_CODE+$EPOXY_VERSION_CODE+$VIRGL_VERSION_CODE+$RVVM_VERSION_CODE+$LIBMEDIA_VERSION_CODE))

LIBMEDIA_GRADLE_VERSION_STRING="Linux Kernel 6.11 (kernel v$KERNEL_VERSION_MAJOR.$KERNEL_VERSION_MINOR)(buildroot+rootfs v$BUILDROOT_VERSION_MAJOR.$BUILDROOT_VERSION_MINOR)(epoxy v$EPOXY_VERSION_MAJOR.$EPOXY_VERSION_MINOR)(virglrenderer v$VIRGL_VERSION_MAJOR.$VIRGL_VERSION_MINOR)(rvvm v$RVVM_VERSION_MAJOR.$RVVM_VERSION_MINOR)(libmedia v$LIBMEDIA_VERSION_MAJOR.$LIBMEDIA_VERSION_MINOR)"

echo "LIBMEDIA_GRADLE_VERSION_CODE=$LIBMEDIA_GRADLE_VERSION_CODE"
echo "LIBMEDIA_GRADLE_VERSION_STRING=$LIBMEDIA_GRADLE_VERSION_STRING"
