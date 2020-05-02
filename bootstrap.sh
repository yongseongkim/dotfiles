#!/bin/sh

# Install Command Line Tools
xcode-select --install

echo '##########################################################################'
echo '############## Installing Brew and packages...'
echo '##########################################################################'
if test ! $(which brew); then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

brew update
brew tap homebrew/bundle
brew bundle --file=$HOME/dotfiles/Brewfile
brew cleanup

[ ! -f $HOME/.gitconfig ] && ln -nfs $HOME/dotfiles/bin/.gitconfig $HOME/.gitconfig
git config --global core.excludesfile $HOME/dotfiles/bin/.gitignore_global

echo '##########################################################################'
echo '############## Installing zsh settings...'
echo '##########################################################################'
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
cp $HOME/dotfiles/bin/.zshrc $HOME/.zshrc

# Install font for agnoster
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts
./install.sh
cd ..
rm -rf fonts

curl -o agnoster.zsh-theme https://gist.githubusercontent.com/agnoster/3712874/raw/43cb371f361eecf62e9dac7afc73a1c16edf89c7/agnoster.zsh-theme
[ ! -d "~/.oh-my-zsh/custom/themes" ] && mkdir ~/.oh-my-zsh/custom/themes
mv agnoster.zsh-theme ~/.oh-my-zsh/custom/themes

source $HOME/.zshrc

echo '##########################################################################'
echo '############## Installing Python, Ruby environment manager...'
echo '##########################################################################'
pyenv install 3.7.0
rbenv install 2.6.5

echo '##########################################################################'
echo '############## Installing MacOS preferences...'
echo '##########################################################################'
source $HOME/dotfiles/bin/.macos

echo '##########################################################################'
echo '############## Complete bootstraping'
echo '##########################################################################'

