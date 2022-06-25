{ config, pkgs, ... }: {
  home = {
    sessionVariables = {
      PAGER = "bat";
    };
    packages = with pkgs; [
      # Nix utils
      update-nix-fetchgit
      nix-index
      nix-alien
      
      # File manager
      ranger
      ueberzug

      # Apps
      bombadillo
      neofetch
      bitwarden-cli

      # QMK
      qmk
      gnumake
    ];
  };
  programs = {
    fish = {
      enable = true;
      shellInit = ''
        set -U fish_greeting

        function fish_prompt
          printf '%s@%s %s%s%s λ ' $USER $hostname \
            (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
        end
      '';
    };

    fzf = {
      enable = true;
      enableFishIntegration = true;
      defaultCommand = "${pkgs.fd}/bin/fd --type f";
      changeDirWidgetCommand = "${pkgs.fd}/bin/fd --type d";
      fileWidgetCommand = "${pkgs.fd}/bin/fd --type f";
    };

    git = {
      enable = true;
      delta.enable = true;
      userName = "ToxicSalt";
      userEmail = "tobiasts@protonmail.com";
      extraConfig = { credential = { helper = "store"; }; };
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };

    tealdeer.enable = true;

    bat.enable = true;

    htop = {
      enable = true;
      settings = {
        vim_mode = true;
        tree_view = true;
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
        set preview_images_method ueberzug
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
