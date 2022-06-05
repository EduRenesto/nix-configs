{ inputs, lib, config, pkgs, ... }: {
  home.packages = with pkgs; [
    xorg.xmodmap
    light
    iosevka-bin
    manrope
    xclip
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

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
      settings = {
        font = {
          normal.family = "Iosevka";
          size = 12;
        };
      };
    };

    rofi.enable = true;

    firefox.enable = true;

    starship = {
      enable = true;
      enableZshIntegration = true;
    };

    git = {
      enable = true;
      userEmail = "edure95@gmail.com";
      userName = "Edu Renesto";
    };

    password-store.enable = true;

    xmobar.enable = true;
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

    flameshot.enable = true;
  };

  xsession.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
    config = ../dots/xmonad/xmonad.hs;
  };

  xsession.initExtra = ''
    ${pkgs.xmodmap}/bin/xmodmap ${config.xdg.configHome}/xmodmap/xmodmap
  '';

  xdg.configFile."xmodmap/xmodmap".source = ../dots/xmodmap/xmodmap;
  xdg.configFile."xmobar/xmobarrc".source = ../dots/xmobar/xmobarrc;

  systemd.user.startServices = "sd-switch";
}
