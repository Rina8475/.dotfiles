#! /usr/bin/env bash

apt_source="# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse

# 以下安全更新软件源包含了官方源与镜像站配置，如有需要可自行修改注释切换
deb http://security.ubuntu.com/ubuntu/ jammy-security main restricted universe multiverse
# deb-src http://security.ubuntu.com/ubuntu/ jammy-security main restricted universe multiverse

# 预发布软件源，不建议启用
# deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-proposed main restricted universe multiverse
# # deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-proposed main restricted universe multiverse"

# This scripts is used to configure the system after the installation of the OS.
# This scripts is only for Ubuntu 22.04.

echo "This script is sponsered by riann-riu"

os=$(lsb_release -is)
version=$(lsb_release -rs)
if [[ $os != "Ubuntu" || $version != "22.04" ]]; then
    echo "This scripts is only for Ubuntu 22.04."
    exit 1
fi

# change the source of apt
echo "change the source of apt..."
echo $apt_source > /etc/apt/sources.list

# update apt
sudo apt update

# install esential tools
echo "install some tools..."
sudo apt install -y vim git curl wget gcc make build-essential gdb tmux

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

# clone the dotfiles(.zshrc, .tmux.conf)
cd ~
git clone https://github.com/Rina8475/dotfiles.git
ln -s ~/dotfiles/.zshrc ~/.zshrc
ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf
source ~/.zshrc

# install other useful tools
sudo apt install -y tldr shellcheck 
tldr --update  #! this command may fail, but it's ok, user can update later

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

# configure vim
echo "configure vim..."
curl -sLf https://spacevim.org/install.sh | bash

echo "Done!"

