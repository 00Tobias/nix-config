{ config, pkgs, ... }: {
  home = {
    sessionVariables = {
      PAGER = "bat";

      # nnn config
      NNN_OPTS = "ax";
      NNN_OPENER = "${config.xdg.configHome}/nnn/plugins/nuke";
      NNN_FIFO = "/tmp/nnn.fifo";
      NNN_PLUG = "n:nuke;p:preview-tui;d:dragdrop";
      NNN_TMPFILE = "/tmp/.lastd";
      NNN_TRASH = "n";
    };
    packages = with pkgs; [
      update-nix-fetchgit # TODO: Split this into dev.nix or something?
      bombadillo
      fd
      (nnn.override { withNerdIcons = true; })
      dragon-drop # Only X, for nnn dragdrop plugin
      ranger
      neofetch
      pulsemixer
      unzip
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

    nushell = {
      enable = true;
      settings = {
        completion_type = "circular";
        ctrlc_exit = false;
        edit_mode = "emacs";
        prompt = "STARSHIP_SHELL= starship prompt";
        rm_always_trash = true;
        skip_welcome_message = true;
        table_mode = "rounded";
      };
    };

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

    gh = {
      enable = true;
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
    # nnn plugins
    "nnn/plugins/nuke" = {
      executable = true;
      source = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/jarun/nnn/c48691fe3d1e43e92937a6a3f6e28a1469b4684e/plugins/nuke";
        sha256 = "1sds7xc4m62aqssr65nvasd2vwphadvkxqmar5bmch6mgq6w23v0";
      };
    };
    "nnn/plugins/preview-tui" = {
      executable = true;
      source = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/jarun/nnn/c48691fe3d1e43e92937a6a3f6e28a1469b4684e/plugins/preview-tui";
        sha256 = "1l6nphzcv0sxbnwlfyij95ghdd8svj7aa6hbnnpiydng25ycvqvn";
      };
    };
    "nnn/plugins/dragdrop" = {
      executable = true;
      source = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/jarun/nnn/c48691fe3d1e43e92937a6a3f6e28a1469b4684e/plugins/dragdrop";
        sha256 = "1jq6v7446gfggp14lxvj14j0vrkglb8mw6f6s96rgl5bhv8jjhk0";
      };
    };

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
