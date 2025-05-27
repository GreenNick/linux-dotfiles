{ config, lib, ... }: {
  options = {
    bat.enable = lib.mkEnableOption "Enable bat";
  };

  config = lib.mkIf config.bat.enable {
    home = {
      sessionVariables = {
        BAT_THEME = "ansi";
        MANPAGER = "sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'";
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
