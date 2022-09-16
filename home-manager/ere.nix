{ inputs, lib, config, pkgs, overlays, ... }: {
  imports = [ inputs.nix-doom-emacs.hmModule ];

  #nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
  #  "spotify"
  #  "spotify-unwrapped"
  #];

  nixpkgs.overlays = overlays;

  home.packages = with pkgs; [
    iosevka-bin
    manrope

    gnumake
    texlive.combined.scheme-full
    pandoc
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
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
      settings = {
        font = {
          normal.family = "Iosevka";
          size = 14;
        };

        colors = with import ../colors/alacritty.nix {}; {
          inherit nord;
        };

        window = {
          padding = {
            x = 5;
            y = 5;
          };

          opacity = 1.0;
        };
      };
    };

    #firefox.enable = true;

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

    doom-emacs = {
      enable = true;
      doomPrivateDir = ../dots/doom;
      emacsPackagesOverlay = self: super: {
        gitignore-mode = pkgs.emacsPackages.git-modes;
        gitconfig-mode = pkgs.emacsPackages.git-modes;
      };
    };
  };

  services = {
    #emacs = {
    #  enable = true;
    #  #package = config.programs.doom-emacs.package;
    #};
  };
}
