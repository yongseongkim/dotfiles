export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="agnoster"

plugins=(git zsh-autosuggestions)
autoload -U compinit && compinit

source $ZSH/oh-my-zsh.sh

export PATH=/opt/homebrew/bin:$PATH

# Language tools
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
export PYENV_VERSION=3.9.11

eval "$(rbenv init -)"
export RBENV_VERSION=2.6.10

alias adbshot="adb shell screencap -p | perl -pe 's/\x0D\x0D\x0A/\x0A/g' > screen.png"
export ADB_HOME=/Users/yongseongkim/Library/Android/sdk/platform-tools
export PATH=${ADB_HOME}:$PATH

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

lg()
{
    export LAZYGIT_NEW_DIR_FILE=~/.lazygit/newdir

    lazygit "$@"

    if [ -f $LAZYGIT_NEW_DIR_FILE ]; then
            cd "$(cat $LAZYGIT_NEW_DIR_FILE)"
            rm -f $LAZYGIT_NEW_DIR_FILE > /dev/null
    fi
}

if [ "$TMUX" = "" ]; then tmux; fi

# VCNC
export VCNC_TADA_SERVER_DIR_FOR_PROTOCOL=/Users/yongseongkim/Documents/workspace.nosync/tada-server
export VCNC_DESIGN_TADA_PATH=/Users/yongseongkim/Google\ Drive/Shared\ drives/VCNC/Product\ Design팀/Development\ UI\ Assets/

