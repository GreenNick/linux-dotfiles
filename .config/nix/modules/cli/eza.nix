{ config, lib, ... }: {
  options = {
    eza.enable = lib.mkEnableOption "Enable eza";
  };

  config = lib.mkIf config.eza.enable {
    programs.eza = {
      enable = true;
      enableZshIntegration = true;
      colors = "auto";
      icons = "auto";
      extraOptions = [ "--group-directories-first" ];
    };
  };
}
