{ config, lib, zsh-fast-syntax-highlighting, zsh-vi-mode, ... }: {
  options = {
    zsh.enable = lib.mkEnableOption "Enable zsh";
  };

  config = lib.mkIf config.zsh.enable {
    programs.zsh = {
      enable = true;
      dotDir = ".config/zsh";
      initExtra = ''
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

        # Load system-specific configuration
        [ -f "$XDG_CONFIG_HOME/shell/system" ] \
            && source $XDG_CONFIG_HOME/shell/system

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
        if [ -z "$ZELLIJ" -a "$TERM_PROGRAM" = "vscode" ]; then
            zellij attach -c vscode 2> /dev/null
        elif [ -z "$ZELLIJ" ]; then
            zellij attach -c main 2> /dev/null
        fi

        # Clear terminal (and run neofetch) on startup
        fetch 2> /dev/null
      '';
      envExtra = ''
        # Application theme
        export GTK_THEME="Catppuccin-Macchiato-Standard-Lavender-Dark"
        export QT_STYLE_OVERRIDE="kvantum"

        # XDG user directories
        export XDG_CONFIG_HOME="$HOME/.config"
        export XDG_CACHE_HOME="$HOME/.cache"
        export XDG_DATA_HOME="$HOME/.local/share"
        export XDG_STATE_HOME="$HOME/.local/state"

        # Add ~/.local/bin to path
        case "$PATH" in
            *"$HOME/.local/bin"*) ;;
            *) export PATH="$PATH:$HOME/.local/bin" ;;
        esac

        # Home directory clean-up
        export ZDOTDIR=$XDG_CONFIG_HOME/zsh

        # Sort hidden files on top
        export LC_COLLATE="C"

        # Pfetch configuration
        export PF_INFO="ascii title os kernel memory uptime shell editor palette"

        # Run firefox in wayland mode
        if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
            export MOZ_ENABLE_WAYLAND=1
        fi

        # Krita theme
        export KRITA_NO_STYLE_OVERRIDE=1
      '';
      plugins = [
        {
          name = "fast-syntax-highlighting";
          src = zsh-fast-syntax-highlighting;
        }
        {
          name = "zsh-vi-mode";
          src = zsh-vi-mode;
        }
      ];
    };
  };
}
