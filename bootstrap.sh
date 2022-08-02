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

sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
cp $HOME/dotfiles/bin/.zshrc $HOME/.zshrc

# install pwerline fonts
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts
./install.sh
cd ..
rm -rf fonts

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
