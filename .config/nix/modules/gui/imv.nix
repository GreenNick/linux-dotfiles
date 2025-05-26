{ config, lib, ... }: {
  options = {
    imv.enable = lib.mkEnableOption "Enable imv";
  };

  config = lib.mkIf config.imv.enable {
    programs.imv = {
      enable = true;
      settings = {};
    };
  };
}
