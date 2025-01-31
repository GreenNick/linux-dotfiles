{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ags = {
      url = "github:aylur/ags";
    };
    zsh-fast-syntax-highlighting = {
      url = "github:zdharma-continuum/fast-syntax-highlighting";
      flake = false;
    };
    zsh-vi-mode = {
      url = "github:jeffreytse/zsh-vi-mode";
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, nix-darwin, ... }:
    let
      darwinSystem = "aarch64-darwin";
      linuxSystem = "x86_64-linux";
    in {
      darwinConfigurations = {
        "Cipher-10363" = nix-darwin.lib.darwinSystem {
          system = "${darwinSystem}";
          modules = [
            ({
              environment.systemPackages = [];
              nix.settings.experimental-features = "nix-command flakes";
              system.configurationRevision = self.rev or self.dirtyRev or null;
              system.stateVersion = 5;
              nixpkgs.hostPlatform = "${darwinSystem}";
            })
            (home-manager.darwinModules.home-manager)
            ({
              users.users.nbowers7.home = "/Users/nbowers7";
              home-manager.extraSpecialArgs = inputs // {
                user = "nbowers7";
                homeDir = "/Users/nbowers7";
                system = "${darwinSystem}";
                pkgs = nixpkgs.legacyPackages.${darwinSystem};
              };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.nbowers7 = {
                imports = [
                  ./modules/cli/direnv.nix
                  ./modules/cli/eza.nix
                  ./modules/cli/zsh.nix
                  ./hosts/cipher-10363/configuration.nix
                ];
              };
            })
          ];
        };
      };
      homeConfigurations = {
        "nick" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${linuxSystem};
          extraSpecialArgs = inputs // {
            user = "nick";
            homeDir = "/home/nick";
            system = "${linuxSystem}";
          };
          modules = [
            ./modules/ags/app-launcher
            ./modules/cli/direnv.nix
            ./modules/cli/eza.nix
            ./modules/cli/zsh.nix
            ./modules/xdg.nix
            ./hosts/nick-laptop/configuration.nix
          ];
        };
      };
    };
}
