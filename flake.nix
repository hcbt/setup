{
  description = "nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    secrets = {
      url = "git+ssh://git@github.com/hcbt/secrets.git";
      flake = false;
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      nix-darwin,
      nix-homebrew,
      homebrew-core,
      homebrew-cask,
      homebrew-bundle,
      sops-nix,
      secrets,
      ...
    }:
    let
      user = "hcbt";
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#kvarcas
      darwinConfigurations = {
        "kvarcas" = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = {
            inherit self inputs user;
            hostname = "kvarcas";
          };
          modules = [
            ./machines/kvarcas/configuration.nix
            ./machines/kvarcas/brew.nix
            sops-nix.darwinModules.sops
            home-manager.darwinModules.home-manager
            {
              home-manager.extraSpecialArgs = { inherit self inputs user; };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users."${user}" = ./machines/kvarcas/home.nix;
            }
          ];
        };
        "kibiras" = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = {
            inherit self inputs user;
            hostname = "kibiras";
          };
          modules = [
            ./machines/kibiras/configuration.nix
            ./machines/kibiras/brew.nix
            sops-nix.darwinModules.sops
            home-manager.darwinModules.home-manager
            {
              home-manager.extraSpecialArgs = { inherit self inputs user; };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users."${user}" = ./machines/kibiras/home.nix;
            }
          ];
        };
      };
      nixosConfigurations = {
        "stakles" = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [ ./configuration.nix ];
        };
      };
    };
}
