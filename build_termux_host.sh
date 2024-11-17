echo "building for host - termux"
apt install golang git wget make cmake ninja clang || exit 1
pip3 install meson || exit 1
if ! grep -q "/go/bin" ~/.bashrc ; then
    echo 'export PATH=$PATH:~/go/bin' >> ~/.bashrc
fi
. ~/.bashrc
go install github.com/hickford/git-credential-oauth@latest || exit 1
git credential-oauth configure || exit 1
. ./restore_libmedia.sh
cd rvvm-scripts || exit 1
./import.sh && ./make_rvvm.sh && ./test.sh
