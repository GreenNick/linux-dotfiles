# ZSH Configuration

# Enable hooks
autoload -Uz add-zsh-hook

# Initialize and style version control info
autoload -Uz vcs_info
zstyle ':vcs_info:*' formats ' %F{yellow}(%f%b%F{yellow})%f'
add-zsh-hook -Uz precmd vcs_info

# Enable prompt substitutions
setopt prompt_subst

# Set shell prompt
PROMPT='%B%F{blue}[%f%~%F{blue}]%f %F{magenta}%n%f%b %F{green}➤%f '
RPROMPT='%B$vcs_info_msg_0_%b'
PS2=" %F{green}➜%f "

# Prepend conda environment to prompt
show_conda_env() {
    [ ! -z $CONDA_DEFAULT_ENV ] \
        && print -rP "%B%F{blue}{%f$CONDA_DEFAULT_ENV%F{yellow}}%f%b"
}

add-zsh-hook -Uz precmd show_conda_env

# Load aliases
[ -f "$XDG_CONFIG_HOME/shell/aliases" ] \
    && source "$XDG_CONFIG_HOME/shell/aliases"

# Set shell history options
HISTFILE=$XDG_STATE_HOME/zsh/history
HISTSIZE=10000
SAVEHIST=10000

# Set auto-completion options
autoload -Uz compinit
zstyle ':completion:*' menu select cache-path $XDG_CACHE_HOME/zsh/zcompcache
compinit -d $XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION

setopt autocd beep extendedglob nomatch notify

# Enable vi key bindings
bindkey -v

# Auto attach to Zellij session
if [[ -z "$ZELLIJ" ]]; then
    zellij attach -c main
fi

# Clear terminal (and run neofetch) on startup
fetch 2> /dev/null

# Load system-specific configuration
[ -f "$XDG_CONFIG_HOME/shell/system" ] \
    && source $XDG_CONFIG_HOME/shell/system


# [ Plugins ]
# Enable improved vi mode
source $HOME/Git/zsh-vi-mode/zsh-vi-mode.zsh \
    2> /dev/null

# Enable syntax highlighting
source $HOME/Git/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
    2> /dev/null

