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
      pkgs.electron
      pkgs.bfetch
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

    gpg.enable = true;
    password-store = {
      enable = true;
      # # settings = { };
    };

    kakoune = {
      enable = true;
    };

    firefox = {
      enable = true;
      package = pkgs.firefox-wayland;
      profiles = {
        toxic = {
          name = "toxic";
          id = 0;
          isDefault = true;
          settings = {
            "gfx.webrender.all" = true;
          };
        };
      };
    };

    browserpass = {
      enable = true;
      browsers = [ "firefox" ];
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
