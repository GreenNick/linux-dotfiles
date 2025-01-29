{ config, user, homeDir, pkgs, ... }:

{
  home.username = "nick";
  home.homeDirectory = "/home/nick";
  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    bat
    bottom
    ghostty
    nerd-fonts.caskaydia-cove
    nerd-fonts.noto
    ripgrep
    zellij
    zsh

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # ags
  app-launcher.enable = true;
  # cli
  direnv.enable = true;
  eza.enable = true;
  zsh.enable = true;

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/nick/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    BROWSER = "zen-browser";
    EDITOR = "nvim";
    VISUAL = "nvim";
    PAGER = "less";
    AUR_PAGER = "nnn";
  };

  programs.home-manager.enable = true;
}
