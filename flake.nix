{
  description = "Renesto's Nix configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    emacs-overlay.url = "github:nix-community/emacs-overlay";
    emacs-overlay.inputs.nixpkgs.follows = "nixpkgs";

    nix-doom-emacs = {
      url = "github:nix-community/nix-doom-emacs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.emacs-overlay.follows = "emacs-overlay";
    };

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = { nixpkgs, home-manager, nix-doom-emacs, ... }@inputs:
    let
      inherit (nixpkgs.lib) nixosSystem;
      inherit (home-manager.lib) homeManagerConfiguration;

      overlays = [
      	inputs.neovim-nightly-overlay.overlay
        inputs.emacs-overlay.overlay
      ];
    in rec {
      nixosConfigurations = {
        alderaan = nixosSystem {
          system = "x86_64-linux";
          modules = [ ./nixos/alderaan/configuration.nix ./nixos/common.nix ];
          specialArgs = { inherit inputs; overlays = overlays; };
        };
      };

      homeConfigurations = {
        "edu@alderaan" = homeManagerConfiguration rec {
          username = "edu";
          homeDirectory = "/home/edu";
          system = "x86_64-linux";
          configuration = ./home-manager/edu.nix;
          extraSpecialArgs = { inherit inputs; overlays = overlays; };
        };
      };
    };
}
