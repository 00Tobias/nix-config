{ config, pkgs, ... }:
let
  colors = import ./colors.nix;
in
{
  programs.kitty = {
    enable = true;
    font = {
      package = (pkgs.nerdfonts.override { fonts = [ "Hack" ]; });
      name = "Hack Nerd Font";
      size = 12;
    };
    keybindings = {
      "ctrl+c" = "copy_or_interrupt";
    };
    settings = with colors.theme; {
      scrollback_lines = 10000;
      enable_audio_bell = false;

      allow_remote_control = true;
      listen_on = "unix:/tmp/kitty";

      # Colors
      foreground = "${foreground}";
      background = "${background}";
      selection_foreground = "${foreground}";
      selection_background = "${lighterGrey}";

      # Normal
      cursor = "${foreground}";
      color0 = "${background}";
      color1 = "${red}";
      color2 = "${green}";
      color3 = "${yellow}";
      color4 = "${blue}";
      color5 = "${magenta}";
      color6 = "${teal}";
      color7 = "${grey}";

      # Bright
      color8 = "${darkerGrey}";
      color9 = "${red}";
      color10 = "${green}";
      color11 = "${yellow}";
      color12 = "${blue}";
      color13 = "${magenta}";
      color14 = "${teal}";
      color15 = "${lighterGrey}";
    };
  };
}
