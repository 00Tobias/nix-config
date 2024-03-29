{ config, pkgs, ... }:

{
  imports =
    [
      # Include hardware configuration
      ./den-hardware.nix
    ];

  # For zsh home manager config, gets completion for system packages
  environment.pathsToLink = [ "/share/zsh" ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    supportedFilesystems = [ "zfs" ];
    kernelPackages = pkgs.linuxKernel.packages.linux_xanmod;
    # kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;
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

  users = {
    users.toxic = {
      isNormalUser = true;
      shell = pkgs.fish;
      extraGroups = [ "wheel" "kvm" "uucp" "dialout" "plugdev" ];
    };
    # patorjk.com/software/taag/#p=display&f=Standard&t=den
    # https://ascii.co.uk/art/dragon
    motd = ''
                  _,-'/-'/                             _
      .      __,-; ,'( '/                           __| | ___ _ __
       \.    `-.__`-._`:_,-._       _ , . ``       / _` |/ _ \ '_ \
        `:-._,------' ` _,`--` -: `_ , ` ,' :  @  | (_| |  __/ | | |
           `---..__,,--'            ` -'. -'       \__,_|\___|_| |_|
    '';
  };

  hardware.nvidia.modesetting.enable = true;
  # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;

  services = {
    getty.autologinUser = "toxic"; # This is a single-user stationary host
    udev.packages = [ pkgs.qmk-udev-rules ];
    zfs = {
      autoScrub.enable = true;
      trim.enable = true;
    };
    xserver = {
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

  environment.systemPackages = with pkgs; [
    easyeffects
    libratbag
    piper

    # Nvidia stuff
    glxinfo
    vulkan-tools
    glmark2
  ];
}
