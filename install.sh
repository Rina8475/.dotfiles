#! /usr/bin/env bash

# This scripts is used to configure the system after the installation of the OS.
# This scripts is only for Ubuntu 20.04 and 22.04

echo "This script is sponsered by riann-riu"

os=$(lsb_release -is)
version=$(lsb_release -rs)
if [[ $os != "Ubuntu" ]]; then
    echo "This scripts is only for Ubuntu."
    exit 1
fi

case $version in
    20.04)
        apt_source=$(cat Ubunut-20.source)
        ;;
    22.04)
        apt_source=$(cat Ubunut-22.source)
        ;;
    *)
        echo "This scripts is only for Ubuntu 20.04 and 22.04."
        exit 1
        ;;
esac

# change the source of apt
echo "change the source of apt..."
echo "$apt_source" | sudo tee /etc/apt/sources.list

# update apt
sudo apt update

# install esential tools
echo "install some tools..."
sudo apt install -y vim git curl wget gcc make build-essential gdb tmux

# set the proxy of git
git config --global http.proxy http://10.21.245.179:7890
git config --global https.proxy https://10.21.245.179:7890

# install oh-my-zsh
echo "install zsh..."
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# install zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# install zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# install fzf
echo "install fzf..."
sudo apt install -y fzf

# install batcat
echo "install batcat..."
sudo apt install -y bat

# configure tmux
git clone https://github.com/catppuccin/tmux.git ~/.config/tmux/plugins/catppuccin

# configure vim
echo "configure vim..."
git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
sh ~/.vim_runtime/install_awesome_vimrc.sh

# clone the dotfiles(.zshrc, .tmux.conf, vimrc)
cd ~
git clone https://github.com/Rina8475/dotfiles.git
ln -sf ~/.dotfiles/.zshrc ~/.zshrc
ln -sf ~/.dotfiles/.tmux.conf ~/.tmux.conf
ln -sf ~/.dotfiles/vimrc ~/.vim_runtime/my_configs.vim
source ~/.zshrc

# install other useful tools
sudo apt install -y tldr shellcheck
tldr --update  #! this command may fail, but it's ok, user can update later

# install golang version v1.23.2
echo "install golang..."
cd ~
wget https://dl.google.com/go/go1.23.2.linux-amd64.tar.gz
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.23.2.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.zshrc
source ~/.zshrc

# configure git
echo "configure git..."
git config --global user.name "Rina"
git config --global user.email tokiriasu@gmail.com
git config --global core.editor vim
git config --global color.branch auto
git config --global color.diff auto
git config --global color.interactive auto
git config --global color.status auto
git config --global color.grep auto
git config --global alias.lol "log --graph --oneline --decorate --color --all"

echo "Done!"
