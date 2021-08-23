# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./nixos-hardware.nix
    ];

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # For zsh home manager config, gets completion for system packages
  environment.pathsToLink = [ "/share/zsh" ];

  # Add my Bulk hard drive
  # TODO: Move this into hardware-configuration or something
  # TODO: Replace this with a ZFS pool
  fileSystems."/media/bulk" =
    {
      device = "/dev/disk/by-uuid/f762410f-9fb0-47b5-adfa-f83c08081916";
      fsType = "ext4";
    };

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    supportedFilesystems = [ "zfs" ];
    kernelParams = [ "nvidia-drm.modeset=1" ];
  };

  hardware = {
    pulseaudio.enable = false;
    opengl.enable = true;
    steam-hardware.enable = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  networking = {
    interfaces.enp7s0.useDHCP = true;
    interfaces.wlp6s0.useDHCP = true;
    hostName = "nixos";
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
    emacs = {
      enable = true;
      package = pkgs.emacsPgtkGcc;
    };
    udev.packages = [ pkgs.yubikey-personalization ];
    dbus.packages = with pkgs; [ gnome3.dconf ]; # NOTE: This fixes gnome themes, move this into something common when it matters
    pcscd.enable = true;
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

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };

  virtualisation = {
    libvirtd = {
      enable = true;
      qemuOvmf = true;
    };
  };

  # Allow programs with unfree licenses on the system, regrettably.
  nixpkgs.config.allowUnfree = true;

  # Enable Steam for this machine
  programs.steam.enable = true;

  # GPG / Yubikey
  # TODO: Modularize this and other Yubikey stuff
  environment.shellInit = ''
    export GPG_TTY="$(tty)"
    gpg-connect-agent /bye
    export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
  '';

  programs = {
    ssh.startAgent = false;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryFlavor = "curses";
    };
  };

  # security.pam.yubico = {
  #   enable = true;
  #   mode = "challenge-response";
  # };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    home-manager
    nixpkgs-fmt
    nix-prefetch
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

}
