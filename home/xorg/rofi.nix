{ config, pkgs, ... }:
let
  theme = import ../theme.nix { inherit pkgs; };
in
{
  programs.rofi = {
    enable = true;
    font = with theme.font; "${name} ${toString size}";
    # terminal = "alacritty";
    # scrollbar = false;
    # width = 40;
    # lines = 5;
    # separator = "solid";
    extraConfig = {
      modi = "drun";
      # combi-modi = "drun";
      show-icons = true;
    };
    theme = with theme.colors;
      let
        inherit (config.lib.formats.rasi) mkLiteral;
      in
        {
          "*" = {
            background-color = mkLiteral "${background}";
            separator-color = mkLiteral "${foreground}";
            text-color = mkLiteral "${foreground}";
          };

          "window" = {
            padding = mkLiteral "20px";
            height = mkLiteral "320px";
            border = mkLiteral "3px";
            border-color = mkLiteral "${darkGrey}";
          };

          "mainbox" = {
            padding = mkLiteral "5px";
            border-radius = mkLiteral "13px";
          };

          "inputbar" = {
            children = map mkLiteral [ "prompt" "entry" ];
          };

          "prompt" = {
            background-color = mkLiteral "${blue}";
            padding = mkLiteral "5px 5px 0px";
          };

          "textbox-prompt-colon" = {
            expand = false;
            str = ":";
          };

          "entry" = {
            padding = mkLiteral "5px";
          };

          listview = {
            border = mkLiteral "0px 0px 0px";
            padding = mkLiteral "6px 0px 0px";
          };

          "element" = {
            padding = mkLiteral "5px";
          };

          "element-icon" = {
            size = mkLiteral "25px";
          };

          "element selected" = {
            background-color = mkLiteral "${lightGrey}";
            text-color = mkLiteral "${foreground}";
          };

          "element urgent" = {
            background-color = mkLiteral "${red}";
            text-color = mkLiteral "${background}";
          };

          "element active" = {
            background-color = mkLiteral "${yellow}";
            text-color = mkLiteral "${background}";
          };
      };
  };
}
