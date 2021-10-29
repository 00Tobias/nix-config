{ config, pkgs, ... }: {
  programs = {
    feh.enable = true; # X only
    mpv.enable = true; # Doesn't work on Wayland
    obs-studio.enable = true;
  };

  home.packages = with pkgs; [
    # Thunar
    xfce.thunar
    xfce.thunar-archive-plugin
    xfce.thunar-volman
    xfce.thunar-media-tags-plugin

    # Gemini client
    lagrange

    # Plover
    plover.dev

    # Creative
    krita
    kdenlive
  ];
}
