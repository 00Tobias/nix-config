{ lib, config, pkgs, ... }:
let
  colors = import ../colors.nix;
in
{
  home.packages = [ (pkgs.nerdfonts.override { fonts = [ "Hack" ]; }) ];
  programs.foot = {
    enable = true;
    settings = with colors.theme; {
      main = {
        font = "Hack Nerd Font:size=10";
        dpi-aware = "no";
      };
      cursor = {
        color = "${lib.removePrefix "#" background} ${lib.removePrefix "#" foreground}";
      };
      colors = {
        foreground = "${lib.removePrefix "#" foreground}";
        background = "${lib.removePrefix "#" background}";

        # Regular
        regular0 = "${lib.removePrefix "#" black}";
        regular1 = "${lib.removePrefix "#" red}";
        regular2 = "${lib.removePrefix "#" green}";
        regular3 = "${lib.removePrefix "#" yellow}";
        regular4 = "${lib.removePrefix "#" blue}";
        regular5 = "${lib.removePrefix "#" magenta}";
        regular6 = "${lib.removePrefix "#" teal}";
        regular7 = "${lib.removePrefix "#" grey}";

        # Bright
        bright0 = "${lib.removePrefix "#" darkerGrey}";
        bright1 = "${lib.removePrefix "#" red}";
        bright2 = "${lib.removePrefix "#" green}";
        bright3 = "${lib.removePrefix "#" yellow}";
        bright4 = "${lib.removePrefix "#" blue}";
        bright5 = "${lib.removePrefix "#" magenta}";
        bright6 = "${lib.removePrefix "#" teal}";
        bright7 = "${lib.removePrefix "#" lighterGrey}";
      };
    };
  };
}
