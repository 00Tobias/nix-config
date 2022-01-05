{ config, pkgs, ... }: {
  programs = {
    mpv.enable = true;
    obs-studio.enable = true;
  };

  home.packages = with pkgs; [
    lagrange
    plover.dev

    # Creative
    krita-beta
    kdenlive
  ];
}
