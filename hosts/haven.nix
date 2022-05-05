{ config, pkgs, ... }:
{
  imports =
    [
      # Include hardware configuration
      ./haven-hardware.nix
    ];

  # For zsh home manager config, gets completion for system packages
  environment.pathsToLink = [ "/share/zsh" ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  networking = {
    interfaces.enp2s0.useDHCP = true;
    interfaces.wlan0.useDHCP = true;

    wireless.iwd.enable = true;
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };

    hostName = "haven";
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
      extraGroups = [ "wheel" "kvm" "uucp" "dialout" "plugdev" ];
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

  # services = { };

  # environment.systemPackages = with pkgs; [ ];
}
