{ config, lib, ... }: {
  options = {
    bat.enable = lib.mkEnableOption "Enable bat";
  };

  config = lib.mkIf config.bat.enable {
    home = {
      sessionVariables = {
        BAT_THEME = "ansi";
        MANPAGER = "sh -c 'col -bx | bat -l man -p'";
        MANROFFOPT = "-c";
      };
      shellAliases = {
        cat = "bat --paging=never";
        less = "bat --paging=always";
      };
    };
    programs.bat = {
      enable = true;
    };
  };
}
