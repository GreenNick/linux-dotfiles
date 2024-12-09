{ ags, config, lib, pkgs, ... }: {
  options = {
    app-launcher.enable = lib.mkEnableOption "Enable app-launcher";
  };

  config = lib.mkIf config.app-launcher.enable {
    home.packages = with pkgs; [
      (ags.lib.bundle {
        inherit pkgs;
        src = ./.;
        name = "app-launcher";
        entry = "app.ts";
      })
    ];
  };
}
