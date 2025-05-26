{ pkgs, lib, ... }: {
  imports = [
    ./direnv.nix
    ./eza.nix
    ./fastfetch.nix
    ./ls-colors.nix
    ./zsh.nix
  ];
}
