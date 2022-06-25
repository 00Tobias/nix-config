{ pkgs, lib }:
let
  theme = import ../theme.nix { inherit pkgs; };
in
with theme.colors; ''
  foreground = "${foreground}"
  background = "${background}"

  black = "${black}"

  blue = "${blue}"
  cyan = "${cyan}"
  green = "${green}"
  magenta = "${magenta}"
  orange = "${orange}"
  red = "${red}"
  teal = "${teal}"
  violet = "${violet}"
  yellow = "${yellow}"
''
