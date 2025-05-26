{ config, lib, ... }: {
  options = {
    xdg_config.enable = lib.mkEnableOption "Enable xdg config";
  };

  config = lib.mkIf config.xdg_config.enable {
    home = {
      preferXdgDirectories = true;
    };
    xdg = {
      mimeApps = {
        enable = true;
        defaultApplications = {
          "text/plain" = [ "nvim.desktop" ];
          "text/html" = [ "zen.desktop" ];
          "x-scheme-handler/http" = [ "zen.desktop" ];
          "x-scheme-handler/https" = [ "zen.desktop" ];
          "x-scheme-handler/chrome" = [ "zen.desktop" ];
          "application/x-extension-htm" = [ "zen.desktop" ];
          "application/x-extension-html" = [ "zen.desktop" ];
          "application/x-extension-shtml" = [ "zen.desktop" ];
          "application/xhtml+xml" = [ "zen.desktop" ];
          "application/x-extension-xhtml" = [ "zen.desktop" ];
          "application/x-extension-xht" = [ "zen.desktop" ];
          "image/bmp" = [ "imv.desktop" ];
          "image/gif" = [ "imv.desktop" ];
          "image/jpeg" = [ "imv.desktop" ];
          "image/jpg" = [ "imv.desktop" ];
          "image/pjpeg" = [ "imv.desktop" ];
          "image/png" = [ "imv.desktop" ];
          "image/tiff" = [ "imv.desktop" ];
          "image/x-bmp" = [ "imv.desktop" ];
          "image/x-pcx" = [ "imv.desktop" ];
          "image/x-png" = [ "imv.desktop" ];
          "image/x-portable-anymap" = [ "imv.desktop" ];
          "image/x-portable-bitmap" = [ "imv.desktop" ];
          "image/x-portable-graymap" = [ "imv.desktop" ];
          "image/x-portable-pixmap" = [ "imv.desktop" ];
          "image/x-tga" = [ "imv.desktop" ];
          "image/x-xbitmap" = [ "imv.desktop" ];
          "image/heif" = [ "imv.desktop" ];
          "image/avif" = [ "imv.desktop" ];
          "application/pdf" = [ "org.pwmt.zathura.desktop" ];
          "application/epub+zip" = [ "org.pwmt.zathura.desktop" ];
          "x-scheme-handler/logseq" = [ "Logseq.desktop" ];
        };
      };
    };
  };
}
