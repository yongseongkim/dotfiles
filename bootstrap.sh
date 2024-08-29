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

# Install zsh theme
# source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme
# echo "source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme" >>~/.zshrc

# Set Git Configurations
[ ! -f $HOME/.gitconfig ] && ln -nfs $HOME/dotfiles/bin/.gitconfig $HOME/.gitconfig
git config --global core.excludesfile $HOME/dotfiles/bin/.gitignore_global

# Install zsh plugins
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

# Install Vim configurations
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
cp $HOME/dotfiles/bin/.vimrc $HOME/.vimrc
vim +'PlugInstall --sync' +qa

## coc.nvim
cp ./coc-settings.json $HOME/.vim/coc-settings.json
vim +'CocInstall -sync coc-json coc-html coc-sh' +qa

cp $HOME/dotfiles/bin/.tmux.conf $HOME/.tmux.conf
cp $HOME/dotfiles/bin/.zshrc $HOME/.zshrc
source $HOME/.zshrc

# Install language tools

## Rust
curl --proto '=https' --tlsv1.3 https://sh.rustup.rs -sSf | sh
curl -L https://github.com/rust-lang/rust-analyzer/releases/latest/download/rust-analyzer-aarch64-apple-darwin.gz | gunzip -c - > ~/.cargo/bin/rust-analyzer
chmod +x ~/.cago/bin/rust-analyzer

asdf plugin add java
asdf install java latest:adoptopenjdk-11
asdf install java latest:adoptopenjdk-17
asdf plugin add ruby
asdf plugin add nodejs
asdf install nodejs latest:18

# Install iOS Requirements
gem install cocoapods

# Set MacOS Preference
source $HOME/dotfiles/bin/.macos

