{ config, lib, ... }: {
  options = {
    direnv.enable = lib.mkEnableOption "Enable direnv";
  };

  config = lib.mkIf config.direnv.enable {
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      config = {
        hide_env_diff = true;
      };
    };
  };
}
