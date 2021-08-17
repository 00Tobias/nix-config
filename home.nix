{ config, pkgs, ... }: {

  imports = [
    ./modules/kakoune.nix
    ./modules/firefox.nix
  ];

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  home = {
    # Some information Home Manager needs
    username = "toxic";
    homeDirectory = "/home/toxic";
    packages = with pkgs; [
      discord-canary
      fd
      xsel
      zig
      yubikey-manager
      yubikey-manager-qt
      yubikey-personalization
      electron
      pfetch
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

    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      enableSyntaxHighlighting = true;
      enableVteIntegration = true;
    };

    git = {
      enable = true;
      userName = "ToxicSalt";
      userEmail = "tobiasts@protonmail.com";
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    exa = {
      enable = true;
      enableAliases = true;
    };

    bat.enable = true;
    fzf.enable = true;
    jq.enable = true;

    htop = {
      enable = true;
      settings = {
        vim_mode = true;
      };
    };

    gpg.enable = true;
    password-store = {
      enable = true;
      settings = {
        PASSWORD_STORE_CLIP_TIME = "60";
      };
    };
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
