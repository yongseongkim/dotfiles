export ZSH="$HOME/.oh-my-zsh"

export LANG=ko_KR.UTF-8
export LC_ALL=ko_KR.UTF-8

# asdf 0.16+ (Go rewrite): no asdf.sh anymore — add shims + completions to PATH/fpath
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
fpath=(${ASDF_DATA_DIR:-$HOME/.asdf}/completions $fpath)

autoload -Uz compinit && compinit

source $ZSH/oh-my-zsh.sh

export PATH=/opt/homebrew/bin:$PATH
export PATH="$HOME/.local/bin:$PATH"

eval "$(zoxide init zsh)"
command -v direnv >/dev/null && eval "$(direnv hook zsh)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Android SDK (only if installed)
if [ -d "$HOME/Library/Android/sdk" ]; then
    export ANDROID_HOME="$HOME/Library/Android/sdk"
    export PATH="$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools"
    alias adbshot="adb shell screencap -p | perl -pe 's/\x0D\x0D\x0A/\x0A/g' > screen.png"
fi

# Java: Corretto 17 (only if installed)
if [ -d "$HOME/Library/Java/JavaVirtualMachines/corretto-17.0.10/Contents/Home" ]; then
    export JAVA_HOME="$HOME/Library/Java/JavaVirtualMachines/corretto-17.0.10/Contents/Home"
    export PATH="$JAVA_HOME/bin:$PATH"
fi

# VCNC tada (only on the work machine)
if [ -d "$HOME/Documents/workspace.nosync/tada-server" ]; then
    export VCNC_TADA_SERVER_DIR_FOR_PROTOCOL="$HOME/Documents/workspace.nosync/tada-server"
    alias tdsbp="cd $VCNC_TADA_SERVER_DIR_FOR_PROTOCOL; ./gradlew :protocol:build"
    export VCNC_DESIGN_TADA_PATH="$HOME/Google Drive/Shared drives/VCNC/Product Design팀/Development UI Assets/"
fi

lg()
{
    export LAZYGIT_NEW_DIR_FILE=~/.lazygit/newdir

    lazygit "$@"

    if [ -f $LAZYGIT_NEW_DIR_FILE ]; then
            cd "$(cat $LAZYGIT_NEW_DIR_FILE)"
            rm -f $LAZYGIT_NEW_DIR_FILE > /dev/null
    fi
}

alias disktop10="du -shx * | sort -rh | head -10"
alias cl="claude"
alias clz="claude --settings ~/.claude/settings-glm.json"
alias csz="cs -p 'claude --settings ~/.claude/settings-glm.json'"

source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# fieldtheory-cli: point at the second-brain repo (only if it's checked out)
if [ -d "$HOME/Documents/workspace.nosync/second-brain" ]; then
    export FT_DATA_DIR="$HOME/Documents/workspace.nosync/second-brain/bookmarks"
    export FT_LIBRARY_DIR="$HOME/Documents/workspace.nosync/second-brain/library"
    export FT_COMMANDS_DIR="$HOME/Documents/workspace.nosync/second-brain/commands"
fi

if [ "$TMUX" = "" ]; then tmux; fi
