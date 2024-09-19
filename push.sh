#
#
# kernel release version
#
# ./make_kernel_change_config.sh ; ./make_kernel_save_config.sh ; ./push.sh
#
# increment [ General Setup > Local Version ] this each time we push a change
#   or the CI will not build it if the CURRENT release matches
#
# eg, if we successfully build and release TAG=6.11.0
#   then attempting to build TAG=6.11.0 again will no-op even if we push changes
#   if we build and release 6.11.1 then building 6.11.0 will succeed since 6.11.0 != 6.11.1
#
#

TAG=$(grep 'LOCALVERSION=' riscv_defconfig | sed 's/^.*[^0-9]\([0-9]*\.[0-9]*\.[0-9]*\).*$/\1/')

git add -Av ; git commit -m "update to riscv-kernel-$TAG" ; git log -n 1 ; git push
