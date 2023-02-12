{ inputs, lib, config, pkgs, overlays, ... }: {
  imports = [ inputs.nix-doom-emacs.hmModule ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "spotify"
    "spotify-unwrapped"
  ];

  nixpkgs.overlays = overlays;

  home.packages = let
    iosevka-curly-slab-bin = pkgs.iosevka-bin.override { variant = "curly-slab"; };
  in with pkgs; [
    xorg.xmodmap
    light
    iosevka-curly-slab-bin
    manrope
    inter
    xclip
    xcape
    pavucontrol
    pamixer
    wineWowPackages.staging
    winetricks
    yabridge
    yabridgectl
    ardour
    calf
    spotify
    #stack
    #haskell-language-server
    feh
    python310
    python310Packages.ipython
    unzip

    gnumake
    texlive.combined.scheme-full
    pandoc
    zathura
    inotify-tools

    docker-compose

    gnupg

    rustup
    rust-analyzer
    #gcc

    hledger

    whitesur-gtk-theme
    nordzy-icon-theme
    gnomeExtensions.user-themes
    gnomeExtensions.blur-my-shell

    helm
    dexed
    freetype
    alsa-lib
    libstdcxx5
  ];

  home.sessionVariables = {
    EDITOR = "nvim";

    DSSI_PATH   = "$HOME/.dssi:$HOME/.nix-profile/lib/dssi:/run/current-system/sw/lib/dssi";
    LADSPA_PATH = "$HOME/.ladspa:$HOME/.nix-profile/lib/ladspa:/run/current-system/sw/lib/ladspa";
    LV2_PATH    = "$HOME/.lv2:$HOME/.nix-profile/lib/lv2:/run/current-system/sw/lib/lv2";
    LXVST_PATH  = "$HOME/.lxvst:$HOME/.nix-profile/lib/lxvst:/run/current-system/sw/lib/lxvst";
    VST_PATH    = "$HOME/.vst:$HOME/.nix-profile/lib/vst:/run/current-system/sw/lib/vst";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  home.username = "edu";
  home.homeDirectory = "/home/edu";

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

    tmux = {
      enable = true;
      keyMode = "vi";
    };

    alacritty = {
      enable = true;
      settings = {
        font = {
          normal.family = "Iosevka Term Curly Slab";
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

        shell.program = "${pkgs.tmux}/bin/tmux";
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

    doom-emacs = {
      enable = true;
      doomPrivateDir = ../dots/doom;
      emacsPackagesOverlay = self: super: {
        gitignore-mode = pkgs.emacsPackages.git-modes;
        gitconfig-mode = pkgs.emacsPackages.git-modes;
      };
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
    };
  };

  services = {
    picom = {
      enable = false;
      backend = "glx";
      fade = true;
      fadeDelta = 5;
      shadow = true;
      vSync = true;

      settings = {
        blur = {
          enable = true;
          method = "dual_kawase";
        };
      };
    };

    flameshot.enable = true;

    emacs = {
      enable = true;
      #package = config.programs.doom-emacs.package;
    };

    lorri.enable = true;
  };

  #xsession.windowManager.xmonad = {
  #  enable = true;
  #  enableContribAndExtras = true;
  #  config = ../dots/xmonad/xmonad.hs;
  #};

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

  home.stateVersion = "22.05";
}
