{ config, pkgs, ... }: {

  imports = [
    ./modules/kakoune.nix
    ./modules/firefox.nix
    ./modules/term.nix
  ];

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  home = {
    # Some information Home Manager needs
    username = "toxic";
    homeDirectory = "/home/toxic";
    packages = with pkgs; [
      discord-canary
      yubikey-manager
      yubikey-manager-qt
      yubikey-personalization
      dwarf-fortress-packages.dwarf-fortress-full
      electron
      wlroots-eglstreams
      # river
    ];
  };

  wayland = {
    windowManager.sway = {
      enable = true;
    };
  };

  programs = {
    obs-studio.enable = true;
    gpg.enable = true;
    password-store = {
      enable = true;
      settings = {
        PASSWORD_STORE_CLIP_TIME = "60";
      };
    };
    rtorrent.enable = true;
  };

  xdg.desktopEntries = {
    discord-canary = {
      name = "Discord Canary";
      icon = "discord-canary";
      exec = "electron --enable-features=UseOzonePlatform --ozone-platform=wayland ${pkgs.discord-canary}/opt/DiscordCanary/resources/app.asar";
      terminal = false;
      categories = [ "Network" "InstantMessaging" ];
      type = "Application";
    };
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.11";
}
