{ lib }:
let
  colors = import ../colors.nix;
in
with colors.theme; ''
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
