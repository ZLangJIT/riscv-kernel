if [ $(( $(getprop | grep api | grep first | sed -e "s/.*: \[//" -e "s/\]//") >= 28 )) == 0 ] ; then
	export CFLAGS="$CFLAGS -D fputc_unlocked\(a,b\)=putc_unlocked\(\(a\),\(b\)\)"
	export CXXFLAGS="$CXXFLAGS -D fputc_unlocked\(a,b\)=putc_unlocked\(\(a\),\(b\)\)"
fi
if [ $(( $(getprop | grep api | grep first | sed -e "s/.*: \[//" -e "s/\]//") >= 29 )) == 0 ] ; then
	export CFLAGS="$CFLAGS -D reallocarray\(a,b,c\)=realloc\(\(a\),\(b\)*\(c\)\)"
	export CXXFLAGS="$CXXFLAGS -D reallocarray\(a,b,c\)=realloc\(\(a\),\(b\)*\(c\)\)"
fi
export gcc_cv_c_no_fpie=no
export gcc_cv_no_fpie=no
git clone --recursive https://github.com/riscv-collab/riscv-gnu-toolchain
cd riscv-gnu-toolchain || exit 1
#./configure --help
#./gcc/configure --help
#./configure \
#--prefix=/data/data/com.termux/files/usr/ \
#|| exit 1
make \
"GCC_EXTRA_CONFIGURE_FLAGS=--enable-host-pie --enable-host-shared --with-isl-path=/data/data/com.termux/files/usr/" \
|| exit 1
