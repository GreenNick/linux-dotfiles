{ pkgs, lib, ... }: {
  imports = [
    ./ags
    ./cli
    ./gui
    ./exchange.nix
    ./gtk.nix
    ./xdg.nix
  ];
}
