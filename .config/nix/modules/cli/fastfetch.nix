{ config, lib, ... }: {
  options = {
    fastfetch.enable = lib.mkEnableOption "Enable fastfetch";
  };

  config = lib.mkIf config.fastfetch.enable {
    home.shellAliases = {
      fetch = "clear && fastfetch";
    };
    programs.fastfetch = {
      enable = true;
      settings = {
        logo = {
          type = "small";
        };
        display.separator = " ";
        modules = [
          {
            key = "╭─";
            type = "custom";
            format = "system details";
          }
          {
            key = "│ ⬤  dist:";
            type = "os";
          }
          {
            key = "│ ⬤  env:";
            type = "de";
          }
          {
            key = "│ ⬤  shell:";
            type = "shell";
          }
          {
            key = "│ ⬤  term:";
            type = "terminal";
          }
          {
            key = "│ ⬤  edit:";
            type = "editor";
          }
          {
            key = "│ ⬤  theme:";
            type = "wmtheme";
          }
          {
            key = "│ ⬤  icon:";
            type = "icons";
          }
          {
            key = "│ ⬤  pkgs:";
            type = "packages";
          }
          {
            key = "╰─";
            type = "custom";
            format = "";
          }
        ];
      };
    };
  };
}
