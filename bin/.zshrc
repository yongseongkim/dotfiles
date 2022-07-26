export ZSH="/Users/yongseongkim/.oh-my-zsh"

plugins=(git)

source $ZSH/oh-my-zsh.sh

export PATH=/opt/homebrew/bin:$PATH

export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
export PYENV_VERSION=3.9.11

eval "$(rbenv init -)"
export RBENV_VERSION=2.7.2

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
