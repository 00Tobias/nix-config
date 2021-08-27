{ config, pkgs, ... }: {
  programs = {
    feh.enable = true;
    mpv.enable = true;
  };

  services = {
    flameshot.enable = true;
  };

  home.packages = with pkgs; [
    # Thunar
    xfce.thunar
    xfce.thunar-archive-plugin
    xfce.thunar-volman
    xfce.thunar-media-tags-plugin

    # Plover
    plover.dev
  ];
}
