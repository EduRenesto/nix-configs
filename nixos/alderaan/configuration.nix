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

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    timeout = 1;
  };

  networking = {
    hostName = "alderaan";

    #wireless.enable = true;
    firewall.enable = true;

    networkmanager.enable = true;
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
    desktopManager.gnome.enable = true;
    windowManager.xmonad.enable = true;
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
  };

  system.stateVersion = "22.11";
}
