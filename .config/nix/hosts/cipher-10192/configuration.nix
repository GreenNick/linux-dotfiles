{ config, user, homeDir, pkgs, ... }: {
  home.username = "nbowers7";
  home.homeDirectory = "/home/nbowers7";
  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    foot
    neovim
    nerd-fonts.caskaydia-cove
    nerd-fonts.noto
    nodePackages.cspell
    ripgrep
    zellij
  ] ++ builtins.attrValues {
    vpn-up = (pkgs.callPackage ./vpn-up.nix {});
  };

  # ags
  app-launcher.enable = true;
  # cli
  bat.enable = true;
  bottom.enable = true;
  direnv.enable = true;
  eza.enable = true;
  fastfetch.enable = true;
  git.enable = true;
  lsColors.enable = true;
  zsh.enable = true;
  # misc
  exchange.enable = true;
  gtkConfig.enable = true;
  xdgConfig.enable = true;

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
