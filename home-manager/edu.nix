{ inputs, lib, config, pkgs, overlays, ... }: {
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "spotify"
    "spotify-unwrapped"
    "unityhub"
  ];

  nixpkgs.overlays = overlays;

  home.packages = with pkgs; [
    xorg.xmodmap
    light
    iosevka-bin
    manrope
    xclip
    xcape
    pavucontrol
    pamixer
    wineWowPackages.staging
    yabridge
    yabridgectl
    ardour
    spotify
    stack
    haskell-language-server
    unityhub
    feh
    omnisharp-roslyn
    dotnet-sdk
    mono
    python310
    python310Packages.ipython
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

        colors = with import ../colors/alacritty.nix {}; {
          inherit nord;
        };

        window = {
          padding = {
            x = 5;
            y = 5;
          };

          opacity = 0.8;
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
    picom = {
      enable = true;
      experimentalBackends = true;
      blur = true;
      fade = true;
      fadeDelta = 5;
      shadow = true;
      vSync = true;
      extraOptions = ''
        blur-method = "dual_kawase";
      '';
    };

    flameshot.enable = true;
  };

  xsession.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
    config = ../dots/xmonad/xmonad.hs;
  };

  # TODO(edu): I need to find a cool way to store my wallpapers.
  # Maybe I should create a Nix package containing them, and then
  # use it to reference the wallpaper path, instead of relying ad hoc
  # on the path...
  xsession.initExtra = ''
    ${pkgs.xmodmap}/bin/xmodmap ${config.xdg.configHome}/xmodmap/xmodmap
    ${pkgs.xcape}/bin/xcape -e "Super_L=Escape"
    ${pkgs.feh}/bin/feh --bg-scale $HOME/wallpapers/pink-circuit.jpg
  '';

  xdg.configFile."xmodmap/xmodmap".source = ../dots/xmodmap/xmodmap;
  xdg.configFile."xmobar/xmobarrc".source = ../dots/xmobar/xmobarrc;
  xdg.configFile."nvim" = {
    recursive = true;
    source = ../dots/neovim;
    onChange = ''
      tmp=$(mktemp)
      mv ${config.xdg.configHome}/nvim/lua/nixsupport.lua $tmp
      rm -rf ${config.xdg.configHome}/nvim/lua/*
      mv $tmp ${config.xdg.configHome}/nvim/lua/nixsupport.lua
    '';
  };
  xdg.configFile."nvim/lua/nixsupport.lua".text = ''
    return {
      omnisharp_path="${pkgs.omnisharp-roslyn}/bin/omnisharp",
    }
  '';
  xdg.configFile."openbox" = {
    recursive = true;
    source = ../dots/openbox;
  };

  systemd.user.startServices = "sd-switch";

  fonts.fontconfig.enable = true;
}
