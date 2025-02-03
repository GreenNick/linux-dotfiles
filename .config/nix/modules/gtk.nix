
{ config, lib, pkgs, ... }: {
  options = {
    gtk_config.enable = lib.mkEnableOption "Enable gtk config";
  };

  config = lib.mkIf config.gtk_config.enable {
    gtk = {
      enable = true;
      font = null;
      iconTheme = {
        name = "Tela";
        package = pkgs.tela-icon-theme;
      };
      theme = {
        name = "catppuccin-macchiato-blue-standard+default";
        # package = pkgs.colloid-gtk-theme;
        # package = pkgs.catppuccin-gtk.override {
        #   variant = "macchiato";
        #   accents = [ "blue" ];
        #   size = "standard";
        # };
      };
    };
  };
}
