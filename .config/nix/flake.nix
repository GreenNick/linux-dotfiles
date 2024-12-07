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
            ({ pkgs, ... }: {
              environment.systemPackages = [];
              nix.settings.experimental-features = "nix-command flakes";
              system.configurationRevision = self.rev or self.dirtyRev or null;
              system.stateVersion = 5;
              nixpkgs.hostPlatform = "${darwinSystem}";
            })
            home-manager.darwinModules.home-manager
            {
              users.users.nbowers7.home = "/Users/nbowers7";
              home-manager.extraSpecialArgs = inputs // {
                user = "nbowers7";
                homeDir = "/Users/nbowers7";
                system = "${darwinSystem}";
                pkgs = nixpkgs.legacyPackages.${darwinSystem};
              };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.nbowers7 = import ./home.nix;
            }
          ];
        };
      };
      homeConfigurations."nick" = home-manager.lib.homeManagerConfiguration {
        # inherit pkgs;
        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          ({
            home-manager.extraSpecialArgs = inputs // {
              user = "nick";
              homeDir = "/home/nick";
              system = "${linuxSystem}";
              pkgs = nixpkgs.legacyPackages.${linuxSystem};
            };
          })
          ./home.nix
        ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
    };
}
