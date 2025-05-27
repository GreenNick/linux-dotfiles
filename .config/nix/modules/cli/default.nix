{ pkgs, lib, ... }: {
  imports = [
    ./bat.nix
    ./bottom.nix
    ./direnv.nix
    ./eza.nix
    ./fastfetch.nix
    ./ls-colors.nix
    ./zsh.nix
  ];
}
