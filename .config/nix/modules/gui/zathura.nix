{ config, lib, ... }: {
  options = {
    zathura.enable = lib.mkEnableOption "Enable zathura";
  };

  config = lib.mkIf config.zathura.enable {
    programs.zathura = {
      enable = true;
    };
  };
}
