{ config, lib, ... }: {
  options = {
    bottom.enable = lib.mkEnableOption "Enable bottom";
  };

  config = lib.mkIf config.bottom.enable {
    home.shellAliases = {
      top = "btm --basic";
    };
    programs.bottom = {
      enable = true;
    };
  };
}
