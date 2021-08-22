{ config, pkgs, ... }: {

  imports = [
    ./home/kakoune.nix
    ./home/qutebrowser.nix
    ./home/firefox.nix
    ./home/term.nix
    ./home/gtk.nix
    ./home/xorg/i3.nix
    ./home/xorg/polybar.nix
    ./home/xorg/rofi.nix
    ./home/xorg/picom.nix
  ];

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  home = {
    # Some information Home Manager needs
    username = "toxic";
    homeDirectory = "/home/toxic";
    packages = with pkgs; [
      cozette
      discord-canary
      yubikey-manager
      yubikey-manager-qt
      yubikey-personalization
      dwarf-fortress-packages.dwarf-fortress-full
      electron
      spotify
    ];
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
