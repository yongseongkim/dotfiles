#!/bin/sh

# Install Command Line Tools
xcode-select --install

# Install Brew and packages
if test ! $(which brew); then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew update
brew tap homebrew/bundle
brew bundle --file=$HOME/dotfiles/Brewfile
brew cleanup

# Set Git Configurations
[ ! -f $HOME/.gitconfig ] && ln -nfs $HOME/dotfiles/bin/.gitconfig $HOME/.gitconfig
git config --global core.excludesfile $HOME/dotfiles/bin/.gitignore_global

# Install zsh plugins
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

source $HOME/.zshrc

# Install Vim configurations
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
cp $HOME/dotfiles/bin/.vimrc $HOME/.vimrc
vim +'PlugInstall --sync' +qa

## coc.nvim
cp ./coc-settings.json $HOME/.vim/coc-settings.json
vim +'CocInstall -sync coc-json coc-html coc-sh' +qa

# Install powerline fonts - Use Dejavu Sans Mono for Powerline
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts
./install.sh
cd ..
rm -rf fonts

cp $HOME/dotfiles/bin/.tmux.conf $HOME/.tmux.conf
cp $HOME/dotfiles/bin/.zshrc $HOME/.zshrc
source $HOME/.zshrc

# Install language tools

## Rust
curl --proto '=https' --tlsv1.3 https://sh.rustup.rs -sSf | sh
curl -L https://github.com/rust-lang/rust-analyzer/releases/latest/download/rust-analyzer-aarch64-apple-darwin.gz | gunzip -c - > ~/.cargo/bin/rust-analyzer
chmod +x ~/.cago/bin/rust-analyzer

## Python
pyenv install 3.9.11
## Ruby
rbenv install 2.6.10
## Java
jenv add /Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home
jenv add /Library/Java/JavaVirtualMachines/adoptopenjdk-11.jdk/Contents/Home

# Install iOS Requirements
gem install cocoapods

# Set MacOS Preference
source $HOME/dotfiles/bin/.macos

