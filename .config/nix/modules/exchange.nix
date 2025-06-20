{ config, lib, pkgs, ... }: {
  options = {
    exchange.enable = lib.mkEnableOption "Enable MS Exchange gateway";
  };

  config = lib.mkIf config.exchange.enable {
    nixpkgs.overlays = [
      (final: _prev: {
        davmail622 = import (builtins.fetchTarball {
          url = "https://codeload.github.com/NixOS/nixpkgs/tar.gz/ebe4301cbd8f81c4f8d3244b3632338bbeb6d49c";
          sha256 = "sha256:0yzl8ir5lras2b628dhk60167jm2dvl5ryyb89v3v6n385sm64p5";
        }) { inherit (final) system; };
      })
    ];
    services = {
      davmail = {
        enable = true;
        # Authentication failure in 6.3.0
        package = pkgs.davmail622.davmail;
        settings = {
          "davmail.url" = "https://mail.gtri.gatech.edu/ews/exchange.asmx";
          "davmail.imapPort" = 1143;
          "davmail.smtpPort" = 1025;
          "davmail.ssl.nosecurecaldav" = true;
          "davmail.ssl.nosecureimap" = true;
          "davmail.ssl.nosecureldap" = true;
          "davmail.ssl.nosecurepop" = true;
          "davmail.ssl.nosecuresmtp" = true;
        };
      };
    };
  };
}
