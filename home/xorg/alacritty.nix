{ config, pkgs, ... }:
let
  colors = import ../colors.nix;
in
{
  home.packages = [ pkgs.cozette ];
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
          # size = 12.0;
          normal = {
            family = "cozette";
            style = "Regular";
          };
          bold = {
            family = "cozette";
            style = "Bold";
          };
          italic = {
            family = "cozette";
            style = "Italic";
          };
        };
        colors = with colors.theme; {
          primary = {
            background = "${background}";
            foreground = "${foreground}";
          };

          normal = {
            black = "${black}";
            red = "${red}";
            green = "${green}";
            yellow = "${yellow}";
            blue = "${blue}";
            magenta = "${magenta}";
            cyan = "${cyan}";
            white = "${foreground}";
          };
        };
      };
    };
  };
}
