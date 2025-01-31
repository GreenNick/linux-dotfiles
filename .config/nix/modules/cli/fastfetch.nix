{ config, lib, ... }: {
  options = {
    fastfetch.enable = lib.mkEnableOption "Enable fastfetch";
  };

  config = lib.mkIf config.fastfetch.enable {
    programs.fastfetch = {
      enable = true;
      settings = {
        logo = {
          type = "small";
        };
      };
    };
  };
}
