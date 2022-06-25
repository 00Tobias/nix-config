{ config, pkgs, ... }: {
  programs = {
    mpv.enable = true;
    obs-studio.enable = true;
  };

  home.packages = with pkgs; [
    lagrange
    librewolf
    obsidian

    # Creative
    krita-beta
    kdenlive
    aseprite
    zrythm
  ];
}
