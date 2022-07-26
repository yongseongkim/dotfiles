#!/bin/sh

# Install Command Line Tools
xcode-select --install

echo '##########################################################################'
echo '############## Installing Brew and packages...'
echo '##########################################################################'
if test ! $(which brew); then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew update
brew tap homebrew/bundle
brew bundle --file=$HOME/dotfiles/Brewfile
brew cleanup

[ ! -f $HOME/.gitconfig ] && ln -nfs $HOME/dotfiles/bin/.gitconfig $HOME/.gitconfig
git config --global core.excludesfile $HOME/dotfiles/bin/.gitignore_global

wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
cp $HOME/dotfiles/bin/.zshrc $HOME/.zshrc

source $HOME/.zshrc

pyenv install 3.9.11
rbenv install 2.7.2
gem install cocoapods
jenv add /Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home
jenv add /Library/Java/JavaVirtualMachines/adoptopenjdk-11.jdk/Contents/Home

echo '##########################################################################'
echo '############## Installing MacOS preferences...'
echo '##########################################################################'
source $HOME/dotfiles/bin/.macos

echo '##########################################################################'
echo '############## Complete bootstraping'
echo '##########################################################################'
