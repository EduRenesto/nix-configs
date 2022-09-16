{ pkgs, ... }:
{
  services.nix-daemon.enable = true;
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = "experimental-features = nix-command flakes";
  
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };

  programs.zsh.enable = true;

  environment.variables = {
    "EDITOR" = "nvim";
  };

  homebrew = {
    enable = true;
    casks = [
      "firefox"
      "spotify"
      "alacritty"
      "transmission"
    ];
  };


}
