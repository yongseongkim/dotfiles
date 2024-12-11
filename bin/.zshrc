export ZSH="$HOME/.oh-my-zsh"

autoload -U compinit && compinit

source $ZSH/oh-my-zsh.sh

export PATH=/opt/homebrew/bin:$PATH

eval "$(zoxide init zsh)"

# Android
# export ANDROID_HOME=$HOME/Library/Android/sdk
# export PATH="$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools"
# alias adbshot="adb shell screencap -p | perl -pe 's/\x0D\x0D\x0A/\x0A/g' > screen.png"

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


alias disktop10="du -shx * | sort -rh | head -10"


. /opt/homebrew/opt/asdf/libexec/asdf.sh

