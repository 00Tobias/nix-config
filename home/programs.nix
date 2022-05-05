{ config, pkgs, ... }: {
  programs = {
    mpv.enable = true;
    obs-studio.enable = true;
  };

  home.packages = with pkgs; [
    lagrange

    # Creative
    krita-beta
    kdenlive
    aseprite
    zrythm
  ];
}
