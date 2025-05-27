{ config, lib, ... }: {
  options = {
    git.enable = lib.mkEnableOption "Enable git";
  };

  config = lib.mkIf config.git.enable {
    programs.git = {
      enable = true;
      delta = {
        enable = true;
      };
      lfs = {
        enable = true;
      };
      extraConfig = {
        core = {
          editor = "nvim";
        };
        init = {
          defaultBranch = "main";
        };
        pull = {
          ff = "only";
        };
        merge = {
          conflictstyle = "zdiff3";
          tool = "nvimdiff";
        };
      };
    };
  };
}
