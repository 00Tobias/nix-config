{ config, pkgs, ... }:

{
  imports =
    [
      # Include hardware configuration
      ./den-hardware.nix
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
    kernelParams = [ "nvidia-drm.modeset=1" ];
  };

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  networking = {
    interfaces.enp7s0.useDHCP = true;
    interfaces.wlp6s0.useDHCP = true;
    hostName = "den";
    hostId = "7cd2d852"; # Required by ZFS
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "se-lat6";
  };

  users.users.toxic = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "kvm" ];
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

      videoDrivers = [ "nvidia" ]; # Use the unfree nvidia drivers

      config = ''
        Section "ServerLayout"

          # Reference the Screen sections for each driver.  This will
          # cause the X server to try each in turn.
            Identifier     "Layout[all]"
            Screen      0  "Screen0" 0 0
            Option         "Xinerama" "0"
        EndSection

        Section "ServerFlags"
            Option         "AllowMouseOpenFail" "on"
            Option         "DontZap" "on"
        EndSection

        Section "Monitor"
            Identifier     "Monitor[0]"
        EndSection

        Section "Monitor"
            Identifier     "Monitor0"
            VendorName     "Unknown"
            ModelName      "Acer ED273 A"
            HorizSync       180.0 - 180.0
            VertRefresh     48.0 - 144.0
        EndSection

        Section "Device"
            Identifier     "Device-nvidia[0]"
            Driver         "nvidia"
        EndSection

        Section "Device"
            Identifier     "Device0"
            Driver         "nvidia"
            VendorName     "NVIDIA Corporation"
            BoardName      "NVIDIA GeForce RTX 3070"
        EndSection

        Section "Screen"
            Identifier     "Screen-nvidia[0]"
            Device         "Device-nvidia[0]"
            Monitor        "Monitor[0]"
            Option         "RandRRotation" "on"
        EndSection

        Section "Screen"
            Identifier     "Screen0"
            Device         "Device0"
            Monitor        "Monitor0"
            DefaultDepth    24
            Option         "Stereo" "0"
            Option         "nvidiaXineramaInfoOrder" "DFP-0"
            Option         "metamodes" "DP-0: nvidia-auto-select +1080+0 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}, HDMI-1: nvidia-auto-select +0+0 {rotation=right, ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}"
            Option         "SLI" "Off"
            Option         "MultiGPU" "Off"
            Option         "BaseMosaic" "off"
            SubSection     "Display"
                Depth       24
            EndSubSection
        EndSection
      '';
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    home-manager
    nixpkgs-fmt
    nix-prefetch
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

}
