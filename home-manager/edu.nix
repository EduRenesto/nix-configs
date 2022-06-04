{ inputs, lib, config, pkgs, ... }: {
  home.packages = with pkgs; [
    xorg.xmodmap
    iosevka-bin
  ];

  programs = {
    home-manager.enable = true;

    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;
      autocd = false;
      history.save = 100000;
      history.size = 100000;
      defaultKeymap = "viins";
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    alacritty = {
      enable = true;
    };

    rofi.enable = true;

    firefox.enable = true;

    starship = {
      enable = true;
      enableZshIntegration = true;
    };

    git = {
      enable = true;
      userEmail = "eduardo.renesto@proton.me";
      userName = "Edu Renesto";
    };

    password-store.enable = true;
  };

  services = {
    xcape = {
      enable = true;
      mapExpression = {
        Super_L="Escape";
      };
    };

    picom = {
      enable = true;
    };
  };

  xsession.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
    config = ../dots/xmonad/xmonad.hs;
  };

  systemd.user.startServices = "sd-switch";
}
