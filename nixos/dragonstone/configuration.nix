{ pkgs, ... }:
{
  services.nix-daemon.enable = true;
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = "experimental-features = nix-command flakes";

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    gnupg
  ];
  
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };

  system.defaults = {
    NSGlobalDomain.ApplePressAndHoldEnabled = false;
  };

  homebrew = {
    enable = true;
    casks = [
      "firefox"
      "spotify"
      "alacritty"
      "reaper"
      "darktable"
    ];
  };
}
