{ inputs, lib, config, pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
  ];

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    registry = lib.mapAttrs' (n: v: lib.nameValuePair n { flake = v; }) inputs;
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "spotify"
    "unityhub"
  ];

  boot.loader = {
    systemd-boot = {
      enable = true;
      extraEntries."opencore.conf" = ''
        title OpenCore
        efi /EFI/BOOT/OpenCore.efi
      '';
    };
    efi.canTouchEfiVariables = true;
    timeout = 1;
  };

  networking = {
    hostName = "alderaan";

    #wireless.enable = true;
    firewall.enable = true;

    networkmanager.enable = true;

    wg-quick.interfaces.wg0 = {
      address = [ "10.0.0.4/24" ];
      privateKeyFile = "/root/wg-keys/alderaan-private-key";

      peers = [
        {
          publicKey = "gNV5dHFj2p1/eCsTFRSYg52XSHF/+UnJX8vgdm6jhgA=";
          allowedIPs = [ "10.0.0.1/32" ];
          endpoint = "rouxinolio.crabdance.com:51820";
        }
      ];
    };
  };

  time.timeZone = "America/Sao_Paulo";

  # TODO add DHCP to things

  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    font = "Lat2-Terminus16";
    keyMap = "dvorak";
  };

  services.xserver = {
    enable = true;
    windowManager.xmonad.enable = true;
    windowManager.openbox.enable = true;
    layout = "dvorak";

    libinput = {
      enable = true;
      touchpad.tapping = true;
    };
  };

  users.users = {
    edu = {
      isNormalUser = true;
      extraGroups = [ "wheel" "docker" ];
      shell = pkgs.zsh;
    };
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.zsh.enable = true;

  services = {
    avahi = {
      enable = true;
      nssmdns = true;
      openFirewall = true;
      publish = {
        enable = true;
        addresses = true;
        workstation = true;
      };
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    openssh = {
      enable = false;
      passwordAuthentication = true;
    };
  };

  security.rtkit.enable = true;
  hardware.pulseaudio.enable = false;

  system.stateVersion = "22.11";
}
