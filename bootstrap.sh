#!/bin/sh

set -e

DOTFILES="$HOME/dotfiles"

# Install Command Line Tools (wait until it actually finishes)
if ! xcode-select -p >/dev/null 2>&1; then
	xcode-select --install
	echo "Complete the Command Line Tools installation in the dialog..."
	until xcode-select -p >/dev/null 2>&1; do sleep 5; done
fi

# Install Homebrew
if ! command -v brew >/dev/null 2>&1; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Load brew into the current shell (so the rest of the script can use it)
if [ -x /opt/homebrew/bin/brew ]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
	eval "$(/usr/local/bin/brew shellenv)"
fi

# Homebrew 6 won't load formulae from third-party taps until they are trusted.
# xen0l/taps is dead weight now that aws-gate comes from pip (below).
brew untap xen0l/taps >/dev/null 2>&1 || true
if brew trust --help >/dev/null 2>&1; then
	brew trust --tap hashicorp/tap tw93/tap
fi

brew update
brew bundle --file="$DOTFILES/Brewfile"
brew cleanup

# Claude Code (native install to ~/.local/bin; self-updates, so not in Brewfile)
if [ ! -x "$HOME/.local/bin/claude" ]; then
	curl -fsSL https://claude.ai/install.sh | bash
fi

# Install oh-my-zsh (unattended: don't switch shell, don't start zsh, keep our .zshrc)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
	RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
		sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Symlink dotfiles (edits in the repo stay live, and live edits get tracked)
ln -nfs "$DOTFILES/bin/.gitconfig"  "$HOME/.gitconfig"
ln -nfs "$DOTFILES/bin/.zshrc"      "$HOME/.zshrc"
ln -nfs "$DOTFILES/bin/.p10k.zsh"   "$HOME/.p10k.zsh"
ln -nfs "$DOTFILES/bin/.tmux.conf"  "$HOME/.tmux.conf"
ln -nfs "$DOTFILES/bin/.vimrc"      "$HOME/.vimrc"
ln -nfs "$DOTFILES/bin/.ideavimrc"  "$HOME/.ideavimrc"

# Ghostty terminal config
mkdir -p "$HOME/.config/ghostty"
ln -nfs "$DOTFILES/ghostty/config" "$HOME/.config/ghostty/config"

# Vim: plugin manager + plugins
curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +'PlugInstall --sync' +qa

# Neovim: LazyVim config symlinked to ~/.config/nvim (existing real dir backed up)
mkdir -p "$HOME/.config"
if [ -e "$HOME/.config/nvim" ] && [ ! -L "$HOME/.config/nvim" ]; then
	mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak"
fi
ln -nfs "$DOTFILES/nvim" "$HOME/.config/nvim"

# Install fonts
mkdir -p "$HOME/Library/Fonts"
for f in "$DOTFILES"/fonts/*; do
	[ -f "$f" ] || continue
	cp "$f" "$HOME/Library/Fonts/"
done

# asdf tools live behind shims, which .zshrc only sets up for interactive shells.
export ASDF_DATA_DIR="${ASDF_DATA_DIR:-$HOME/.asdf}"
export PATH="$ASDF_DATA_DIR/shims:$PATH"

# Node via asdf
asdf plugin add nodejs || true
asdf install nodejs latest:18
asdf set -u nodejs "$(asdf latest nodejs 18)"

# Python via asdf. Also installs aws-gate: an AWS SSM CLI that's a pip package
# pinned to old deps (cffi 1.15.1), so it only builds on Python 3.10 — which is
# why it can't be a Homebrew formula (brew forces its own newer Python).
asdf plugin add python || true
asdf install python latest:3.10
asdf set -u python "$(asdf latest python 3.10)"
python -m pip install aws-gate
asdf reshim python

# Neovim plugins (mason needs node, so this runs after asdf). The install pass
# overwrites lazy-lock.json, so put the pinned one back and check it out.
nvim_lock="$DOTFILES/nvim/lazy-lock.json"
nvim_lock_backup="$(mktemp)"
cp "$nvim_lock" "$nvim_lock_backup"
nvim --headless "+Lazy! install" +qa
cp "$nvim_lock_backup" "$nvim_lock"
rm -f "$nvim_lock_backup"
nvim --headless "+Lazy! restore" +qa

# macOS system preferences (keyboard, trackpad, dock, typing)
sh "$DOTFILES/macos.sh"

echo "Done. Open a new terminal (or run: exec zsh) to load your shell."
