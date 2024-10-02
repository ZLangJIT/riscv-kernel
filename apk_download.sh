TAG=$(grep 'LOCALVERSION=' riscv_defconfig | sed 's/^.*[^0-9]\([0-9]*\.[0-9]*\.[0-9]*\).*$/\1/')

if $(am --help 2>&1 | grep -q -i "to-intent-uri")
  then
    echo "Android detected"
    # prefer external application over termux shell
    if $(pm list packages -3 2>&1 | grep -q "idm.internet.download.manager.plus")
      then
        echo "1DM+ detected"
        am start --user 0 -n "idm.internet.download.manager.plus/idm.internet.download.manager.UrlHandlerDownloader" -d "https://github.com/ZLangJIT/riscv-kernel/releases/download/6.11.39/linux.kernel.rvvm.release.apk"
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
        wget https://github.com/ZLangJIT/riscv-kernel/releases/download/$TAG/linux.kernel.rvvm.release.apk &&
        set +x &&
        echo &&
        echo 'please install the following apk ...' &&
        echo &&
        echo '/data/data/com.termux/files/home/linux.kernel.rvvm.release.apk' &&
        echo
        exit
    fi
fi
