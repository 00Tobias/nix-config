{ config, pkgs, ... }:
let
  theme = import ../theme.nix { inherit pkgs; };
in
{
  # home.packages = [ pkgs.cozette ];
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
        font = with theme.font; {
          size = size;
          normal = {
            family = "${name}";
            style = "Regular";
          };
          bold = {
            family = "${name}";
            style = "Bold";
          };
          italic = {
            family = "${name}";
            style = "Italic";
          };
        };
        colors = with theme.colors; {
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
