{ lib, pkgs, config, ... }: {
  home.username = "edu";
  home.homeDirectory = "/Users/edu";
  home.stateVersion = "24.05";

  programs = {
    home-manager.enable = true;

    zsh = {
      enable = true;
      syntaxHighlighting.enable = true;
      autosuggestion.enable = true;
      autocd = false;
      history.save = 100000;
      history.size = 100000;
      defaultKeymap = "viins";

      oh-my-zsh = {
        enable = true;
        theme = "ys";
      };

      plugins = [
        {
          name = "zsh-vi-mode";
          src = pkgs.zsh-vi-mode;
          file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
        }
      ];
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
          size = 14;
        };

        colors = let my-colors = import ../colors/alacritty.nix {}; in my-colors.nord;

        window = {
          padding = {
            x = 7;
            y = 7;
          };

          opacity = 1.0;
        };
      };
    };


    git = {
      enable = true;
      userEmail = "edure95@gmail.com";
      userName = "Edu Renesto";
    };

    password-store.enable = true;

    direnv = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
