{ inputs, lib, config, pkgs, overlays, ...}: {
  nixpkgs.overlays = overlays;

  environment.systemPackages = with pkgs; [
    neovim-nightly
    wget
    bottom
    bat
    ripgrep
  ];
}
