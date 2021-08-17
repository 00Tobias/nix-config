{ config, pkgs, ... }: {

  programs = {
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      enableSyntaxHighlighting = true;
      enableVteIntegration = true;
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
    jq.enable = true;

    htop = {
      enable = true;
      settings = {
        vim_mode = true;
      };
    };
  };
  home.packages = with pkgs; [
    fd
    pfetch
    zig
    xsel
  ];
}
