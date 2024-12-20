./termux_shell.sh "sed -i -e 's/#Co/Co/' /etc/pacman.conf"
./termux_shell.sh "sed -i -e 's/#Pa/Pa/' /etc/pacman.conf"
./termux_shell.sh "pacman -Sy --noconfirm --needed glibc wget sudo"
./termux_shell.sh "sed -i -e 's/# ALL ALL=(ALL:ALL) ALL/ALL ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers"
./termux_shell.sh "useradd nix-install"
./termux_shell.sh "groupadd nixbld"
./termux_shell.sh "useradd _nixbld1"
./termux_shell.sh "usermod -a -G nixbld _nixbld1"
./termux_shell.sh "su nix-install bash -c 'bash <(wget -q -O - https://nixos.org/nix/install) --no-daemon'"
#proot-distro login riscv_kernel_bootstrap_nix --isolated --bind "$(pwd):/termux_pwd" -- sh -c "apk update ; apk add bash"
./termux_shell.sh "/nix/store/*/bin/nix-channel --add https://nixos.org/channels/nixos-24.05 nixos ; /nix/store/*/bin/nix-channel --update && /nix/store/*/bin/nix-env --install --attr nixpkgs.nix"
echo "dropping to shell, type 'exit' to continue"
echo "/termux_pwd -> $(pwd)"
./termux_shell.sh
