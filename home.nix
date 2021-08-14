{ config, pkgs, ... }: {

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  home = {
    # Some information Home Manager needs
    username = "toxic";
    homeDirectory = "/home/toxic";
    sessionVariables = {
      MOZ_ENABLE_WAYLAND = 1;
    };
    packages = [
      pkgs.discord-canary
      pkgs.fd
      pkgs.yubikey-manager
      pkgs.yubikey-manager-qt
      pkgs.yubikey-personalization
      pkgs.electron
      pkgs.pfetch
      pkgs.wlroots-eglstreams
      # pkgs.river
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

    kakoune = {
      enable = true;
    };

    firefox = {
      enable = true;
      # package = pkgs.firefox-wayland;
      package = pkgs.firefox.override {
        cfg = {
          # Gnome shell native connector
          enableGnomeExtensions = true;
          # Tridactyl native connector
          enableTridactylNative = true;
        };
      };

      profiles = {
        toxic = {
          name = "toxic";
          id = 0;
          isDefault = true;
          settings = {
            "gfx.webrender.all" = true;
          };
        };
        spotify = {
          name = "spotify";
          id = 1;
          isDefault = false;
          settings = {
            "gfx.webrender.all" = true;
          };
        };
      };
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        browserpass
        clearurls
        sidebery
        sponsorblock
        tabliss
        tridactyl
        ublock-origin
      ];
    };

    browserpass = {
      enable = true;
      browsers = [ "firefox" ];
    };
  };

  xdg.desktopEntries = {
    discord-canary = {
      name = "Discord Canary";
      icon = "discord-canary";
      exec = "electron --enable-features=UseOzonePlatform --ozone-platform=wayland /nix/store/0vx4mdibhyg6p4hxwb3c03pjxb00fn0p-discord-canary-0.0.126/opt/DiscordCanary/resources/app.asar";
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
