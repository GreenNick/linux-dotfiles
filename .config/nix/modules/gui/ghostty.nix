{ config, lib, pkgs, ... }: {
  options = {
    ghostty.enable = lib.mkEnableOption "Enable ghostty";
  };

  config = lib.mkIf config.ghostty.enable {
    home.packages = with pkgs; [
      ghostty
    ];
  };
}
