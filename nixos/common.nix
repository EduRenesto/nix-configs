{ inputs, lib, config, pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    neovim
    wget
    bottom
    bat
    ripgrep
  ];
}
