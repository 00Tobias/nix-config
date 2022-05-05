{ config, pkgs, ... }: {
  home = {
    sessionVariables = {
      PAGER = "bat";
    };
    packages = with pkgs; [
      update-nix-fetchgit
      bombadillo
      fd
      ranger
      neofetch
      pulsemixer
      unzip
      bitwarden-cli
    ];
  };
  programs = {
    zsh = {
      enable = true;
      defaultKeymap = "emacs";
      enableAutosuggestions = true;
      enableCompletion = true;
      enableSyntaxHighlighting = true;
      enableVteIntegration = true;
    };

    # nushell = {
    #   enable = true;
    #   settings = {
    #     completion_type = "circular";
    #     ctrlc_exit = false;
    #     edit_mode = "emacs";
    #     prompt = "STARSHIP_SHELL= starship prompt";
    #     rm_always_trash = true;
    #     skip_welcome_message = true;
    #     table_mode = "rounded";
    #   };
    # };

    fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "fd --type f";
      changeDirWidgetCommand = "fd --type d";
      fileWidgetCommand = "fd --type f";
    };

    git = {
      enable = true;
      delta.enable = true;
      userName = "ToxicSalt";
      userEmail = "tobiasts@protonmail.com";
      extraConfig = { credential = { helper = "store"; }; };
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    lsd = {
      enable = true;
      enableAliases = true;
    };

    bat.enable = true;
    jq.enable = true;

    htop = {
      enable = true;
      settings = {
        vim_mode = true;
      };
    };
  };

  # Config files
  xdg.configFile = {
    # ranger
    "ranger/rc.conf" = {
      text = ''
        set draw_borders both
        set preview_images true
        set preview_images_method kitty
        default_linemode devicons
      '';
    };

    # Plugins
    "ranger/plugins/ranger-devicons" = {
      recursive = true;
      # executable = true;
      source = pkgs.fetchFromGitHub {
        owner = "alexanderjeurissen";
        repo = "ranger_devicons";
        rev = "11941619b853e9608a41028ac8ebde2e6ca7d934";
        sha256 = "1sfmm5j2hg84j6g82mzxlh03sri8yphj2979wr0zgn62mr38w8zd";
      };
    };
  };
}
