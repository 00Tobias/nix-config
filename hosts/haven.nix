{ config, pkgs, ... }:
{
  imports =
    [
      # Include hardware configuration
      ./haven-hardware.nix
    ];

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # For zsh home manager config, gets completion for system packages
  environment.pathsToLink = [ "/share/zsh" ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    supportedFilesystems = [ "zfs" ];
  };

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  networking = {
    interfaces.enp2s0.useDHCP = true;
    interfaces.wlp0s20f3.useDHCP = true;
    hostName = "haven";
    hostId = "27cefd8d"; # Required by ZFS
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "se-lat6";
  };

  users = {
    users.toxic = {
      isNormalUser = true;
      shell = pkgs.zsh;
      extraGroups = [ "wheel" "kvm" ];
    };
    # patorjk.com/software/taag/#p=display&f=Standard&t=haven
    # https://ascii.co.uk/art/dragon
    motd = ''
                  _,-'/-'/                         _
      .      __,-; ,'( '/                         | |__   __ ___   _____ _ __
       \.    `-.__`-._`:_,-._       _ , . ``      | '_ \ / _` \ \ / / _ \ '_ \
        `:-._,------' ` _,`--` -: `_ , ` ,' :  @  | | | | (_| |\ V /  __/ | | |
           `---..__,,--'            ` -'. -'      |_| |_|\__,_| \_/ \___|_| |_|
    '';
  };

  services = {
    zfs = {
      autoScrub.enable = true;
      trim.enable = true;
    };
    xserver = {
      enable = true;
      layout = "se";

      displayManager.startx.enable = true;
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # home-manager
    nixpkgs-fmt
    nix-prefetch
  ];
}