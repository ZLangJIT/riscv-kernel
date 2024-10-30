set -x
apt install golang git
if ! grep -q "/go/bin" ~/.bashrc ; then
    echo 'export PATH=$PATH:~/go/bin' >> ~/.bashrc
fi
. ~/.bashrc
go install github.com/hickford/git-credential-oauth@latest
git credential-oauth configure
