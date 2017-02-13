
alias app-get=apt-get
sudo app-get install software-properties-common && alias add-repo="add-apt-repository -y"

sudo add-repo ppa:webupd8team/unstable
sudo app-get update
# sudo app-get build-dep guake
sudo app-get install terminator
