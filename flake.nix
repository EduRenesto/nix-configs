{
  description = "Renesto's Nix configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
    let
      inherit (nixpkgs.lib) nixosSystem;
      inherit (home-manager.lib) homeManagerConfiguration;
    in rec {
      nixosConfigurations = {
        alderaan = nixosSystem {
          system = "x86_64-linux";
          modules = [ ./nixos/alderaan/configuration.nix ./nixos/common.nix ];
          specialArgs = { inherit inputs; };
        };
      };

      homeConfigurations = {
        "edu@alderaan" = homeManagerConfiguration rec {
          username = "edu";
          homeDirectory = "/home/edu";
          system = "x86_64-linux";
          configuration = ./home-manager/edu.nix;
          extraSpecialArgs = { inherit inputs; };
        };
      };
    };
}
