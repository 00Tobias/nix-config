{ config, pkgs, ... }: {

  programs = {
    alacritty = {
      enable = true;
      settings = {
        window = {
          dynamic_padding = true;
          padding = {
            x = 0;
            y = 0;
          };
        };
        font = {
          normal = {
            family = "Hack Nerd Font";
            style = "Regular";
          };
          bold = {
            family = "Hack Nerd Font";
            style = "Bold";
          };
          italic = {
            family = "Hack Nerd Font";
            style = "Italic";
          };
        };
        colors = {
          primary = {
            background = "0x17191e";
            foreground = "0xabb2bf";
          };

          normal = {
            black = "0x1e2127";
            red = "0xe06c75";
            green = "0x98c379";
            yellow = "0xd19a66";
            blue = "0x61afef";
            magenta = "0xc678dd";
            cyan = "0x56b6c2";
            white = "0x828791";
          };

          bright = {
            black = "0x5c6370";
            red = "0xe06c75";
            green = "0x98c379";
            yellow = "0xd19a66";
            blue = "0x61afef";
            magenta = "0xc678dd";
            cyan = "0x56b6c2";
            white = "0xe6efff";
          };
        };
      };
    };

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

    update-nix-fetchgit # TODO: Split this into dev.nix or something?
    
    (nerdfonts.override { fonts = [ "Hack" ]; })
    fd
    pfetch
    pulsemixer
    zig
    xsel
  ];
}
