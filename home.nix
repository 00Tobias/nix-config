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
    ];
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

    kakoune = {
      enable = true;
    };

    firefox = {
      enable = true;
      package = pkgs.firefox-devedition-bin;
      profiles = {
        myprofile = {
          settings = {
            "gfx.webrender.all" = true;
          };
        };
      };
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
