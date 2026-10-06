#!/bin/sh

set -e

DOTFILES="$HOME/dotfiles"

# xcode-select --install은 설치 창만 띄우고 바로 끝나므로, 설치가 끝날 때까지 직접 기다린다.
if ! xcode-select -p >/dev/null 2>&1; then
	xcode-select --install
	echo "Complete the Command Line Tools installation in the dialog..."
	until xcode-select -p >/dev/null 2>&1; do sleep 5; done
fi

if ! command -v brew >/dev/null 2>&1; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# 방금 설치한 brew는 아직 이 셸의 PATH에 없다.
if [ -x /opt/homebrew/bin/brew ]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
	eval "$(/usr/local/bin/brew shellenv)"
fi

# xen0l/taps는 쓰지 않으므로, 이전 설치에서 남아 있으면 지운다.
brew untap xen0l/taps >/dev/null 2>&1 || true
# Homebrew 6부터는 trust 하지 않은 서드파티 tap의 formula를 불러오지 않는다.
if brew trust --help >/dev/null 2>&1; then
	brew trust --tap adembc/tap hashicorp/tap tw93/tap
fi

brew update
brew bundle --file="$DOTFILES/Brewfile"
brew cleanup

if [ ! -x "$HOME/.local/bin/claude" ]; then
	curl -fsSL https://claude.ai/install.sh | bash
fi

# RUNZSH=no가 없으면 설치 스크립트가 마지막에 zsh를 띄워서 bootstrap이 거기서 멈춘다.
if [ ! -d "$HOME/.oh-my-zsh" ]; then
	RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
		sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# 복사하지 않고 심볼릭 링크를 건다.
# 그래야 repo에서 고친 내용이 바로 적용되고, 앱이 바꾼 설정도 repo의 diff로 보인다.
ln -nfs "$DOTFILES/bin/.gitconfig"  "$HOME/.gitconfig"
ln -nfs "$DOTFILES/bin/.zshrc"      "$HOME/.zshrc"
ln -nfs "$DOTFILES/bin/.p10k.zsh"   "$HOME/.p10k.zsh"
ln -nfs "$DOTFILES/bin/.tmux.conf"  "$HOME/.tmux.conf"
ln -nfs "$DOTFILES/bin/.vimrc"      "$HOME/.vimrc"
ln -nfs "$DOTFILES/bin/.ideavimrc"  "$HOME/.ideavimrc"

mkdir -p "$HOME/.config/ghostty"
ln -nfs "$DOTFILES/ghostty/config" "$HOME/.config/ghostty/config"

vscode_user="$HOME/Library/Application Support/Code/User"
mkdir -p "$vscode_user"
ln -nfs "$DOTFILES/vscode/settings.json" "$vscode_user/settings.json"
lazygit_dir="$HOME/Library/Application Support/lazygit"
mkdir -p "$lazygit_dir"
ln -nfs "$DOTFILES/lazygit/config.yml" "$lazygit_dir/config.yml"

mkdir -p "$HOME/.claude"
ln -nfs "$DOTFILES/claude/settings.json" "$HOME/.claude/settings.json"
# 링크할 자리에 실제 디렉터리가 있으면 ln -nfs가 그 안에 링크를 만들므로, 먼저 .bak으로 옮긴다.
if [ -e "$HOME/.claude/commands" ] && [ ! -L "$HOME/.claude/commands" ]; then
	mv "$HOME/.claude/commands" "$HOME/.claude/commands.bak"
fi
ln -nfs "$DOTFILES/claude/commands" "$HOME/.claude/commands"

# cship은 settings.json의 statusLine이 실행하는 Claude Code 상태 표시줄이다.
# 설치 스크립트는 settings.json에 statusLine이 이미 있으면 건드리지 않으므로, 링크를 건 뒤에 실행한다.
if [ ! -x "$HOME/.local/bin/cship" ]; then
	curl -fsSL https://cship.dev/install.sh | bash
fi

curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +'PlugInstall --sync' +qa

mkdir -p "$HOME/.config"
if [ -e "$HOME/.config/nvim" ] && [ ! -L "$HOME/.config/nvim" ]; then
	mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak"
fi
ln -nfs "$DOTFILES/nvim" "$HOME/.config/nvim"

mkdir -p "$HOME/Library/Fonts"
for f in "$DOTFILES"/fonts/*; do
	[ -f "$f" ] || continue
	cp "$f" "$HOME/Library/Fonts/"
done

# sh로 도는 이 스크립트는 .zshrc를 읽지 않으므로, asdf shim 경로를 직접 PATH에 넣는다.
export ASDF_DATA_DIR="${ASDF_DATA_DIR:-$HOME/.asdf}"
export PATH="$ASDF_DATA_DIR/shims:$PATH"

asdf plugin add nodejs || true
asdf install nodejs latest:18
asdf set -u nodejs "$(asdf latest nodejs 18)"

# aws-gate는 cffi 1.15.1에 고정된 pip 패키지라 Python 3.10에서만 빌드된다.
# Homebrew formula는 brew가 정한 더 새로운 Python을 쓰므로, asdf Python 3.10에 pip으로 설치한다.
asdf plugin add python || true
asdf install python latest:3.10
asdf set -u python "$(asdf latest python 3.10)"
python -m pip install aws-gate
asdf reshim python

# CocoaPods와 fastlane이 이 Ruby를 쓴다.
asdf plugin add ruby || true
asdf install ruby latest:3.4
asdf set -u ruby "$(asdf latest ruby 3.4)"

# rustup은 스스로 업데이트하므로 Brewfile 대신 공식 설치 스크립트로 설치한다.
# cargo를 PATH에 넣는 줄은 설치 스크립트가 ~/.zshenv와 ~/.profile에 추가한다.
if [ ! -x "$HOME/.cargo/bin/rustup" ]; then
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi

# mason이 node를 쓰므로 asdf 설치 뒤에 실행한다.
# Lazy install이 lazy-lock.json을 다시 쓰므로, 커밋된 파일을 되돌린 뒤 restore로 그 버전에 맞춘다.
nvim_lock="$DOTFILES/nvim/lazy-lock.json"
nvim_lock_backup="$(mktemp)"
cp "$nvim_lock" "$nvim_lock_backup"
nvim --headless "+Lazy! install" +qa
cp "$nvim_lock_backup" "$nvim_lock"
rm -f "$nvim_lock_backup"
nvim --headless "+Lazy! restore" +qa

sh "$DOTFILES/macos.sh"

echo "Done. Open a new terminal (or run: exec zsh) to load your shell."
