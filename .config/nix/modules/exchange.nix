{ config, lib, ... }: {
  options = {
    exchange.enable = lib.mkEnableOption "Enable MS Exchange gateway";
  };

  config = lib.mkIf config.exchange.enable {
    services = {
      davmail = {
        enable = true;
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
